# Article 2: Kafka Architecture Deep Dive

## The Request-Response Protocol

Every Kafka interaction is a TCP request/response pair over a **binary protocol** on port `9092` (plaintext) or `9093` (TLS). Clients do not use HTTP, REST, or AMQP — they use the Kafka wire protocol directly.

The broker listens for these major request types:

| Request | Sent By | Purpose |
|---------|---------|---------|
| `Produce` | Producer | Append records to partition |
| `Fetch` | Consumer, Follower | Retrieve records |
| `Metadata` | All | Discover brokers, partition leaders |
| `OffsetCommit` | Consumer | Persist committed offset in `__consumer_offsets` |
| `OffsetFetch` | Consumer | Read last committed offset |
| `JoinGroup` / `SyncGroup` / `Heartbeat` / `LeaveGroup` | Consumer | Consumer group membership |
| `FindCoordinator` | Consumer, Transactional Producer | Discover group/txn coordinator |
| `InitProducerId` / `AddPartitionsToTxn` / `EndTxn` | Transactional Producer | Transaction lifecycle |
| `CreateTopics`, `DeleteTopics`, `AlterConfigs` | Admin client | Cluster management |
| `LeaderAndIsr`, `UpdateMetadata`, `StopReplica` | Controller → Broker | Leadership & ISR changes |

Every Kafka message on the wire is a **binary** frame with a length prefix. The clients handle batching multiple records into one Produce request.

## The Broker's Responsibilities

A broker is a JVM process that:

1. **Hosts partition replicas** on its local disk (each replica is a directory of log segment files).
2. **Serves fetch & produce requests** for partitions it leads.
3. **Replicates** partitions it follows (as a follower for other leaders).
4. **Responds to metadata queries**.
5. **Handles consumer group coordination** (if it's the coordinator for a given group).
6. **Runs the controller elected duties** (if it is the current controller).

A broker has three critical thread pools:

| Pool | What It Does | Config |
|------|--------------|--------|
| Network threads | Accept/send bytes on sockets | `num.network.threads` (default 3) |
| I/O threads | Actually process requests (disk read/write) | `num.io.threads` (default 8) |
| Replica fetchers | Fetch from leaders when this broker is a follower | `num.replica.fetchers` (default 1) |

A request arrives on a network thread → queued in a **request channel** → picked up by an I/O thread → processed → response enqueued → sent by the network thread. This separation prevents slow disk I/O from blocking new connections.

## The Cluster Controller

Exactly **one** broker in the cluster is the *active controller* at any time. The controller is responsible for:

1. **Tracking live brokers** (via ZooKeeper sessions or KRaft heartbeats).
2. **Managing partition leader elections** when a broker dies.
3. **Managing ISR shrinks/expands**.
4. **Executing admin operations** (create/delete topics, reassign partitions).
5. **Propagating metadata** via `UpdateMetadata` and `LeaderAndIsr` requests to every broker.

Historically (pre-KRaft), the controller stored its state in ZooKeeper. In KRaft mode, the controller is itself a Raft quorum of 1, 3, or 5 nodes that persist metadata in a dedicated `__cluster_metadata` topic.

## ZooKeeper vs KRaft

| Aspect | ZooKeeper | KRaft |
|--------|-----------|-------|
| Metadata storage | ZooKeeper znodes | `__cluster_metadata` Kafka topic |
| Controller | Dynamically elected broker | Dedicated Raft quorum |
| Failover | Full metadata re-read on controller change | Incremental log replay |
| Dependencies | ZooKeeper cluster (separate process) | None — single deployment |
| Scalability | Limited to ~200k partitions | Millions of partitions |
| Status (Kafka 3.x) | Supported but deprecated | GA from 3.3 onward |

**Exam relevance:** CCDAK is largely version-agnostic but expects you to know:
- KRaft exists and removes the ZK dependency.
- ZooKeeper is used for controller election & metadata in pre-KRaft clusters.
- Neither is required knowledge for client code.

## Clients: The Fat Client Principle

Kafka clients are *thick*. They contain:

- Connection pooling to every broker
- Metadata cache (with TTL-based refresh)
- Record accumulator (producer) or fetch buffer (consumer)
- Serialization
- Partitioner logic
- Retry logic
- Offset tracking (consumer)
- Transaction state machine (transactional producer)
- Group protocol (consumer)
- Compression / decompression

This is why Kafka can scale: most logic runs on the client, not the broker.

## Replication Pipeline

Every partition has a **leader** and zero or more **followers**. The replication pipeline:

```
Producer ──▶ Leader (writes to local log)
                │
                ├──▶ Follower 1 (fetch request → appends to local log)
                ├──▶ Follower 2 (fetch request → appends to local log)
                │
       Returns ACK when enough replicas have fetched
       (determined by acks and min.insync.replicas)
```

Followers **pull** from the leader (fetch protocol). They do not get pushed to. This keeps the replication path identical to the consumer path.

A follower is **in-sync** (member of ISR) if it is within `replica.lag.time.max.ms` (default 30 seconds) of the leader. If it falls behind, it is removed from ISR and excluded from the "acks=all" guarantee set.

## High Watermark and Log End Offset

| Metric | Definition |
|--------|-----------|
| **LEO (Log End Offset)** | The offset of the next record to be appended |
| **HW (High Watermark)** | The last offset replicated to all ISR members — the maximum offset a consumer can read |

A record is **committed** once all ISR members have replicated it. Only committed records are visible to a standard consumer.

```
Partition Leader
  ┌───┬───┬───┬───┬───┐
  │ 0 │ 1 │ 2 │ 3 │ 4 │   LEO = 5
  └───┴───┴───┴───┴───┘
                 ↑
               HW = 3 (offsets 0..2 fully replicated, 3 and 4 still replicating)
```

Consumers with `isolation.level=read_uncommitted` (the default!) read up to the HW.
Consumers with `isolation.level=read_committed` read up to the Last Stable Offset (LSO), which is either the HW or the offset of the first ongoing transaction, whichever is lower.

## Storage: Partitions → Segments → Indexes

Each partition on disk is a directory:

```
/var/lib/kafka/logs/orders-0/
  ├── 00000000000000000000.log      (record data)
  ├── 00000000000000000000.index    (sparse offset → position index)
  ├── 00000000000000000000.timeindex (sparse timestamp → offset index)
  ├── 00000000000000047283.log      (newer active segment)
  ├── 00000000000000047283.index
  ├── 00000000000000047283.timeindex
  ├── leader-epoch-checkpoint
  └── ...
```

- **Segment** = one `.log` file + its indexes. Rolled when size > `segment.bytes` (default 1 GB) or age > `segment.ms` (default 7 days).
- Only the most recent segment is **active** (writable); all others are **closed** and eligible for retention/compaction.

## Zero-Copy Transfer

When a consumer issues a fetch, the broker uses the Linux `sendfile()` system call to transfer bytes from the page cache directly to the socket without copying into user space. This is one of the reasons Kafka handles millions of messages per second per broker.

## Exam Pointers

- Know that the **controller is a broker** — not a separate process (in both ZK and KRaft mode).
- Replication is **pull-based** — followers fetch from leaders just like consumers do.
- A record is durable and visible only when it is **committed to all ISR members**.
- `acks=all` + `min.insync.replicas=1` does NOT give you meaningful durability — you need `min.insync.replicas >= 2` with `replication.factor >= 3`.
- Zero-copy is why Kafka's throughput is so high — expect a question hinting at network efficiency.

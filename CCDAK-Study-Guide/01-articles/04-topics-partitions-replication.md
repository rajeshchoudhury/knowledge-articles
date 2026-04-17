# Article 4: Topics, Partitions, and Replication

## Creating a Topic

```bash
kafka-topics --bootstrap-server localhost:9092 \
  --create --topic orders \
  --partitions 6 \
  --replication-factor 3 \
  --config min.insync.replicas=2 \
  --config retention.ms=604800000
```

When this command runs:

1. The admin client contacts any broker, which forwards to the controller.
2. The controller chooses a leader for each partition from the available brokers, trying to balance leaders evenly across brokers (and racks, if rack-aware).
3. Followers are assigned to the next brokers in a round-robin fashion.
4. Metadata is propagated via `LeaderAndIsr` and `UpdateMetadata` requests.

### Replica Assignment Algorithm (Simplified)

For a topic with `P` partitions and `R` replication factor over `B` brokers:

1. Pick a random starting broker `start`.
2. For partition 0: leader = brokers[start], replicas[1..R-1] = brokers[start+1 .. start+R-1].
3. For partition 1: leader = brokers[start+1], replicas = brokers[start+2..start+R].
4. Continue rotating.

With rack awareness, the algorithm ensures no two replicas of the same partition land on the same rack if possible.

## Partitions

A partition is the unit of:

- **Ordering** — records within a partition are strictly ordered by offset.
- **Parallelism** — each partition is consumed by at most one consumer within a group.
- **Distribution** — partitions are spread across brokers.
- **Replication** — each partition is independently replicated.

### How to Choose Partition Count

More partitions = more parallelism, but:

- More file handles on every broker (each partition is ≥ one segment file + indexes per replica).
- More leader elections during controller failovers.
- More open TCP connections per producer/consumer.
- Longer end-to-end latency (replication happens per partition).
- More memory for producer batching (`batch.size` applies per partition).

**Rule of thumb:**
- `N = max(target_throughput / per_consumer_throughput, target_throughput / per_producer_throughput)`.
- Never fewer partitions than your maximum parallel consumers.
- Round up for future growth; halving partitions is expensive (requires topic recreation).

**Increasing partitions is possible** but has a major caveat: **existing keys may get rehashed to different partitions**, breaking partition ordering for consumers that rely on key-based ordering.

### Record Key → Partition Mapping

The default partitioner logic (since 2.4+) is:

1. If a partition is explicitly specified, use it.
2. Else if the key is non-null: `partition = murmur2(key) % numPartitions` (same as old `DefaultPartitioner`).
3. Else (key is null): the **UniformStickyPartitioner** batches records into the same partition until the batch is sent, then rotates.

Since Kafka 3.3, the `DefaultPartitioner` is the same as UniformSticky for null keys. Configuration: `partitioner.class` (default: `null`, meaning use the built-in).

Legacy partitioners:
- `DefaultPartitioner` (explicit): same as the built-in.
- `UniformStickyPartitioner` (explicit): same sticky behavior.
- `RoundRobinPartitioner`: spreads every record across partitions — defeats batching.
- Custom: implement `org.apache.kafka.clients.producer.Partitioner`.

## Replication

Replication gives us durability and availability. Terms you must know cold:

| Term | Meaning |
|------|---------|
| **Replica** | A copy of a partition on some broker |
| **Leader** | The replica that handles all reads/writes |
| **Follower** | A replica that fetches from the leader |
| **ISR (In-Sync Replica set)** | Replicas that are caught up to the leader |
| **OSR (Out-of-Sync Replica set)** | Replicas that have fallen behind |
| **AR (Assigned Replicas)** | All replicas for a partition (ISR ∪ OSR) |
| **Preferred Leader** | The first replica in the AR list — used by preferred leader election |

### What "In-Sync" Means

A follower is in-sync if both:
1. Its lag is < `replica.lag.time.max.ms` (default 30,000 ms). This is measured as: time since the follower's last fetch that was up to the leader's LEO.
2. (Historical) Its offset lag is < `replica.lag.max.messages` — this config was removed in Kafka 0.9+.

If a follower misses one fetch cycle but quickly catches up, it stays in ISR.

### Leader Election

When a leader fails:

1. The controller detects via ZK watch / Raft heartbeat loss.
2. The controller picks a new leader from the ISR (default election algorithm).
3. If no ISR member exists:
   - With `unclean.leader.election.enable=false` (default): partition stays unavailable.
   - With `unclean.leader.election.enable=true`: an OSR replica becomes leader; data beyond its LEO is lost.
4. New leader is announced; producers/consumers refresh their metadata.

**Preferred leader election** is the process of re-balancing leadership so the first replica in AR becomes leader — run periodically (`auto.leader.rebalance.enable=true`, default) or manually via `kafka-leader-election`.

## min.insync.replicas

The broker-side (or topic-level) config that enforces the minimum number of ISR members that must ACK before a `acks=all` write succeeds.

| RF | min.insync.replicas | Outcome |
|---:|--------------------:|---------|
| 3 | 2 | Tolerates 1 broker failure with no data loss, no availability loss |
| 3 | 3 | No data loss but first broker failure blocks writes |
| 3 | 1 | No durability guarantee beyond the leader — effectively `acks=1` |

**Exam rule:** `min.insync.replicas = replication.factor - 1` is the durability sweet spot.

If the number of ISR falls below `min.insync.replicas`, the producer with `acks=all` receives `NotEnoughReplicasException` (a retriable exception).

## Example Scenario

Topic `payments`, RF=3, `min.insync.replicas=2`, producer with `acks=all`:

- Normal: 3 brokers, ISR={1,2,3}. Writes succeed.
- Broker 2 dies. ISR shrinks to {1,3}. Writes still succeed (2 ≥ min.insync.replicas).
- Broker 3 dies. ISR = {1}. Writes FAIL with `NotEnoughReplicasException`. Consumers can still read everything already committed.
- Broker 3 recovers. ISR = {1,3}. Writes succeed again.

## Deleting a Topic

```bash
kafka-topics --bootstrap-server localhost:9092 --delete --topic test
```

Requires `delete.topic.enable=true` (default true in recent versions). The controller marks the topic for deletion; brokers remove log directories asynchronously.

## Describing a Topic

```bash
kafka-topics --bootstrap-server localhost:9092 --describe --topic orders
```

Output:
```
Topic: orders   TopicId: abc123  PartitionCount: 6  ReplicationFactor: 3
Topic: orders   Partition: 0    Leader: 1  Replicas: 1,2,3  Isr: 1,2,3
Topic: orders   Partition: 1    Leader: 2  Replicas: 2,3,1  Isr: 2,3,1
...
```

A healthy cluster has `Replicas` equal to `Isr` for every partition.

## Under-Replicated Partitions

A partition is **under-replicated** when `|ISR| < replication.factor`. Metric: `kafka.server:type=ReplicaManager,name=UnderReplicatedPartitions`.

An alarming scenario is **under-min-ISR partitions** — partitions where `|ISR| < min.insync.replicas`. These cannot accept `acks=all` writes. Metric: `UnderMinIsrPartitionCount`.

## Exam Pointers

- Partitions are the unit of ordering — ordering is NEVER guaranteed across partitions.
- `min.insync.replicas` **only matters when `acks=all`**. With `acks=0` or `acks=1`, it is ignored.
- A single-broker cluster cannot sustain `RF > 1`. Default `replication.factor = 1` for convenience.
- Preferred leader election is **automatic** by default (`auto.leader.rebalance.enable=true`).
- You can **increase** partitions but not decrease them without recreating the topic.
- Reducing RF is a multi-step operation: use `kafka-reassign-partitions.sh` to change `Replicas`.

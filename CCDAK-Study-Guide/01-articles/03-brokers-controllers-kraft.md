# Article 3: Brokers, Controllers, and KRaft

## Broker Identity

Each broker has a **broker ID** (integer). In ZooKeeper mode, the ID must be explicitly set via `broker.id`. In KRaft mode, it's set via `node.id`.

The broker also advertises:

- `listeners` — host:port pairs for client connections (PLAINTEXT, SSL, SASL_SSL, etc.)
- `advertised.listeners` — the externally reachable host:port (what the broker publishes in metadata responses)
- `inter.broker.listener.name` — which listener inter-broker traffic uses
- `controller.quorum.voters` (KRaft only) — the list of controller nodes

When producers/consumers call `bootstrap.servers`, they connect to any listed broker, issue a `Metadata` request, receive the full cluster topology, and then connect directly to the leader of each partition they interact with.

## Controller: Deep Dive

The controller serializes cluster-wide state changes. Only the active controller can:

- Select partition leaders
- Update ISR
- Publish new topic metadata
- Handle partition reassignment
- Propagate config changes

### ZooKeeper Mode Controller Election

In ZK mode, any broker can become the controller by racing to create the ephemeral ZK node `/controller`. When a broker dies, its ephemeral node disappears, and every other broker races again. The winner reads all cluster metadata from ZK and fires a `UpdateMetadata` to every broker.

Historical limitation: this re-read is O(topics × partitions × replicas), becoming slow for clusters with > 100k partitions.

### KRaft Mode Controller (Raft)

KRaft replaces ZK entirely. A small set of **controller** nodes (3 or 5 typically) form a Raft quorum. One is the leader; the others are voters/observers. Metadata changes are appended to the internal `__cluster_metadata` topic, which is replicated via Raft.

Benefits:
- **Faster failover** (seconds → milliseconds).
- **Supports more partitions** (millions).
- **Simpler operational model** — no ZK cluster to run.
- **Incremental snapshots** — the metadata log is snapshotted periodically.

In KRaft, you deploy brokers in three possible roles (via `process.roles`):

- `broker` only
- `controller` only (for production)
- `broker,controller` (combined mode, only for dev/test)

## Per-Broker Configuration Highlights

| Config | Default | Purpose |
|--------|---------|---------|
| `broker.id` / `node.id` | — | Required, must be unique |
| `log.dirs` | `/tmp/kafka-logs` | Directories where partitions are stored |
| `num.partitions` | 1 | Default partition count for auto-created topics |
| `default.replication.factor` | 1 | Default RF for auto-created topics |
| `offsets.topic.replication.factor` | 3 | RF of `__consumer_offsets` — if your cluster has < 3 brokers, this MUST be lowered or the topic won't create |
| `transaction.state.log.replication.factor` | 3 | Same, for `__transaction_state` |
| `min.insync.replicas` | 1 | Broker-level default, can be overridden per topic |
| `log.retention.hours` | 168 (7 days) | Default time-based retention |
| `log.retention.bytes` | -1 (unlimited) | Default size-based retention |
| `log.segment.bytes` | 1 GB | Segment roll size |
| `log.segment.ms` | 7 days | Segment roll age |
| `auto.create.topics.enable` | `true` | Strongly recommended: set to `false` in prod |
| `delete.topic.enable` | `true` | Allow DeleteTopics admin calls |
| `unclean.leader.election.enable` | `false` | Allow out-of-sync replicas to become leader on failure (data loss!) |

## Internal Topics

Certain topics are created and managed by Kafka itself:

| Topic | Purpose | Partitions | Cleanup |
|-------|---------|-----------|---------|
| `__consumer_offsets` | Offset commits per group | 50 (configurable) | `compact` |
| `__transaction_state` | Transaction metadata | 50 | `compact` |
| `_schemas` | Schema Registry backing store | 1 | `compact` (compaction must not delete!) |
| `__cluster_metadata` | KRaft controller log | 1 | None — log-compact style snapshot |
| `_confluent-ksql-*` | ksqlDB internal topics | Varies | Varies |
| `_confluent-command` | Confluent control/reporting | Varies | `compact` |

## Per-Topic Configuration Overrides

Every broker-level config prefixed with `log.` has a per-topic equivalent. Most common:

| Topic-Level Config | Broker-Level Equivalent | Typical Override |
|-------------------|--------------------------|------------------|
| `cleanup.policy` | `log.cleanup.policy` | `delete` or `compact` or `compact,delete` |
| `retention.ms` | `log.retention.ms` | Time-based retention per topic |
| `retention.bytes` | `log.retention.bytes` | Size-based retention per topic |
| `segment.bytes` | `log.segment.bytes` | Segment size per topic |
| `segment.ms` | `log.segment.ms` | Segment age per topic |
| `min.insync.replicas` | `min.insync.replicas` | ISR minimum for `acks=all` |
| `compression.type` | `compression.type` | `producer` (default), `gzip`, `snappy`, `lz4`, `zstd`, `uncompressed` |
| `max.message.bytes` | `message.max.bytes` | Largest record |
| `delete.retention.ms` | `log.cleaner.delete.retention.ms` | How long tombstones persist after compaction |
| `min.cleanable.dirty.ratio` | `log.cleaner.min.cleanable.ratio` | Trigger for compaction (default 0.5) |
| `segment.jitter.ms` | `log.roll.jitter.ms` | Randomness added to segment roll age |

Set via admin client or CLI:

```bash
kafka-configs --bootstrap-server localhost:9092 \
  --entity-type topics --entity-name orders \
  --alter --add-config retention.ms=86400000,min.insync.replicas=2
```

## Unclean Leader Election

`unclean.leader.election.enable` is a classic trap.

**When FALSE (default):** if the leader dies and all ISR members are offline, the partition becomes unavailable until an ISR replica recovers. No data loss.

**When TRUE:** Kafka will elect an out-of-sync replica as leader. Data that was committed but not yet replicated to this out-of-sync replica is lost. Availability is restored at the cost of consistency.

**Exam answer:** if the question emphasizes *no data loss*, `unclean.leader.election.enable=false`. If the question emphasizes *availability over correctness*, `true`.

## Graceful Shutdown

When a broker is shut down gracefully (`SIGTERM` or `bin/kafka-server-stop.sh`):

1. It stops accepting new connections.
2. It finalizes in-flight requests.
3. The controller migrates partition leadership off this broker.
4. Log directories are fsynced and closed.

Config: `controlled.shutdown.enable=true` (default) enables this. With `controlled.shutdown.max.retries=3`.

## Rack Awareness

Set `broker.rack` on each broker (e.g., `broker.rack=us-east-1a`). Then Kafka's partition assignment algorithm distributes replicas across racks to survive a rack/AZ failure. The producer's `DefaultPartitioner` and the `ReplicaSelector` for follower fetching can also leverage rack information (via `replica.selector.class=RackAwareReplicaSelector` on the broker — needed for follower fetching).

## Exam Pointers

- Know the **default replication factor for internal topics is 3** — a 1-broker dev cluster must lower these.
- `unclean.leader.election.enable` defaults to **false** from Kafka 0.11 onward.
- Topics can be created automatically if `auto.create.topics.enable=true` — the exam often punishes this default.
- **KRaft removes ZK** but doesn't change client behavior; your clients look the same.
- The controller is a role; it's still a normal broker doing extra work.

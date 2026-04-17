# Article 31: MirrorMaker 2 and Cluster Linking

Cross-cluster replication tools.

## Use Cases

- **Geo-redundancy** — replicate to a DR cluster.
- **Multi-region** — active-active data availability.
- **Migration** — moving from on-prem to cloud.
- **Aggregation** — combining regional data into a central cluster.
- **Isolation** — replicate a subset to a dev cluster.

## MirrorMaker 2 (MM2)

A Kafka Connect-based replication framework (replaces the legacy MirrorMaker 1).

**Architecture**: MM2 runs as a set of **Connect connectors**:
- `MirrorSourceConnector` — replicates records from source → target topics.
- `MirrorHeartbeatConnector` — produces heartbeats to check connectivity.
- `MirrorCheckpointConnector` — replicates consumer offsets (translated).

MM2 can run in three modes:
1. **Standalone** — dedicated MM2 cluster (`connect-mirror-maker.sh`).
2. **Connect cluster** — install connectors into an existing Connect cluster.
3. **Embedded** — in a driver JVM.

## Replication Flow

```
┌──────────────┐                  ┌──────────────┐
│ source-cluster│───MM2 Source────▶│ target-cluster│
│              │◀──MM2 Checkpoint─│              │
└──────────────┘                  └──────────────┘
```

Records from `source-cluster.topic-A` are mirrored to `target-cluster.<source-cluster>.topic-A` (by default, prefixed with the source's alias).

### Topic Naming

- Default: `<alias>.<topic>` — e.g., `us-east.orders`.
- Useful in **aggregation** scenarios (multiple sources, one target).
- Configurable: `replication.policy.class=org.apache.kafka.connect.mirror.IdentityReplicationPolicy` keeps original names (but risks loops in active-active).

## Configuration

```properties
# mm2.properties
clusters = src, dst
src.bootstrap.servers = source:9092
dst.bootstrap.servers = target:9092

# Enable src → dst replication
src->dst.enabled = true
src->dst.topics = .*                          # regex of topics
src->dst.topics.exclude = __.*                # excludes internal topics
src->dst.groups = .*                          # groups to mirror offsets for
src->dst.groups.exclude = console-consumer.*

# Replication factor on target
replication.factor = 3
checkpoints.topic.replication.factor = 3
heartbeats.topic.replication.factor = 3
offset-syncs.topic.replication.factor = 3

# Number of tasks
tasks.max = 4
```

Launch:
```bash
connect-mirror-maker.sh mm2.properties
```

## Consumer Offset Translation

MM2 can translate offsets so consumers can "fail over" to the target cluster at the equivalent position:

- MirrorCheckpointConnector records a mapping of source offsets → target offsets in an internal topic (`<src>.checkpoints.internal`).
- Tool: `RemoteClusterUtils.translateOffsets()` converts group offsets.
- For Kafka 2.7+, MM2 can automatically translate and commit consumer offsets on the target cluster.

## Active-Active Concerns

Two clusters both replicating to each other can cause a loop: a record written on src is replicated to dst, then dst replicates it back to src.

Solutions:
- **DefaultReplicationPolicy** prefixes the topic name with the source alias — the target connector sees the name is already prefixed and skips.
- **Different ACLs** or topic conventions to avoid loops.

## Internal Topics on Target

- `<src>.heartbeats` — heartbeat records.
- `<src>.checkpoints.internal` — offset checkpoints.
- `mm2-offsets.<src>.internal` — MM2's own offsets.

## Cluster Linking (Confluent Platform Only)

Cluster Linking is a **Confluent-proprietary** feature that avoids using Connect — it's a direct broker-to-broker replication protocol.

Advantages over MM2:
- **Lower latency** — replicates at the protocol level, not through producers/consumers.
- **Preserves offsets** — the destination topic has the same offsets as the source (no translation needed).
- **Simpler operational model** — no Connect cluster to manage.
- **Mirror topics** are read-only on the destination by default.

### Concepts

- **Cluster link** — a named connection from destination → source.
- **Mirror topic** — a topic on the destination backed by a topic on the source.

Creating a cluster link:

```bash
confluent kafka link create <link-name> \
  --url <source-bootstrap-servers> \
  --config-file source.properties \
  --cluster <destination-cluster-id>
```

Creating a mirror topic:

```bash
confluent kafka mirror create orders --link <link-name>
```

The topic `orders` on the destination is now a mirror of `orders` on the source.

### Promoting a Mirror Topic

In a DR scenario, you promote the mirror to become writable:

```bash
confluent kafka mirror promote orders --link <link-name>
```

Or fail over via `failover` command.

### Cluster Linking vs MM2

| Feature | Cluster Linking | MM2 |
|---------|-----------------|-----|
| Offset preservation | Yes (byte-for-byte) | No (translated) |
| Latency | Very low | Higher (Connect overhead) |
| Topic rename | Configurable | Default prefix |
| ACLs preserved | Yes | No |
| Apache Kafka | No | Yes |
| Throughput | High | Medium |

## Exam Pointers

- MM2 is **Connect-based**; three connectors: Source, Heartbeat, Checkpoint.
- Default replication policy **prefixes with the source alias**.
- Offsets are NOT byte-compatible across clusters under MM2 — translated via checkpoints.
- Cluster Linking is **Confluent-only**; preserves offsets; byte-level replication.
- Active-active with MM2 requires careful topic naming to avoid loops.
- Internal topics (`__*`) are typically excluded from replication.
- For DR, the offset translation mapping is essential — consumers on DR need it to resume cleanly.

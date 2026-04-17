# Article 30: Performance Tuning

## The Tuning Triangle

You tune between three conflicting goals:

```
            Throughput
               △
              ╱ ╲
             ╱   ╲
            ╱     ╲
   Latency ◁───────▷ Durability
```

Pushing one usually compromises another. Producer configs offer fine-grained control.

## Producer Tuning

### For throughput

```properties
acks=all                    # required for durability but OK for throughput with idempotence
linger.ms=20-100            # allow bigger batches
batch.size=131072-524288    # 128-512KB batches
compression.type=lz4        # or zstd
buffer.memory=67108864      # 64 MB
max.in.flight.requests.per.connection=5
```

The magic: `linger.ms + batch.size` together dictate batch efficiency. Compression amplifies throughput by reducing network bytes.

### For latency

```properties
linger.ms=0                 # send immediately
batch.size=16384            # default; small batches OK
compression.type=none       # avoid CPU work
acks=1                      # faster ack, less durable
```

### For durability (lowest loss risk)

```properties
acks=all
enable.idempotence=true
retries=Integer.MAX_VALUE
delivery.timeout.ms=300000
max.in.flight.requests.per.connection=5
```

Broker side:
```properties
min.insync.replicas=2       # on the topic
replication.factor=3
unclean.leader.election.enable=false
```

## Consumer Tuning

### For throughput

```properties
fetch.min.bytes=65536       # wait for 64 KB
fetch.max.wait.ms=500       # but no more than 500 ms
max.partition.fetch.bytes=1048576
max.poll.records=500        # default; raise if processing is fast
```

### For latency

```properties
fetch.min.bytes=1
fetch.max.wait.ms=100
max.poll.records=10
```

### For slow processing

If your per-record work takes seconds, beware `max.poll.interval.ms`:

```properties
max.poll.records=50          # smaller batches
max.poll.interval.ms=600000  # 10 minutes, if truly needed
```

Or better: offload processing to worker threads and keep poll loop fast.

## Broker Tuning

### Disk

- Use dedicated disks for Kafka's `log.dirs` — ideally SSDs (NVMe for high throughput).
- One log dir per disk; Kafka spreads partitions across dirs.
- Filesystem: XFS recommended over ext4.
- Disable `atime`: `mount -o noatime`.

### Memory

- **Don't oversize the JVM heap.** Typical: 5–6 GB. Remaining RAM goes to **page cache** (which Kafka heavily relies on).
- `log.flush.interval.messages` / `log.flush.interval.ms` → leave at defaults (very large); let OS flush via fsync on segment close.

### Network

- Tune `num.network.threads` (default 3) — usually no need to touch unless you see `NetworkProcessor.AvgIdlePercent` < 0.3.
- Tune `num.io.threads` (default 8).

### OS Kernel

- `vm.swappiness=1` (avoid swapping page cache).
- `vm.dirty_ratio=80`, `vm.dirty_background_ratio=5`.
- `net.core.rmem_max`, `net.core.wmem_max` — bigger socket buffers for high throughput links.
- File descriptor limits: at least 100k per broker (each partition replica opens 3–5 files).

### Replication

- `num.replica.fetchers=4` (up from default 1) — parallel fetchers from leaders.
- `replica.fetch.max.bytes=1048576` (default, increase cautiously).

## Partition Sizing

Guidelines:

- **Target partition size**: 25–50 GB on disk after compression.
- **Max partitions per broker**: ~4000 (with ZK); 200k+ with KRaft.
- **Max partitions in a topic**: typically 1000; beyond that, operational cost grows.

Remember: partitions are the unit of parallelism. Adding partitions post-hoc is cheap (but **rehashes keys**).

## Replication Factor Choice

| RF | Trade-off |
|---:|-----------|
| 1 | Dev only, no durability |
| 2 | Minimal production; one failure = partition offline |
| 3 | **Recommended production** — tolerates 1 broker loss |
| 5 | Extreme durability, more overhead |

Combined with `min.insync.replicas`:
- RF=3 + minISR=2 → tolerate 1 broker failure, no data loss, no availability loss.
- RF=3 + minISR=3 → zero ISR drops; any failure = outage.

## Compression Trade-offs

| Codec | CPU | Ratio | Recommended |
|-------|----:|------:|:-----------:|
| `gzip` | High | Best | Legacy only |
| `snappy` | Low | Medium | Widely compatible |
| `lz4` | Lowest | Medium | Low CPU; recommended |
| `zstd` | Medium | Best | Modern default (2.1+) |

Compression happens **per batch**, not per record. Small batches → little compression benefit.

## Producer Interceptor Overhead

`interceptor.classes=...` runs for every record. A poorly written interceptor can halve throughput. Keep interceptors lean.

## Sticky Partitioner Impact

The default partitioner since 2.4+ (UniformStickyPartitioner / DefaultPartitioner) **sticks to one partition** until the batch is full, then rotates. This dramatically improves batching for null-keyed records.

If you're seeing uneven partition load with null keys, it's this partitioner (by design).

For stricter even distribution use `partitioner.class=org.apache.kafka.clients.producer.RoundRobinPartitioner` — but you lose batch efficiency.

## Consumer Group Sizing

- `numConsumers ≤ numPartitions`.
- Extra consumers are idle — wasted resources.
- Right-size based on per-consumer throughput × target rate.

## Streams Tuning

- `num.stream.threads` — parallelism per instance. Typically = CPU cores / 2.
- `commit.interval.ms`:
  - 30000 (default, at-least-once) — throughput.
  - 100 (EOS) — lower latency.
- `cache.max.bytes.buffering` / `statestore.cache.max.bytes` — higher = less downstream traffic, higher memory.
- `num.standby.replicas` — RF-like for state stores, enables fast failover.

## Connect Tuning

- `tasks.max` — parallelism of a connector.
- Sink: `consumer.max.poll.records`, `consumer.max.partition.fetch.bytes`.
- Source: connector-specific (e.g., JDBC `batch.max.rows`).
- Worker: `producer.override.compression.type=lz4` for sink.

## Common Bottlenecks

| Symptom | Usual Cause | Fix |
|---------|-------------|-----|
| High Produce latency, low disk I/O | `acks=all` + small ISR or slow follower | Check ISR health, reduce cross-AZ latency |
| Producer `BufferExhaustedException` | Backpressure, slow broker | Increase `buffer.memory` or fix broker |
| Consumer lag growing | Processing too slow | Scale consumers, parallelize processing |
| Consumer poll timeout → rebalance loop | Processing > `max.poll.interval.ms` | Reduce `max.poll.records` or raise timeout |
| Frequent rebalances | Consumer instability, long GC | Use `group.instance.id`, fix app |
| Under-replicated partitions | Slow disk or network on one broker | Replace disk, check network |

## Benchmarking Recipe

```bash
# Producer
kafka-producer-perf-test \
  --topic perf \
  --num-records 10000000 --record-size 1024 --throughput -1 \
  --producer-props bootstrap.servers=broker:9092 acks=all compression.type=lz4 linger.ms=20 batch.size=131072

# Consumer
kafka-consumer-perf-test \
  --bootstrap-server broker:9092 \
  --topic perf --messages 10000000 \
  --group perf-group
```

Vary one config at a time; measure throughput and latency.

## Exam Pointers

- For durability: `acks=all` + `min.insync.replicas=2` + `RF=3`.
- For throughput: `linger.ms` + `batch.size` + compression.
- Page cache is sacred — don't bloat the JVM heap.
- `num.stream.threads` ~ CPU/2 for Streams.
- `lz4` or `zstd` for modern compression.
- Extra consumers beyond partition count = wasted.
- Streams EOS sets `commit.interval.ms=100`, higher overhead.

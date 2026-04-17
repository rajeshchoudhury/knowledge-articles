# Article 33: Troubleshooting Common Kafka Issues

Most production issues fall into recognizable patterns. Master these and you'll diagnose fast.

## Producer Issues

### "Producer closed while send in progress"

**Cause:** `producer.close()` called while records are still buffered.
**Fix:** Call `producer.flush()` before `close()`, or use `close(timeout)`.

### `TimeoutException: Expiring N records after Xms`

**Cause:** Record stuck in accumulator longer than `delivery.timeout.ms`. Usually broker unavailable or network issues.
**Fix:**
- Check broker health.
- Increase `delivery.timeout.ms` if the broker is slow but eventually available.
- Check `request.timeout.ms` and `linger.ms` sum.

### `BufferExhaustedException` (really `TimeoutException` on `send()`)

**Cause:** `buffer.memory` full, `max.block.ms` exceeded.
**Fix:**
- Increase `buffer.memory`.
- Slow application down (backpressure).
- Diagnose broker: likely slow/backed up.

### `OutOfOrderSequenceException`

**Cause:** Idempotent producer detected a sequence number gap. Indicates that records were dropped somehow (possibly broker retention evicted them before a retry).
**Fix:**
- Close producer and restart. This is a **fatal** error.
- Investigate broker logs: possibly `replica.lag.time.max.ms` too short causing ISR churn.

### `ProducerFencedException`

**Cause:** Transactional producer: another process started a producer with the same `transactional.id` and got a higher epoch.
**Fix:**
- Fatal for this instance. Close and exit.
- Ensure `transactional.id` uniqueness (one logical producer per ID).

### Records sent with acks=all succeed but data is lost

**Cause:** `unclean.leader.election.enable=true` AND a non-ISR broker got elected.
**Fix:** Set to `false` (default since 0.11).

### Batching is poor (small batch-size-avg)

**Cause:** `linger.ms=0` (default) sends immediately.
**Fix:** Increase `linger.ms` to 5–20 ms.

## Consumer Issues

### Consumer group stuck in `PreparingRebalance` or `CompletingRebalance`

**Cause:**
- A consumer isn't heartbeating or isn't completing join/sync.
- Long GC pauses.
- Network partition.

**Fix:**
- Check consumer logs for GC.
- Raise `session.timeout.ms`.
- Use `group.instance.id` (static membership) to avoid restart-triggered rebalances.

### `CommitFailedException` — "Commit cannot be completed since the group has already rebalanced"

**Cause:** Consumer processed longer than `max.poll.interval.ms`. Partition reassigned to someone else.
**Fix:**
- Reduce `max.poll.records`.
- Increase `max.poll.interval.ms`.
- Offload processing to worker threads.

### Duplicate processing observed

**Cause:** Commit happens **after** processing (at-least-once); crash between process and commit.
**Fix:** Idempotent downstream, or use EOS (transactional producer + `sendOffsetsToTransaction`).

### Consumer reads no records

**Possible causes:**
- No committed offset AND `auto.offset.reset=latest` → starts at log end.
- Subscribed to wrong topic.
- ACLs missing.
- Consumer paused.
- Topic has `acks=all` with broken ISR → consumers still read, but no new writes.

### `InvalidOffsetException` / `OffsetOutOfRangeException`

**Cause:** Committed offset is outside the log's range (retention deleted the older data).
**Fix:** Catch and reset to earliest/latest; or reset via `kafka-consumer-groups --reset-offsets`.

### Rebalance loops

**Cause:** Consumer group repeatedly joins/leaves.
- Long GC.
- `max.poll.interval.ms` too small for processing.
- Flaky network.

**Fix:** See above.

## Broker Issues

### `UnderReplicatedPartitions > 0`

**Cause:** At least one follower lagging.
**Fix:**
- Check the slow broker's disk I/O, network.
- Possibly raise `num.replica.fetchers` or `replica.fetch.max.bytes`.

### `NotEnoughReplicasException` on producer

**Cause:** `acks=all` + ISR count < `min.insync.replicas`.
**Fix:** Restore broker availability; the producer auto-retries.

### Controller keeps failing over

**Cause:**
- ZK session issues (pre-KRaft).
- Controller broker under memory/CPU pressure.

**Fix:**
- Check ZK timeouts.
- Move controller role off a loaded broker (KRaft allows dedicated controllers).

### Log recovery slow on broker restart

**Cause:** Many segments to scan.
**Fix:**
- `log.flush.scheduler.interval.ms` and `log.flush.start.offset.checkpoint.interval.ms`.
- Shutdown cleanly (not SIGKILL).
- Raise `num.recovery.threads.per.data.dir`.

### "Too many open files"

**Cause:** File descriptor limit too low for the number of partition replicas.
**Fix:** Raise `ulimit -n` to 100k+; adjust systemd limits.

## Schema Registry Issues

### `SerializationException: Error deserializing Avro message`

**Cause:**
- Magic byte not 0 (non-Confluent-serialized record).
- Schema ID not in registry.
- Reader schema incompatible with writer.

**Fix:**
- Confirm producer uses `KafkaAvroSerializer`.
- Ensure registry has the schema (or is reachable).
- For evolution issues, check compatibility mode.

### `RestClientException: Schema not found; error code: 40403`

**Cause:** Schema ID in the record doesn't exist in this registry (e.g., cross-cluster mirroring where schemas weren't also mirrored).
**Fix:** Mirror schemas to the target registry or use a shared registry.

### Schema evolution fails (`Incompatible schema`)

**Cause:** New schema violates the compatibility rule.
**Fix:**
- Check mode: `GET /config/<subject>`.
- Reconsider the change; add defaults; or (carefully) switch compatibility mode.

## Connect Issues

### Connector stuck in `FAILED`

**Cause:** Task-level exception. Check `/connectors/<name>/status` for stack trace.
**Fix:**
- Fix the root cause (bad config, missing plugin, external system down).
- `POST /connectors/<name>/restart`.

### Sink connector can't deserialize records

**Cause:** Wrong converter.
**Fix:**
- Align `value.converter` with the producer's serializer.
- Enable `errors.tolerance=all` + DLQ.

### Rebalance storms in Connect cluster

**Cause:**
- Workers thrashing (GC, network).
- `group.id` mismatch.

**Fix:**
- Stable `group.id`.
- Adequate heap.

## Kafka Streams Issues

### `InvalidStateStoreException: Cannot get state store X because the stream thread is PARTITIONS_ASSIGNED, not RUNNING`

**Cause:** Interactive query during rebalance/restore.
**Fix:** Wait for `KafkaStreams.State.RUNNING`; use `streams.state()` check, or retry.

### State store keeps restoring forever

**Cause:** Changelog topic huge AND no local RocksDB copy. Or changelog compaction not active, so unlimited history.
**Fix:**
- Verify changelog topic is `compact`.
- Provide standby replicas.
- Ensure adequate disk on new instance.

### `TopologyException: Invalid topology`

**Cause:** Source or sink missing, or repartition topic names colliding.
**Fix:** Always name operations (`Named.as(...)`), use unique topic names per app.

### Output topic has duplicates despite EOS

**Cause:**
- `processing.guarantee` not set to `exactly_once_v2`.
- External consumer reads with `read_uncommitted`.
- Side effects in user code (external DB writes) ran twice.

**Fix:** Set EOS correctly; tell consumers to use `read_committed`.

## General Debugging Tips

- Increase log level temporarily: `kafka-configs --entity-type broker-loggers --alter --add-config kafka.controller=DEBUG`.
- Use `kafka-dump-log` to inspect specific log files.
- Use `kafka-console-consumer --partition 0 --offset X` to read a specific record.
- Use `kafka-consumer-groups --describe` to see lag per partition.
- Inspect `__consumer_offsets` with `--offsets-decoder`.
- Inspect `__transaction_state` with `--transaction-log-decoder`.

## Exam Pointers

- **`CommitFailedException` = processing took too long** — reduce `max.poll.records` or raise `max.poll.interval.ms`.
- **`ProducerFencedException`, `OutOfOrderSequenceException`** = fatal; close the producer.
- **`UnderReplicatedPartitions > 0`** = follower is slow; not necessarily data loss.
- **`NotEnoughReplicasException`** = ISR < `min.insync.replicas` on `acks=all`.
- Rebalance loops → check GC, `session.timeout.ms`, `max.poll.interval.ms`, consider static membership.
- Bad deserialization can cause infinite poll loops unless handled.

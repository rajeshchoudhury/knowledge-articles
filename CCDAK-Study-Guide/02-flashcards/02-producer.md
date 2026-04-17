# Flashcards: Producer

---

Q: What is the default value of `acks` in Kafka 3.x+?
A: `all` (was `1` before 3.0).

---

Q: What is the default of `enable.idempotence` in Kafka 3.x+?
A: `true`.

---

Q: What is the default of `max.in.flight.requests.per.connection`?
A: 5.

---

Q: What is the default of `retries`?
A: `Integer.MAX_VALUE` (2,147,483,647).

---

Q: What does `acks=0` mean?
A: The producer does not wait for any acknowledgement. Records may be lost even if the broker is up.

---

Q: What does `acks=1` mean?
A: The leader has written to its local log. No wait for follower replication — risk of data loss if the leader fails before replicating.

---

Q: What does `acks=all` mean?
A: All in-sync replicas (at least `min.insync.replicas`) have acknowledged the write.

---

Q: What configs are required for idempotent producer?
A: `acks=all`, `retries > 0`, and `max.in.flight.requests.per.connection ≤ 5` (enforced at client startup since 3.0).

---

Q: What does the idempotent producer guarantee?
A: No duplicates **per partition, per producer session**. Uses PID + epoch + sequence numbers.

---

Q: What is a "producer ID" (PID)?
A: A unique identifier assigned to a producer by the broker on `InitProducerId`. Used for deduplication.

---

Q: What happens if sequence numbers have a gap?
A: The broker throws `OutOfOrderSequenceException` — fatal for the idempotent producer.

---

Q: Does idempotence survive a producer restart?
A: No. A new PID is allocated on restart; there is no cross-session dedup.

---

Q: What is the key difference between idempotence and transactions?
A: Idempotence = per-partition, per-session dedup. Transactions = atomic across partitions, across sessions (via fencing).

---

Q: What config enables transactions?
A: Setting `transactional.id=<stable-id>`. This implicitly requires `enable.idempotence=true`.

---

Q: What must be stable across restarts for transactions to work?
A: The `transactional.id`. This enables fencing of zombie producers.

---

Q: What is `ProducerFencedException`?
A: A fatal exception: a newer producer with the same `transactional.id` and higher epoch has taken over. The current producer must be closed.

---

Q: What is `transaction.timeout.ms` default?
A: 60,000 ms.

---

Q: What caps `transaction.timeout.ms`?
A: The broker's `transaction.max.timeout.ms` (default 900,000 ms / 15 min).

---

Q: What method commits consumer offsets inside a transaction?
A: `producer.sendOffsetsToTransaction(offsets, consumer.groupMetadata())`.

---

Q: What is `linger.ms` default?
A: 0 — send immediately.

---

Q: What does `linger.ms > 0` do?
A: Delays sending so more records batch together. Trades latency for throughput.

---

Q: What is `batch.size` default?
A: 16384 bytes (16 KB).

---

Q: What is `buffer.memory` default?
A: 33,554,432 bytes (32 MB).

---

Q: What happens when `buffer.memory` is full?
A: `send()` blocks for up to `max.block.ms` (default 60s); then throws `TimeoutException`.

---

Q: What is `max.block.ms` default?
A: 60,000 ms.

---

Q: What is `delivery.timeout.ms` default?
A: 120,000 ms (2 min).

---

Q: What must hold: `delivery.timeout.ms >= ?`
A: `delivery.timeout.ms >= linger.ms + request.timeout.ms`.

---

Q: What is `request.timeout.ms` default?
A: 30,000 ms.

---

Q: What is `max.request.size` default?
A: 1,048,576 bytes (~1 MB).

---

Q: What compression codecs does Kafka support?
A: `none` (default), `gzip`, `snappy`, `lz4`, `zstd`.

---

Q: Which compression codec is best for modern deployments?
A: `zstd` (best ratio/speed trade-off since Kafka 2.1). `lz4` is also commonly used for low CPU cost.

---

Q: What does `compression.type=producer` on a topic mean?
A: The broker stores whatever the producer sent. No recompression.

---

Q: What is the default partitioner?
A: Since Kafka 3.3, a unified `DefaultPartitioner` that hashes non-null keys via murmur2 and uses a sticky/uniform-sticky strategy for null keys.

---

Q: How does the sticky partitioner work for null keys?
A: Sends all records to a single partition until the current batch is sent, then rotates to the next partition. Improves batching.

---

Q: If you set `partitioner.class=RoundRobinPartitioner`, what happens?
A: Every record goes to the next partition in round-robin order — defeats batching, improves distribution uniformity.

---

Q: What's the formula the default partitioner uses for non-null keys?
A: `murmur2(key) % numPartitions`.

---

Q: Are callbacks invoked on the application thread?
A: No. They run on the Sender (I/O) thread. Long-running callbacks will block the Sender and kill throughput.

---

Q: What happens in `producer.flush()`?
A: Blocks until all buffered records have been sent (and acked or failed).

---

Q: What happens in `producer.close()`?
A: Flushes, then releases resources. If called with a timeout, abort pending records after that window.

---

Q: What are the "retriable" exception types the producer can recover from?
A: `NotEnoughReplicasException`, `NotLeaderForPartitionException`, `LeaderNotAvailableException`, `NetworkException`, many `TimeoutException` cases.

---

Q: What are "fatal" producer exceptions?
A: `SerializationException`, `RecordTooLargeException`, `AuthenticationException`, `AuthorizationException`, `OutOfOrderSequenceException`, `ProducerFencedException`.

---

Q: How does `max.in.flight.requests.per.connection=1` affect ordering on retry?
A: Guarantees order because only one request is being retried at a time — but throughput suffers.

---

Q: Can idempotent producers allow `max.in.flight > 1` without reordering?
A: Yes. The broker uses sequence numbers to preserve order regardless — up to 5 in-flight.

---

Q: What's the wire format of a ProducerRecord on the wire?
A: A record batch containing one or more records. Records contain key length, key, value length, value, headers, relative offset, and delta timestamp.

---

Q: Can you send records with a null key?
A: Yes. The default partitioner uses the sticky strategy for null keys. Compacted topics cannot use null keys though.

---

Q: Can you send records with a null value?
A: Yes. For compacted topics, a null value is a **tombstone**.

---

Q: What is a "ProducerInterceptor"?
A: A pluggable class that runs on every record before send() and before the callback fires. Used for metrics, logging, or field mutations.

---

Q: What's the effect of `interceptor.classes` on throughput?
A: Interceptors add CPU work per record. Heavy interceptors can halve throughput.

---

Q: What three components define throughput in a producer?
A: Batch size, linger time, and compression. Tune all three together.

---

Q: What's the `client.id` for?
A: An identifying string for the producer in server logs, metrics, and quota accounting.

---

Q: How does the producer discover brokers?
A: Initial connection to `bootstrap.servers`, which returns full metadata. Subsequent connections go directly to partition leaders.

---

Q: What's `connections.max.idle.ms`?
A: How long an idle connection is kept open before the client closes it. Default 540,000 ms (9 min).

---

Q: What's `metadata.max.age.ms`?
A: Forced refresh interval for cached metadata. Default 300,000 ms.

---

Q: How do you flush a producer before close?
A: `producer.flush()` — blocks until all in-flight records are acked/failed.

---

Q: What's the difference between `send(rec).get()` and `send(rec, cb)`?
A: `get()` synchronously blocks the caller; `send(rec, cb)` is async and invokes the callback on the Sender thread.

---

Q: What's `producer.initTransactions()`?
A: Called once at startup. Fetches/advances the PID and epoch from the transaction coordinator, fencing any older producer with the same transactional.id.

---

Q: In a transactional producer, can you call `send()` without `beginTransaction()`?
A: No. Sends outside a transaction fail with `IllegalStateException`.

---

Q: When does a transaction commit?
A: On `commitTransaction()`, which atomically marks all written records as committed and updates the transaction state log.

---

Q: What happens if you forget `commitTransaction()`?
A: After `transaction.timeout.ms`, the coordinator aborts the transaction and the producer is fenced on the next `beginTransaction()`.

---

Q: What is `linger.ms` + `batch.size` interaction?
A: A batch flushes when it reaches `batch.size` OR when `linger.ms` elapses, whichever happens first.

---

Q: Can you enable compression without setting `linger.ms` > 0?
A: Yes, but compression on small batches yields little benefit. Combine with linger for best results.

---

Q: What is `sticky partitioner` vs the old default partitioner for null keys?
A: Old (pre-2.4): round-robin with smaller batches. Sticky (2.4+): commits to one partition per batch, producing larger and more efficient batches.

---

# Flashcards: Consumer

---

Q: What does `consumer.subscribe()` do?
A: Registers the consumer with its group; the coordinator assigns partitions. Triggers group-protocol rebalances.

---

Q: What does `consumer.assign()` do?
A: Directly assigns specific TopicPartitions. No group coordination, no rebalances, no auto-commit.

---

Q: Can you use both `subscribe()` and `assign()` on the same consumer?
A: No — they are mutually exclusive.

---

Q: What is a consumer group?
A: A set of consumers identified by `group.id`; Kafka ensures each partition is consumed by exactly one member of the group.

---

Q: What if there are more consumers than partitions in a group?
A: Extras are idle.

---

Q: What is `group.id` required for?
A: Required for `subscribe()`; also needed when committing offsets from an `assign()`-based consumer.

---

Q: Who is the group coordinator?
A: The broker that leads the `__consumer_offsets` partition for the hash of the `group.id`.

---

Q: What is the default `auto.offset.reset`?
A: `latest` — start from end of log if no committed offset.

---

Q: When does `auto.offset.reset` take effect?
A: Only when no committed offset exists for the group. If an offset exists, it is used regardless.

---

Q: What does `enable.auto.commit=true` do?
A: The background thread commits the current position every `auto.commit.interval.ms` (default 5s).

---

Q: What is `auto.commit.interval.ms` default?
A: 5,000 ms.

---

Q: What's the risk of auto-commit?
A: You may commit offsets for records the application hasn't yet processed, leading to data loss on crash.

---

Q: What is `session.timeout.ms` default?
A: 45,000 ms.

---

Q: What is `heartbeat.interval.ms` default?
A: 3,000 ms.

---

Q: What is `max.poll.interval.ms` default?
A: 300,000 ms (5 min).

---

Q: What's the difference between `session.timeout.ms` and `max.poll.interval.ms`?
A: Session timeout is between heartbeats (background thread); poll interval is between poll() calls (main thread).

---

Q: What happens if `max.poll.interval.ms` is exceeded?
A: Consumer is removed from the group; rebalance is triggered. The consumer's next commit fails with `CommitFailedException`.

---

Q: What does `commitSync()` commit?
A: The offsets for the records returned by the last `poll()` (i.e., the offset of the next record to process).

---

Q: What does `commitAsync()` do differently?
A: Does not block; does not retry on failure (could commit a lower offset after a higher one succeeded).

---

Q: How do you commit explicit offsets?
A: `consumer.commitSync(Map<TopicPartition, OffsetAndMetadata>)`.

---

Q: What value in `OffsetAndMetadata` represents "processed through offset N"?
A: `N+1` — the offset of the next record to consume.

---

Q: What is `max.poll.records` default?
A: 500.

---

Q: What is `fetch.min.bytes` default?
A: 1.

---

Q: What is `fetch.max.wait.ms` default?
A: 500.

---

Q: What is `max.partition.fetch.bytes` default?
A: 1,048,576 (1 MB).

---

Q: What is `fetch.max.bytes` default?
A: 52,428,800 (50 MB).

---

Q: What is `isolation.level` default?
A: `read_uncommitted`. For exactly-once with transactions, set to `read_committed`.

---

Q: What does `isolation.level=read_committed` do?
A: Skips aborted transactional records; reads up to the Last Stable Offset (LSO) — no open transactions pass through.

---

Q: What are the partition assignment strategies?
A: `RangeAssignor`, `RoundRobinAssignor`, `StickyAssignor`, `CooperativeStickyAssignor`.

---

Q: What is the default partition assignment strategy in Kafka 2.8+?
A: `RangeAssignor,CooperativeStickyAssignor` (a list). The first strategy all members have in common wins.

---

Q: What's unique about CooperativeStickyAssignor?
A: It's **incremental** — only partitions that need to move are revoked; others keep processing during rebalance.

---

Q: What is static group membership?
A: Set `group.instance.id` to a stable ID. On restart, the coordinator keeps the slot assigned to the same static member — no rebalance.

---

Q: What's the default for `group.instance.id`?
A: `null` (dynamic membership).

---

Q: What is `ConsumerRebalanceListener.onPartitionsRevoked()` for?
A: Called before a rebalance so you can commit offsets before losing the partition.

---

Q: What is `ConsumerRebalanceListener.onPartitionsLost()` used for?
A: Called (in cooperative mode) when partitions are forcibly revoked (e.g., session timeout). Do NOT commit in this handler.

---

Q: Is `KafkaConsumer` thread-safe?
A: No. Never share a single consumer across threads (except for `wakeup()`).

---

Q: How do you wake a blocked consumer from another thread?
A: Call `consumer.wakeup()`. The next `poll()` throws `WakeupException`.

---

Q: What's `pause(partitions)` for?
A: Stops fetching records for those partitions while keeping the consumer alive (heartbeats still work).

---

Q: How do you seek by timestamp?
A: `consumer.offsetsForTimes(Map<TP, Long>)` returns the earliest offsets with timestamp ≥ the queried time; then call `seek()`.

---

Q: What exception is thrown when a committed offset is outside the log?
A: `OffsetOutOfRangeException` (a subclass of `InvalidOffsetException`).

---

Q: How long do consumer group offsets persist without activity?
A: `offsets.retention.minutes` default is 10080 (7 days). After that, offsets are deleted and `auto.offset.reset` kicks in.

---

Q: Where are consumer offsets stored?
A: In the `__consumer_offsets` topic, keyed by `(group, topic, partition)`.

---

Q: What's the default partitions for `__consumer_offsets`?
A: 50.

---

Q: What's the default replication factor for `__consumer_offsets`?
A: 3.

---

Q: Can you commit offsets for partitions you're not assigned?
A: No — throws `IllegalStateException`.

---

Q: What does `consumer.position(partition)` return?
A: The offset the consumer will next fetch for that partition.

---

Q: What does `consumer.committed(partition)` return?
A: The last committed offset from `__consumer_offsets` (or null if none).

---

Q: What does `consumer.endOffsets(partitions)` return?
A: The log-end offset for each partition.

---

Q: Can `subscribe()` use a regex?
A: Yes: `consumer.subscribe(Pattern.compile("orders-.*"));`. New matching topics trigger rebalances.

---

Q: What's the default of `allow.auto.create.topics` for consumers?
A: true. Set to false to avoid accidental topic creation.

---

Q: What happens if two consumers in the same group have different `partition.assignment.strategy`?
A: The first strategy supported by ALL members wins. If no common strategy, rebalance fails.

---

Q: What does the consumer do when there are no records to return?
A: `poll()` waits up to the timeout you pass; returns an empty `ConsumerRecords`.

---

Q: What happens with a manual `commitSync()` call outside the poll loop?
A: The consumer commits the current in-memory position for all assigned partitions.

---

Q: What is the effect of a long GC pause on the consumer?
A: Heartbeats may stall → session timeout → consumer kicked out → rebalance on recovery.

---

Q: Can you use `assign()` for exactly-once with external state?
A: Yes. A common pattern is: assign to fixed partitions, store offsets in a DB alongside processed data.

---

Q: How is the offset of a record determined in a consumer?
A: It comes directly from the broker's log — it's the record's position in its partition.

---

Q: Do consumers read from followers or leaders by default?
A: From the leader. Follower fetch is available (KIP-392) via `client.rack` + broker `replica.selector.class=RackAwareReplicaSelector`.

---

Q: What does `client.rack` do?
A: Tells the broker which rack the consumer is in, enabling follower fetching to reduce cross-AZ traffic (when rack-aware selector is configured).

---

Q: What is the poll() timeout for?
A: The maximum time to block waiting for records. If no records, poll returns an empty batch.

---

Q: Why does `poll()` need to be called regularly even if no work is being done?
A: Because heartbeats, rebalances, and auto-commit are serviced inside `poll()`. Skipping leads to `max.poll.interval.ms` timeout.

---

Q: What's the behavior with extra consumers and cooperative rebalance?
A: The cooperative protocol still leaves extras idle, but the rebalance is incremental so active partitions keep flowing.

---

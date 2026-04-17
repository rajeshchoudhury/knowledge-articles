# Article 34: Exam Day Strategy

## Before the Exam (The Final 24 Hours)

1. **Sleep.** A well-rested brain scores 5–10% higher on technical exams.
2. **Hydrate.** Most proctored exams don't allow water breaks; drink before starting.
3. **One-pager review only.** Open `05-cheat-sheets/00-one-pager.md`. Do not attempt new material.
4. **Clear the workspace.** Remove books, phones, second monitors; dress casually.
5. **Test your webcam and mic.** Proctor systems are finicky.
6. **Know your exam time zone.**

## During the Exam — Time Management

- **60 questions, 90 minutes → 1.5 min/question.**
- Do not spend more than 90 seconds on any single question in the first pass.
- **Mark for review** and move on; you'll get 20–25 minutes of end-time to return.

### Suggested pacing

| Phase | Time | Goal |
|-------|------|------|
| First pass | 60 min | Answer 50 confidently, mark 10 |
| Review pass | 20 min | Close out the 10 |
| Buffer | 10 min | Double-check anything uncertain |

## Reading Questions Carefully

Every word matters. Watch for:

- **"ALL OF THE FOLLOWING EXCEPT"** — inverts the answer.
- **"MOST CORRECT"** — multiple options may be factually true; pick the one that directly answers.
- **"MINIMUM configuration"** — avoid gold-plated answers.
- **"In PRODUCTION"** — durability-leaning answer.
- **"HIGHEST THROUGHPUT"** — usually `linger.ms>0`, compression, async.
- **"LOWEST LATENCY"** — `acks=1`, `linger.ms=0`, no compression.

## Common Pitfalls and How to Dodge Them

### Defaults Matter

The exam asks "with default values, what happens?" For producer defaults (Kafka 3.x+):
- `acks=all`
- `enable.idempotence=true`
- `retries=Integer.MAX_VALUE`
- `max.in.flight.requests.per.connection=5`
- `linger.ms=0`
- `batch.size=16384`

Consumer:
- `auto.offset.reset=latest`
- `enable.auto.commit=true`
- `session.timeout.ms=45000`
- `max.poll.interval.ms=300000`
- `max.poll.records=500`

### Ordering Guarantees

- Within a partition: ordered.
- Across partitions: NOT ordered.
- The exam often stages scenarios where records appear "out of order" across partitions — they never were ordered.

### Extra Consumers

If a question says "a topic with 4 partitions and a consumer group with 6 consumers" — 2 consumers are **idle**.

### ACKs vs Durability

`acks=all` ALONE doesn't give durability. Needs:
- `min.insync.replicas >= 2`
- `replication.factor >= 3` (recommended)
- `unclean.leader.election.enable=false`
- `enable.idempotence=true` (for no duplicates)

### Exactly-Once

- **Idempotent producer** = no duplicates **per partition, per session**.
- **Transactional producer** = atomic **across partitions, across sessions**.
- Full EOS requires `isolation.level=read_committed` on consumer.

### Compatibility Modes

- **BACKWARD** (default) — new reader, old writer: OK. Consumer upgrades first.
- **FORWARD** — old reader, new writer: OK. Producer upgrades first.
- **FULL** — both.
- **TRANSITIVE** — apply across all prior versions, not just latest.

### Co-partitioning

KS-KS, KS-KT, KT-KT joins **require** matching partition counts + matching partitioner.

**GlobalKTable** joins do NOT require co-partitioning (and can use a key mapper).

### Compaction vs Deletion

`cleanup.policy=compact` keeps latest value per key. `delete` is the default (time/size retention).

Tombstones (null value) delete keys but persist for `delete.retention.ms` (default 24h).

## Elimination Strategy

When unsure:

1. Strike options mentioning non-existent configs.
2. Strike options with wrong defaults.
3. Strike options that misuse terminology (e.g., "the broker pushes to consumers" — false).
4. Strike options that solve a different problem than the question asked.

Usually this leaves 2 options; now apply the "most correct" / "minimum config" / "production-appropriate" lens.

## Physical Tips

- **Deep breaths** every 15 minutes — lowers stress-induced errors.
- **Read each question twice** before answering.
- If stuck for more than 90 seconds, **move on** — your brain will work on it in the background.
- **Eye breaks**: look at a distant point briefly between questions.

## Final Mental Model to Carry In

When in doubt, ask yourself:
1. **Where is the state?** (Producer buffer, broker log, consumer position, Streams state store?)
2. **What are the failure modes?** (What happens if the broker/consumer dies mid-operation?)
3. **Who is the principal?** (Who is authenticated for this operation?)
4. **What are the timestamps?** (Record timestamp, stream time, grace period?)
5. **What changed from the default?** (The exam rarely tests defaults directly — it tests what they imply.)

## After the Exam

- Screenshot the result if shown.
- Relax. You've prepared thoroughly.
- Confluent emails the certificate in 24–72 hours.
- Add it to LinkedIn; set a recertification reminder (2 years).

Good luck.

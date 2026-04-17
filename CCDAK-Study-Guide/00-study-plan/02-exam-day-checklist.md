# Exam Day Checklist

## 24 Hours Before

- [ ] Test your webcam, microphone, and internet on the proctor's system check tool.
- [ ] Clear the desk where you'll sit (no books, phones, second monitors).
- [ ] Have government-issued photo ID ready.
- [ ] Confirm the exam time zone.
- [ ] Do a **light** review of `05-cheat-sheets/00-one-pager.md` only. Do NOT cram.
- [ ] Sleep early.

## 2 Hours Before

- [ ] Light meal, plenty of water (but not right before — no breaks in most proctored exams).
- [ ] Re-read the compatibility-mode matrix and the producer config defaults ONCE.
- [ ] Close all apps except the proctor browser.
- [ ] Disable notifications, background updates.

## During the Exam

### Time Management

- 60 questions in 90 minutes ≈ **1.5 minutes/question**.
- Plan: first pass at 1 minute each, mark anything that takes > 75 seconds, come back.
- Reserve 15 minutes at the end for marked questions.

### Question Strategy

1. **Read every answer before picking.** Kafka exams love "most correct" answers where 2 options are technically true but only one is *best*.
2. **Eliminate obviously wrong answers first.** If an answer mentions a non-existent config or the wrong default, strike it.
3. **Watch for absolute words.** "Always", "never", "must" — Kafka has subtle exceptions (e.g., idempotent producer requires `acks=all` since 3.0, but previously allowed `acks=1`).
4. **Multi-select:** The question will tell you "Choose 2" or "Choose 3". If unsure, prioritize answers that directly solve the stated problem; secondary beneficial answers are usually distractors.
5. **Scenario questions:** Identify the *constraint* (cost, latency, durability, ordering, EOS) first — the answer that satisfies the constraint is almost always the best choice.

### Common Traps

| Trap | Watch For |
|------|-----------|
| "Exactly-once" without `transactional.id` | EOS across partitions requires transactions |
| Idempotence vs transactions | Idempotence = per-partition no-dupes; transactions = atomic across partitions |
| `auto.offset.reset` | Only triggers when **no** committed offset exists for the group |
| Consumer > partitions | Extra consumers are idle |
| Join co-partitioning | KS-KT requires same keys+partition count; GKT does not |
| Compaction vs retention | Compacted topics can also have time retention |
| `min.insync.replicas` | Only enforced when `acks=all` |
| `acks=all` alone ≠ no data loss | Need `min.insync.replicas >= 2` AND `replication.factor >= 3` |
| `delete.retention.ms` | For tombstones, not for general retention |
| Controller responsibilities | Not the same as a "leader" |

## After Submitting

- [ ] Screenshot / photograph any result screen (Confluent emails a certificate within 24–72 hours).
- [ ] Update LinkedIn, update recertification reminder (2 years).
- [ ] Review the domains with lower scores — helpful for real-world work.

## If You Fail (It Happens)

- Confluent lets you retake after **14 days**.
- Review your score breakdown — Confluent provides domain-level scoring.
- Focus your next study cycle on the weakest domain, plus one full refresher of the cheat sheets.
- Don't re-sit until you're consistently ≥ 85% on practice exams.

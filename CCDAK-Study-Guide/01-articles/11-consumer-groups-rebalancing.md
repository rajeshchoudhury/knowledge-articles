# Article 11: Consumer Groups and Rebalancing

## What is a Consumer Group?

A consumer group is identified by `group.id`. Within the group:

- Kafka ensures **each partition is consumed by exactly one member**.
- The number of members equals the number of active consumers that called `subscribe()` with the same `group.id`.
- If `consumers > partitions`, extras are idle.

Different groups reading the same topic are independent:

```
topic: orders (6 partitions)

Group "billing"    : consumer1 (p0,p1,p2)  consumer2 (p3,p4,p5)
Group "analytics"  : consumerA (p0..p5)
```

## The Group Coordinator

Each group has one **group coordinator** — a specific broker chosen by hashing `group.id` to a partition of `__consumer_offsets`. The leader of that partition serves as coordinator.

The coordinator:
- Tracks group membership via heartbeats.
- Runs the rebalance protocol.
- Persists offsets (when committed).

## The Rebalance Protocol (Eager / Classic)

The classic protocol works in two phases: **JoinGroup** and **SyncGroup**.

1. **Trigger events:** member joins, member leaves, member times out, partitions added to topic, new topic matches subscription regex.
2. **JoinGroup phase:** every member sends `JoinGroup` to coordinator with its subscription. Coordinator picks a **group leader** (first to join) and returns the full member list + subscriptions to the leader.
3. **Leader assigns partitions** using the configured `partition.assignment.strategy`.
4. **SyncGroup phase:** leader sends assignment to coordinator; coordinator distributes assignments back to each member.
5. Members call `poll()` and begin consuming.

### "Stop the World" Cost

Under the Eager protocol, **every member revokes all partitions at the start of the rebalance** and waits until the new assignment is known. During this window, no records are consumed. For large groups (hundreds of members), this can take seconds to minutes.

## Partition Assignment Strategies

Set via `partition.assignment.strategy` (a list; the first one all members have in common wins):

### Range (default pre-2.4)

For each topic, assign contiguous partition ranges:

```
Topic A: 4 partitions, Consumers [c1, c2]
  c1 → A-0, A-1
  c2 → A-2, A-3
```

**Problem:** with multiple co-subscribed topics, early consumers get more load.

### RoundRobin

All partitions from all topics are assigned in a round-robin fashion:

```
Topic A: 3 partitions, Topic B: 3 partitions, Consumers [c1, c2]
  c1 → A-0, A-2, B-1
  c2 → A-1, B-0, B-2
```

More even distribution. All consumers must subscribe to same topics.

### Sticky (2.0+)

On rebalance, tries to **preserve existing assignments** as much as possible while still achieving balance. Minimizes state-store migration for stateful consumers. Still eager — still stops the world.

### CooperativeSticky (2.4+, Incremental)

Runs a **cooperative rebalance** — only partitions that need to move are revoked. Members keep consuming the rest during rebalance.

Process:
1. First rebalance: revoke *only* the partitions that will move. Others keep processing.
2. Second rebalance shortly after: assign the freed partitions.

Requires `partition.assignment.strategy = CooperativeStickyAssignor`. **This is the recommended choice for modern deployments.**

### Comparison

| Strategy | Load Balance | Migration Impact | Stop-the-world? |
|----------|--------------|-------------------|------------------|
| Range | Poor with multi-topic | High | Yes |
| RoundRobin | Good | High | Yes |
| Sticky | Good | Low | Yes |
| CooperativeSticky | Good | Low | **No (incremental)** |

## ConsumerRebalanceListener

Hook into rebalance events to commit offsets and manage state:

```java
consumer.subscribe(List.of("orders"), new ConsumerRebalanceListener() {
    @Override
    public void onPartitionsRevoked(Collection<TopicPartition> partitions) {
        // Called BEFORE rebalance; good place to commitSync()
        consumer.commitSync();
    }

    @Override
    public void onPartitionsAssigned(Collection<TopicPartition> partitions) {
        // Called AFTER rebalance; initialize per-partition state, seek, etc.
    }

    @Override
    public void onPartitionsLost(Collection<TopicPartition> partitions) {
        // Only called in CooperativeSticky when partitions are forcibly revoked (timeout)
        // Do NOT commit — partitions are gone
    }
});
```

With Cooperative rebalance:
- `onPartitionsRevoked` is called only for partitions that will move — not all.
- `onPartitionsAssigned` is called only with newly assigned partitions — not all.

## Static Group Membership

Traditionally, every restart triggers a rebalance because the coordinator sees the old consumer drop and a new one join.

**Static membership** (introduced in 2.3) solves this via `group.instance.id`:

- Set `group.instance.id` to a stable string (e.g., pod name).
- On restart, coordinator recognizes the same static member within `session.timeout.ms`.
- No rebalance occurs.

Use case: Kubernetes StatefulSets where pods are ephemeral but logical identity is stable.

Caveats:
- Session timeout should be raised (e.g., to 5 min) so a restart fits within the window.
- If the static member never comes back, the slot remains idle until `session.timeout.ms` expires.

## Rebalance Causes

| Cause | Trigger |
|-------|---------|
| New consumer joins group | `JoinGroup` RPC |
| Consumer leaves gracefully | `LeaveGroup` RPC on `close()` (unless `internal.leave.group.on.close=false`) |
| Consumer crashes | Heartbeat timeout after `session.timeout.ms` |
| Consumer processing takes too long | `max.poll.interval.ms` elapses between polls |
| Topic's partition count grows | Metadata change |
| New topic matches subscription regex | Metadata change |

## Offset Commits & Rebalances

When a rebalance starts:
1. **`onPartitionsRevoked`** is called first — commit offsets here.
2. If you don't commit, records processed since the last commit will be **reprocessed** by whichever consumer gets the partition next.

Idempotent processing + manual commits is the typical production pattern.

## Incremental Cooperative Rebalance in Action

```
Initial state: c1 owns [p0,p1,p2,p3], c2 owns [p4,p5,p6,p7]
New consumer c3 joins.

Goal: c1=[p0,p1,p2], c2=[p4,p5,p6], c3=[p3,p7]
```

### Eager protocol:
- c1 revokes ALL of [p0..p3]. c2 revokes ALL of [p4..p7]. c3 joins.
- Assignment computed. c1 gets [p0,p1,p2], c2 gets [p4,p5,p6], c3 gets [p3,p7].
- Total downtime on all partitions.

### Cooperative protocol:
- First round: c1 revokes only [p3]. c2 revokes only [p7]. Partitions [p0..p2,p4..p6] keep flowing.
- Second round: [p3,p7] assigned to c3. All partitions now consumed.
- Downtime limited to only the moving partitions.

## Upgrade Path

To migrate from Eager to Cooperative:

1. Deploy a version that lists both strategies: `partition.assignment.strategy=CooperativeStickyAssignor,RangeAssignor`.
2. Once all consumers include this config, redeploy listing only `CooperativeStickyAssignor`.

This staged rollout prevents a bad rebalance during the transition.

## Related Configs

| Config | Default |
|--------|---------|
| `group.id` | — (required for `subscribe`) |
| `group.instance.id` | null (enables static membership if set) |
| `partition.assignment.strategy` | `RangeAssignor,CooperativeStickyAssignor` (2.8+) |
| `session.timeout.ms` | 45000 |
| `heartbeat.interval.ms` | 3000 |
| `max.poll.interval.ms` | 300000 |
| `allow.auto.create.topics` | true |

## Exam Pointers

- Only **one consumer per group per partition**.
- Extras are idle — a very common trap on the exam.
- Cooperative Sticky is **incremental** — consumers keep polling during rebalance.
- `group.instance.id` enables static membership (no rebalance on restart).
- `onPartitionsRevoked` is the right place to commit offsets before losing partitions.
- Rebalances can be triggered by new topics matching a regex subscription.
- Different groups are fully independent — separate offsets, separate consumption pace.

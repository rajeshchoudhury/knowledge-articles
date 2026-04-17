# Article 20: Windowing in Kafka Streams

Windowing groups records by time so aggregations operate on bounded chunks of an unbounded stream.

## The Four Window Types

### 1. Tumbling Window

**Fixed-size, non-overlapping, aligned to the epoch.**

```
|―――5min―――|―――5min―――|―――5min―――|
```

Every record belongs to exactly one window.

```java
TimeWindows.ofSizeWithNoGrace(Duration.ofMinutes(5))
```

Or with a grace period:
```java
TimeWindows.ofSizeAndGrace(Duration.ofMinutes(5), Duration.ofSeconds(30))
```

### 2. Hopping Window

**Fixed-size, overlapping by a sliding step (the hop/advance).**

```
window size = 10 min, advance = 2 min
|―――10min―――|
    |―――10min―――|
        |―――10min―――|
```

Each record belongs to `size / advance` windows.

```java
TimeWindows.ofSizeWithNoGrace(Duration.ofMinutes(10))
           .advanceBy(Duration.ofMinutes(2))
```

### 3. Sliding Window

**Dynamic, record-driven windows: a window forms around each record's timestamp ± size.**

Used specifically for stream-stream **join** windows and (from 2.7+) for aggregations.

```java
SlidingWindows.ofTimeDifferenceAndGrace(Duration.ofMinutes(5), Duration.ofSeconds(30))
```

Each record creates a new window spanning `[record.ts - size, record.ts + size]` (for joins) or `[record.ts - size, record.ts]` (for sliding aggregation).

### 4. Session Window

**Activity-based, variable length. A session is a period of activity closed by a gap of inactivity.**

```
session1: event event event     <― inactivity gap ―>     session2: event
```

```java
SessionWindows.ofInactivityGapAndGrace(Duration.ofMinutes(10), Duration.ofMinutes(1))
```

A record arrives → starts a new session OR extends an active session, OR **merges** two active sessions if its timestamp bridges the gap.

## Time Semantics

Windowing depends on **timestamps**. Streams uses `TimestampExtractor`:

- `FailOnInvalidTimestamp` (default) — uses record timestamp; fails if < 0.
- `LogAndSkipOnInvalidTimestamp` — logs and skips.
- `UsePartitionTimeOnInvalidTimestamp` — falls back to partition time.
- `WallclockTimestampExtractor` — uses `System.currentTimeMillis()`.
- Custom.

Timestamp sources:
- Producer-set (default, `CreateTime`).
- Broker-overwritten if topic uses `LogAppendTime`.

### Stream Time

Streams maintains **stream time** per task: max timestamp seen so far. Stream time only advances; it does not go back.

### Late Records

A **late record** has a timestamp < current stream time.

Without a grace period, late records for a closed window are **dropped**.

With `ofSizeAndGrace(size, grace)`, the window stays open until `stream_time > window_end + grace`. Late records within the grace period update the window. Beyond that, they're dropped.

## Grace Period (Critical)

`grace` is how long to **wait for late records** before closing the window for good.

Example:
- Window: 10:00–10:05.
- Grace: 30s.
- Window remains "open" until stream time > 10:05:30.
- A record with timestamp 10:04:00 arriving at stream time 10:05:10 → accepted.
- Same record at stream time 10:05:35 → dropped.

Kafka 2.5+ **requires** an explicit grace (`ofSizeWithNoGrace` or `ofSizeAndGrace`). No default.

## Suppress Operator

Emit windowed aggregations only **after the window closes** (instead of on every update):

```java
KTable<Windowed<String>, Long> counts = stream
    .groupByKey()
    .windowedBy(TimeWindows.ofSizeAndGrace(Duration.ofMinutes(5), Duration.ofSeconds(30)))
    .count()
    .suppress(Suppressed.untilWindowCloses(Suppressed.BufferConfig.unbounded()));
```

`untilWindowCloses` — emit once per window, when stream time passes window-end + grace.

`untilTimeLimit(duration, bufferConfig)` — emit an update every `duration`, not for every input record.

**Caveat**: `suppress` requires stream time to advance beyond the window — which needs more records. A "quiet" stream may not emit until new events arrive.

## Windowed KTables

A windowed aggregation produces a `KTable<Windowed<K>, V>`. `Windowed<K>` has `key()`, `window().start()`, `window().end()`.

Convert to a stream for sinks:

```java
counts.toStream()
     .map((Windowed<String> wk, Long v) ->
        KeyValue.pair(wk.key() + "@" + wk.window().start(), v))
     .to("hourly-counts");
```

## Retention of Window Stores

The underlying WindowStore retains each window for `retention = max(windowSize + gracePeriod, Materialized.withRetention)`.

After retention, old windows are removed; queries return null.

## Time-Based Joins

Stream-stream joins REQUIRE a join window:

```java
leftStream.join(
    rightStream,
    (l, r) -> combine(l, r),
    JoinWindows.ofTimeDifferenceWithNoGrace(Duration.ofMinutes(5))
);
```

A pair matches if `|leftTs - rightTs| ≤ 5 min`.

With `leftJoin`, unmatched left records emit after the window closes (with null right).

## Worked Example — Hourly Rolling Count

```java
KTable<Windowed<String>, Long> hourlyClicks = clickStream
    .groupByKey()
    .windowedBy(TimeWindows.ofSizeAndGrace(Duration.ofHours(1), Duration.ofMinutes(5)))
    .count(Materialized.as("hourly-clicks"));
```

This creates:
- A windowed state store named `hourly-clicks`.
- Records retained for `retention = max(65 min, Materialized.withRetention)` (default: window size + grace).
- Updates every incoming record; emits to downstream KTable.

## Exam Pointers

- **Tumbling** = non-overlapping; **Hopping** = fixed size, advancing; **Sliding** = record-centered; **Session** = gap-bounded.
- A record belongs to **one** tumbling window and to **N = size/advance** hopping windows.
- `grace` is the tolerance for late arrivals; required explicitly since 2.5.
- Late records outside grace are **dropped** (no errors).
- `suppress(untilWindowCloses)` emits once per window, not per update.
- Stream time only advances; it is the max timestamp seen so far.
- Session windows can **merge** when a bridging record arrives.

# Article 29: Monitoring — JMX Metrics

Kafka exposes hundreds of metrics via JMX. You do not need to memorize every one, but knowing the key ones is critical.

## Metric Namespaces

Every metric is an MBean under one of:

- `kafka.server:*` — broker-internal (replication, request metrics)
- `kafka.network:*` — network threads, connections
- `kafka.log:*` — log management
- `kafka.controller:*` — controller-specific
- `kafka.cluster:*` — partition-level
- `kafka.producer:*` — producer client
- `kafka.consumer:*` — consumer client
- `kafka.streams:*` — Streams app
- `kafka.connect:*` — Connect worker

## Broker Health Metrics

| Metric | What It Means | Alert When |
|--------|--------------|-----------|
| `kafka.server:type=ReplicaManager,name=UnderReplicatedPartitions` | Partitions where ISR < RF | > 0 sustained |
| `kafka.server:type=ReplicaManager,name=UnderMinIsrPartitionCount` | Partitions below min ISR | > 0 at all |
| `kafka.server:type=ReplicaManager,name=OfflinePartitionsCount` | Partitions with no leader | > 0 |
| `kafka.controller:type=KafkaController,name=OfflinePartitionsCount` | Same as above from controller | > 0 |
| `kafka.controller:type=KafkaController,name=ActiveControllerCount` | Should be exactly 1 cluster-wide | ≠ 1 across cluster total |
| `kafka.server:type=BrokerTopicMetrics,name=MessagesInPerSec` | Write rate | — |
| `kafka.server:type=BrokerTopicMetrics,name=BytesInPerSec` | Bytes produced | — |
| `kafka.server:type=BrokerTopicMetrics,name=BytesOutPerSec` | Bytes consumed | — |
| `kafka.network:type=RequestMetrics,name=TotalTimeMs,request=Produce` | Produce latency | high |
| `kafka.network:type=RequestMetrics,name=TotalTimeMs,request=FetchConsumer` | Consumer fetch latency | high |
| `kafka.server:type=ReplicaFetcherManager,name=MaxLag,clientId=Replica` | Max follower lag | high |

## Request Latency Percentiles

Every request type has latency histograms: `Mean`, `50thPercentile`, `99thPercentile`, `999thPercentile`.

Broken down into phases:
- `TotalTimeMs` — end-to-end
- `RequestQueueTimeMs` — time in request queue
- `LocalTimeMs` — time to execute on leader
- `RemoteTimeMs` — time waiting for replication (for Produce with acks=all)
- `ResponseQueueTimeMs`
- `ResponseSendTimeMs`

High `RemoteTimeMs` → slow replication.
High `RequestQueueTimeMs` → broker overloaded.

## Producer Metrics

| Metric | Meaning |
|--------|---------|
| `record-send-rate` | Records/sec |
| `record-send-total` | Total records |
| `record-error-rate` | Errors/sec |
| `record-retry-rate` | Retries/sec |
| `request-latency-avg` | Avg Produce latency |
| `request-latency-max` | Max Produce latency |
| `batch-size-avg` | Average batch size |
| `records-per-request-avg` | Records per Produce request |
| `compression-rate-avg` | Compressed/uncompressed ratio |
| `buffer-available-bytes` | Free space in RecordAccumulator |
| `outgoing-byte-rate` | Bytes sent |

Diagnostic:
- **Low throughput + small batch-size-avg** → increase `linger.ms` or `batch.size`.
- **High record-retry-rate** → broker slow or network issues.
- **buffer-available-bytes near 0** → producer backpressure; increase `buffer.memory` or slow application.

## Consumer Metrics

| Metric | Meaning |
|--------|---------|
| `records-consumed-rate` | Records/sec |
| `records-lag-max` | Max lag (records behind) across assigned partitions |
| `records-lag-avg` | Avg lag |
| `fetch-rate` | Fetch requests/sec |
| `fetch-latency-avg` | Fetch latency |
| `fetch-size-avg` | Bytes per fetch |
| `commit-latency-avg` | Commit RPC latency |
| `time-between-poll-avg` | Time between polls (processing + fetch) |
| `heartbeat-response-time-max` | Heartbeat latency |

Diagnostic:
- **records-lag-max rising** → consumer too slow; scale up or optimize.
- **time-between-poll-avg > session.timeout.ms / 2** → risk of poll timeout.
- **commit-latency-avg high** → coordinator overloaded.

## Consumer Lag

Fetch from the admin client:
```
kafka-consumer-groups --describe --group billing --bootstrap-server ...
```

Or export via Prometheus's JMX exporter and alert on:
```
kafka_consumer_fetch_manager_metrics_records_lag_max > threshold
```

Burrow is an alternate tool by LinkedIn for lag monitoring.

## Streams Metrics

| Metric | Meaning |
|--------|---------|
| `stream-metrics:process-rate` | Records processed per thread |
| `stream-metrics:commit-rate` | Streams commits/sec |
| `stream-metrics:poll-rate` | Polls/sec |
| `stream-task-metrics:process-latency-avg` | Latency per record |
| `stream-processor-node-metrics:process-rate` | Per-processor-node rate |
| `stream-state-metrics:put-rate`, `get-rate` | State store ops |
| `stream-rocksdb-metrics:*` | RocksDB internals |
| `stream-thread-metrics:thread-start-time` | Start time |
| `stream-client-metrics:state` | `CREATED`, `RUNNING`, `REBALANCING`, `ERROR`, etc. |

## Connect Metrics

| Metric | Meaning |
|--------|---------|
| `connect-worker-metrics:connector-count` | Connectors on this worker |
| `connect-worker-metrics:task-count` | Tasks on this worker |
| `connect-connector-metrics:connector-startup-success-total` | Startup successes |
| `connect-source-task-metrics:source-record-poll-rate` | Records/sec from source |
| `connect-sink-task-metrics:sink-record-read-rate` | Records/sec read from Kafka |
| `connect-sink-task-metrics:sink-record-send-rate` | Records sent downstream |
| `connect-worker-rebalance-metrics:rebalance-avg-time-ms` | Rebalance duration |

## Controller Metrics

| Metric | Meaning |
|--------|---------|
| `ActiveControllerCount` | Should be 1 across the whole cluster |
| `OfflinePartitionsCount` | 0 in healthy cluster |
| `PreferredReplicaImbalanceCount` | Non-preferred leaders |
| `GlobalTopicCount` / `GlobalPartitionCount` | Cluster inventory |
| `LeaderElectionRateAndTimeMs` | How often leader changes happen |
| `UncleanLeaderElectionsPerSec` | Should be 0 |

## JMX Setup

Enable in broker:
```
export KAFKA_JMX_OPTS="-Dcom.sun.management.jmxremote \
  -Dcom.sun.management.jmxremote.authenticate=false \
  -Dcom.sun.management.jmxremote.ssl=false \
  -Dcom.sun.management.jmxremote.port=9999"
export JMX_PORT=9999
```

Clients can enable JMX too (same flags, different port).

## Prometheus / Grafana Stack

Common production monitoring:
- `jmx_exporter` — Java agent that converts JMX to Prometheus format.
- Dashboards: Confluent ships official Grafana dashboards.

## Log Files

Broker logs at `${log.dir}/server.log`. Log level configured via `log4j.properties`. Important loggers:
- `kafka.controller` — controller activity.
- `state.change.logger` — partition leader changes.
- `kafka.request.logger` — if enabled, every request.
- `kafka.authorizer.logger` — authorization decisions.

## Quotas

Monitor:
- `kafka.server:type=Produce,client-id=<id>` — produce-throttle-time-ms
- `kafka.server:type=Fetch,client-id=<id>` — fetch-throttle-time-ms
- `kafka.server:type=Request,client-id=<id>` — request-throttle-time-ms

If `throttle-time-ms > 0`, the client is being throttled by a quota.

## Exam Pointers

- `UnderReplicatedPartitions > 0` = unhealthy cluster.
- Exactly **one** `ActiveControllerCount=1` across the entire cluster.
- Consumer lag = `LogEndOffset - CurrentOffset`; track `records-lag-max`.
- `time-between-poll-avg` → if approaching `max.poll.interval.ms`, rebalance risk.
- `UncleanLeaderElectionsPerSec > 0` = data loss.
- `OfflinePartitionsCount > 0` = partition unavailable.
- Request latency has many phases (queue, local, remote, response); diagnose by phase.

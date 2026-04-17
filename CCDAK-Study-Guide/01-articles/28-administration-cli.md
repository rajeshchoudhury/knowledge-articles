# Article 28: Administration and CLI Tools

Every CCDAK candidate should be fluent with the core command-line tools.

## The Tool Belt

| Tool | Purpose |
|------|---------|
| `kafka-topics.sh` | Manage topics |
| `kafka-console-producer.sh` | Send records from stdin |
| `kafka-console-consumer.sh` | Read records to stdout |
| `kafka-consumer-groups.sh` | Inspect/reset groups |
| `kafka-configs.sh` | Manage dynamic configs |
| `kafka-acls.sh` | Manage ACLs |
| `kafka-reassign-partitions.sh` | Reassign partitions across brokers |
| `kafka-preferred-replica-election.sh` | Trigger preferred leader election |
| `kafka-log-dirs.sh` | Log-dir inspection |
| `kafka-verifiable-producer.sh` | Load test producing |
| `kafka-verifiable-consumer.sh` | Load test consuming |
| `kafka-producer-perf-test.sh` | Producer perf test |
| `kafka-consumer-perf-test.sh` | Consumer perf test |
| `kafka-dump-log.sh` | Inspect log files |
| `kafka-delete-records.sh` | Delete before a given offset |
| `kafka-delegation-tokens.sh` | Token management |

## kafka-topics

```bash
# List
kafka-topics --bootstrap-server localhost:9092 --list

# Create
kafka-topics --bootstrap-server localhost:9092 --create \
  --topic orders --partitions 6 --replication-factor 3 \
  --config retention.ms=604800000 --config min.insync.replicas=2

# Describe
kafka-topics --bootstrap-server localhost:9092 --describe --topic orders

# Describe under-replicated
kafka-topics --bootstrap-server localhost:9092 --describe --under-replicated-partitions

# Describe under-min-ISR
kafka-topics --bootstrap-server localhost:9092 --describe --under-min-isr-partitions

# Alter partitions (increase only)
kafka-topics --bootstrap-server localhost:9092 --alter \
  --topic orders --partitions 12

# Delete
kafka-topics --bootstrap-server localhost:9092 --delete --topic temp-topic
```

**Note**: `--alter --partitions` can only **increase** partition count.

## kafka-console-producer

```bash
# Basic
kafka-console-producer --bootstrap-server localhost:9092 --topic orders

# With keys
kafka-console-producer --bootstrap-server localhost:9092 --topic orders \
  --property parse.key=true --property key.separator=:

# With custom serializers / schema registry
kafka-console-producer --bootstrap-server localhost:9092 --topic orders \
  --producer-property acks=all \
  --producer.config producer.properties
```

Use `Ctrl-D` (EOF) to exit.

## kafka-console-consumer

```bash
# From now (tail)
kafka-console-consumer --bootstrap-server localhost:9092 --topic orders

# From beginning
kafka-console-consumer --bootstrap-server localhost:9092 --topic orders --from-beginning

# Specific partition
kafka-console-consumer --bootstrap-server localhost:9092 --topic orders --partition 0 --offset 100

# Limit records
kafka-console-consumer --bootstrap-server localhost:9092 --topic orders --max-messages 10

# Display keys and headers
kafka-console-consumer --bootstrap-server localhost:9092 --topic orders --from-beginning \
  --property print.key=true --property print.timestamp=true --property print.headers=true

# With group
kafka-console-consumer --bootstrap-server localhost:9092 --topic orders --group test-group
```

## kafka-consumer-groups

```bash
# List groups
kafka-consumer-groups --bootstrap-server localhost:9092 --list

# Describe group
kafka-consumer-groups --bootstrap-server localhost:9092 --describe --group billing

# Describe ALL groups
kafka-consumer-groups --bootstrap-server localhost:9092 --describe --all-groups

# Describe offsets only (no member info)
kafka-consumer-groups --bootstrap-server localhost:9092 --describe --group billing --offsets

# Describe members
kafka-consumer-groups --bootstrap-server localhost:9092 --describe --group billing --members

# Describe state
kafka-consumer-groups --bootstrap-server localhost:9092 --describe --group billing --state

# Delete group (must be inactive)
kafka-consumer-groups --bootstrap-server localhost:9092 --delete --group billing

# Reset offsets (many options)
kafka-consumer-groups --bootstrap-server localhost:9092 \
  --group billing --topic orders \
  --reset-offsets --to-earliest --execute

# Other reset targets:
# --to-latest
# --to-offset 1000
# --to-datetime 2025-01-01T00:00:00.000
# --to-current
# --shift-by -500
# --from-file offsets.csv

# Dry run (show what would happen) — omit --execute
# Add --dry-run explicitly if supported

# Must have NO active members in group
```

## kafka-configs

```bash
# Show broker config
kafka-configs --bootstrap-server localhost:9092 --entity-type brokers --entity-name 1 --describe

# Show topic config
kafka-configs --bootstrap-server localhost:9092 --entity-type topics --entity-name orders --describe

# Alter topic config
kafka-configs --bootstrap-server localhost:9092 --entity-type topics --entity-name orders \
  --alter --add-config retention.ms=86400000,min.insync.replicas=2

# Remove a topic override
kafka-configs --bootstrap-server localhost:9092 --entity-type topics --entity-name orders \
  --alter --delete-config retention.ms

# Show only dynamic configs (not broker defaults)
kafka-configs --bootstrap-server localhost:9092 --entity-type brokers --entity-name 1 --describe --all

# Users (SCRAM credentials)
kafka-configs --bootstrap-server localhost:9092 \
  --entity-type users --entity-name alice \
  --alter --add-config 'SCRAM-SHA-512=[password=alice-secret]'

# Client quota
kafka-configs --bootstrap-server localhost:9092 \
  --entity-type users --entity-name alice \
  --alter --add-config 'producer_byte_rate=1048576,consumer_byte_rate=2097152'
```

## kafka-acls

```bash
# List all ACLs
kafka-acls --bootstrap-server localhost:9092 --list

# Add producer ACL
kafka-acls --bootstrap-server localhost:9092 \
  --add --allow-principal User:alice \
  --producer --topic orders

# Add consumer ACL (handles topic + group)
kafka-acls --bootstrap-server localhost:9092 \
  --add --allow-principal User:bob \
  --consumer --topic orders --group billing

# Prefixed ACL
kafka-acls --bootstrap-server localhost:9092 \
  --add --allow-principal User:streams-app \
  --operation ALL --topic myapp \
  --resource-pattern-type PREFIXED

# Remove ACL
kafka-acls --bootstrap-server localhost:9092 \
  --remove --allow-principal User:alice \
  --producer --topic orders
```

## kafka-reassign-partitions

Move partitions between brokers. Used when adding/removing brokers.

```bash
# 1. Generate a proposal
echo '{"topics":[{"topic":"orders"}],"version":1}' > topics.json

kafka-reassign-partitions --bootstrap-server localhost:9092 \
  --topics-to-move-json-file topics.json \
  --broker-list "1,2,3,4" --generate > proposal.json

# 2. Apply
kafka-reassign-partitions --bootstrap-server localhost:9092 \
  --reassignment-json-file proposal.json --execute

# 3. Verify
kafka-reassign-partitions --bootstrap-server localhost:9092 \
  --reassignment-json-file proposal.json --verify

# 4. Throttle (during execute)
kafka-reassign-partitions --bootstrap-server localhost:9092 \
  --reassignment-json-file proposal.json --execute \
  --throttle 10000000   # 10 MB/s

# 5. Cancel
kafka-reassign-partitions --bootstrap-server localhost:9092 \
  --reassignment-json-file proposal.json --cancel
```

## kafka-delete-records

Delete records **before** a given offset (non-reversible):

```bash
cat > delete.json << EOF
{
  "partitions": [
    {"topic": "orders", "partition": 0, "offset": 1000}
  ],
  "version": 1
}
EOF

kafka-delete-records --bootstrap-server localhost:9092 \
  --offset-json-file delete.json
```

Deletes records 0–999 from `orders-0`. Useful for GDPR compliance.

## kafka-dump-log

Inspect log segment files:

```bash
kafka-dump-log --files 00000000000000000000.log --print-data-log

# For __consumer_offsets (decode messages)
kafka-dump-log --files /tmp/kafka-logs/__consumer_offsets-5/00000000000000000000.log \
  --offsets-decoder

# For __transaction_state
kafka-dump-log --files ... --transaction-log-decoder

# Verify index integrity
kafka-dump-log --files 00000000000000000000.index --index-sanity-check
```

## kafka-log-dirs

Disk usage by log dir:

```bash
kafka-log-dirs --bootstrap-server localhost:9092 \
  --broker-list "1,2,3" --describe | jq .
```

## kafka-producer-perf-test

Benchmark a producer:

```bash
kafka-producer-perf-test \
  --topic perf-test \
  --num-records 1000000 \
  --record-size 1024 \
  --throughput -1 \
  --producer-props bootstrap.servers=localhost:9092 acks=all compression.type=lz4
```

## kafka-consumer-perf-test

```bash
kafka-consumer-perf-test \
  --bootstrap-server localhost:9092 \
  --topic perf-test \
  --messages 1000000 \
  --group perf-group
```

## Exam Pointers

- **`kafka-topics --alter --partitions` can only increase** the partition count.
- `kafka-consumer-groups --reset-offsets` requires **no active members**.
- `kafka-configs --entity-type users` is used for SCRAM credentials AND client quotas.
- `kafka-delete-records` sets the **log start offset** (effectively purging older records).
- `kafka-acls --producer`/`--consumer` are **shortcuts** that grant the right operations automatically.
- `kafka-reassign-partitions` workflow: generate → execute → verify.
- `kafka-dump-log --offsets-decoder` is the way to inspect `__consumer_offsets`.

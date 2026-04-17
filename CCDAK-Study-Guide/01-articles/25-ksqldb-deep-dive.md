# Article 25: ksqlDB Deep Dive

## What Is ksqlDB?

A streaming SQL engine built on top of Kafka Streams. Write SQL; ksqlDB generates a Streams topology under the hood.

- Offers `STREAM` (= KStream) and `TABLE` (= KTable) types.
- Supports CREATE, SELECT, INSERT, and built-in functions.
- Materialized views via `CREATE TABLE ... AS SELECT`.
- Push queries (continuous) and pull queries (snapshot lookups).

Deployment: one or more ksqlDB servers, each backed by a Kafka Streams application.

## Streams vs Tables in ksqlDB

```sql
CREATE STREAM clicks (user_id VARCHAR, page VARCHAR, ts BIGINT)
    WITH (KAFKA_TOPIC='clicks', VALUE_FORMAT='AVRO');

CREATE TABLE user_profile (user_id VARCHAR PRIMARY KEY, name VARCHAR, email VARCHAR)
    WITH (KAFKA_TOPIC='users', VALUE_FORMAT='AVRO');
```

Streams: append-only events. Tables: keyed state, where records with the same key overwrite.

## Value Formats

| Format | Schema Registry Required |
|--------|--------------------------|
| `AVRO` | Yes |
| `PROTOBUF` | Yes |
| `JSON_SR` | Yes |
| `JSON` | No (no schema) |
| `DELIMITED` | No |
| `KAFKA` | No (primitive types only) |
| `NONE` | No |

## Queries

### Push Query (continuous)

Emits results continuously as new data arrives.

```sql
SELECT user_id, COUNT(*) 
FROM clicks 
WINDOW TUMBLING (SIZE 1 MINUTE)
GROUP BY user_id
EMIT CHANGES;
```

`EMIT CHANGES` is the push marker. Query runs until terminated.

### Pull Query (point-in-time)

Snapshot query over a table's current state.

```sql
SELECT * FROM user_counts WHERE user_id = 'u42';
```

No `EMIT` clause. Uses the local state store; fast and not streaming.

Pull queries can be done only on **materialized tables** (created via `CREATE TABLE AS SELECT` or equivalent), not on arbitrary streams.

## CTAS and CSAS

- `CREATE STREAM AS SELECT` (CSAS) — derive a new stream from an existing one, persisting to a Kafka topic.
- `CREATE TABLE AS SELECT` (CTAS) — derive a new materialized table, queryable via pull.

```sql
CREATE TABLE user_click_counts AS
    SELECT user_id, COUNT(*) AS clicks
    FROM clicks
    GROUP BY user_id
    EMIT CHANGES;
```

## Joins in ksqlDB

Mirror Kafka Streams:

| Join | Support | Example |
|------|---------|---------|
| Stream-Stream | Yes (windowed) | `SELECT ... FROM a JOIN b WITHIN 5 MINUTES ON a.k=b.k` |
| Stream-Table | Yes | `... FROM s JOIN t ON s.k=t.k` |
| Table-Table | Yes | `... FROM t1 JOIN t2 ON t1.k=t2.k` |

Stream-GlobalTable not explicitly named; ksqlDB handles co-partitioning transparently.

## Windowing

```sql
-- Tumbling
WINDOW TUMBLING (SIZE 5 MINUTES)

-- Hopping
WINDOW HOPPING (SIZE 10 MINUTES, ADVANCE BY 2 MINUTES)

-- Session
WINDOW SESSION (30 SECONDS)
```

Grace is configured via `WITH(GRACE PERIOD...)` options.

## Built-in Functions

- Scalar: `UCASE`, `SUBSTRING`, `CAST`, `ARRAY_CONTAINS`, `DATEFORMAT`, etc.
- Aggregate: `COUNT`, `SUM`, `AVG`, `MIN`, `MAX`, `TOPK`, `COLLECT_LIST`, `COLLECT_SET`.
- Table/Stream operators: `MASK`, `REGEXP_REPLACE`, `SPLIT`.
- User-defined:
  - UDF — scalar
  - UDAF — aggregate
  - UDTF — table (1:N)

Deployed as Java jars placed in `ksql.extension.dir`.

## INSERT Statements

```sql
INSERT INTO clicks (user_id, page, ts) VALUES ('u1', '/home', 1692000000);
```

Behind the scenes, produces a record to the Kafka topic backing the stream.

## REST API

ksqlDB server exposes a REST API (port 8088 default):

| Endpoint | Purpose |
|----------|---------|
| `POST /ksql` | Submit DDL or meta queries |
| `POST /query` | Run push query (streaming HTTP) |
| `POST /query-stream` (newer, HTTP/2) | Streaming push queries |
| `GET /info` | Server info |

## Headless Mode

Run ksqlDB as a set of pre-defined queries from a SQL file:

```
ksql.queries.file=/etc/ksql/queries.sql
```

Headless mode disables interactive SQL — useful for immutable prod deployments.

## Interactive Mode

The `ksql` CLI connects to the server and runs ad-hoc queries.

```bash
ksql http://ksqldb:8088
ksql> SHOW STREAMS;
ksql> SHOW TABLES;
ksql> SELECT * FROM clicks EMIT CHANGES LIMIT 10;
```

## Connectors via ksqlDB

ksqlDB can manage Kafka Connect from SQL:

```sql
CREATE SOURCE CONNECTOR mysql_cdc WITH (
    'connector.class' = 'io.debezium.connector.mysql.MySqlConnector',
    'database.hostname' = 'mysql',
    'database.port' = '3306',
    ...
);
```

This proxies to the Connect REST API.

## Internal Topics

- `_confluent-ksql-<service-id>-query_<n>-*` — Streams-generated topics.
- `_confluent-ksql-<service-id>__command_topic` — DDL command log.

## Configuration Highlights

| Config | Purpose |
|--------|---------|
| `ksql.service.id` | Unique identifier (becomes Streams `application.id` prefix) |
| `ksql.streams.bootstrap.servers` | Upstream Kafka |
| `ksql.schema.registry.url` | For AVRO/PROTOBUF/JSON_SR |
| `ksql.streams.num.stream.threads` | Parallelism |
| `ksql.queries.file` | Headless mode queries |
| `ksql.extension.dir` | Dir for UDF jars |

## Exam Pointers

- ksqlDB = **SQL on Kafka Streams** — same semantics.
- `EMIT CHANGES` → push query (streaming).
- Pull queries require a **materialized** (CTAS) table.
- CSAS = Create Stream As Select; CTAS = Create Table As Select.
- Windowed aggregations support TUMBLING, HOPPING, SESSION.
- ksqlDB manages Kafka Connect via SQL DDL.
- Schema-based formats (AVRO/PROTOBUF/JSON_SR) require Schema Registry.
- `ksql.service.id` becomes the underlying Streams `application.id`.

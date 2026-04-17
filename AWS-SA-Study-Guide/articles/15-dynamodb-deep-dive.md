# DynamoDB Deep Dive

## Table of Contents

1. [DynamoDB Fundamentals](#dynamodb-fundamentals)
2. [Tables, Items, and Attributes](#tables-items-and-attributes)
3. [Primary Keys](#primary-keys)
4. [DynamoDB Data Types](#dynamodb-data-types)
5. [Capacity Modes](#capacity-modes)
6. [RCU and WCU Calculations](#rcu-and-wcu-calculations)
7. [Secondary Indexes](#secondary-indexes)
8. [LSI vs GSI Comparison](#lsi-vs-gsi-comparison)
9. [DynamoDB Streams](#dynamodb-streams)
10. [DynamoDB Global Tables](#dynamodb-global-tables)
11. [DynamoDB TTL](#dynamodb-ttl)
12. [DynamoDB Transactions](#dynamodb-transactions)
13. [DynamoDB DAX](#dynamodb-dax)
14. [DynamoDB Backup and Recovery](#dynamodb-backup-and-recovery)
15. [DynamoDB Encryption](#dynamodb-encryption)
16. [Query vs Scan](#query-vs-scan)
17. [Batch Operations](#batch-operations)
18. [DynamoDB Pagination](#dynamodb-pagination)
19. [DynamoDB Access Patterns](#dynamodb-access-patterns)
20. [DynamoDB PartiQL](#dynamodb-partiql)
21. [DynamoDB Export and Import](#dynamodb-export-and-import)
22. [DynamoDB Pricing Model](#dynamodb-pricing-model)
23. [Common Exam Scenarios](#common-exam-scenarios)

---

## DynamoDB Fundamentals

Amazon DynamoDB is a fully managed, serverless, key-value and document NoSQL database designed to deliver single-digit millisecond performance at any scale.

### Key Characteristics

- **Fully managed**: No server provisioning, patching, or management
- **Serverless**: No infrastructure to manage, auto-scales
- **Performance**: Single-digit millisecond latency at any scale
- **Durability**: Data replicated across **3 Availability Zones** automatically
- **Scalability**: Virtually unlimited throughput and storage
- **Event-driven**: Integrated with DynamoDB Streams and Lambda
- **Encryption**: Encrypted at rest by default
- **Global**: Global Tables for multi-region, multi-active replication
- **Maximum item size**: 400 KB

### When to Use DynamoDB

- Applications requiring consistent, single-digit millisecond response times
- Serverless applications (pairs well with Lambda, API Gateway)
- Applications with known access patterns
- Key-value or simple document data models
- High-scale applications (millions of requests per second)
- Gaming leaderboards, session management, IoT data, shopping carts

### When NOT to Use DynamoDB

- Complex relational queries (JOINs, complex aggregations)
- Ad-hoc queries across many attributes
- Applications requiring ACID transactions across multiple tables (limited transaction support)
- Data requiring complex reporting (use Redshift or RDS instead)
- Small-scale applications where cost doesn't justify managed service

---

## Tables, Items, and Attributes

### Tables

- Top-level entity in DynamoDB (similar to a table in relational databases)
- No fixed schema (except for the primary key)
- Each table must have a primary key defined at creation
- Tables exist within a specific AWS region
- Table names must be unique within an AWS account and region

### Items

- An item is a single record in a DynamoDB table (similar to a row)
- Each item is uniquely identified by its primary key
- Maximum item size: **400 KB** (including attribute names and values)
- Items can have different attributes (schema-less)
- No limit on the number of items in a table

### Attributes

- An attribute is a fundamental data element (similar to a column)
- Each item is composed of one or more attributes
- Attributes can be:
  - **Scalar**: Single value (string, number, binary, boolean, null)
  - **Document**: Complex nested structure (list, map)
  - **Set**: Multiple scalar values (string set, number set, binary set)
- Nested attributes can be up to 32 levels deep
- No limit on the number of attributes per item (as long as total size ≤ 400 KB)

---

## Primary Keys

DynamoDB supports two types of primary keys.

### Partition Key Only (Simple Primary Key)

- Also called a **hash key**
- A single attribute that uniquely identifies each item
- DynamoDB uses the partition key value as input to an internal hash function
- The hash output determines the partition (physical storage) where the item is stored
- Must be unique across all items in the table
- Example: `UserId` as partition key

### Partition Key + Sort Key (Composite Primary Key)

- Also called **hash key + range key**
- Two attributes together uniquely identify each item
- **Partition key**: Determines the partition (same hash function)
- **Sort key**: Items with the same partition key are stored together, sorted by the sort key
- Multiple items can share the same partition key, but the combination must be unique
- Enables range queries on the sort key
- Example: `UserId` (partition key) + `Timestamp` (sort key)

### Choosing a Good Partition Key

- **High cardinality**: Many distinct values (e.g., UserId, SessionId)
- **Uniform distribution**: Access patterns should be evenly distributed
- **Avoid hot partitions**: A partition key accessed much more than others creates a bottleneck
- Bad choices: Status codes (only a few values), Boolean values, dates (for time-series data)

### How Partitions Work

- DynamoDB internally divides table data into **partitions**
- Each partition can store up to **10 GB** of data
- Each partition can handle up to **3,000 RCU** and **1,000 WCU**
- Partition key hash determines which partition stores the item
- More partitions are created as data and throughput requirements grow
- **Adaptive capacity**: DynamoDB automatically redistributes capacity to hot partitions

---

## DynamoDB Data Types

### Scalar Types

| Type | Description | Example |
|------|-------------|---------|
| **S** (String) | UTF-8 encoded text | `"Hello World"` |
| **N** (Number) | Positive, negative, or zero | `42`, `3.14`, `-17` |
| **B** (Binary) | Binary data (base64-encoded) | `dGhpcyBpcyBhIHRlc3Q=` |
| **BOOL** (Boolean) | True or false | `true`, `false` |
| **NULL** (Null) | Unknown or undefined | `null` |

### Document Types

| Type | Description | Example |
|------|-------------|---------|
| **L** (List) | Ordered collection of values (any type) | `["Hello", 42, true]` |
| **M** (Map) | Unordered collection of key-value pairs | `{"Name": "John", "Age": 30}` |

- Lists and Maps can be nested (up to 32 levels deep)
- Items in a list can be of different types
- Maps are similar to JSON objects

### Set Types

| Type | Description | Example |
|------|-------------|---------|
| **SS** (String Set) | Set of unique strings | `["Red", "Green", "Blue"]` |
| **NS** (Number Set) | Set of unique numbers | `[1, 2, 3, 4, 5]` |
| **BS** (Binary Set) | Set of unique binary values | `[base64_1, base64_2]` |

- Sets must contain elements of the same type
- Elements in a set must be unique
- Sets are unordered
- Sets cannot be empty (must contain at least one element)

---

## Capacity Modes

DynamoDB offers two capacity modes for managing read/write throughput.

### Provisioned Mode (Default)

- You specify the number of **Read Capacity Units (RCU)** and **Write Capacity Units (WCU)**
- Predictable pricing: Pay for provisioned capacity whether used or not
- Can be auto-scaled based on utilization (recommended)
- Best for: Workloads with predictable traffic patterns
- Offers **Reserved Capacity** for significant cost savings (1 or 3-year terms)
- Throttling occurs if you exceed provisioned capacity
- **Burst capacity**: DynamoDB retains up to 5 minutes of unused capacity for bursts

### On-Demand Mode

- No capacity planning needed
- DynamoDB automatically scales to handle any traffic level
- Pay per request (pay for what you use)
- **Read Request Units (RRU)** and **Write Request Units (WRU)**
- Best for: Unpredictable workloads, new tables with unknown patterns, spiky traffic
- More expensive per request than provisioned mode
- No throttling (scales automatically)
- Can switch between modes once every 24 hours

### Auto Scaling (Provisioned Mode)

- Automatically adjusts provisioned capacity based on utilization
- Uses **Application Auto Scaling** service
- Configure:
  - **Minimum capacity**: Floor for scaling down
  - **Maximum capacity**: Ceiling for scaling up
  - **Target utilization**: Percentage of consumed capacity (e.g., 70%)
- Reacts to actual usage patterns
- Some delay in scaling (not instantaneous)
- Best practice: Use auto scaling with provisioned mode for cost optimization

### Capacity Mode Comparison

| Feature | Provisioned | On-Demand |
|---------|-------------|-----------|
| Planning | Required | Not required |
| Cost | Lower (predictable) | Higher (pay per request) |
| Scaling | Manual or auto scaling | Automatic |
| Throttling | Possible | Very unlikely |
| Reserved Capacity | Available (up to 77% savings) | Not available |
| Best For | Predictable workloads | Unpredictable workloads |
| Switch Frequency | Once per 24 hours | Once per 24 hours |

---

## RCU and WCU Calculations

Understanding capacity unit calculations is essential for the exam.

### Write Capacity Units (WCU)

- **1 WCU = 1 write per second for an item up to 1 KB**
- Items larger than 1 KB require additional WCUs
- Formula: `WCU = (Item Size in KB, rounded up) × (Writes per second)`

**Example Calculations:**

1. Write 10 items per second, each 2 KB:
   - WCU = ceil(2 KB / 1 KB) × 10 = 2 × 10 = **20 WCU**

2. Write 6 items per second, each 4.5 KB:
   - WCU = ceil(4.5 KB / 1 KB) × 6 = 5 × 6 = **30 WCU**

3. Write 120 items per minute, each 0.5 KB:
   - Writes per second = 120 / 60 = 2
   - WCU = ceil(0.5 KB / 1 KB) × 2 = 1 × 2 = **2 WCU**

### Read Capacity Units (RCU)

- **1 RCU = 1 strongly consistent read per second for an item up to 4 KB**
- **1 RCU = 2 eventually consistent reads per second for an item up to 4 KB**
- Items larger than 4 KB require additional RCUs

**Strongly Consistent Reads:**
- Formula: `RCU = (Item Size in KB, rounded up to nearest 4 KB / 4) × (Reads per second)`

**Eventually Consistent Reads:**
- Formula: `RCU = (Item Size in KB, rounded up to nearest 4 KB / 4) × (Reads per second) / 2`

**Example Calculations:**

1. Read 10 items per second, each 4 KB, strongly consistent:
   - RCU = (4 / 4) × 10 = 1 × 10 = **10 RCU**

2. Read 10 items per second, each 4 KB, eventually consistent:
   - RCU = (4 / 4) × 10 / 2 = 10 / 2 = **5 RCU**

3. Read 16 items per second, each 12 KB, strongly consistent:
   - RCU = ceil(12 / 4) × 16 = 3 × 16 = **48 RCU**

4. Read 16 items per second, each 12 KB, eventually consistent:
   - RCU = ceil(12 / 4) × 16 / 2 = 48 / 2 = **24 RCU**

5. Read 10 items per second, each 6 KB, strongly consistent:
   - RCU = ceil(6 / 4) × 10 = 2 × 10 = **20 RCU**

6. Read 10 items per second, each 6 KB, eventually consistent:
   - RCU = ceil(6 / 4) × 10 / 2 = 20 / 2 = **10 RCU**

### Transactional Reads and Writes

- **Transactional write**: Costs **2x WCU** (2 WCU per 1 KB item)
- **Transactional read**: Costs **2x RCU** (2 RCU per 4 KB item, strongly consistent)

**Example:**
- Transactional write of 5 items per second, each 3 KB:
  - WCU = ceil(3 / 1) × 5 × 2 = 3 × 5 × 2 = **30 WCU**

- Transactional read of 5 items per second, each 8 KB:
  - RCU = ceil(8 / 4) × 5 × 2 = 2 × 5 × 2 = **20 RCU**

### Throttling

- **ProvisionedThroughputExceededException**: Returned when capacity is exceeded
- Solutions:
  - Increase provisioned capacity
  - Enable auto scaling
  - Switch to on-demand mode
  - Use exponential backoff (built into AWS SDK)
  - Distribute requests across partition keys (avoid hot partitions)
  - Use DAX for read-heavy workloads

---

## Secondary Indexes

Secondary indexes allow querying data using attributes other than the primary key.

### Local Secondary Index (LSI)

- **Same partition key** as the base table, but a **different sort key**
- Must be created at **table creation time** (cannot be added later)
- Maximum **5 LSIs** per table
- Uses the **same capacity** as the base table (no separate RCU/WCU)
- Maximum total size per partition key value: **10 GB** (including base table and all LSIs)
- Supports **strongly consistent** and eventually consistent reads
- Sort key can be any scalar attribute (String, Number, Binary)

**LSI Key Structure:**
- Partition key: Same as the base table's partition key (required)
- Sort key: Any scalar attribute different from the table's sort key (required)

**Example:**
- Base table: `UserId` (PK) + `OrderDate` (SK)
- LSI: `UserId` (PK) + `OrderAmount` (SK) → Query orders by amount for a user

### Global Secondary Index (GSI)

- **Different partition key** and optionally a **different sort key** from the base table
- Can be created at any time (at creation or added later)
- Maximum **20 GSIs** per table (soft limit, can be increased)
- Has its own **separate provisioned capacity** (RCU and WCU)
- No partition key value size limit
- Only supports **eventually consistent reads**
- If GSI capacity is throttled, the **base table writes are also throttled**
- GSI is essentially a full copy of the selected attributes (maintained asynchronously)

**GSI Key Structure:**
- Partition key: Any attribute (can be different from base table's PK)
- Sort key: Optional, any scalar attribute

**Example:**
- Base table: `UserId` (PK) + `OrderDate` (SK)
- GSI: `ProductId` (PK) + `OrderDate` (SK) → Query orders by product

### Index Projections

Both LSI and GSI support projections — defining which attributes are copied into the index.

| Projection Type | Description | Storage Cost |
|----------------|-------------|--------------|
| **KEYS_ONLY** | Only key attributes (PK + SK of table and index) | Lowest |
| **INCLUDE** | Specific non-key attributes | Medium |
| **ALL** | All attributes from the base table | Highest |

- If a query requests attributes not in the projection, DynamoDB must **fetch** from the base table (expensive)
- Choose projections carefully to balance storage cost vs query efficiency

---

## LSI vs GSI Comparison

| Feature | LSI | GSI |
|---------|-----|-----|
| Partition Key | Same as table | Can be different |
| Sort Key | Must be different | Can be different or none |
| Creation Time | Table creation only | Any time |
| Maximum per Table | 5 | 20 |
| Capacity | Shared with table | Separate (own RCU/WCU) |
| Read Consistency | Strong or eventual | Eventual only |
| Size Limit | 10 GB per PK value | No limit |
| Throttling Impact | Throttles table | Throttles table writes |
| Projection Changes | Cannot change after creation | Cannot change after creation |
| Delete/Recreate | Cannot delete (must recreate table) | Can delete and recreate |

### When to Use LSI

- Need strongly consistent reads on the index
- Access pattern always includes the same partition key
- Known at table creation time
- Minimal additional attributes needed in projection

### When to Use GSI

- Need to query by a completely different attribute
- Access patterns evolve over time (can add later)
- Need flexibility in partition key choice
- Eventually consistent reads are acceptable

---

## DynamoDB Streams

DynamoDB Streams captures a time-ordered sequence of item-level modifications in a DynamoDB table.

### How Streams Work

1. Each modification to the table generates a **stream record**
2. Stream records are organized into **shards**
3. Records are retained for **24 hours**
4. Each stream record contains:
   - The table name
   - Event timestamp
   - Other metadata
   - The changed data (based on view type)

### Stream View Types

| View Type | Data Captured |
|-----------|--------------|
| **KEYS_ONLY** | Only the key attributes of the modified item |
| **NEW_IMAGE** | The entire item as it appears after modification |
| **OLD_IMAGE** | The entire item as it appeared before modification |
| **NEW_AND_OLD_IMAGES** | Both the new and old images of the item |

### Stream Processing Options

**AWS Lambda Triggers:**
- Most common integration
- Lambda function is automatically invoked when new stream records appear
- Event source mapping between DynamoDB Streams and Lambda
- Lambda processes batches of stream records
- Ideal for: Real-time reactions, data transformations, cross-table updates

**Kinesis Client Library (KCL):**
- Custom consumer application using KCL
- More control over processing logic
- Can process streams from multiple tables
- Suitable for complex stream processing pipelines

**Kinesis Data Streams (via Kinesis Adapter):**
- Replicate DynamoDB Streams into Kinesis Data Streams
- Longer retention (up to 365 days vs 24 hours)
- Multiple consumers with enhanced fan-out
- Integration with Kinesis Data Analytics, Firehose

### Stream Use Cases

1. **Cross-region replication**: Foundation for Global Tables
2. **Real-time triggers**: Update search index, send notifications
3. **Data pipeline**: Feed changes to analytics systems
4. **Audit trail**: Track all changes to items
5. **Materialized views**: Maintain denormalized copies of data
6. **Aggregation**: Compute running totals, counts, etc.

---

## DynamoDB Global Tables

Global Tables provide a fully managed, multi-region, multi-active database solution.

### How Global Tables Work

- Create a table in multiple AWS regions simultaneously
- All replicas are **read/write** (multi-active, not primary/secondary)
- Writes to any replica are **asynchronously replicated** to all other replicas
- Replication latency: Typically **under 1 second**
- Uses DynamoDB Streams for replication (streams must be enabled)
- Uses **last writer wins** conflict resolution

### Requirements

- DynamoDB Streams must be enabled with **NEW_AND_OLD_IMAGES** view type
- Table must be in **on-demand mode** or have auto scaling enabled
- Table must have the same name in all regions
- Table must have the same key schema in all regions
- No existing GSIs or LSIs that differ across regions (must match)
- Table must be empty when adding a new region (for version 2019.11.21+, this restriction is removed)

### Conflict Resolution

- **Last writer wins**: Based on the timestamp of the write
- If two regions write to the same item simultaneously, the write with the latest timestamp wins
- This is the only conflict resolution strategy (cannot be customized)
- Applications should be designed to handle eventual consistency across regions

### Global Tables Version

- **Version 2019.11.21** (current): Recommended, simpler management
- **Version 2017.11.29** (legacy): Older, more manual management
- New tables should always use the current version

### Use Cases

- **Globally distributed applications**: Low-latency access from any region
- **Disaster recovery**: If one region goes down, other regions continue to operate
- **Data migration**: Replicate data across regions for migration scenarios
- **Compliance**: Keep data in specific regions while maintaining global access

---

## DynamoDB TTL

Time to Live (TTL) allows you to automatically delete expired items from a table.

### How TTL Works

1. Define a TTL attribute on the table (must contain a Unix epoch timestamp in seconds)
2. DynamoDB periodically scans the table for expired items
3. Items with TTL timestamp in the past are marked for deletion
4. Deleted items are removed within **48 hours** of expiration (not immediate)
5. Expired items may still appear in queries/scans until actually deleted
6. TTL deletions are recorded in DynamoDB Streams (as system deletes)

### TTL Key Points

- TTL is **free** — no WCU consumed for TTL deletions
- Does NOT use provisioned capacity (background process)
- TTL attribute must be a **Number** type containing a Unix epoch timestamp (seconds)
- Items that don't have the TTL attribute or have a non-numeric value are not affected
- TTL can be enabled/disabled at any time
- TTL deletions appear in DynamoDB Streams with `eventName: REMOVE` and `userIdentity: dynamodb.amazonaws.com`

### Use Cases

- Session data: Expire sessions after inactivity
- Temporary data: Promotional offers, temporary access tokens
- Regulatory compliance: Delete data after retention period
- Log data: Remove old log entries automatically
- Shopping cart: Clear abandoned carts

---

## DynamoDB Transactions

DynamoDB Transactions provide ACID (Atomicity, Consistency, Isolation, Durability) guarantees across multiple items and tables.

### TransactWriteItems

- Write up to **100 items** across multiple tables in a single transaction
- Maximum total transaction size: **4 MB**
- Operations: Put, Update, Delete, ConditionCheck
- All operations succeed or all fail (atomic)
- Uses **2x WCU** per item (double the cost of non-transactional writes)

### TransactGetItems

- Read up to **100 items** across multiple tables in a single transaction
- Maximum total transaction size: **4 MB**
- Returns a consistent snapshot of all items
- Uses **2x RCU** per item (double the cost of strongly consistent reads)

### Transaction Characteristics

- **Atomic**: All operations succeed or all fail
- **Consistent**: Transactions see a consistent view of data
- **Isolated**: Transactions don't interfere with each other
- **Durable**: Once committed, data is persistent
- No locking: Uses optimistic concurrency control
- **Idempotent**: Can safely retry with same client token

### Transaction Use Cases

- Financial transactions: Transfer money between accounts
- Order processing: Update inventory and create order atomically
- Gaming: Update player state and leaderboard together
- Multi-table updates: Maintain data consistency across tables

### Transaction Limitations

- Maximum 100 items per transaction
- Maximum 4 MB total data per transaction
- Cannot target the same item with multiple operations in one transaction
- No support for cross-region transactions (within a single region only)
- 2x capacity cost (significant cost consideration)

---

## DynamoDB DAX

DynamoDB Accelerator (DAX) is an in-memory caching layer for DynamoDB.

### How DAX Works

1. DAX sits between your application and DynamoDB
2. Read requests go through DAX first
3. **Cache hit**: DAX returns the cached result (**microsecond** latency)
4. **Cache miss**: DAX reads from DynamoDB, caches the result, returns it
5. Write requests pass through DAX to DynamoDB (write-through)
6. DAX is API-compatible with DynamoDB (minimal code changes)

### DAX Architecture

- **DAX Cluster**: One or more nodes
- **Primary node**: Handles reads and writes
- **Read replica nodes**: Handle reads (up to 10 replicas)
- Nodes are placed in your **VPC**
- Multi-AZ deployment recommended for high availability
- **Node types**: Various sizes (dax.r5.large, dax.r5.xlarge, etc.)

### DAX Caches

| Cache | What It Caches | TTL |
|-------|---------------|-----|
| **Item Cache** | Individual items (GetItem, BatchGetItem) | Default 5 minutes |
| **Query Cache** | Query and Scan results | Default 5 minutes |

### DAX vs ElastiCache

| Feature | DAX | ElastiCache |
|---------|-----|-------------|
| **Purpose** | DynamoDB acceleration | General-purpose caching |
| **API Compatibility** | DynamoDB API | Redis/Memcached API |
| **Code Changes** | Minimal (SDK change) | Application-level caching logic |
| **Data Model** | Same as DynamoDB | Key-value / data structures |
| **Use Case** | Speed up DynamoDB reads | Cache any data source, session store |
| **Write Caching** | Write-through | Application-managed |
| **Latency** | Microseconds | Sub-millisecond |

### When to Use DAX

- Read-heavy workloads on DynamoDB
- Applications requiring microsecond read latency
- Same queries repeated frequently
- Cost optimization: Reduce DynamoDB RCU consumption

### When NOT to Use DAX

- Write-heavy workloads (DAX primarily benefits reads)
- Applications that require strongly consistent reads (DAX returns eventually consistent)
- Applications with infrequent reads (cache miss overhead)
- Applications not using DynamoDB

---

## DynamoDB Backup and Recovery

### On-Demand Backup

- Create **full backups** at any time
- No performance impact on the table
- Backups are retained until explicitly deleted
- Backups can be used to restore to a **new table**
- Useful for long-term archival and compliance
- Backups include: Table data, provisioned capacity settings, LSI/GSI, streams settings, encryption settings

### Point-in-Time Recovery (PITR)

- Continuous backups of your DynamoDB table
- Restore to any point in time within the last **35 days**
- Must be **explicitly enabled** (not enabled by default)
- Recovery creates a **new table** (cannot restore in-place)
- Latest restorable time: Typically 5 minutes before the current time
- PITR includes: Table data, GSIs, LSIs, streams, encryption, TTL settings
- Does NOT preserve: Auto scaling policies, IAM policies, CloudWatch alarms, tags

### Backup Comparison

| Feature | On-Demand Backup | PITR |
|---------|-----------------|------|
| Trigger | Manual | Continuous |
| Recovery Window | Any backup taken | Last 35 days |
| Granularity | Snapshot at backup time | Any second within 35 days |
| Retention | Until deleted | Rolling 35-day window |
| Cost | Per GB stored | Per GB per month |
| Enable | Always available | Must enable |
| Restore Target | New table | New table |

---

## DynamoDB Encryption

### Encryption at Rest

All DynamoDB tables are **encrypted at rest by default**. Three options:

| Option | Key Type | Key Management | Cost |
|--------|----------|---------------|------|
| **AWS Owned Key** | AWS owns and manages | No visibility or control | Free (default) |
| **AWS Managed Key** (`aws/dynamodb`) | AWS KMS managed | Visible in KMS, audit in CloudTrail | KMS charges |
| **Customer Managed CMK** | You create and manage | Full control, rotation, deletion | KMS charges |

### When to Use Each

- **AWS Owned Key**: Default, simplest, no KMS charges, no CloudTrail audit trail
- **AWS Managed Key**: Need CloudTrail audit trail for key usage, regulatory compliance
- **Customer Managed CMK**: Need full control over key lifecycle, cross-account access, custom key policies

### Encryption in Transit

- DynamoDB endpoints use **HTTPS** (TLS encryption)
- All API calls encrypted in transit by default
- No additional configuration needed for in-transit encryption

### Encryption Notes

- Encryption type can be changed on an existing table (unlike RDS)
- When using Customer Managed CMK, the key must be in the same region as the table
- Encryption applies to table data, LSIs, GSIs, streams, backups, and DAX clusters (DAX encryption at rest is separate)

---

## Query vs Scan

### Query Operation

- Retrieves items based on **primary key values**
- Must specify the **partition key** (exact match, equality condition)
- Can optionally specify conditions on the **sort key** (=, <, >, <=, >=, BETWEEN, BEGINS_WITH)
- Can use **filter expressions** on non-key attributes (applied after data retrieval, does NOT reduce RCU consumption)
- Returns items sorted by sort key (ascending by default, `ScanIndexForward=false` for descending)
- Maximum **1 MB** of data returned per query (use pagination for more)
- Can query the base table or any secondary index
- **Efficient**: Only reads items that match the partition key

### Scan Operation

- Reads **every item** in the entire table or index
- Returns all attributes by default (use ProjectionExpression to limit)
- Can apply filter expressions (applied after reading, does NOT reduce RCU consumption)
- Maximum **1 MB** of data returned per scan (use pagination for more)
- **Expensive**: Consumes RCU for the entire table regardless of filter results
- Gets less efficient as the table grows

### Parallel Scan

- Scan can be parallelized by dividing the table into **segments**
- Each segment is scanned by a separate thread/worker
- Parameters: `TotalSegments` and `Segment`
- Improves scan speed but consumes more RCU simultaneously
- Use with caution in production (can spike RCU usage)

### Query vs Scan Performance

| Feature | Query | Scan |
|---------|-------|------|
| Data Read | Only matching PK items | Entire table |
| RCU Cost | Low (targeted) | High (full table) |
| Speed | Fast | Slow for large tables |
| Filter | Applied after PK match | Applied after full read |
| Sort | By sort key | No guaranteed order |
| Use Case | Known access patterns | Data migration, analytics |

### Best Practices

- **Always prefer Query over Scan** when possible
- Design tables and indexes to support Query operations
- Use filter expressions to reduce data returned to client (but understand RCU is still consumed)
- Use ProjectionExpression to return only needed attributes
- For Scans: Use parallel scan with rate limiting if full table scan is necessary

---

## Batch Operations

### BatchGetItem

- Read up to **100 items** from one or more tables in a single request
- Maximum **16 MB** of data returned
- Uses eventually consistent reads by default (can specify strongly consistent)
- If some items fail, they appear in `UnprocessedKeys` (retry with exponential backoff)
- More efficient than individual GetItem calls (fewer round trips)
- Each item's read still consumes RCU as if read individually

### BatchWriteItem

- Write (Put or Delete) up to **25 items** across one or more tables
- Maximum **16 MB** of data
- Does NOT support UpdateItem (only Put and Delete)
- If some items fail, they appear in `UnprocessedItems` (retry with exponential backoff)
- Operations are NOT atomic (individual items may succeed or fail independently)
- More efficient than individual PutItem/DeleteItem calls
- **Cannot update items** — only put (insert/replace) or delete

### Batch Operation Best Practices

- Use exponential backoff for retrying UnprocessedKeys/UnprocessedItems
- Enable auto scaling to handle burst batch operations
- Distribute items across partitions for parallel processing
- Monitor `UnprocessedKeys`/`UnprocessedItems` for throttling issues

---

## DynamoDB Pagination

### How Pagination Works

- DynamoDB returns a maximum of **1 MB** per Query/Scan request
- If there are more results, the response includes a **LastEvaluatedKey**
- To get the next page, use LastEvaluatedKey as the **ExclusiveStartKey** in the next request
- When LastEvaluatedKey is absent, you've reached the last page
- **Limit** parameter: Maximum number of items to evaluate (not necessarily return)

### Pagination Flow

```
Request 1 → Results + LastEvaluatedKey
Request 2 (ExclusiveStartKey = LastEvaluatedKey from Request 1) → Results + LastEvaluatedKey
Request 3 (ExclusiveStartKey = LastEvaluatedKey from Request 2) → Results (no LastEvaluatedKey = done)
```

### Important Notes

- `Limit` restricts items **evaluated**, not items returned after filtering
- Filter expressions are applied AFTER the Limit and AFTER data is read
- Even with a Limit of 10, if filtering removes 9 items, you only get 1 result but consume RCU for 10
- Applications must handle pagination logic (DynamoDB SDKs often provide auto-pagination)

---

## DynamoDB Access Patterns

### Adjacency List Pattern

- Model many-to-many relationships using a single table
- Partition key: Entity ID
- Sort key: Related entity ID (with a prefix to identify type)
- Example: Users and Groups
  - `PK=User#123, SK=User#123` → User details
  - `PK=User#123, SK=Group#456` → User's membership in Group 456
  - `PK=Group#456, SK=Group#456` → Group details
  - `PK=Group#456, SK=User#123` → Group's member User 123
- Query `PK=User#123` to get all groups a user belongs to
- Query `PK=Group#456` to get all members of a group

### Write Sharding

- Distribute writes across multiple partitions to avoid hot partitions
- Add a random suffix to the partition key
- Example: Instead of `PK=OrderDate#2024-01-15`, use `PK=OrderDate#2024-01-15#0` through `PK=OrderDate#2024-01-15#9`
- Reads require scatter-gather across all shards
- Trade-off: Better write performance, more complex reads

### Sparse Indexes

- Create a GSI on an attribute that not all items have
- Only items WITH that attribute appear in the index
- Creates a smaller, targeted index
- Example: GSI on `IsActive` attribute — only active items appear in the index
- Useful for filtering without scanning the entire table

### Composite Sort Keys

- Combine multiple attributes into a single sort key
- Enables hierarchical queries
- Example: `SK=Country#State#City`
  - `BEGINS_WITH("USA")` → All US records
  - `BEGINS_WITH("USA#CA")` → All California records
  - `BEGINS_WITH("USA#CA#SanFrancisco")` → San Francisco records
- Provides flexible querying at different granularity levels

### Single-Table Design

- Store multiple entity types in a single DynamoDB table
- Use generic attribute names for PK and SK (e.g., `PK`, `SK`)
- Overload the key attributes with type prefixes
- Benefits: Fewer tables, single request for related data, reduced cost
- Complexity: Harder to understand, maintain, and evolve the data model

---

## DynamoDB PartiQL

PartiQL is a SQL-compatible query language for DynamoDB.

### Key Features

- Execute **SELECT, INSERT, UPDATE, DELETE** statements
- SQL-like syntax for DynamoDB operations
- Supports batch operations and transactions
- Available through AWS Console, CLI, and SDKs
- Simplifies interaction for developers familiar with SQL

### Examples

```sql
-- Select
SELECT * FROM "Users" WHERE "UserId" = '12345'

-- Insert
INSERT INTO "Users" VALUE {'UserId': '12345', 'Name': 'John'}

-- Update
UPDATE "Users" SET "Name" = 'Jane' WHERE "UserId" = '12345'

-- Delete
DELETE FROM "Users" WHERE "UserId" = '12345'
```

### Limitations

- Still follows DynamoDB's query/scan model underneath
- No JOINs across tables
- No aggregate functions (SUM, COUNT, AVG)
- Performance characteristics are the same as native DynamoDB API
- SELECT without specifying partition key still results in a Scan

---

## DynamoDB Export and Import

### Export to S3

- Export DynamoDB table data to an **S3 bucket**
- Uses **Point-in-Time Recovery (PITR)** — PITR must be enabled
- Export any point in time within the PITR window (last 35 days)
- Export does NOT affect table performance (reads from PITR, not live table)
- Export formats: **DynamoDB JSON** or **Amazon Ion**
- Exported data can be queried with **Athena**, processed with **Glue**, **EMR**, etc.
- Useful for analytics, data lake ingestion, compliance archival

### Import from S3

- Import data from an S3 bucket into a **new DynamoDB table**
- Creates a new table (cannot import into existing table)
- Supported formats: DynamoDB JSON, Amazon Ion, CSV
- Does NOT consume WCU (uses internal import mechanism)
- Import errors are logged to CloudWatch Logs
- Useful for data migration, bulk loading, restoring from export

---

## DynamoDB Pricing Model

### Provisioned Mode Pricing

- **WCU**: Per WCU-hour (varies by region)
- **RCU**: Per RCU-hour (varies by region)
- **Storage**: Per GB per month (first 25 GB free in free tier)
- **Reserved Capacity**: 1-year or 3-year terms (up to 77% savings)
- **Data Transfer**: In is free; out to internet is charged per GB

### On-Demand Mode Pricing

- **Write Request Units**: Per million WRU
- **Read Request Units**: Per million RRU
- **Storage**: Same as provisioned (per GB per month)
- No reserved capacity pricing available
- Typically 5-7x more expensive per request than provisioned

### Additional Costs

- **DynamoDB Streams**: Free for reading (2 GetRecords calls per shard per second)
- **Global Tables**: Additional WRU for replicated writes
- **DAX**: Per node-hour (depends on node type)
- **Backups**: On-demand backup (per GB), PITR (per GB per month)
- **Data Transfer Out**: Per GB (standard AWS data transfer pricing)
- **Export to S3**: Per GB exported
- **Restore from backup**: Per GB restored

### Free Tier (Always Free)

- 25 GB of storage
- 25 WCU and 25 RCU (provisioned mode) — enough for ~200 million requests/month
- 2.5 million stream read requests per month
- Available indefinitely (not just first 12 months)

---

## Common Exam Scenarios

### Scenario 1: Serverless Application with Variable Traffic

**Question**: A startup is building a serverless application with unpredictable traffic patterns. They need a database that scales automatically.

**Solution**: **DynamoDB in on-demand mode**. No capacity planning needed, scales automatically, pairs perfectly with Lambda and API Gateway for a fully serverless architecture.

### Scenario 2: Low-Latency Reads for Gaming Leaderboard

**Question**: A gaming application needs microsecond read latency for a leaderboard that is read millions of times per second.

**Solution**: **DynamoDB with DAX**. DAX provides microsecond read latency for frequently accessed items. Use a GSI with the score as a sort key for efficient leaderboard queries.

### Scenario 3: Session Management for Web Application

**Question**: A web application needs to store user session data with automatic expiration.

**Solution**: **DynamoDB with TTL**. Store session data with a TTL attribute set to the session expiration timestamp. DynamoDB automatically deletes expired sessions at no additional cost.

### Scenario 4: Multi-Region Active-Active Application

**Question**: An application needs to operate in multiple regions with read and write access from all regions.

**Solution**: **DynamoDB Global Tables**. Provides multi-region, multi-active replication with sub-second replication latency. Each region can handle both reads and writes.

### Scenario 5: Real-Time Data Processing Pipeline

**Question**: An application needs to trigger processing whenever data changes in the database.

**Solution**: **DynamoDB Streams + Lambda**. Enable streams with NEW_AND_OLD_IMAGES, create a Lambda trigger. Lambda processes changes in near real-time for notifications, analytics, or cross-service updates.

### Scenario 6: Reducing Read Costs

**Question**: A DynamoDB table has high RCU consumption due to repeated reads of the same items.

**Solution**: Implement **DAX** for caching frequently accessed items. Alternatively, use eventually consistent reads (half the RCU cost) if the application can tolerate slight staleness.

### Scenario 7: Complex Queries Across Different Attributes

**Question**: An e-commerce application needs to query orders by CustomerId, by OrderDate, and by ProductId.

**Solution**: Design the table with `CustomerId` as partition key and `OrderDate` as sort key. Create **GSIs** for `ProductId` and any other query patterns needed. Each GSI enables a different query pattern.

### Scenario 8: Migrate from MongoDB to AWS

**Question**: A company wants to migrate their MongoDB-based application to AWS with minimal code changes.

**Solution**: Use **Amazon DocumentDB** (MongoDB-compatible) for minimal code changes. However, if the application can be redesigned for key-value access patterns, DynamoDB provides better scalability and lower operational overhead.

### Scenario 9: Large Item Storage

**Question**: An application needs to store items larger than 400 KB in DynamoDB.

**Solution**: Store the large data in **S3** and keep a reference (S3 URL/key) in the DynamoDB item. This is the standard pattern for handling large objects with DynamoDB.

### Scenario 10: Hot Partition Problem

**Question**: A DynamoDB table is experiencing throttling on certain partition keys.

**Solution**:
1. Redesign the partition key for better distribution (higher cardinality)
2. Implement **write sharding** to distribute hot keys across partitions
3. Use **DAX** to cache frequently read hot items
4. Enable **on-demand mode** or increase provisioned capacity with auto scaling
5. DynamoDB's **adaptive capacity** helps, but doesn't eliminate poor key design

### Scenario 11: Compliance Backup Requirements

**Question**: A company needs to maintain database backups with the ability to restore to any point in the last 30 days.

**Solution**: Enable **Point-in-Time Recovery (PITR)** on the DynamoDB table. PITR provides continuous backups with the ability to restore to any second in the last 35 days.

### Scenario 12: Atomic Multi-Item Updates

**Question**: A financial application needs to transfer funds between two accounts atomically.

**Solution**: Use **DynamoDB Transactions** (TransactWriteItems). Debit one account and credit another in a single transaction. If either operation fails, both are rolled back. Note: Transactions consume 2x WCU.

### Scenario 13: Data Analytics on DynamoDB Data

**Question**: The analytics team needs to run complex SQL queries on DynamoDB data without affecting production.

**Solution**: **Export DynamoDB to S3** (using PITR, no impact on live table), then query with **Amazon Athena** or process with **AWS Glue** for complex analytics. This avoids expensive Scan operations on the live table.

---

## Key Numbers to Remember

| Feature | Value |
|---------|-------|
| Maximum item size | 400 KB |
| Maximum partition throughput | 3,000 RCU, 1,000 WCU |
| Maximum partition size | 10 GB |
| LSI per table | 5 |
| GSI per table | 20 (soft limit) |
| LSI size limit per PK | 10 GB |
| BatchGetItem max items | 100 |
| BatchWriteItem max items | 25 |
| Transaction max items | 100 |
| Transaction max size | 4 MB |
| Query/Scan max response | 1 MB |
| Streams retention | 24 hours |
| PITR window | 35 days |
| TTL deletion delay | Up to 48 hours |
| Transactional cost | 2x normal cost |
| Global Tables max regions | All available regions |
| DynamoDB data replication | 3 AZs |
| DAX item cache default TTL | 5 minutes |

---

## Summary

- **DynamoDB** = fully managed, serverless NoSQL, single-digit ms latency, 400 KB max item size
- **Capacity Modes** = Provisioned (with auto scaling) vs On-Demand
- **RCU/WCU** = 1 WCU = 1 KB write/s, 1 RCU = 4 KB strongly consistent read/s (or 2 eventually consistent)
- **LSI** = Same PK, different SK, created at table time, shared capacity
- **GSI** = Different PK/SK, created anytime, separate capacity, eventually consistent only
- **Streams** = 24-hour ordered log of changes, Lambda triggers, foundation for Global Tables
- **Global Tables** = Multi-region, multi-active, last-writer-wins, sub-second replication
- **Transactions** = ACID across items/tables, 2x capacity cost, max 100 items
- **DAX** = In-memory cache, microsecond reads, minimal code changes
- **TTL** = Auto-delete expired items, free, up to 48h delay
- **PITR** = Continuous backup, restore to any second in 35 days
- **Export to S3** = Analytics without impacting table, uses PITR

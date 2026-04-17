# S3 Deep Dive

## Table of Contents

1. [S3 Fundamentals](#s3-fundamentals)
2. [Storage Classes](#storage-classes)
3. [S3 Lifecycle Rules](#s3-lifecycle-rules)
4. [S3 Versioning](#s3-versioning)
5. [S3 Replication](#s3-replication)
6. [S3 Encryption](#s3-encryption)
7. [S3 Access Control](#s3-access-control)
8. [S3 Object Lock](#s3-object-lock)
9. [S3 Presigned URLs](#s3-presigned-urls)
10. [S3 Performance](#s3-performance)
11. [S3 Event Notifications](#s3-event-notifications)
12. [S3 Static Website Hosting](#s3-static-website-hosting)
13. [S3 CORS](#s3-cors)
14. [S3 Access Logging vs CloudTrail](#s3-access-logging-vs-cloudtrail)
15. [S3 Storage Lens](#s3-storage-lens)
16. [S3 Batch Operations](#s3-batch-operations)
17. [S3 Object Lambda](#s3-object-lambda)
18. [S3 Pricing Model](#s3-pricing-model)
19. [Exam Tips & Scenarios](#exam-tips--scenarios)

---

## S3 Fundamentals

Amazon Simple Storage Service (S3) is an **object storage** service that offers industry-leading scalability, data availability, security, and performance. S3 is one of the most heavily tested services on the SAA-C03 exam.

### Buckets

- Buckets are the top-level containers for objects
- Bucket names must be **globally unique** (across all AWS accounts and regions)
- Buckets are created in a specific **AWS Region**
- Naming rules: 3-63 characters, lowercase letters, numbers, hyphens, no periods (recommended)
- Flat structure (no actual directories — the "/" in keys is just a prefix delimiter)
- Soft limit: 100 buckets per account (can request increase to 1000)

### Objects

- Objects are the fundamental entities stored in S3
- Each object consists of:
  - **Key**: The full path/name of the object (e.g., `photos/2024/vacation/beach.jpg`)
  - **Value**: The content (body) of the object — up to **5 TB** in size
  - **Version ID**: If versioning is enabled
  - **Metadata**: System and user-defined key-value pairs
  - **Tags**: Key-value pairs for organization, billing, and access control (up to 10 per object)
  - **Sub-resources**: ACLs, torrent info

### Keys

- The key is the unique identifier for an object within a bucket
- Full object URL: `https://{bucket-name}.s3.{region}.amazonaws.com/{key}`
- Prefix: everything before the last "/" (e.g., `photos/2024/vacation/` is the prefix for `beach.jpg`)
- There is no concept of directories — S3 is a flat namespace. The console shows "folders" for convenience.

### Metadata

**System-defined metadata:**
- `Content-Type`: MIME type (e.g., `image/jpeg`, `application/json`)
- `Content-Length`: Size in bytes
- `Last-Modified`: Timestamp
- `ETag`: Hash of the object (MD5 for non-multipart uploads)
- `x-amz-server-side-encryption`: Encryption algorithm

**User-defined metadata:**
- Custom key-value pairs prefixed with `x-amz-meta-`
- Example: `x-amz-meta-author: john`, `x-amz-meta-project: alpha`
- Metadata is returned with the object and in HEAD requests
- Cannot be modified after upload without re-uploading the object

### Tags

- Up to 10 tags per object
- Key-value pairs (key: 128 characters max, value: 256 characters max)
- Use cases: cost allocation, access control (tag-based IAM policies), lifecycle rules
- Tags can be modified without re-uploading the object

---

## Storage Classes

Understanding S3 storage classes and when to use each is critical for the exam.

### S3 Standard

| Feature | Detail |
|---------|--------|
| **Durability** | 99.999999999% (11 nines) |
| **Availability** | 99.99% |
| **AZs** | ≥ 3 |
| **Retrieval fee** | None |
| **Min storage duration** | None |
| **Min object size** | None |
| **First byte latency** | Milliseconds |
| **Use cases** | Frequently accessed data, websites, content distribution, big data analytics |

### S3 Standard-IA (Infrequent Access)

| Feature | Detail |
|---------|--------|
| **Durability** | 99.999999999% (11 nines) |
| **Availability** | 99.9% |
| **AZs** | ≥ 3 |
| **Retrieval fee** | Yes (per GB) |
| **Min storage duration** | 30 days |
| **Min object size** | 128 KB (smaller objects charged as 128 KB) |
| **First byte latency** | Milliseconds |
| **Use cases** | Backups, disaster recovery, data accessed less than once a month |

### S3 One Zone-IA

| Feature | Detail |
|---------|--------|
| **Durability** | 99.999999999% (11 nines) within one AZ |
| **Availability** | 99.5% |
| **AZs** | 1 |
| **Retrieval fee** | Yes (per GB) |
| **Min storage duration** | 30 days |
| **Min object size** | 128 KB |
| **First byte latency** | Milliseconds |
| **Use cases** | Secondary backups, data that can be re-created, thumbnails |

**Risk**: Data is lost if the AZ is destroyed. Only use for data that can be recreated.

### S3 Glacier Instant Retrieval

| Feature | Detail |
|---------|--------|
| **Durability** | 99.999999999% (11 nines) |
| **Availability** | 99.9% |
| **AZs** | ≥ 3 |
| **Retrieval fee** | Yes (higher than IA) |
| **Min storage duration** | 90 days |
| **Min object size** | 128 KB |
| **First byte latency** | Milliseconds |
| **Use cases** | Archive data accessed once per quarter, medical images, news media |

**Key**: Same latency as Standard/IA but much lower storage cost. Higher retrieval cost.

### S3 Glacier Flexible Retrieval (formerly Glacier)

| Feature | Detail |
|---------|--------|
| **Durability** | 99.999999999% (11 nines) |
| **Availability** | 99.99% (after restoration) |
| **AZs** | ≥ 3 |
| **Retrieval fee** | Yes |
| **Min storage duration** | 90 days |
| **Min object size** | 40 KB |
| **Retrieval options** | Expedited (1-5 min), Standard (3-5 hours), Bulk (5-12 hours) |
| **Use cases** | Archive data accessed 1-2 times per year, compliance archives |

**Retrieval tiers:**
- **Expedited**: 1-5 minutes. Most expensive. For urgent access.
- **Standard**: 3-5 hours. Default.
- **Bulk**: 5-12 hours. Cheapest. For large amounts of data.
- **Provisioned capacity**: Guarantees expedited retrieval availability ($100/unit/month)

### S3 Glacier Deep Archive

| Feature | Detail |
|---------|--------|
| **Durability** | 99.999999999% (11 nines) |
| **Availability** | 99.99% (after restoration) |
| **AZs** | ≥ 3 |
| **Retrieval fee** | Yes |
| **Min storage duration** | 180 days |
| **Min object size** | 40 KB |
| **Retrieval options** | Standard (12 hours), Bulk (48 hours) |
| **Use cases** | Long-term regulatory compliance, 7-10 year retention |

**Cheapest storage** in S3. Lowest cost per GB.

### S3 Intelligent-Tiering

| Feature | Detail |
|---------|--------|
| **Durability** | 99.999999999% (11 nines) |
| **Availability** | 99.9% |
| **AZs** | ≥ 3 |
| **Retrieval fee** | None |
| **Monitoring fee** | Small per-object monitoring fee |
| **Min storage duration** | None |
| **Use cases** | Unknown or changing access patterns |

**How it works (automatic tiering):**

| Access Tier | When Objects Move Here | Latency |
|-------------|----------------------|---------|
| **Frequent Access** | Default (recently accessed) | Milliseconds |
| **Infrequent Access** | After 30 days without access | Milliseconds |
| **Archive Instant Access** | After 90 days without access | Milliseconds |
| **Archive Access** (optional) | After 90-730 days (configurable) | 3-5 hours |
| **Deep Archive Access** (optional) | After 180-730 days (configurable) | 12 hours |

No retrieval fee. Small monthly monitoring and automation fee per object. Objects are automatically moved between tiers based on access patterns. The Archive and Deep Archive tiers must be explicitly opted-in.

### S3 Express One Zone

| Feature | Detail |
|---------|--------|
| **Durability** | 99.999999999% (11 nines) within one AZ |
| **Availability** | 99.95% |
| **AZs** | 1 (specific AZ selected) |
| **Latency** | Single-digit milliseconds (consistent) |
| **Use cases** | ML training data, real-time analytics, HPC, financial modeling |

- Uses a **directory bucket** (different from general-purpose buckets)
- Up to 10x faster than Standard S3
- 50% lower request costs
- Data is co-located with compute for lowest latency
- Bucket name includes the AZ ID (e.g., `my-bucket--useast1-az1--x-s3`)

### Storage Class Comparison Table

| Class | Durability | Avail. | AZs | Min Duration | Retrieval Fee | Latency | Cost (Storage) |
|-------|-----------|--------|-----|-------------|---------------|---------|---------------|
| Standard | 11 9s | 99.99% | ≥3 | None | None | ms | $$$$$ |
| Standard-IA | 11 9s | 99.9% | ≥3 | 30 days | Per GB | ms | $$$ |
| One Zone-IA | 11 9s | 99.5% | 1 | 30 days | Per GB | ms | $$ |
| Glacier Instant | 11 9s | 99.9% | ≥3 | 90 days | Per GB | ms | $$ |
| Glacier Flexible | 11 9s | 99.99% | ≥3 | 90 days | Per GB | min-hours | $ |
| Deep Archive | 11 9s | 99.99% | ≥3 | 180 days | Per GB | hours | ¢ |
| Intelligent-Tiering | 11 9s | 99.9% | ≥3 | None | None | ms-hours | Variable |
| Express One Zone | 11 9s | 99.95% | 1 | None | None | <10ms | $$$$$ |

---

## S3 Lifecycle Rules

Lifecycle rules automate transitioning objects between storage classes and expiring (deleting) objects.

### Transition Actions

Move objects to a different storage class after a specified number of days.

**Allowed transitions (waterfall — can only move "down"):**
```
Standard → Standard-IA → Intelligent-Tiering → One Zone-IA
                                                      ↓
Standard → Glacier Instant Retrieval → Glacier Flexible → Glacier Deep Archive
```

**Rules:**
- Standard → Standard-IA: Minimum 30 days after creation
- Standard → One Zone-IA: Minimum 30 days after creation
- Standard-IA → Glacier: Can be done at any time (after the 30-day minimum in IA)
- Small objects (<128 KB) in IA/One Zone-IA are charged as 128 KB

### Expiration Actions

Automatically delete objects after a specified time:
- Delete current versions after N days
- Delete previous versions (in versioned buckets) after N days
- Delete expired object delete markers (cleanup)
- Abort incomplete multipart uploads after N days (important for cost management)

### Filters

Lifecycle rules can be scoped to:
- **Prefix**: Apply to objects with a specific prefix (e.g., `logs/`)
- **Tags**: Apply to objects with specific tags (e.g., `Department: Finance`)
- **Object size**: Apply to objects above/below a certain size
- **Combination** of the above

### Example Lifecycle Configuration

```json
{
  "Rules": [
    {
      "ID": "MoveToIAAfter30Days",
      "Filter": { "Prefix": "documents/" },
      "Status": "Enabled",
      "Transitions": [
        {
          "Days": 30,
          "StorageClass": "STANDARD_IA"
        },
        {
          "Days": 90,
          "StorageClass": "GLACIER"
        },
        {
          "Days": 365,
          "StorageClass": "DEEP_ARCHIVE"
        }
      ]
    },
    {
      "ID": "DeleteOldVersions",
      "Filter": {},
      "Status": "Enabled",
      "NoncurrentVersionExpiration": {
        "NoncurrentDays": 90,
        "NewerNoncurrentVersions": 3
      }
    },
    {
      "ID": "CleanupMultipart",
      "Filter": {},
      "Status": "Enabled",
      "AbortIncompleteMultipartUpload": {
        "DaysAfterInitiation": 7
      }
    }
  ]
}
```

---

## S3 Versioning

Versioning keeps multiple variants of an object in the same bucket.

### States

- **Unversioned** (default): No versioning. Objects overwritten without history.
- **Enabled**: All objects get a version ID. Overwrites create new versions.
- **Suspended**: New objects get `null` as version ID. Existing versions are preserved.

**Key**: Once versioning is enabled, it **cannot be disabled**, only suspended.

### How Versioning Works

- Each PUT creates a new version with a unique version ID
- GET (without version ID) returns the latest version
- GET (with version ID) returns the specific version
- DELETE (without version ID) creates a **delete marker** (latest version becomes the delete marker)
- DELETE (with version ID) permanently deletes that specific version

### Delete Markers

- A delete marker is a placeholder indicating an object has been "deleted"
- The object isn't actually deleted — previous versions still exist
- Retrieving an object with a delete marker as the latest version returns a 404
- Deleting the delete marker "undeletes" the object (restores the previous version as current)
- Delete markers do not have associated data and are not billed for storage

### MFA Delete

MFA Delete adds an extra layer of protection for versioned buckets.

**When MFA Delete is enabled, MFA is required to:**
- Permanently delete an object version
- Suspend versioning on the bucket

**MFA is NOT required for:**
- Enabling versioning
- Listing deleted versions
- Creating delete markers (soft delete)

**Configuration:**
- Only the **bucket owner (root account)** can enable/disable MFA Delete
- Can only be enabled via the CLI or API (not the console)
- Bucket must have versioning enabled

---

## S3 Replication

### Cross-Region Replication (CRR)

Replicate objects from a source bucket in one region to a destination bucket in a different region.

**Use cases:** Compliance (data residency), lower latency access, cross-account data sharing

### Same-Region Replication (SRR)

Replicate objects between buckets in the same region.

**Use cases:** Log aggregation from multiple buckets, live replication between prod and test accounts, data sovereignty (keep copies in the same region)

### Requirements

- **Versioning** must be enabled on both source and destination buckets
- **IAM permissions**: S3 must have permissions to replicate (via a replication IAM role)
- Buckets can be in different AWS accounts
- Asynchronous replication (not real-time, typically within 15 minutes for most objects)

### What IS Replicated

- New objects created after replication is enabled
- Object metadata, tags, and ACLs
- Objects encrypted with SSE-S3 or SSE-KMS (if configured)
- Object Lock retention information
- Delete markers (optional — must be explicitly enabled)

### What is NOT Replicated

- Objects that existed before replication was enabled (use **S3 Batch Replication** for these)
- Objects encrypted with SSE-C (customer-provided keys)
- Objects in the Glacier or Glacier Deep Archive storage class
- Delete markers (by default — must opt-in)
- Permanent deletes of specific versions (by design — to prevent malicious deletes propagating)
- Lifecycle rule actions are not replicated
- Objects already replicated from another source (no chaining by default)

### Bi-Directional Replication

- Set up replication rules in both directions (Bucket A → B and B → A)
- Prevents infinite loops — S3 tracks replication status and doesn't re-replicate
- Useful for active-active architectures

### S3 Replication Time Control (S3 RTC)

- **SLA**: Replicates 99.99% of objects within **15 minutes**
- Provides metrics and CloudWatch notifications for replication progress
- Useful when compliance requires predictable replication timing
- Additional cost on top of standard replication

---

## S3 Encryption

### Server-Side Encryption with Amazon S3-Managed Keys (SSE-S3)

- **Default** encryption for all new S3 objects (as of January 2023)
- AWS manages the keys entirely
- Uses **AES-256** encryption
- Header: `x-amz-server-side-encryption: AES256`
- No additional cost
- No key management required

### Server-Side Encryption with KMS Keys (SSE-KMS)

- AWS KMS manages the encryption keys
- You can use the **AWS-managed key** (`aws/s3`) or a **customer-managed key (CMK)**
- Provides audit trail via CloudTrail (every key usage is logged)
- Header: `x-amz-server-side-encryption: aws:kms`
- **KMS API limits**: Each encryption/decryption counts against your KMS request quota (5,500-30,000 requests/sec depending on region)
- Can be a bottleneck for high-throughput workloads

**When to use SSE-KMS over SSE-S3:**
- Need to control who can access the encryption keys (key policies)
- Need audit logging of key usage (CloudTrail)
- Need to rotate keys on a schedule
- Need to separate key management from data management
- Regulatory requirements mandate customer-controlled keys

### Server-Side Encryption with Customer-Provided Keys (SSE-C)

- You provide the encryption key with every request
- AWS does not store the key — you must manage it
- **HTTPS is mandatory** (the key is sent in the request header)
- Headers: `x-amz-server-side-encryption-customer-algorithm`, `x-amz-server-side-encryption-customer-key`, `x-amz-server-side-encryption-customer-key-MD5`
- Cannot be used with S3 replication, S3 inventory, or S3 analytics
- Cannot be set as bucket default encryption

### Client-Side Encryption

- You encrypt the data **before** uploading to S3
- You decrypt the data **after** downloading from S3
- AWS never sees the unencrypted data
- Use libraries like the **Amazon S3 Encryption Client** or your own encryption libraries
- Full control over keys and encryption process

### Bucket Default Encryption

- Configure default encryption for a bucket (applies to all new objects without explicit encryption headers)
- Options: SSE-S3 (default) or SSE-KMS
- Object-level encryption headers override the bucket default
- SSE-S3 is now always applied even if no default is configured

### Enforcing Encryption with Bucket Policies

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DenyUnencryptedUploads",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::my-bucket/*",
      "Condition": {
        "StringNotEquals": {
          "s3:x-amz-server-side-encryption": "aws:kms"
        }
      }
    }
  ]
}
```

### Encryption in Transit

- S3 supports HTTPS (TLS) for data in transit
- Enforce HTTPS-only access with a bucket policy:

```json
{
  "Condition": {
    "Bool": {
      "aws:SecureTransport": "false"
    }
  },
  "Effect": "Deny",
  "Action": "s3:*",
  "Resource": "arn:aws:s3:::my-bucket/*"
}
```

---

## S3 Access Control

### Bucket Policies (Primary Method)

JSON-based resource policies attached to buckets.

**Common use cases:**
- Grant public access to a bucket (for static websites)
- Force encryption on upload
- Cross-account access
- Restrict access by IP address or VPC endpoint
- Require MFA for specific actions
- Restrict access to specific IAM roles

**Key elements:**
- `Effect`: Allow or Deny
- `Principal`: Who the policy applies to (AWS account, IAM user/role, everyone `*`)
- `Action`: S3 API operations (e.g., `s3:GetObject`, `s3:PutObject`)
- `Resource`: Bucket or object ARN
- `Condition`: Optional conditions (IP, VPC endpoint, encryption, etc.)

### ACLs (Access Control Lists) — Deprecated for New Buckets

- Legacy access control mechanism
- **Disabled by default** for new buckets (since April 2023)
- AWS recommends using bucket policies and IAM policies instead
- Bucket ACLs and Object ACLs (less granular than policies)
- "Bucket owner enforced" setting disables ACLs entirely

### Block Public Access Settings

Account-level and bucket-level settings to prevent accidental public access.

| Setting | What It Blocks |
|---------|---------------|
| **BlockPublicAcls** | Prevents setting public ACLs on buckets/objects |
| **IgnorePublicAcls** | Ignores any existing public ACLs |
| **BlockPublicPolicy** | Prevents bucket policies that grant public access |
| **RestrictPublicBuckets** | Restricts public and cross-account access from policies |

**Best practice**: Enable all Block Public Access settings at the **account level**, then selectively disable on specific buckets that genuinely need public access (e.g., static website hosting).

### S3 Access Points

Access Points simplify managing access to shared datasets in S3.

- Each access point has its own DNS name (internet or VPC origin)
- Each access point has its own access policy (simpler than one complex bucket policy)
- Can restrict access to a specific VPC (VPC-origin access points)
- Each access point is associated with one bucket

**Example**: A single data lake bucket with different access points for different teams:
- `finance-ap` → Allows access to `finance/` prefix
- `analytics-ap` → Allows access to `analytics/` prefix
- `marketing-ap` → Allows access to `marketing/` prefix

### Multi-Region Access Points (MRAP)

- A single global endpoint that routes S3 requests to the closest bucket replica
- Works with S3 Cross-Region Replication
- Uses AWS Global Accelerator for optimized network routing
- **Active-active** or **active-passive** configurations
- Failover controls for disaster recovery
- Supports failover between regions in minutes

---

## S3 Object Lock

Object Lock provides **write-once-read-many (WORM)** protection for S3 objects.

### Requirements

- Versioning must be enabled
- Can only be enabled at bucket creation time (cannot be added later)
- Applies at the object version level

### Retention Modes

**Governance Mode:**
- Most users cannot overwrite or delete the object version
- Users with special permissions (`s3:BypassGovernanceRetention` + sending the header `x-amz-bypass-governance-retention: true`) CAN modify or delete
- Use cases: Internal compliance, protection against accidental deletion with override capability

**Compliance Mode:**
- **Nobody** can overwrite or delete the object version — not even the root user
- Retention period cannot be shortened
- Protection is absolute during the retention period
- Use cases: Regulatory compliance (SEC, FINRA), legal requirements where data must be immutable

### Retention Period

- Duration during which the object is protected (days or years)
- After the retention period expires, the object can be modified/deleted normally
- Can be set per-object or as a default for the bucket

### Legal Hold

- Prevents deletion/overwrite regardless of retention period
- No expiration date — stays until explicitly removed
- Can be applied/removed by users with `s3:PutObjectLegalHold` permission
- Independent of retention mode/period
- Use cases: Active litigation, investigations (hold indefinitely)

### Object Lock + Glacier Vault Lock

For maximum compliance, combine:
- S3 Object Lock (Compliance mode) for S3 objects
- Glacier Vault Lock for Glacier archives
- Both enforce WORM policies that cannot be overridden

---

## S3 Presigned URLs

Presigned URLs grant temporary access to private S3 objects.

### How They Work

1. A user with access to the object generates a presigned URL using their credentials
2. The URL includes a signature, expiration time, and the specific operation (GET, PUT)
3. Anyone with the URL can perform the specified operation until it expires
4. The URL inherits the permissions of the user who generated it

### Generation

```bash
# Generate a presigned URL for download (GET) — expires in 1 hour (3600 seconds)
aws s3 presign s3://my-bucket/my-file.pdf --expires-in 3600

# Generate a presigned URL for upload (PUT)
aws s3 presign s3://my-bucket/upload-here.pdf --expires-in 300
```

### Key Details

- **Default expiration**: 3600 seconds (1 hour)
- **Max expiration**:
  - IAM user: Up to **7 days** (604800 seconds)
  - IAM role (including STS temporary credentials): Up to **12 hours**
  - EC2 instance role: Up to **6 hours**
- Generated using the credentials of the signer (IAM user or role)
- If the signer's permissions are revoked, the presigned URL stops working immediately
- Support GET (download) and PUT (upload) operations
- Can include specific headers (e.g., Content-Type for uploads)

### Use Cases

- Allow users to download private files without AWS credentials
- Allow users to upload files to a specific location
- Temporary access to resources behind a paywall
- Share files with external parties without making the bucket public

---

## S3 Performance

### Baseline Performance

- **3,500 PUT/COPY/POST/DELETE** requests per second per prefix
- **5,500 GET/HEAD** requests per second per prefix
- No limit on the number of prefixes in a bucket
- Performance scales linearly with prefixes

**Prefix example:**
- `bucket/folder1/file.txt` → prefix is `folder1/`
- `bucket/folder2/file.txt` → prefix is `folder2/`
- Each prefix independently gets 3,500 write + 5,500 read per second

**Optimization strategy:** Spread objects across multiple prefixes to increase total throughput.

### Multipart Upload

- **Required** for objects > 5 GB
- **Recommended** for objects > 100 MB
- Upload parts in parallel (improves throughput)
- If one part fails, only that part is retried
- Parts: minimum 5 MB each (except the last part), maximum 10,000 parts
- Maximum object size: 5 TB
- **Abort incomplete multipart uploads** with lifecycle rules to avoid paying for orphaned parts

### S3 Transfer Acceleration

- Uses CloudFront's edge locations to accelerate uploads/downloads over long distances
- Data is transferred to the nearest edge location, then routed over AWS's optimized backbone network
- Uses a special endpoint: `{bucket}.s3-accelerate.amazonaws.com`
- **Must be enabled** on the bucket
- Compatible with multipart upload
- Additional cost per GB transferred
- Speed improvement depends on distance to the nearest edge location

**When to use:** Uploading data from geographically distant locations (e.g., uploading from Asia to a US bucket).

### Byte-Range Fetches

- Request specific byte ranges of an object (HTTP `Range` header)
- Download parts of a large file in parallel
- Retrieve only a portion of an object (e.g., first 50 bytes for header info)
- Useful for: parallel downloads, resumable downloads, partial reads

### S3 Select

- Retrieve a subset of data from an object using **SQL expressions**
- Works on CSV, JSON, and Parquet files
- Up to **400% faster** and **80% cheaper** than downloading the entire object
- Filtering is done server-side (data transfer is reduced)

```sql
SELECT s.name, s.age FROM S3Object s WHERE s.age > 25
```

**Glacier Select**: Same concept but for objects in Glacier Flexible Retrieval.

---

## S3 Event Notifications

S3 can send notifications when certain events occur in a bucket.

### Supported Events

- `s3:ObjectCreated:*` (Put, Post, Copy, CompleteMultipartUpload)
- `s3:ObjectRemoved:*` (Delete, DeleteMarkerCreated)
- `s3:ObjectRestore:*` (Restore initiated, completed from Glacier)
- `s3:Replication:*` (Replication failed, completed, etc.)
- `s3:ObjectTagging:*` (tags put, deleted)
- `s3:ObjectAcl:Put`
- `s3:LifecycleTransition`
- `s3:IntelligentTiering`
- `s3:ReducedRedundancyLostObject`

### Destination Types

**SNS Topic:**
- Publish notification to an SNS topic
- Requires SNS topic access policy allowing S3 to publish
- Fan-out to multiple subscribers

**SQS Queue:**
- Send notification to an SQS queue
- Requires SQS queue access policy allowing S3 to send messages
- Good for: asynchronous processing, decoupling

**Lambda Function:**
- Invoke a Lambda function directly
- Requires Lambda resource policy allowing S3 to invoke
- Good for: real-time processing (thumbnails, metadata extraction)

**Amazon EventBridge:**
- Send all S3 events to EventBridge (must be enabled on the bucket)
- **All event types** are sent (not just the ones listed above)
- EventBridge can route to 20+ targets with filtering and transformation
- Supports: archive and replay, schema discovery, multiple targets per rule
- **Best option** for complex event routing

### Event Notification Delivery

- Typically delivered within seconds
- If versioning is NOT enabled, simultaneous writes to the same key may result in only one notification
- With versioning enabled, every write generates a notification

---

## S3 Static Website Hosting

S3 can host static websites (HTML, CSS, JavaScript, images).

### Setup

1. Enable static website hosting on the bucket
2. Specify the **index document** (e.g., `index.html`)
3. Optionally specify an **error document** (e.g., `error.html`)
4. Make the content publicly readable (bucket policy or individual object ACLs)
5. Disable "Block Public Access" for the specific settings needed

### Endpoint

- Website endpoint: `http://{bucket-name}.s3-website-{region}.amazonaws.com` or `http://{bucket-name}.s3-website.{region}.amazonaws.com`
- Note: S3 website endpoints use **HTTP only** (not HTTPS)
- For HTTPS: Use **CloudFront** in front of the S3 website

### Redirect Rules

- Configure redirect rules for URL redirects
- Redirect all requests to another host (e.g., redirect `http://` to `https://` via CloudFront)
- Conditional redirects based on key prefix or HTTP error code

---

## S3 CORS

**CORS (Cross-Origin Resource Sharing)** is a browser security mechanism. S3 supports CORS headers to allow cross-origin requests.

### When CORS Is Needed

When a web page served from one domain (origin) needs to access S3 resources from a different domain.

Example:
- Website at `https://www.example.com` (Origin A)
- S3 bucket at `https://my-bucket.s3.amazonaws.com` (Origin B)
- Browser blocks the request unless Origin B returns proper CORS headers

### Configuration

CORS is configured on the **S3 bucket being requested** (the "other" bucket):

```json
[
  {
    "AllowedHeaders": ["*"],
    "AllowedMethods": ["GET", "PUT", "POST"],
    "AllowedOrigins": ["https://www.example.com"],
    "ExposeHeaders": ["x-amz-server-side-encryption"],
    "MaxAgeSeconds": 3000
  }
]
```

**Exam Tip**: If you see "cross-origin" or "CORS error" in a question, the answer involves configuring CORS on the target S3 bucket. The CORS configuration must allow the requesting origin.

---

## S3 Access Logging vs CloudTrail

### S3 Server Access Logging

- Logs all requests made to a bucket
- Stored in a target logging bucket (different bucket recommended)
- Log format: time, requester, bucket, key, operation, response code, etc.
- Best-effort delivery (not guaranteed — some requests may not be logged)
- Delay: Logs may take hours to appear
- Free (but you pay for storage of the log files)
- **Do NOT set the logging bucket to be the same as the source bucket** (creates an infinite loop)

### CloudTrail for S3

- Logs S3 **API calls** (management events and data events)
- **Management events**: Bucket-level operations (CreateBucket, DeleteBucket, PutBucketPolicy) — logged by default
- **Data events**: Object-level operations (GetObject, PutObject, DeleteObject) — must be explicitly enabled, additional cost
- Near real-time delivery
- Logs to S3 bucket and/or CloudWatch Logs
- Can trigger EventBridge rules

### Comparison

| Feature | Server Access Logging | CloudTrail Data Events |
|---------|----------------------|----------------------|
| Granularity | Request-level | API-level |
| Delivery guarantee | Best-effort | Guaranteed |
| Delivery time | Hours | Minutes |
| Cost | Free (storage only) | Per event fee |
| Integration | Logs to S3 only | S3, CloudWatch, EventBridge |
| Filtering | None | Event selectors |
| Best for | Detailed access analysis | Security auditing, compliance |

---

## S3 Storage Lens

S3 Storage Lens provides **organization-wide visibility** into object storage usage, activity trends, and cost-optimization recommendations.

### Features

- **Dashboard**: Visualize storage metrics across your organization
- **Metrics**: 60+ usage and activity metrics
- **Recommendations**: Actionable suggestions to reduce costs
- **Scope**: Organization, account, region, bucket, or prefix level
- **Free tier**: 28 summary metrics retained for 14 days
- **Advanced**: 35+ additional metrics, 15-month retention, prefix-level aggregation, CloudWatch publishing

### Key Metrics

- Total storage (bytes, object count)
- Storage class distribution
- Incomplete multipart upload bytes
- Encryption status
- Replication status
- Request activity (GET, PUT rates)
- Error rates

### Use Cases

- Identify cost-optimization opportunities (e.g., objects that could be moved to cheaper storage classes)
- Monitor storage growth trends
- Find buckets with public access
- Track encryption compliance across the organization
- Identify incomplete multipart uploads consuming storage

---

## S3 Batch Operations

S3 Batch Operations performs large-scale operations on billions of objects across S3 buckets.

### How It Works

1. **Generate a manifest**: Use S3 Inventory report or provide a CSV file listing objects
2. **Define the operation**: What to do with each object
3. **Submit the job**: S3 Batch Operations processes all objects
4. **Monitor**: Track progress and review the completion report

### Supported Operations

- **Copy**: Copy objects between buckets (cross-region, cross-account)
- **Invoke Lambda**: Run a Lambda function on each object (for custom transformations)
- **Replace ACLs**: Update ACLs on objects
- **Replace tags**: Add/replace tags on objects
- **Restore from Glacier**: Initiate restore on archived objects
- **Object Lock**: Apply retention or legal hold settings
- **Replicate**: Trigger replication for existing objects (S3 Batch Replication)

### Use Cases

- Encrypt existing unencrypted objects
- Change storage class for millions of objects
- Copy objects to another account/region
- Apply Object Lock to existing objects
- Replicate existing objects that were created before replication was enabled

---

## S3 Object Lambda

S3 Object Lambda lets you transform data as it is retrieved from S3 using Lambda functions.

### How It Works

1. Create an **S3 Object Lambda Access Point**
2. Associate it with a regular S3 Access Point and a Lambda function
3. When a client requests an object through the Object Lambda Access Point, the Lambda function intercepts and transforms the data before returning it

### Use Cases

- **Redact PII** (personally identifiable information) from objects based on the caller's identity
- **Convert data formats** (e.g., XML to JSON, CSV to Parquet)
- **Resize images** on the fly based on the requester
- **Add watermarks** to images
- **Enrich data** with information from other sources (databases, APIs)
- **Filter rows or columns** from data sets based on the requester's permissions

### Key Details

- Each caller can get a different view of the same object
- No need to create or maintain multiple copies of the data
- The original object in S3 is not modified
- Supports GET, HEAD, and LIST requests

---

## S3 Pricing Model

### Storage Pricing

Charged per GB per month. Varies by storage class and region.

**Approximate US East (N. Virginia) pricing:**

| Storage Class | $/GB/month (approx.) |
|--------------|---------------------|
| Standard | $0.023 |
| Standard-IA | $0.0125 |
| One Zone-IA | $0.01 |
| Glacier Instant Retrieval | $0.004 |
| Glacier Flexible Retrieval | $0.0036 |
| Glacier Deep Archive | $0.00099 |
| Intelligent-Tiering | Varies by tier + monitoring fee ($0.0025 per 1000 objects/month) |

### Request Pricing

| Storage Class | PUT/COPY/POST/LIST (per 1000) | GET/SELECT (per 1000) |
|--------------|------------------------------|---------------------|
| Standard | $0.005 | $0.0004 |
| Standard-IA | $0.01 | $0.001 |
| One Zone-IA | $0.01 | $0.001 |
| Glacier Flexible | $0.03 | $0.0004 |
| Deep Archive | $0.05 | $0.0004 |

### Data Retrieval Pricing

- Standard: Free
- Standard-IA: $0.01 per GB
- One Zone-IA: $0.01 per GB
- Glacier Instant: $0.03 per GB
- Glacier Flexible: $0.01/GB (Standard), $0.03/GB (Expedited)
- Deep Archive: $0.02/GB (Standard), $0.05/GB (Bulk)

### Data Transfer

- **In** to S3: Free
- **Out** to Internet: $0.09/GB (first 10 TB/month), tiered pricing for higher volumes
- **Out** to same region: Free
- **Out** to other regions (S3 Transfer): $0.02/GB
- **Transfer Acceleration**: Additional $0.04-$0.08/GB

### Key Cost Optimization Tips

1. Use lifecycle rules to transition to cheaper storage classes
2. Clean up incomplete multipart uploads
3. Use Intelligent-Tiering for unknown access patterns
4. Use S3 Storage Lens to identify optimization opportunities
5. Use VPC endpoints to avoid data transfer costs for AWS service access
6. Consider S3 Express One Zone for high-throughput, low-latency workloads

---

## Exam Tips & Scenarios

### Scenario 1: Cost-Effective Archive
**Q:** Store compliance data that must be retained for 7 years. Accessed once or twice per year. Retrieval can wait 12 hours.
**A:** S3 Glacier Deep Archive. Cheapest storage, 12-hour retrieval acceptable.

### Scenario 2: Infrequently Accessed with Instant Access
**Q:** Medical images accessed quarterly for patient reviews. Must be available immediately.
**A:** S3 Glacier Instant Retrieval. Low storage cost with millisecond retrieval.

### Scenario 3: Unknown Access Patterns
**Q:** New application with unknown data access patterns. Want to optimize costs automatically.
**A:** S3 Intelligent-Tiering. Automatically moves objects between tiers based on access patterns.

### Scenario 4: Cross-Region Data Access
**Q:** Users in multiple regions need low-latency access to the same S3 data.
**A:** S3 Cross-Region Replication with Multi-Region Access Points. Data is replicated to multiple regions, MRAP routes to the closest copy.

### Scenario 5: Preventing Accidental Deletion
**Q:** Critical data must be protected from accidental deletion for compliance.
**A:** Enable versioning + S3 Object Lock (Compliance mode) + MFA Delete. Versioning prevents permanent deletion, Object Lock prevents modification, MFA Delete adds another layer.

### Scenario 6: Encrypting Existing Objects
**Q:** Need to encrypt millions of existing unencrypted objects with SSE-KMS.
**A:** S3 Batch Operations with copy operation (copy-in-place with encryption header).

### Scenario 7: Large File Uploads from Far Away
**Q:** Users in Southeast Asia upload 5 GB files to a US bucket. Uploads are slow.
**A:** S3 Transfer Acceleration + Multipart Upload. Transfer Acceleration uses edge locations, multipart uploads parts in parallel.

### Scenario 8: Enforcing HTTPS
**Q:** All S3 access must use HTTPS for compliance.
**A:** Bucket policy with `Condition: {"Bool": {"aws:SecureTransport": "false"}}` and `Effect: Deny`.

### Scenario 9: Immutable Records
**Q:** Financial records must be immutable (WORM) for regulatory compliance. Not even root user should be able to delete.
**A:** S3 Object Lock in **Compliance** mode. Nobody, including root, can delete or modify during the retention period.

### Scenario 10: Processing Uploads in Real-Time
**Q:** Automatically generate thumbnails when images are uploaded to S3.
**A:** S3 Event Notification → Lambda function (or EventBridge → Lambda). Lambda resizes the image and stores the thumbnail.

### Key Exam Patterns

1. **Storage classes**: Know the durability, availability, retrieval times, and minimum durations
2. **Glacier retrieval**: Instant (ms), Flexible (1-5min/3-5hr/5-12hr), Deep Archive (12hr/48hr)
3. **Encryption**: SSE-S3 (default, simplest), SSE-KMS (audit trail, key control), SSE-C (customer manages keys)
4. **SSE-KMS throttling**: KMS API limits can bottleneck high-throughput workloads
5. **Replication**: Requires versioning. Existing objects need Batch Replication. Delete markers optional.
6. **Object Lock Compliance mode**: Absolutely immutable (even root user). Governance mode: overridable with permission.
7. **Presigned URLs**: Temporary access. IAM user = 7 days max. IAM role = 12 hours max.
8. **Performance**: 3,500 PUT + 5,500 GET per prefix. Spread across prefixes for more throughput.
9. **Multipart Upload**: Required >5 GB, recommended >100 MB
10. **S3 Event Notifications**: EventBridge is the most flexible option (all events, multiple targets, filtering)
11. **CORS**: Configure on the bucket being accessed (the "target"), not the bucket making the request
12. **Block Public Access**: Enable at account level. Override at bucket level only when necessary.

---

*Previous: [← Elastic Beanstalk & App Runner](10-beanstalk-apprunner.md) | Next: [EBS, EFS & FSx →](12-ebs-efs-fsx.md)*

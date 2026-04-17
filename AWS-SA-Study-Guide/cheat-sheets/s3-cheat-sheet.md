# S3 Cheat Sheet

## Storage Class Comparison Table

| Storage Class              | Durability     | Availability | AZs | Min Storage Duration | Retrieval Time      | Retrieval Fee | Use Case                        |
|----------------------------|----------------|--------------|-----|----------------------|---------------------|---------------|---------------------------------|
| **S3 Standard**            | 99.999999999%  | 99.99%       | ≥3  | None                 | Instant             | None          | Frequently accessed data        |
| **S3 Intelligent-Tiering** | 99.999999999%  | 99.9%        | ≥3  | None                 | Instant*            | None          | Unknown/changing access patterns|
| **S3 Standard-IA**         | 99.999999999%  | 99.9%        | ≥3  | 30 days              | Instant             | Per GB        | Infrequent, rapid access needed |
| **S3 One Zone-IA**         | 99.999999999%  | 99.5%        | 1   | 30 days              | Instant             | Per GB        | Re-creatable infrequent data    |
| **S3 Glacier Instant**     | 99.999999999%  | 99.9%        | ≥3  | 90 days              | Milliseconds        | Per GB        | Archive with instant access     |
| **S3 Glacier Flexible**    | 99.999999999%  | 99.99%*      | ≥3  | 90 days              | 1 min – 12 hrs      | Per GB        | Archive, flexible retrieval     |
| **S3 Glacier Deep Archive**| 99.999999999%  | 99.99%*      | ≥3  | 180 days             | 12 – 48 hrs         | Per GB        | Long-term archive, compliance   |

*Intelligent-Tiering: Archive Access tier has minutes–hours retrieval  
*Glacier availability: after restore

**Key numbers to memorize:**
- 11 nines durability (99.999999999%) — ALL classes
- Standard: 99.99% availability
- IA classes: 99.9%
- One Zone-IA: 99.5%
- Min object size charge: 128 KB (IA/One Zone-IA), 40 KB (Glacier)

---

## S3 Encryption Options

| Encryption Type             | Key Managed By | Key Storage | Encryption At        | Use Case                          |
|-----------------------------|----------------|-------------|----------------------|-----------------------------------|
| **SSE-S3 (AES-256)**       | AWS            | S3          | Server-side          | Default, simplest option          |
| **SSE-KMS**                | AWS KMS        | KMS         | Server-side          | Audit trail, key rotation control |
| **SSE-C**                  | Customer       | Customer    | Server-side          | Customer manages keys externally  |
| **CSE (Client-Side)**      | Customer       | Customer    | Client-side          | Encrypt before upload             |

**SSE-S3** is the default encryption for all new buckets (since Jan 2023).

**SSE-KMS limits:** KMS has API rate limits (5,500 – 30,000 req/s depending on region). High-throughput S3 workloads may hit KMS throttling.

**Bucket key:** Reduces KMS API calls by generating a bucket-level key. Reduces cost by up to 99%.

**Exam tip:** "Audit key usage" or "separate key permissions" → SSE-KMS. "Customer manages keys outside AWS" → SSE-C.

---

## S3 Replication — CRR vs SRR

| Feature                     | CRR (Cross-Region)            | SRR (Same-Region)              |
|-----------------------------|-------------------------------|--------------------------------|
| **Regions**                 | Different regions             | Same region                    |
| **Use case**                | Compliance, lower latency, DR | Log aggregation, dev/prod sync |
| **Versioning required**     | Yes (source AND destination)  | Yes (source AND destination)   |
| **Existing objects**        | NOT replicated (use S3 Batch) | NOT replicated (use S3 Batch)  |
| **Delete markers**          | Optional (can enable)         | Optional (can enable)          |
| **Permanent deletes**       | NOT replicated                | NOT replicated                 |
| **Chaining**                | NOT supported (no transitive) | NOT supported                  |
| **Encryption**              | SSE-S3, SSE-KMS supported    | SSE-S3, SSE-KMS supported     |
| **Cross-account**           | Supported                     | Supported                      |

**Exam tip:** "Replicate existing objects" → S3 Batch Replication. Delete markers can optionally replicate, but permanent deletes (version ID deletes) never replicate.

---

## Lifecycle Transition Rules

**Allowed Transitions (waterfall — can only move DOWN):**

```
S3 Standard
    ├──→ S3 Intelligent-Tiering
    ├──→ S3 Standard-IA  (min 30 days after creation)
    ├──→ S3 One Zone-IA  (min 30 days after creation)
    ├──→ S3 Glacier Instant Retrieval
    ├──→ S3 Glacier Flexible Retrieval
    └──→ S3 Glacier Deep Archive

S3 Standard-IA
    ├──→ S3 Intelligent-Tiering
    ├──→ S3 One Zone-IA
    ├──→ S3 Glacier Instant Retrieval
    ├──→ S3 Glacier Flexible Retrieval
    └──→ S3 Glacier Deep Archive

S3 Glacier Flexible Retrieval
    └──→ S3 Glacier Deep Archive

S3 One Zone-IA
    ├──→ S3 Glacier Flexible Retrieval
    └──→ S3 Glacier Deep Archive
```

**Rules:**
- Cannot transition from any Glacier back to Standard/IA (must restore then copy)
- Cannot transition from One Zone-IA to Standard-IA
- Minimum 30 days in Standard before transitioning to IA classes
- Small objects (<128 KB) may cost more in IA classes (minimum size charge)

---

## S3 Performance Limits

| Metric                      | Limit                                        |
|-----------------------------|----------------------------------------------|
| **PUT/COPY/POST/DELETE**    | 3,500 requests/sec per prefix                |
| **GET/HEAD**                | 5,500 requests/sec per prefix                |
| **Object size (single PUT)**| Up to 5 GB                                  |
| **Object size (multipart)** | Up to 5 TB                                  |
| **Multipart recommended**   | >100 MB                                     |
| **Multipart required**      | >5 GB                                       |
| **Max buckets per account** | 100 (soft limit, can increase)               |

**Performance optimization strategies:**
- **Multi-prefix:** Spread reads across prefixes to multiply throughput
- **Multipart upload:** Parallelize uploads for large files
- **S3 Transfer Acceleration:** Use CloudFront edge locations for faster uploads
- **Byte-range fetches:** Parallelize downloads by requesting byte ranges
- **S3 Select / Glacier Select:** Retrieve only needed data using SQL

---

## S3 Event Notification Destinations

| Destination            | Use Case                                    | Notes                           |
|------------------------|---------------------------------------------|---------------------------------|
| **SNS**                | Fan-out to multiple subscribers              | Topic policy required           |
| **SQS**                | Queue processing, decoupling                 | Queue policy required           |
| **Lambda**             | Custom processing, thumbnails, transcoding   | Resource policy required        |
| **EventBridge**        | Advanced filtering, multiple destinations    | All events, archive/replay      |

**EventBridge advantages:** Advanced filtering rules, multiple destinations, archive and replay events, Schema Registry integration.

**Supported events:** s3:ObjectCreated:*, s3:ObjectRemoved:*, s3:ObjectRestore:*, s3:Replication:*, s3:LifecycleTransition, etc.

---

## S3 Access Control Methods

| Method                      | Scope          | Use Case                                    |
|-----------------------------|----------------|---------------------------------------------|
| **Bucket Policy**           | Bucket level   | Cross-account access, public access, IP-based |
| **IAM Policy**              | User/role      | Control user access to S3                    |
| **ACLs (Legacy)**           | Object/Bucket  | Legacy; use bucket policies instead          |
| **Access Points**           | Prefix-level   | Simplify access for shared datasets          |
| **VPC Endpoint Policy**     | VPC Endpoint   | Restrict which buckets can be accessed       |
| **S3 Block Public Access**  | Account/Bucket | Override ACLs/policies that grant public access |
| **Object Ownership**        | Bucket         | Disable ACLs (recommended)                   |
| **Pre-signed URLs**         | Object         | Temporary access to specific objects         |

**Exam tip:** "Simplify managing access for hundreds of applications to a shared dataset" → S3 Access Points.

---

## S3 Object Lock Modes

| Feature                     | Governance Mode                | Compliance Mode                |
|-----------------------------|--------------------------------|--------------------------------|
| **Override**                | Users with special IAM perms   | Nobody (not even root)         |
| **Delete**                  | Allowed with bypass permission | Cannot delete until expiry     |
| **Shorten retention**       | Allowed with bypass permission | Cannot shorten                 |
| **Extend retention**        | Yes                            | Yes                            |
| **Use case**                | Soft lock, testing             | Regulatory compliance (SEC, FINRA) |

**Legal Hold:** Independent of retention period. Can be applied/removed by users with `s3:PutObjectLegalHold`. Prevents deletion regardless of retention settings.

**Requirements:** Versioning must be enabled. Object Lock enabled at bucket creation only.

---

## Glacier Retrieval Options

| Retrieval Type              | Glacier Flexible          | Glacier Deep Archive       |
|-----------------------------|---------------------------|----------------------------|
| **Expedited**               | 1 – 5 minutes             | N/A                        |
| **Standard**                | 3 – 5 hours               | 12 hours                   |
| **Bulk**                    | 5 – 12 hours              | 48 hours                   |
| **Cost**                    | Expedited > Std > Bulk    | Standard > Bulk            |

**Provisioned capacity:** Guarantees expedited retrievals are available when needed ($100/month per unit).

**Glacier Instant Retrieval:** Millisecond access (no restore needed), priced between Standard-IA and Glacier Flexible.

---

## S3 Pricing Components

| Component                   | Description                                       |
|-----------------------------|---------------------------------------------------|
| **Storage**                 | Per GB/month, varies by storage class              |
| **Requests**                | PUT, COPY, POST, LIST (more expensive), GET, SELECT |
| **Data Transfer OUT**       | Per GB, tiered pricing. Transfer IN is free        |
| **Transfer Acceleration**   | Additional fee on top of data transfer             |
| **Replication**             | S3 request + data transfer charges                 |
| **Management/Analytics**    | Inventory, analytics, object tagging               |
| **Retrieval fees**          | IA and Glacier classes charge per GB retrieved      |
| **Early deletion**          | Charged if deleted before minimum storage duration  |
| **Minimum storage charge**  | 128 KB for IA, 40 KB for Glacier                   |

**Free:** Data transfer IN, transfer between S3 and EC2/CloudFront in same region, Gateway Endpoint traffic.

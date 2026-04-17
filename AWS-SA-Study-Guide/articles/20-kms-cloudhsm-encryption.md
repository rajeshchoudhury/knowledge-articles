# KMS, CloudHSM & Encryption

## Table of Contents

1. [Encryption Fundamentals](#encryption-fundamentals)
2. [AWS KMS Overview](#aws-kms-overview)
3. [KMS Key Types](#kms-key-types)
4. [KMS Key Policies](#kms-key-policies)
5. [KMS Operations](#kms-operations)
6. [KMS API Call Limits and Throttling](#kms-api-call-limits-and-throttling)
7. [KMS Key Rotation](#kms-key-rotation)
8. [KMS Multi-Region Keys](#kms-multi-region-keys)
9. [KMS Grants](#kms-grants)
10. [KMS with S3](#kms-with-s3)
11. [KMS with Other AWS Services](#kms-with-other-aws-services)
12. [AWS CloudHSM](#aws-cloudhsm)
13. [KMS vs CloudHSM Comparison](#kms-vs-cloudhsm-comparison)
14. [AWS Certificate Manager (ACM)](#aws-certificate-manager-acm)
15. [ACM Integration with AWS Services](#acm-integration-with-aws-services)
16. [ACM Private CA / AWS Private CA](#acm-private-ca--aws-private-ca)
17. [AWS Secrets Manager](#aws-secrets-manager)
18. [Systems Manager Parameter Store](#systems-manager-parameter-store)
19. [Secrets Manager vs Parameter Store Comparison](#secrets-manager-vs-parameter-store-comparison)
20. [Encryption in Transit](#encryption-in-transit)
21. [S3 Encryption Options Comparison](#s3-encryption-options-comparison)
22. [Common Exam Scenarios](#common-exam-scenarios)

---

## Encryption Fundamentals

### Symmetric Encryption

- **One key** for both encryption and decryption
- Sender and receiver share the same secret key
- Fast and efficient for large data sets
- Challenge: Securely sharing the key between parties
- Algorithm: AES-256 (used by KMS)
- KMS default: Symmetric keys

### Asymmetric Encryption

- **Two keys**: Public key (encrypt) and Private key (decrypt)
- Public key can be shared freely
- Only the private key holder can decrypt
- Slower than symmetric encryption
- Used for: Digital signatures, key exchange, encrypting small data
- Algorithms: RSA, ECC (Elliptic Curve Cryptography)
- KMS supports asymmetric keys for encrypt/decrypt and sign/verify

### Envelope Encryption

Envelope encryption is a critical concept for the AWS exam.

**The Problem:**
- KMS can only encrypt data up to **4 KB** directly
- Large files (GBs) cannot be sent to KMS for encryption

**The Solution — Envelope Encryption:**

1. KMS generates a **Data Encryption Key (DEK)** — both plaintext and encrypted versions
2. Use the **plaintext DEK** to encrypt your large data locally
3. Store the **encrypted DEK** alongside the encrypted data
4. Discard the plaintext DEK from memory
5. To decrypt: Send the encrypted DEK to KMS → KMS returns the plaintext DEK → Use it to decrypt the data

**Why "Envelope"?**
- The data is encrypted with the DEK
- The DEK is encrypted (wrapped) with the KMS key
- Like a letter (data) inside an envelope (encrypted DEK)

**Key API calls for envelope encryption:**
- `GenerateDataKey` → Returns plaintext DEK + encrypted DEK
- `GenerateDataKeyWithoutPlaintext` → Returns only encrypted DEK (for later use)
- `Decrypt` → Decrypts the encrypted DEK to get plaintext DEK

### Encryption at Rest vs In Transit

| Aspect | At Rest | In Transit |
|--------|---------|-----------|
| What | Data stored on disk/storage | Data moving over network |
| Where | S3, EBS, RDS, DynamoDB | Between client and server |
| How | AES-256, KMS, CloudHSM | TLS/SSL, VPN, HTTPS |
| When | Data is written/stored | Data is transferred |

---

## AWS KMS Overview

AWS Key Management Service (KMS) is a managed service for creating and controlling encryption keys used to encrypt your data.

### Key Characteristics

- **Fully managed**: AWS manages the HSM infrastructure
- **Centralized**: Central control over encryption keys across AWS services
- **Integrated**: Directly integrated with 100+ AWS services
- **Auditable**: All API calls logged in **CloudTrail**
- **Compliant**: FIPS 140-2 Level 2 validated (Level 3 for some operations)
- **Regional**: Keys are region-specific (except multi-region keys)
- **Durable**: Keys are designed for 99.999999999% (11 9s) durability

### KMS Concepts

- **KMS Key** (formerly CMK — Customer Master Key): The primary resource in KMS
- **Key ID**: Unique identifier for the key
- **Key ARN**: Amazon Resource Name for the key
- **Alias**: User-friendly name (e.g., `alias/my-key`)
- **Key Material**: The cryptographic material used for encryption/decryption
- **Key Spec**: The type of key (symmetric, asymmetric, HMAC)
- **Key Usage**: What the key can do (encrypt/decrypt, sign/verify, generate/verify MAC)

---

## KMS Key Types

### By Management

**AWS Managed Keys:**
- Created and managed by AWS on your behalf
- Used by AWS services (e.g., `aws/s3`, `aws/ebs`, `aws/rds`)
- You can view them but cannot manage (delete, rotate manually, change policy)
- Automatically rotated every **1 year** (recently changed to every year)
- No direct cost for the key itself (but API usage charges may apply)
- Visible in KMS console under "AWS managed keys"

**Customer Managed Keys:**
- Created and managed by you
- Full control: Create, enable/disable, rotate, delete, set key policy
- Can define IAM policies and grants
- Can be used across accounts (via key policy + IAM)
- Monthly cost: $1/month per key
- API call charges: $0.03 per 10,000 requests
- Rotation: Configurable (automatic every year or manual)

**AWS Owned Keys:**
- Owned and managed by AWS internally
- Used by AWS services to protect your data
- You have **no visibility or control** over these keys
- No charges
- No CloudTrail logging of key usage
- Example: Default encryption in S3 when no key is specified
- Cannot be viewed in KMS console

### By Key Material Origin

**KMS (AWS_KMS):**
- Key material generated by KMS
- Default for most keys
- Managed entirely by KMS
- Automatic rotation supported

**External (EXTERNAL):**
- You generate key material externally and import it into KMS
- You are responsible for key material security and durability
- Automatic rotation is **NOT supported** (manual rotation only)
- Can set key material to expire
- Use case: Compliance requirements dictating where key material is generated
- Import process: Download public key wrapping key from KMS → Encrypt your key material with it → Import

**CloudHSM (AWS_CLOUDHSM):**
- Key material generated and stored in your CloudHSM cluster
- KMS custom key store backed by CloudHSM
- You manage the HSM cluster
- FIPS 140-2 Level 3 compliance
- Use case: Regulatory requirements for HSM-based key management

### By Key Spec

**Symmetric (SYMMETRIC_DEFAULT):**
- AES-256-GCM algorithm
- Single 256-bit key
- Used for: Encrypt/decrypt, envelope encryption
- Key material never leaves KMS (you never see the plaintext key)
- Default and most common type

**Asymmetric (RSA or ECC):**
- RSA: RSA_2048, RSA_3072, RSA_4096
- ECC: ECC_NIST_P256, ECC_NIST_P384, ECC_NIST_P521, ECC_SECG_P256K1
- Public key can be downloaded (for use outside AWS)
- Private key never leaves KMS
- Use cases:
  - Encrypt/Decrypt: When callers can't use KMS API (external systems)
  - Sign/Verify: Digital signatures, code signing
- **Exam tip**: Use asymmetric when encryption must happen outside AWS (e.g., on-premises applications that can't call KMS)

**HMAC:**
- Symmetric key for Hash-based Message Authentication Code
- Used for: Message integrity verification
- HMAC_224, HMAC_256, HMAC_384, HMAC_512

---

## KMS Key Policies

Every KMS key has a key policy (similar to S3 bucket policies or IAM policies).

### Default Key Policy

When you create a KMS key without specifying a policy, the default policy:
- Gives the **root user** of the AWS account full access to the key
- This means any IAM user/role in the account can use the key IF their IAM policy allows it
- Enables IAM policies to work with the key

```json
{
  "Sid": "Enable IAM policies",
  "Effect": "Allow",
  "Principal": {"AWS": "arn:aws:iam::123456789012:root"},
  "Action": "kms:*",
  "Resource": "*"
}
```

### Custom Key Policy

- Define specific users, roles, or accounts that can use or manage the key
- Can restrict key usage to specific operations
- **Required** for cross-account access

**Example — Cross-Account Access:**

Step 1: Key policy in Account A allows Account B:
```json
{
  "Sid": "Allow Account B",
  "Effect": "Allow",
  "Principal": {"AWS": "arn:aws:iam::222233334444:root"},
  "Action": [
    "kms:Encrypt",
    "kms:Decrypt",
    "kms:GenerateDataKey"
  ],
  "Resource": "*"
}
```

Step 2: IAM policy in Account B allows the role to use the key:
```json
{
  "Effect": "Allow",
  "Action": [
    "kms:Encrypt",
    "kms:Decrypt",
    "kms:GenerateDataKey"
  ],
  "Resource": "arn:aws:kms:us-east-1:111122223333:key/key-id"
}
```

### Key Policy Components

| Element | Description |
|---------|-------------|
| **Key administrators** | Can manage the key (enable, disable, rotate, delete) but NOT use it for crypto |
| **Key users** | Can use the key for encrypt/decrypt operations |
| **Grants** | Delegate key usage permissions programmatically |

### Key Policy Best Practices

- Follow least privilege: Only grant necessary actions
- Separate key administrators from key users
- Use condition keys for additional restrictions (e.g., `kms:ViaService`)
- Always have at least one administrator to prevent lockout
- Use `kms:EncryptionContext` condition for additional security

---

## KMS Operations

### Core Cryptographic Operations

**Encrypt:**
- Encrypts plaintext data (up to **4 KB**) using a KMS key
- Returns ciphertext
- For data > 4 KB, use envelope encryption

**Decrypt:**
- Decrypts ciphertext that was encrypted with a KMS key
- Returns plaintext
- KMS determines which key to use from the ciphertext metadata

**Re-Encrypt:**
- Decrypts ciphertext and re-encrypts it with a different KMS key
- Done **server-side** (plaintext is never exposed to the caller)
- Use case: Rotate to a new key, change encryption context
- Efficient: Single API call instead of Decrypt + Encrypt

**GenerateDataKey:**
- Generates a data encryption key (DEK) for envelope encryption
- Returns BOTH:
  - Plaintext DEK (use for encryption, then discard)
  - Encrypted DEK (store alongside encrypted data)
- You specify the KMS key to encrypt the DEK

**GenerateDataKeyWithoutPlaintext:**
- Same as GenerateDataKey but returns ONLY the encrypted DEK
- Use when you don't need to encrypt data immediately
- To use later: Call `Decrypt` to get the plaintext DEK

**GenerateRandom:**
- Returns a random byte string (1-1024 bytes)
- Use for: Generating random tokens, nonces, initialization vectors

### Signature Operations (Asymmetric Keys)

**Sign:**
- Create a digital signature using a private key
- Input: Message or message digest
- Output: Signature

**Verify:**
- Verify a digital signature using a public key
- Input: Message + Signature
- Output: Valid/Invalid

### Encryption Context

- Key-value pairs that provide additional context for encryption
- Acts as **additional authenticated data (AAD)**
- Must provide the same encryption context for decryption
- Logged in CloudTrail (useful for auditing)
- NOT secret (visible in logs)
- Use for: Restricting decryption to specific contexts

```json
{
  "Department": "Finance",
  "Purpose": "QuarterlyReport"
}
```

---

## KMS API Call Limits and Throttling

### Request Quotas (Per Second Per Account Per Region)

| Operation | Default Quota |
|-----------|--------------|
| Cryptographic operations (Symmetric) | 5,500 - 30,000 requests/second (varies by region) |
| Cryptographic operations (Asymmetric RSA) | 500 requests/second |
| Cryptographic operations (Asymmetric ECC) | 300 requests/second |
| GenerateDataKey | Same as cryptographic operations |
| GenerateRandom | Same as cryptographic operations |

### Throttling

- When quota is exceeded, KMS returns `ThrottlingException`
- Solutions:
  1. **Exponential backoff** (built into AWS SDK)
  2. **Caching data keys**: Cache the plaintext DEK locally and reuse for multiple encryptions
  3. **Request quota increase** via Service Quotas or AWS Support
  4. **S3 Bucket Keys**: Reduce KMS calls for S3 encryption (see below)
  5. **KMS key for each service**: Spread load across multiple keys

### Exam Tip

- "KMS ThrottlingException" or "KMS API limits" → Consider:
  - Implement data key caching
  - Use S3 Bucket Keys (for S3)
  - Request quota increase
  - Use envelope encryption (fewer KMS API calls)

---

## KMS Key Rotation

### Automatic Key Rotation

- Available for **customer managed keys** only (not imported keys)
- Rotation period: **Every 1 year** (365 days) — configurable from 90 to 2560 days
- AWS generates new key material
- **Old key material is retained** for decrypting previously encrypted data
- The **key ID, ARN, alias, and policies remain the same**
- Applications don't need to change anything (transparent rotation)
- Rotation happens in the background
- **Backing keys**: Each rotation creates a new backing key; KMS uses the appropriate one for decrypt

### Manual Key Rotation

- Create a new KMS key with new key material
- Update the **alias** to point to the new key
- Old key must be retained for decrypting old data
- Applications referencing the alias automatically use the new key
- You manage the rotation schedule
- Required for: Imported key material (EXTERNAL origin)

**Manual rotation steps:**
1. Create a new KMS key
2. Update the application or alias to use the new key ID
3. Keep the old key enabled (for decrypting old data)
4. Optionally disable the old key after a transition period

### Imported Key Rotation

- Automatic rotation is **NOT supported** for keys with imported material
- Must use **manual rotation**
- Import new key material into a new KMS key
- Update aliases or applications
- Keep old key for decrypting old data

### Rotation Comparison

| Feature | Automatic Rotation | Manual Rotation |
|---------|-------------------|-----------------|
| Key Material | New backing key | New KMS key |
| Key ID/ARN | Same | Different |
| Alias | Same | Update alias |
| Old Data | Automatically decrypted | Keep old key |
| Frequency | Configurable (90-2560 days) | You decide |
| Imported Keys | Not supported | Required |
| Application Changes | None | Update alias/key reference |

---

## KMS Multi-Region Keys

### Overview

- KMS keys that are replicated across multiple AWS regions
- **One primary key** in one region
- **Replica keys** in other regions
- Same key material across all regions (same key ID prefix: `mrk-`)
- Encrypt in one region, decrypt in another (without cross-region API calls)

### How Multi-Region Keys Work

1. Create a multi-region primary key in one region
2. Create replica keys in other regions
3. All keys share the same key material and key ID
4. Data encrypted in Region A can be decrypted in Region B using the local replica
5. No cross-region KMS API calls needed for decrypt

### Key Characteristics

- Same key ID (prefix `mrk-`) across regions
- Same key material (cryptographically identical)
- Independent key policies in each region
- Can be independently enabled/disabled per region
- Rotation: Automatic rotation rotates all keys simultaneously
- Aliases: Must be set independently per region

### Multi-Region Key Use Cases

- **Global client-side encryption**: Encrypt data in one region, decrypt in another
- **DynamoDB Global Tables encryption**: Encrypt attributes with a multi-region key; replicated data can be decrypted locally
- **Aurora Global Database encryption**: Encrypted data readable in secondary regions
- **Cross-region disaster recovery**: Encrypted data accessible in DR region
- **Digital signatures**: Sign in one region, verify in another

### Important Notes

- Multi-region keys are **NOT global** (they're independent keys with the same material)
- Each region's key has its own ARN
- Key policies are managed independently per region
- Not a replacement for replicating encrypted data (you still need to replicate the data)
- Higher cost than single-region keys

---

## KMS Grants

### What Are Grants

- Programmatic way to delegate KMS key permissions
- **Temporary, time-limited** permissions
- Don't modify key policy or IAM policy
- Useful for: Short-term access, delegating to services

### How Grants Work

1. **Grantee principal**: IAM entity receiving permissions
2. **Retiring principal**: Entity that can retire (delete) the grant
3. **Operations**: Specific KMS operations allowed (Encrypt, Decrypt, etc.)
4. **Constraints**: Encryption context restrictions

### Creating a Grant

```
aws kms create-grant \
  --key-id arn:aws:kms:us-east-1:123456789:key/key-id \
  --grantee-principal arn:aws:iam::123456789:role/MyRole \
  --operations Encrypt Decrypt \
  --retiring-principal arn:aws:iam::123456789:role/AdminRole
```

### Grant Use Cases

- AWS services use grants to encrypt/decrypt on your behalf (e.g., EBS, RDS)
- Temporary access for maintenance or migration tasks
- Delegating key usage without modifying key policy
- Programmatic, fine-grained access control

### Grant vs Key Policy

| Feature | Grant | Key Policy |
|---------|-------|-----------|
| Duration | Temporary | Permanent (until changed) |
| Creation | API call | Policy document |
| Use Case | Short-term delegation | Long-term permissions |
| Modification | Retire/revoke | Update policy |
| Audit | Grant tokens | Policy versions |

---

## KMS with S3

### SSE-KMS (Server-Side Encryption with KMS)

- S3 encrypts objects using a KMS key
- Each object is encrypted with a unique data key (envelope encryption)
- Data key is encrypted with the KMS key
- **KMS API calls** are made for each object PUT/GET
- Provides: Audit trail (CloudTrail), fine-grained key control, separation of duties

### S3 Bucket Keys

**The Problem:**
- Each S3 PUT/GET with SSE-KMS makes a KMS API call
- High-volume S3 operations can cause KMS throttling
- KMS API costs add up with millions of objects

**The Solution — S3 Bucket Keys:**
- S3 generates a short-lived **bucket-level key** from KMS
- This bucket key is used to encrypt data keys for individual objects
- Reduces KMS API calls by **up to 99%**
- Reduces KMS costs significantly
- Bucket key is cached in S3 for a short time

**How it works:**
1. S3 calls KMS once to generate a bucket-level data key
2. S3 uses this bucket key to generate per-object data keys
3. Per-object data keys encrypt the objects
4. Only one KMS call per bucket key rotation (not per object)

**Trade-off:**
- CloudTrail logs show the **bucket ARN** instead of the object key for KMS events
- Fewer KMS API entries in CloudTrail (aggregated at bucket level)

### SSE-KMS vs SSE-S3 vs SSE-C

| Feature | SSE-S3 | SSE-KMS | SSE-C |
|---------|--------|---------|-------|
| Key Management | AWS manages | KMS (you control) | Customer provides |
| Key Stored By | S3 | KMS | Customer |
| Audit Trail | No | CloudTrail | No |
| Header | `x-amz-server-side-encryption: AES256` | `x-amz-server-side-encryption: aws:kms` | `x-amz-server-side-encryption-customer-*` |
| Cost | Free | KMS charges | Free (no KMS) |
| Key Rotation | Automatic | Configurable | Customer managed |
| Cross-Account | N/A | Key policy required | N/A |
| HTTPS Required | No | No | Yes (mandatory) |
| Default | Yes (since 2023) | No | No |

---

## KMS with Other AWS Services

### KMS with EBS

- EBS volumes can be encrypted with KMS keys
- Encryption is enabled at volume creation (or encrypted via snapshot copy)
- All data at rest, I/O, and snapshots are encrypted
- Key used: AWS managed key (`aws/ebs`) or customer managed key
- Encryption is transparent (no performance impact for most workloads)
- Snapshots of encrypted volumes are automatically encrypted
- Copying an unencrypted snapshot → can enable encryption on the copy
- Volumes created from encrypted snapshots are automatically encrypted

### KMS with RDS

- RDS encryption at rest uses KMS
- Enabled at database creation time (cannot encrypt existing unencrypted DB directly)
- Encrypts: Storage, automated backups, read replicas, snapshots
- Key: AWS managed key (`aws/rds`) or customer managed key
- All replicas must use the same encryption status as the primary

### KMS with Secrets Manager

- Secrets Manager encrypts secrets using KMS
- Default: AWS managed key (`aws/secretsmanager`)
- Can specify a customer managed key for more control
- Encryption happens automatically
- Cross-account secret sharing requires customer managed key

### KMS with Lambda

- Lambda environment variables can be encrypted with KMS
- Default: AWS managed key
- Can use customer managed key for additional control
- Lambda decrypts environment variables at function startup

### KMS with DynamoDB

- DynamoDB encrypts all data at rest by default
- Three options: AWS owned, AWS managed (`aws/dynamodb`), customer managed
- Client-side encryption also available (Amazon DynamoDB Encryption Client)

### General Pattern

Most AWS services follow this pattern:
1. Service creates a data key using your KMS key (GenerateDataKey)
2. Service encrypts data with the plaintext data key
3. Service stores the encrypted data key with the encrypted data
4. For decryption, service sends encrypted data key to KMS → gets plaintext → decrypts data

---

## AWS CloudHSM

AWS CloudHSM provides **dedicated Hardware Security Modules (HSMs)** in the AWS Cloud.

### Key Characteristics

- **Single-tenant**: Dedicated HSM appliance for your exclusive use
- **FIPS 140-2 Level 3**: Highest level of HSM certification (KMS is Level 2)
- **Full control**: You manage the keys, KMS doesn't have access
- **Custom key store**: Integrate with KMS for seamless AWS service integration
- **Industry standards**: PKCS#11, JCE, CNG interfaces
- **High availability**: CloudHSM clusters across multiple AZs

### CloudHSM Architecture

- **CloudHSM Cluster**: One or more HSMs across AZs
- Each HSM is a dedicated device in an AWS data center
- HSMs in a cluster synchronize keys automatically
- Client software (CloudHSM client) installed on your EC2 instances
- Communication via encrypted channels

### CloudHSM Cluster

- Minimum: 1 HSM (not recommended for production)
- Recommended: 2+ HSMs across different AZs (high availability)
- Keys are automatically synchronized across HSMs in the cluster
- If one HSM fails, others in the cluster continue operating

### CloudHSM Key Management

- **You own and manage the keys** (AWS has NO access to your keys)
- If you lose your keys, **AWS cannot recover them**
- Supports: Symmetric keys, asymmetric keys, session keys, certificates
- Key types: AES, RSA, ECC, HMAC, and more
- Can export keys from CloudHSM (unlike KMS where keys stay in the service)

### CloudHSM Custom Key Store with KMS

- Create a **custom key store** in KMS backed by CloudHSM
- KMS keys are generated and stored in your CloudHSM cluster
- AWS services use KMS API as normal, but keys are in CloudHSM
- Best of both worlds: KMS integration + CloudHSM security
- Use case: Regulatory requirement for FIPS 140-2 Level 3 with AWS service integration

### CloudHSM Use Cases

- **Regulatory compliance**: FIPS 140-2 Level 3 required
- **Key sovereignty**: You must have full control over keys
- **SSL/TLS offloading**: Terminate SSL on HSM for web servers
- **Oracle TDE**: Transparent Data Encryption with hardware key storage
- **Certificate authority**: Sign certificates with HSM-protected keys
- **Code signing**: Sign code with HSM-protected keys
- **Digital signatures**: Generate signatures for financial transactions

---

## KMS vs CloudHSM Comparison

| Feature | KMS | CloudHSM |
|---------|-----|----------|
| **Tenancy** | Multi-tenant (shared infrastructure) | Single-tenant (dedicated HSM) |
| **FIPS Level** | FIPS 140-2 Level 2 (Level 3 in some areas) | FIPS 140-2 Level 3 |
| **Key Control** | AWS manages HSM, you manage policies | You fully manage keys and HSM |
| **Key Access** | Keys never leave KMS | Keys can be exported |
| **AWS Integration** | Native with 100+ services | Via custom key store or direct |
| **Management** | Fully managed | You manage cluster, users, keys |
| **Pricing** | $1/key/month + API calls | ~$1.50/HSM/hour |
| **Availability** | Built-in (multi-AZ) | You configure (cluster across AZs) |
| **Key Recovery** | AWS can help | AWS CANNOT help (your responsibility) |
| **Symmetric Keys** | AES-256 | AES, DES, Triple DES |
| **Asymmetric Keys** | RSA, ECC | RSA, ECC, DH |
| **SSL Offloading** | No | Yes |
| **Oracle TDE** | Yes | Yes (hardware-based) |
| **Custom Key Store** | N/A | Yes (integrates with KMS) |
| **CloudTrail Audit** | Yes | Yes (CloudHSM audit logs) |

### When to Use KMS

- Default choice for most encryption needs
- AWS service integration (S3, EBS, RDS, DynamoDB)
- No regulatory requirement for FIPS 140-2 Level 3
- Cost-effective key management
- Simple, managed solution

### When to Use CloudHSM

- FIPS 140-2 Level 3 compliance required
- Full control over key material required
- Need to export keys
- SSL/TLS offloading for web servers
- Oracle TDE with hardware key storage
- Asymmetric key operations at high volume
- Financial or government regulatory requirements

---

## AWS Certificate Manager (ACM)

AWS Certificate Manager handles the creation, storage, and renewal of SSL/TLS certificates.

### Public Certificates

- **Free** SSL/TLS certificates for use with AWS services
- Trusted by all major browsers and operating systems
- Automatically renewed (no manual intervention)
- Validation methods:
  - **DNS validation** (recommended): Add CNAME record to DNS
  - **Email validation**: Verify via email to domain contacts
- Cannot be used outside AWS (only with integrated services)
- Cannot be exported (private key is managed by ACM)

### Private Certificates

- Created using **AWS Private CA** (Private Certificate Authority)
- Used for internal services, IoT devices, VPN
- You control the CA hierarchy
- Can be exported and installed on EC2, on-premises servers
- **Cost**: Monthly charge for Private CA + per-certificate charge

### Certificate Renewal

**Public certificates (ACM-issued):**
- Automatically renewed before expiration (if validated)
- DNS validation: Renewed automatically if CNAME record exists
- Email validation: Renewal email sent to domain contacts

**Imported certificates:**
- NOT automatically renewed
- You must import the renewed certificate manually
- ACM sends CloudWatch Events/EventBridge notifications before expiration
- Monitor with CloudWatch alarm on `DaysToExpiry` metric

### Certificate Validation

**DNS Validation (Recommended):**
- Create a CNAME record in your DNS (Route 53 or external DNS)
- ACM automatically checks the CNAME
- Faster and automatic renewal
- Works well with Route 53 (ACM can create the record for you)

**Email Validation:**
- ACM sends validation emails to domain contacts (WHOIS) and admin addresses
- Domain owner clicks the validation link
- Must be re-validated for each renewal
- Not recommended for production

### Importing Certificates

- Import third-party certificates into ACM
- Use for certificates issued by external CAs
- Must manually renew and re-import
- Supported formats: PEM-encoded certificate, private key, and certificate chain
- No additional charge for imported certificates

---

## ACM Integration with AWS Services

### Supported Services

| Service | ACM Region Requirement |
|---------|----------------------|
| **Elastic Load Balancer (ALB/NLB)** | Same region as the load balancer |
| **Amazon CloudFront** | Certificate must be in **us-east-1** (N. Virginia) |
| **Amazon API Gateway** | Same region (Regional) or us-east-1 (Edge-Optimized) |
| **AWS Elastic Beanstalk** | Same region (via ALB) |
| **AWS CloudFormation** | Same region |
| **AWS App Runner** | Same region |
| **Amazon Lightsail** | Same region |

### ACM with ALB

- Attach ACM certificate to the ALB HTTPS listener
- ALB terminates SSL (SSL offloading)
- Traffic between ALB and EC2 can be HTTP (within VPC)
- Can attach multiple certificates (for multiple domains)
- Uses **SNI (Server Name Indication)** for multiple certs on one ALB

### ACM with CloudFront

- Certificate **must be in us-east-1**
- Attach to CloudFront distribution
- Supports custom domain names
- Default CloudFront domain (`*.cloudfront.net`) has its own certificate

### ACM with API Gateway

- Custom domain name requires an ACM certificate
- **Edge-Optimized**: Certificate in **us-east-1**
- **Regional**: Certificate in the **same region** as the API

### Services NOT Integrated with ACM

- **EC2**: Cannot directly attach ACM certificate to EC2 (use ALB or install manually)
- **On-premises servers**: Cannot use ACM-issued public certificates (use Private CA or import your own)
- To use certificates on EC2: Import certificate, or use ALB/NLB in front

---

## ACM Private CA / AWS Private CA

### Overview

- Create your own **private Certificate Authority (CA)** hierarchy
- Issue private certificates for internal use
- Managed service: AWS handles CA infrastructure
- Supports: X.509 certificates, certificate revocation lists (CRLs), OCSP

### CA Hierarchy

- **Root CA**: Top of the trust chain
- **Subordinate CA**: Issued by root CA, issues end-entity certificates
- Best practice: Keep root CA offline, use subordinate CAs for issuing

### Private Certificate Use Cases

- Internal service-to-service TLS (microservices)
- IoT device authentication
- VPN authentication
- Code signing (internal)
- Email encryption (S/MIME)
- Client certificate authentication

### Pricing

- Monthly charge per active CA ($400/month for general-purpose, $50/month for short-lived)
- Per-certificate charge (varies by volume)
- Relatively expensive — use only when private CA is required

### Exam Tip

- "Internal TLS certificates for microservices" → **AWS Private CA**
- "Free public SSL certificate for ALB" → **ACM public certificate**
- "Certificate for EC2 instances directly" → Cannot use ACM; use Private CA with export, or self-signed

---

## AWS Secrets Manager

AWS Secrets Manager helps you protect access to your applications, services, and IT resources without the upfront cost of managing your own infrastructure.

### Key Features

- **Secret storage**: Store credentials, API keys, tokens, connection strings
- **Automatic rotation**: Built-in rotation for RDS, Redshift, DocumentDB, and custom
- **Fine-grained access**: IAM policies and resource-based policies
- **Encryption**: Encrypted at rest using KMS
- **Cross-account access**: Share secrets across AWS accounts
- **Cross-region replication**: Replicate secrets to other regions
- **Versioning**: Track secret versions (current, previous, pending)
- **Audit**: All access logged in CloudTrail

### Secret Rotation

**Built-in rotation (native):**
- RDS (MySQL, PostgreSQL, MariaDB, Oracle, SQL Server)
- Amazon Redshift
- Amazon DocumentDB
- Secrets Manager manages the rotation process end-to-end

**Custom rotation:**
- Use a **Lambda function** for rotation logic
- Define your own rotation steps
- Supported for any secret type

**Rotation process (single-user rotation):**
1. **createSecret**: Create a new version of the secret (AWSPENDING)
2. **setSecret**: Update the database with the new credentials
3. **testSecret**: Verify the new credentials work
4. **finishSecret**: Promote the new version to AWSCURRENT

**Rotation process (alternating-user rotation):**
- Maintains two sets of credentials
- Alternates between them during rotation
- Ensures zero downtime (one set is always valid)

### Rotation Schedule

- Configure rotation interval (days): 1 to 365 days
- Schedule expression (cron or rate): `rate(30 days)`, `cron(0 0 1 * ? *)`
- Rotation starts within the window (not exact timing)
- Initial rotation happens immediately when enabled

### Secrets Manager Pricing

- $0.40 per secret per month
- $0.05 per 10,000 API calls
- No charge for secrets replicated to other regions (but API call charges apply)

### Resource-Based Policies

- Attach policies directly to secrets
- Enable cross-account access
- Restrict access by VPC endpoint, IP, or other conditions

### Cross-Region Replication

- Replicate secrets to multiple AWS regions
- Use case: Multi-region applications, disaster recovery
- Replica secrets are read-only
- Rotation occurs in the primary region and replicates

---

## Systems Manager Parameter Store

AWS Systems Manager Parameter Store provides secure, hierarchical storage for configuration data and secrets.

### Parameter Types

**Standard Parameters:**
- Maximum size: **4 KB**
- Maximum parameters per account: 10,000
- **Free** (no additional charge)
- No parameter policies
- Storage: Standard throughput (up to 40 TPS)
- Higher throughput: Available (up to 1,000 TPS, additional charges)

**Advanced Parameters:**
- Maximum size: **8 KB**
- Maximum parameters per account: 100,000
- **Charges apply**: $0.05 per advanced parameter per month
- Parameter policies supported (expiration, notification)
- Storage: Standard and higher throughput
- Required for: Parameter policies, parameters > 4 KB

### Parameter Value Types

| Type | Description | Example |
|------|-------------|---------|
| **String** | Plain text | `"production"` |
| **StringList** | Comma-separated strings | `"us-east-1,us-west-2"` |
| **SecureString** | Encrypted with KMS | Database password, API key |

### SecureString Parameters

- Encrypted at rest using KMS
- Default key: `aws/ssm` (AWS managed key)
- Can specify customer managed key
- Decrypted when retrieved (with appropriate permissions)
- IAM permissions needed: `ssm:GetParameter` + `kms:Decrypt` (for customer managed key)

### Parameter Hierarchies

- Organize parameters in a hierarchy using paths:
  - `/app/production/db-host`
  - `/app/production/db-password`
  - `/app/staging/db-host`
  - `/app/staging/db-password`
- Retrieve all parameters in a path: `GetParametersByPath`
- Maximum path depth: 15 levels
- Supports IAM policies at any level of the hierarchy

### Parameter Policies (Advanced Only)

**Expiration Policy:**
- Set an expiration date for the parameter
- EventBridge notification before expiration
- Parameter is NOT automatically deleted (just notification)

**ExpirationNotification:**
- EventBridge event sent before expiration
- Configurable notification period (days before expiration)

**NoChangeNotification:**
- EventBridge event if parameter hasn't been changed for a specified period
- Use for: Detecting stale configurations, ensuring regular rotation

### Parameter Store Integration

- **EC2**: UserData scripts, SSM Agent
- **ECS**: Task definition environment variables
- **Lambda**: Environment variable reference
- **CloudFormation**: Dynamic references (`{{resolve:ssm:param-name}}`)
- **CodeDeploy, CodeBuild, CodePipeline**: Build/deploy configuration
- **AppConfig**: Application configuration management

---

## Secrets Manager vs Parameter Store Comparison

| Feature | Secrets Manager | Parameter Store |
|---------|----------------|-----------------|
| **Purpose** | Secrets (credentials, keys) | Configuration + secrets |
| **Rotation** | Built-in automatic rotation | No built-in rotation |
| **RDS Integration** | Native rotation for RDS, Redshift, DocDB | No native integration |
| **Encryption** | Always encrypted (KMS) | Optional (SecureString) |
| **Cost** | $0.40/secret/month + API | Free (Standard), $0.05/param/month (Advanced) |
| **Max Size** | 64 KB | 4 KB (Standard), 8 KB (Advanced) |
| **Max Count** | 500,000 | 10,000 (Standard), 100,000 (Advanced) |
| **Cross-Account** | Yes (resource policy) | Yes (shared via RAM or IAM) |
| **Cross-Region** | Built-in replication | No native replication |
| **Versioning** | Automatic (AWSCURRENT, AWSPREVIOUS, AWSPENDING) | Version labels |
| **Hierarchy** | No | Yes (path-based) |
| **CloudFormation** | Dynamic reference | Dynamic reference |
| **Parameter Policies** | N/A | Expiration, notification (Advanced) |
| **API** | GetSecretValue | GetParameter, GetParametersByPath |

### When to Use Secrets Manager

- Database credentials that need automatic rotation
- RDS, Redshift, DocumentDB passwords
- Cross-region secret replication needed
- Budget allows $0.40/secret/month
- Need built-in rotation without custom Lambda

### When to Use Parameter Store

- Application configuration (non-secret)
- Cost-sensitive (Standard tier is free)
- Parameter hierarchies needed
- Simple secrets without rotation requirements
- Integration with SSM Agent on EC2
- Large number of configuration parameters

### When to Use Both Together

- Parameter Store for application config (feature flags, URLs, non-sensitive settings)
- Secrets Manager for credentials (database passwords, API keys)
- Lambda functions can reference both
- CloudFormation can resolve both dynamically

---

## Encryption in Transit

### TLS/SSL

- **TLS (Transport Layer Security)**: Current standard for encrypting data in transit
- **SSL (Secure Sockets Layer)**: Predecessor to TLS (deprecated but still referenced)
- TLS versions: 1.0, 1.1 (deprecated), 1.2 (minimum recommended), 1.3 (latest)
- Uses asymmetric encryption for key exchange, symmetric for data transfer

### TLS in AWS Services

| Service | TLS Support |
|---------|-------------|
| **S3** | HTTPS endpoints, enforce via bucket policy |
| **RDS** | SSL connections, force via parameter groups |
| **DynamoDB** | HTTPS (always encrypted in transit) |
| **ElastiCache Redis** | Encryption in transit (optional) |
| **ELB** | HTTPS listeners, TLS termination |
| **CloudFront** | HTTPS viewer, HTTPS origin |
| **API Gateway** | HTTPS (always) |
| **Lambda** | HTTPS (always) |
| **SQS** | HTTPS (default), enforce via queue policy |

### Enforcing HTTPS

**S3 Bucket Policy:**
```json
{
  "Effect": "Deny",
  "Principal": "*",
  "Action": "s3:*",
  "Resource": ["arn:aws:s3:::mybucket/*"],
  "Condition": {
    "Bool": {
      "aws:SecureTransport": "false"
    }
  }
}
```

**SQS Queue Policy:**
```json
{
  "Effect": "Deny",
  "Principal": "*",
  "Action": "sqs:*",
  "Resource": "arn:aws:sqs:...",
  "Condition": {
    "Bool": {
      "aws:SecureTransport": "false"
    }
  }
}
```

### VPN Encryption

- **Site-to-Site VPN**: IPSec encryption over the internet
- **Client VPN**: OpenVPN-based TLS encryption
- **Transit Gateway**: IPSec for VPN connections
- All VPN connections are encrypted by default

### VPC Traffic Encryption

- Traffic within a VPC is **not encrypted by default** (it's isolated but not encrypted)
- Use TLS/SSL for application-level encryption within VPC
- **VPC Traffic Mirroring**: Can inspect encrypted traffic (with appropriate keys)
- **Nitro-based instances**: Encryption between instances in same VPC is automatic on certain instance types

---

## S3 Encryption Options Comparison

| Feature | SSE-S3 | SSE-KMS | SSE-C | Client-Side |
|---------|--------|---------|-------|-------------|
| **Key Management** | AWS (S3) | AWS (KMS) | Customer | Customer |
| **Key Storage** | S3 | KMS | Customer | Customer |
| **Encryption Location** | S3 server | S3 server | S3 server | Client |
| **Header** | `AES256` | `aws:kms` | `customer-*` | N/A |
| **HTTPS Required** | No | No | **Yes** | N/A |
| **Default** | Yes (since Jan 2023) | No | No | No |
| **Cost** | Free | KMS charges | Free | Free |
| **Audit Trail** | No | CloudTrail | No | No |
| **Key Rotation** | AWS automatic | Configurable | Customer | Customer |
| **Bucket Keys** | N/A | Yes (reduces costs) | N/A | N/A |
| **Cross-Account** | N/A | Key policy | N/A | N/A |
| **Replication** | Simple | Need key access in destination | Cannot replicate | Cannot replicate |
| **Key Visibility** | No | KMS console | Full control | Full control |

### Default Encryption

- Since January 2023, S3 applies **SSE-S3 by default** to all new objects
- You can override the default to use SSE-KMS
- Bucket-level default encryption setting
- Individual object encryption can override the bucket default

### S3 Bucket Policy for Encryption Enforcement

**Require SSE-KMS:**
```json
{
  "Effect": "Deny",
  "Principal": "*",
  "Action": "s3:PutObject",
  "Resource": "arn:aws:s3:::mybucket/*",
  "Condition": {
    "StringNotEquals": {
      "s3:x-amz-server-side-encryption": "aws:kms"
    }
  }
}
```

**Require specific KMS key:**
```json
{
  "Condition": {
    "StringNotEquals": {
      "s3:x-amz-server-side-encryption-aws-kms-key-id": "arn:aws:kms:us-east-1:123456789:key/key-id"
    }
  }
}
```

---

## Common Exam Scenarios

### Scenario 1: Encrypt Data at Rest with Audit Trail

**Question**: A company needs to encrypt data in S3 with the ability to audit who accessed the encryption keys.

**Solution**: Use **SSE-KMS** (customer managed key). All key usage is logged in **CloudTrail**. Create a customer managed key for full control over key policy and rotation.

### Scenario 2: FIPS 140-2 Level 3 Compliance

**Question**: A financial institution requires FIPS 140-2 Level 3 validated encryption for their keys.

**Solution**: Use **AWS CloudHSM**. KMS provides FIPS 140-2 Level 2. CloudHSM provides Level 3. For AWS service integration, create a **KMS custom key store** backed by CloudHSM.

### Scenario 3: Cross-Region Encrypted Data Access

**Question**: An application encrypts data with KMS in us-east-1 and needs to decrypt it in eu-west-1.

**Solution**: Use **KMS multi-region keys**. Create a primary key in us-east-1 and a replica in eu-west-1. Data encrypted in one region can be decrypted in the other using the local key (no cross-region API calls).

### Scenario 4: KMS ThrottlingException

**Question**: An application making many KMS API calls is receiving ThrottlingException errors.

**Solution**:
1. Implement **data key caching** (cache DEKs locally, reuse for multiple operations)
2. Enable **S3 Bucket Keys** if S3 is the source of KMS calls
3. Request a **quota increase** via AWS Support
4. Implement **exponential backoff** in the application

### Scenario 5: Automatic Database Password Rotation

**Question**: A company needs to automatically rotate RDS database passwords every 30 days.

**Solution**: Use **AWS Secrets Manager** with automatic rotation enabled for RDS. Configure rotation schedule to 30 days. Secrets Manager handles the rotation process (creates new password, updates RDS, verifies, and promotes).

### Scenario 6: Free Configuration Management

**Question**: An application needs to store hundreds of configuration values (non-sensitive) at no cost.

**Solution**: Use **Systems Manager Parameter Store** with **Standard parameters** (free tier). Organize using hierarchies (e.g., `/app/prod/config`). Use `GetParametersByPath` to retrieve all configs for an environment.

### Scenario 7: SSL Certificate for ALB

**Question**: A web application running behind an ALB needs an SSL certificate for HTTPS.

**Solution**: Use **ACM** to provision a free public SSL certificate. Validate via DNS (add CNAME to Route 53). Attach the certificate to the ALB HTTPS listener. ACM automatically renews the certificate.

### Scenario 8: SSL Certificate for CloudFront

**Question**: A CloudFront distribution needs a custom SSL certificate for `cdn.example.com`.

**Solution**: Create an ACM certificate in **us-east-1** (required for CloudFront). Validate via DNS. Attach to the CloudFront distribution. Note: The certificate MUST be in us-east-1 regardless of the origin region.

### Scenario 9: Encrypt Existing Unencrypted EBS Volume

**Question**: An existing EC2 instance has unencrypted EBS volumes that need to be encrypted.

**Solution**:
1. Create a snapshot of the unencrypted volume
2. Copy the snapshot with encryption enabled (specify KMS key)
3. Create a new volume from the encrypted snapshot
4. Detach old volume, attach new encrypted volume
5. (Or: Stop instance, create AMI, copy AMI with encryption, launch new instance)

### Scenario 10: Internal Service-to-Service TLS

**Question**: Microservices in a VPC need TLS certificates for mutual authentication.

**Solution**: Use **AWS Private CA** to create a private certificate authority. Issue private certificates for each microservice. Configure mutual TLS between services. Certificates can be managed via ACM and deployed to ALB or directly to services.

### Scenario 11: Encrypting Lambda Environment Variables

**Question**: A Lambda function stores a database password in an environment variable and it needs to be encrypted.

**Solution**: Lambda environment variables are encrypted at rest by default with an AWS managed key. For additional security, enable **encryption helpers** (client-side encryption) with a customer managed KMS key. The function code decrypts the value at runtime using the KMS Decrypt API.

### Scenario 12: Secrets Manager vs Parameter Store Decision

**Question**: An application has database credentials, API keys, and application configuration. What should be used to store each?

**Solution**:
- **Database credentials**: **Secrets Manager** (automatic rotation for RDS)
- **API keys**: **Secrets Manager** (if rotation needed) or **Parameter Store SecureString** (if no rotation)
- **Application configuration** (non-sensitive): **Parameter Store String** (free, hierarchical)

### Scenario 13: Cross-Account S3 Encryption

**Question**: Account A has an S3 bucket encrypted with KMS. Account B needs to upload objects to this bucket.

**Solution**: The KMS key policy must allow Account B to use the key (Encrypt, GenerateDataKey). The S3 bucket policy must allow Account B to PutObject. Account B's IAM role must have permissions for both S3 and KMS operations. The KMS key must be a **customer managed key** (AWS managed keys don't support cross-account).

---

## Key Numbers to Remember

| Feature | Value |
|---------|-------|
| KMS direct encrypt max | 4 KB |
| KMS symmetric algorithm | AES-256 |
| KMS key cost | $1/month per customer managed key |
| KMS API cost | $0.03 per 10,000 requests |
| KMS automatic rotation | Configurable (90-2560 days) |
| KMS multi-region key prefix | mrk- |
| CloudHSM FIPS level | 140-2 Level 3 |
| CloudHSM cost | ~$1.50/HSM/hour |
| ACM public cert cost | Free |
| ACM cert for CloudFront region | us-east-1 |
| Secrets Manager cost | $0.40/secret/month |
| Secrets Manager max size | 64 KB |
| Parameter Store Standard max size | 4 KB |
| Parameter Store Advanced max size | 8 KB |
| Parameter Store Standard max count | 10,000 |
| Parameter Store Advanced max count | 100,000 |
| S3 default encryption | SSE-S3 (since Jan 2023) |
| S3 Bucket Keys KMS reduction | Up to 99% fewer KMS calls |
| KMS FIPS level | 140-2 Level 2 |

---

## Summary

- **KMS** = managed key service, symmetric/asymmetric, 4 KB direct encrypt, envelope encryption for larger data
- **KMS Key Types** = AWS managed, customer managed, AWS owned; material: KMS, external, CloudHSM
- **Key Policies** = Required for every key, enables cross-account access, controls admin vs user
- **Envelope Encryption** = GenerateDataKey → encrypt locally with DEK → store encrypted DEK
- **Key Rotation** = Automatic (configurable period), manual (new key + alias), imported keys (manual only)
- **Multi-Region Keys** = Same key material across regions, encrypt in one, decrypt in another
- **S3 Bucket Keys** = Reduce KMS API calls by up to 99% for SSE-KMS
- **CloudHSM** = Single-tenant HSM, FIPS 140-2 Level 3, full key control, custom key store for KMS
- **ACM** = Free public SSL/TLS certificates, auto-renewal, ALB/CloudFront/API Gateway integration
- **ACM for CloudFront** = Must be in us-east-1
- **Private CA** = Internal certificates, mutual TLS, IoT device auth
- **Secrets Manager** = Credential storage, automatic rotation for RDS, $0.40/secret/month
- **Parameter Store** = Config + secrets, hierarchical, free (Standard), no built-in rotation
- **SSE-S3** = Default S3 encryption, AWS managed, no audit trail
- **SSE-KMS** = KMS-based S3 encryption, CloudTrail audit, Bucket Keys for cost reduction
- **SSE-C** = Customer-provided keys, HTTPS required, S3 doesn't store the key

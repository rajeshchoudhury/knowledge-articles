# Service Deep Dive — Cloud Storage (GCS)

## Buckets
- Global namespace; name unique.
- Location: **region** / **dual-region** / **multi-region** (us, eu, asia).
- Storage classes: **Standard / Nearline / Coldline / Archive**.
- Min duration billing: Nearline 30d, Coldline 90d, Archive 365d (early-delete fees).
- **Autoclass** manages transitions automatically (skip for objects <128 KiB).

## Object lifecycle management
- Rules: age, createdBefore, matchesStorageClass, numNewerVersions, isLive, daysSinceCustomTime.
- Actions: SetStorageClass, Delete, AbortIncompleteMultipartUpload.

## Durability & availability
- 11 nines durability (multi-region & dual-region).
- Availability: 99.95% multi-region, 99.99% dual-region read, 99.9% regional.

## Versioning
- Enable per bucket; noncurrent versions billed as live.
- Lifecycle to expire noncurrent after N days.

## Retention
- **Retention policy** per bucket (seconds/minutes/years); **bucket lock** makes policy immutable.
- **Object retention locks** per object (plus event-based holds / temp holds).

## Access control
- **IAM** (project/bucket/object).
- **UBLA** (uniform bucket-level access) — disables ACLs.
- **Public access prevention** org policy.
- **Signed URLs** (V4 recommended).
- **Signed policy documents** for direct browser uploads.
- **POSIX-like ACLs** (legacy; avoid).

## Security
- Default encryption (Google-managed) + **CMEK** + **CSEK** (per-request AES-256).
- VPC-SC perimeter support.
- Object-level lock for tamper-proof logs.

## Performance
- Parallel composite uploads for large files.
- Avoid sequential prefixes that hot-spot.
- Use `gsutil`/`gcloud storage` with multi-thread (`-m`).
- Caching: integrate with Cloud CDN, media CDN.

## Notifications
- Pub/Sub notifications on object finalize / delete / archive / metadataUpdate.
- Eventarc triggers build on these.

## Data transfer
- Storage Transfer Service, Transfer Appliance.
- `gcloud storage` CLI (formerly `gsutil`).

## Pricing (typical)
- Storage / GB / month by class.
- Operation costs (class A/B; A includes writes).
- Egress to internet / cross-region.
- Early delete fees for Nearline/Coldline/Archive.

## Exam cues
- Lifecycle to move cold data → Nearline / Coldline / Archive.
- Bucket lock for WORM compliance.
- Signed URLs for time-limited access.
- Turbo replication for dual-region RPO 15 min.
- UBLA + PAP at org level for governance.

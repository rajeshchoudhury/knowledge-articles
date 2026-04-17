# Service Deep Dive — Cloud Run and Cloud Functions

## Cloud Run (services)
- Container-based; scales 0→N.
- Concurrency 1–1000 (default 80).
- Max timeout 60 min.
- CPU allocated during requests by default; **always allocated** option.
- Ingress: `all`, `internal`, `internal-and-cloud-load-balancing`.
- **Min / max instances** per service.
- **CPU boost** for faster cold start.
- **Execution environments**: Gen1 (legacy) / Gen2 (full Linux compat, preferred).
- **VPC access**: Serverless VPC Connector (legacy) or **Direct VPC Egress**.
- **Traffic split / tags / revisions** for canary.
- **Cloud Run Jobs** for batch-style runs.
- **Cloud Run Functions** (new name of 2nd-gen Functions on Cloud Run).

## Cloud Functions (2nd gen)
- Built on Cloud Run + Eventarc.
- Triggers: HTTP, Pub/Sub, Eventarc (GCS, Audit logs, Firestore, BQ, etc.).
- Runtimes: Node, Python, Go, Java, Ruby, PHP, .NET.
- Memory up to 16 GB; timeout up to 60 min.

## Network & security
- Private ingress via LB serverless NEG.
- IAM on service: `roles/run.invoker`.
- OIDC for Pub/Sub push.
- Secrets via `--set-secrets`.
- CMEK on image pulls.
- Binary Authorization supported.

## Pricing
- Pay for CPU + memory × time when serving (or always if "CPU always allocated").
- Request count charge.
- Free tier monthly.

## Limits (typical)
- 32 GB image size; 8 GB RAM/4 vCPU (16 on Gen2); in-memory `/tmp`.
- 32 concurrent revisions traffic.

## Exam cues
- Default choice for stateless HTTP/gRPC; scale to zero.
- Use `internal-and-cloud-load-balancing` to front with Armor/CDN.
- Concurrency tuning saves cost — increase for I/O-bound, reduce for CPU-bound.
- Cloud Run Jobs for long-running batch.

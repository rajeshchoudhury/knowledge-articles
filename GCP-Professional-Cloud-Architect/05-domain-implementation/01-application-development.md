# 5.1 Application Development on GCP

How to advise developers so that apps fit GCP idiomatically — with low latency, observability, correct identity, and clean failure handling.

---

## 1. Twelve-factor on GCP

| 12-factor principle | GCP realization |
| --- | --- |
| Codebase | Cloud Source Repos / GitHub / GitLab |
| Dependencies | Artifact Registry (images, Maven, Yarn, NPM, PyPI) |
| Config | Environment variables, Secret Manager, Cloud Build substitutions |
| Backing services | Pub/Sub, Cloud SQL, Memorystore, etc., via connection strings |
| Build/Release/Run | Cloud Build + Artifact Registry + Cloud Deploy |
| Processes | Stateless Cloud Run or GKE Deployments |
| Port binding | Cloud Run (listen on `$PORT`) |
| Concurrency | Horizontal scaling (MIG, HPA, Cloud Run) |
| Disposability | Fast startup + graceful shutdown (SIGTERM handling) |
| Dev/prod parity | Same container runs locally and in prod |
| Logs | stdout/stderr → Cloud Logging |
| Admin processes | Cloud Run Jobs / Cloud Functions |

---

## 2. Container guidance

- Use **distroless** base images for smaller attack surface.
- Multi-arch images: `linux/amd64`, `linux/arm64` (Tau T2A support).
- Pin base image digests (`@sha256:...`).
- Use **BuildKit** with caching; Cloud Build caching via `--cache`.
- Health checks: liveness + readiness.
- Graceful shutdown: handle SIGTERM; finish in-flight requests; close DB connections.
- Keep **stateless**; persist to managed services.

---

## 3. Configuration and secrets

- Env vars for non-secret config.
- **Secret Manager** for secrets; mount via `--set-secrets` on Cloud Run or volumeMount on GKE (CSI secret driver).
- Use **Workload Identity** to access Secret Manager without keys.
- Avoid embedding credentials in images.

---

## 4. Connectivity to data stores

- **Cloud SQL** connector / Auth Proxy for IAM DB auth.
- **AlloyDB** connector.
- **Spanner client libraries** with session pool tuning.
- **Firestore** SDKs with offline support.
- **Memorystore** via private IP; use pooling.

---

## 5. Idempotency & reliability in code

- Retries with exponential backoff + jitter.
- Deduplicate messages (use Pub/Sub message IDs + cache or DB unique constraint).
- Circuit breakers (resilience4j, Polly).
- Timeouts everywhere; avoid unbounded waits.
- Structured logging with request IDs.
- OpenTelemetry SDKs for trace / metrics / logs.

---

## 6. Handling async & events

- Pub/Sub for decoupling; enable ordering only if necessary (hot partition risk).
- Eventarc filters for GCS / Cloud Audit events.
- Workflows for declarative orchestration.

---

## 7. Frontend concerns

- **Firebase Hosting** for static SPA + CDN + SSL.
- **Cloud CDN** for arbitrary assets via LB.
- Identity: Firebase Auth / Identity Platform.
- Firestore offline sync for mobile.

---

## 8. APIs

- REST: OpenAPI + ESPv2 / API Gateway / Apigee.
- gRPC: Cloud Run supports HTTP/2 end-to-end; Cloud Endpoints ESPv2; Apigee X.
- Versioning: URL path `/v1/…` or headers; semver.
- Rate limits at Apigee / Cloud Armor / application.

---

## 9. Observability in app code

- **OpenTelemetry** SDKs (auto-instrumentation for Java, Python, Go, Node).
- Emit traces to Cloud Trace; metrics to Cloud Monitoring.
- **Structured logs** (JSON with `severity`, `traceId`, `spanId`, `labels`).
- Use `cloud.google.com/api` metadata server for project / zone discovery.

---

## 10. Local dev parity

- **Skaffold** + **Cloud Code** for dev loop against GKE.
- **Emulators** for Firestore, Spanner, Pub/Sub, Bigtable.
- **Functions Framework** for local Cloud Functions testing.
- **Cloud Workstations** for standardized dev envs.

---

## 11. Example: Cloud Run Python service with secret + Cloud SQL

```python
from flask import Flask
import os, pg8000, google.auth
from google.cloud.sql.connector import Connector

app = Flask(__name__)
conn = None

def get_conn():
    global conn
    if conn is None:
        connector = Connector()
        conn = connector.connect(
            os.environ["CLOUD_SQL_CONN"],
            "pg8000",
            user="app",
            password=os.environ["DB_PASS"],  # from Secret Manager
            db="app",
        )
    return conn

@app.route("/")
def index():
    c = get_conn()
    cur = c.cursor()
    cur.execute("SELECT NOW()")
    return {"time": cur.fetchone()[0].isoformat()}

if __name__ == "__main__":
    app.run("0.0.0.0", int(os.environ.get("PORT", "8080")))
```

Deploy:

```bash
gcloud run deploy app --source=. --region=us-central1 \
  --set-secrets=DB_PASS=db-pass:latest \
  --set-env-vars=CLOUD_SQL_CONN=proj:region:inst \
  --service-account=app-sa@proj.iam.gserviceaccount.com \
  --add-cloudsql-instances=proj:region:inst
```

---

## 12. Developer-experience exam patterns

| Scenario | Answer |
| --- | --- |
| "Standardize dev environments" | Cloud Workstations |
| "Avoid duplicate events in workers" | Idempotent handlers + Pub/Sub exactly-once |
| "Secrets not in env" | Secret Manager + Workload Identity |
| "Trace a slow API" | OpenTelemetry → Cloud Trace |
| "Avoid connection storm to Cloud SQL" | Connector + connection pooling |
| "Deploy per-PR preview" | Cloud Run preview with unique tag per PR or GKE namespace |

Next: `02-apis-integration.md`.

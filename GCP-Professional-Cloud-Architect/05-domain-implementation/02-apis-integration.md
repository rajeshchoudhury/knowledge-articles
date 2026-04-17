# 5.2 APIs, Integration, and Messaging

API management and integration are core to enterprise GCP architectures. This chapter covers Apigee, API Gateway, Cloud Endpoints, Pub/Sub, Eventarc, and Workflows.

---

## 1. API gateway options

| Product | Description | Best for |
| --- | --- | --- |
| **Apigee** | Full API lifecycle platform (policies, quotas, monetization, developer portal) | B2B partner APIs, public API products |
| **API Gateway** | Managed, simple API gateway based on Envoy / ESPv2 | Internal / simple external APIs |
| **Cloud Endpoints (ESPv2)** | Lightweight, deploy side-car with OpenAPI; Google Auth & API keys | gRPC/REST for GKE |
| **Anthos Service Mesh** | L7 mesh with Envoy sidecars | service-to-service mTLS + policies |

### When to pick Apigee

- Expose APIs to external partners/customers.
- Need quotas, rate limits, spike arrest, OAuth/JWT validation, mediation (SOAP↔REST), monetization.
- Developer portal with API docs.

### When to pick API Gateway

- Simple public/internal API for Cloud Run/Functions/GKE.
- OpenAPI-based.
- Light policy needs (API keys, JWT).

### When to pick Endpoints

- gRPC transcoding, simpler, runs as sidecar.
- Within a GKE cluster.

---

## 2. Apigee basics

- **Environments** (dev/test/prod) and **organizations**.
- **API proxies** with policies:
  - **OAuth v2 / JWT validation / SAML**.
  - **Spike arrest / quota / concurrent rate limit**.
  - **Threat protection** (XML/JSON), **CORS**.
  - **Mediation**: XSLT, JSON↔XML, field masking.
  - **Caching** (response cache policy).
  - **Traffic management**: routing by header.
- **Analytics** (request metrics, latency, error).
- **Developer portal** (Apigee-integrated or custom Drupal/Jekyll).
- **Apigee X**: VPC-peered, private; supports Cloud Armor in front.

---

## 3. Pub/Sub deep dive

Already covered in 2.4 — key implementation patterns:

- **Push** subscriptions POST to Cloud Run / App Engine / HTTPS.
  - Use OIDC token (`oidcToken`) for secure push to Cloud Run.
  - Back-pressure: Pub/Sub throttles based on ACK success.
- **Pull** subscriptions via streaming client libs (preferred for latency).
- **Ordering keys**: same key → same subscriber, order preserved.
- **Message attributes** for filtering; reduce downstream work.
- **Dead-letter topic** after N max delivery attempts; monitor DLQ.
- **Exactly-once** delivery: enable on subscription; use `ack_id` + DB unique constraints.

### Pub/Sub Lite

- Zonal, lower cost, reserved throughput; no ordering keys, no filtering, no push.
- Choose when throughput predictable and cost critical; Kafka-like semantics.

---

## 4. Eventarc

- Event router from GCP sources (Audit Logs, Pub/Sub, Cloud Storage, Firestore, BigQuery, Cloud Functions) to destinations (Cloud Run, GKE, Workflows).
- CloudEvents format; single delivery target per trigger.
- Filters via Audit log service name / method / resource labels.

### Example trigger

```bash
gcloud eventarc triggers create gcs-new-file \
  --destination-run-service=processor \
  --destination-run-region=us-central1 \
  --event-filters="type=google.cloud.storage.object.v1.finalized" \
  --event-filters="bucket=acme-ingest" \
  --service-account=trigger-sa@proj.iam.gserviceaccount.com \
  --location=us-central1
```

---

## 5. Workflows

- Declarative orchestration language (YAML/JSON).
- Steps: HTTP calls, variable assignments, parallel steps, retries, switch.
- Serverless; per-step pricing.
- Good for "saga"-style orchestrations across services.

```yaml
main:
  params: [input]
  steps:
    - load:
        call: http.get
        args: { url: "https://api.example.com/records" }
        result: records
    - process:
        parallel:
          for:
            value: r
            in: ${records.body}
            steps:
              - upload:
                  call: googleapis.storage.v1.objects.insert
                  args: { bucket: acme, body: ${r} }
    - done: { return: "ok" }
```

---

## 6. Cloud Scheduler

- Managed cron; HTTPS / Pub/Sub / App Engine targets.
- Combine with Workflows / Functions / Run for scheduled jobs.

---

## 7. Cloud Tasks

- Durable, asynchronous task queue (HTTP targets).
- Rate limiting per queue, retries, deduplication.
- Use when you need high-volume background tasks with precise pacing (e.g., sending emails).

---

## 8. Integration connectors (Application Integration / IP)

- **Application Integration**: visual, iPaaS-like, ~300+ connectors (Salesforce, SAP, ServiceNow).
- **Integration Connectors**: managed connectors used by Apigee and Application Integration.
- Alternatives: **Informatica**, **MuleSoft** on GCE / Private Marketplace.

---

## 9. Healthcare & retail verticals

- **Cloud Healthcare API**: FHIR, HL7v2, DICOM storage and ops.
- **Retail API**: search, recommendations, events.
- These are vertical APIs you recommend for domain use cases.

---

## 10. API design best practices

- Resource-oriented REST with nouns; consistent plural.
- Pagination, versioning, idempotency keys for POST.
- Errors with machine-readable codes.
- OpenAPI spec as source of truth; generate SDKs.
- Auth: OAuth 2.0 + OIDC (Google Sign-In / Identity Platform).
- Use **mTLS** for B2B with Apigee.

---

## 11. Integration exam patterns

| Scenario | Answer |
| --- | --- |
| "Expose APIs to partners with monetization" | Apigee |
| "Simple OpenAPI on Cloud Run" | API Gateway |
| "Saga across 5 services" | Workflows (or Eventarc + orchestrator) |
| "Event on GCS object create → processor" | Eventarc trigger → Cloud Run |
| "Need high-cardinality fan-out decoupling" | Pub/Sub |
| "Cron job daily" | Cloud Scheduler + Workflows / Cloud Run Job |
| "Integration with SaaS with minimal code" | Application Integration |

Next: `03-migration-execution.md`.

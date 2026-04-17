# 2.4 Configuring Data Solutions

Provisioning and tuning Google Cloud's data ecosystem for analytics, streaming, and ML-ready architectures.

---

## 1. Data taxonomy on GCP

| Layer | Services |
| --- | --- |
| Ingest | Pub/Sub, Datastream, Storage Transfer Service, Dataflow, Transfer Appliance |
| Store | GCS (lake), BigQuery (warehouse/lakehouse), Bigtable, Spanner, Cloud SQL, Firestore |
| Process | Dataflow (Beam), Dataproc (Spark/Hadoop), BigQuery (SQL / BigQuery ML), Dataform, Cloud Functions, Cloud Run Jobs |
| Orchestrate | Cloud Composer (Airflow), Workflows, Eventarc, Cloud Scheduler |
| Govern | Dataplex, Data Catalog (now under Dataplex), DLP, Policy Tags |
| Analyze/ML | BigQuery BI Engine, BigQuery ML, Vertex AI, Looker, Looker Studio |

---

## 2. Pub/Sub configuration

- **Topics** receive; **subscriptions** deliver.
- Two delivery modes:
  - **Pull**: client initiates `pull` / `streamingPull`.
  - **Push**: Pub/Sub HTTPS POST to endpoint (Cloud Run, App Engine, any URL).
- **Filter**: per-subscription attribute filters to reduce work.
- **Ordering**: enable ordering key; single-subscriber per key for strict order.
- **Dead-letter topic**: redirect undeliverable messages after N attempts.
- **Snapshots + Seek**: replay up to 7 days backwards.
- **Exactly-once delivery** subscription option (at-least once by default).
- **Pub/Sub Lite**: zonal, cheaper, reserved capacity; for data-plane, not critical transactional.
- **Schema**: Avro / Protobuf validation.

### Creation example

```bash
gcloud pubsub topics create orders
gcloud pubsub subscriptions create orders-sub \
  --topic=orders --ack-deadline=60 --enable-exactly-once-delivery \
  --message-retention-duration=7d --dead-letter-topic=orders-dlq \
  --max-delivery-attempts=5 --filter='attributes.env="prod"'
```

---

## 3. Dataflow configuration

- Managed Apache Beam runner.
- **Streaming Engine** separates compute from worker VMs (cost-effective at scale).
- **Flexible Resource Scheduling (FlexRS)** for batch: spot + delayed start.
- **Shuffle Service** for batch: offload intermediate data.
- **Templates**: Classic + Flex; parameterized pipelines.
- **Autoscaling**: throughput-based (streaming) or worker-based (batch).
- **Dataflow Prime**: enhanced autoscaling, vertical resource management.
- **Inference** with Dataflow for ML pipelines (RunInference transform).

### Streaming template example

```bash
gcloud dataflow flex-template run pubsub-to-bq \
  --template-file-gcs-location=gs://dataflow-templates-us/latest/flex/Cloud_PubSub_to_BigQuery_Flex \
  --region=us-central1 \
  --parameters inputSubscription=projects/p/subscriptions/orders-sub,\
outputTableSpec=p:ds.orders,\
network=vpc-a,subnetwork=regions/us-central1/subnetworks/dataflow
```

Network: provision **Dataflow workers in a Shared VPC** with Private Google Access; egress via Cloud NAT as needed.

---

## 4. Dataproc & Dataproc Serverless

### Dataproc (ephemeral clusters recommended)

- Spin up a cluster per job; store data in GCS/BQ/Bigtable; tear down.
- **Autoscaling policies** for secondary workers (preemptible).
- **Component Gateway** for Jupyter / Zeppelin / HDFS UI.
- Custom image builder for dependency baking.

### Dataproc Serverless

- Submit Spark batch without managing a cluster.
- Auto-scales.
- Same security posture as Dataflow (VPC, CMEK).

```bash
gcloud dataproc batches submit spark \
  --region=us-central1 \
  --jar=gs://jars/my.jar \
  --class=com.acme.Main \
  --subnet=dataproc-subnet --service-account=dp-sa@proj.iam.gsa
```

---

## 5. BigQuery organization

### Datasets

- Regional / multi-regional choice at dataset creation.
- Access control at dataset (legacy), table, column, row.
- **Authorized views / datasets** expose subsets.
- **Policy tags** from Data Catalog for column-level policies.

### Tables

- **Partition** by `_PARTITIONTIME`, DATE, TIMESTAMP, or integer range.
- **Cluster** by up to 4 columns (order matters).
- **Require partition filter** flag blocks full-table scans.
- **Time-travel** 2–7 days.
- **Snapshots / clones**: immutable / writable copies.
- **Materialized views** incrementally refresh.

### Slot management

- On-demand default.
- **Editions** (Standard, Enterprise, Enterprise+) with **reservations** and **assignments** (PROJECT, FOLDER, ORG).
- **Autoscaling** in Enterprise adds/removes slots as needed.
- Use **commitments** (annual) for steady-state with extra autoscaling on top.

---

## 6. Cloud Composer / Workflows

### Composer

- Managed Apache Airflow.
- V2 on GKE Autopilot (private). CMEK supported.
- Write DAGs in Python; deploy via GCS / CI.

### Workflows

- Declarative YAML/JSON; orchestrates service calls, retries, parallelism.
- Lightweight, serverless; low cost per execution.
- Good for orchestrating Cloud Run + BigQuery + GCS without a full Airflow deployment.

Choose Workflows for short, stateless orchestrations (<hundreds of steps). Choose Composer for complex DAGs, SLA scheduling, operators ecosystem.

---

## 7. Dataplex and governance

- Dataplex organizes data **lakes** (domains) → **zones** (raw / curated) → **assets** (GCS buckets, BQ datasets).
- Auto-discovery and metadata.
- **Data quality** rules via Dataplex; integrates with BigQuery and Data Catalog.
- **Data lineage** (Dataplex Lineage) and **IAM with policy tags**.

---

## 8. Real-time analytics reference pipeline

```
Mobile / IoT → Pub/Sub (topic: events)
            → Dataflow (streaming, windowed: 1m/5m/60m)
               ├── BigQuery (streaming insert / Storage Write API)
               ├── Bigtable (hot lookup)
               └── GCS (hourly rollups, avro/parquet for historical)
BigQuery → Looker / BI Engine (dashboards)
Alerts: Monitoring on custom metrics from Dataflow
```

For exactly-once ingest into BigQuery use **Storage Write API** (default in newer Beam).

---

## 9. Cloud SQL / Spanner / AlloyDB data provisioning

### Cloud SQL HA + cross-region replica

```bash
gcloud sql instances create orders-db \
  --database-version=POSTGRES_15 --tier=db-custom-4-16384 \
  --region=us-central1 --availability-type=REGIONAL \
  --enable-bin-log --backup-start-time=02:00 \
  --network=projects/host/global/networks/shared-vpc \
  --no-assign-ip --require-ssl

gcloud sql instances create orders-db-eu \
  --master-instance-name=orders-db \
  --database-version=POSTGRES_15 --tier=db-custom-4-16384 \
  --region=europe-west1 --replication=ASYNCHRONOUS
```

### Spanner multi-region

```bash
gcloud spanner instances create orders-spanner \
  --config=nam-eur-asia1 \
  --nodes=3 --description="Global orders"
```

### AlloyDB cluster

```bash
gcloud alloydb clusters create orders --region=us-central1 \
  --password=$(gcloud secrets versions access latest --secret=alloydb-pw) \
  --network=projects/host/global/networks/shared-vpc
gcloud alloydb instances create primary --cluster=orders --instance-type=PRIMARY \
  --cpu-count=8 --region=us-central1
```

---

## 10. Data security checklist

- **CMEK** on all stored data when compliance mandates customer keys.
- **DLP** scans raw ingestion zone; redacts PII before curated zone.
- **VPC Service Controls** perimeter around BQ, GCS, Spanner, Bigtable, Pub/Sub.
- **Private Service Connect** for Cloud SQL/Spanner connections.
- **Audit logging** — enable Data Access logs on BQ / GCS for high-sensitivity data.
- **Access Transparency** + **Access Approval** for Google support access.

---

## 11. Common data configuration exam patterns

| Scenario | Correct pattern |
| --- | --- |
| "Need exactly-once streaming into BQ" | Dataflow + Storage Write API or exactly-once subscription |
| "Replay last 7 days" | Pub/Sub snapshots + seek |
| "Global analytics, low-latency dashboards" | BQ multi-region + BI Engine + Looker |
| "Batch nightly ETL, cheap compute" | Dataproc Serverless or Dataflow FlexRS with spot |
| "Oracle to BQ near-real-time" | Datastream → BQ or Dataflow |
| "Orchestrate 50-step DAG with retries and SLAs" | Composer |
| "Simple 5-step orchestration" | Workflows |

Next: `05-deployment-automation.md`.

# Service Deep Dive — Dataflow, Dataproc, Composer

## Dataflow
- Managed **Apache Beam** runner; batch + streaming.
- **Autoscaling** (throughput-based streaming, worker-based batch).
- **Streaming Engine** — separates compute from worker VMs; state service-side.
- **Shuffle Service** for batch (offloads shuffle).
- **FlexRS** for batch with spot + delayed start.
- **Dataflow Prime** (enhanced autoscaling, vertical scaling).
- **Templates**: Classic + Flex; Google-provided templates (PubSub→BQ, GCS→BQ, etc.).
- **Pipeline IO**: Pub/Sub, BigQuery, GCS, Bigtable, Spanner, JDBC.
- **State & timers** for complex streaming logic.
- **Dataflow SQL** — SQL authoring of pipelines (limited).
- **RunInference** transform for ML predictions.

Security: workers in Shared VPC + PSA + CMEK + Service Account impersonation.

## Dataproc
- Managed Hadoop / Spark / Flink / Presto.
- **Cluster modes**: standard / single-node / high-availability.
- **Ephemeral** (preferred): spin up per job; storage in GCS.
- **Autoscaling policies** (secondary workers = preemptible).
- **Component Gateway** for Jupyter / Zeppelin / HDFS UI.
- **Initialization actions** (scripts on cluster create).
- **Dataproc Metastore** (managed Hive metastore).
- **Dataproc Serverless** — submit Spark batch without cluster; autoscaled.
- Supports Workflow Templates, Jobs API.

### Exam tips
- Ephemeral > long-lived.
- Use GCS instead of HDFS as DFS.
- Use Dataproc Serverless for simple Spark jobs.

## Cloud Composer
- Managed Apache Airflow.
- V2 on GKE Autopilot; private by default; CMEK.
- Write DAGs in Python; deploy to GCS `dags/`.
- Operators for BQ, Dataflow, Dataproc, GCS, HTTP, Kubernetes.
- Use for complex DAGs with SLAs and operator ecosystem.

## Workflows
- Serverless orchestration via YAML/JSON.
- HTTP calls, parallel steps, retries.
- Cheaper, simpler than Composer for <100 step orchestrations.

## Datastream
- Managed CDC from MySQL/PG/Oracle/SQL Server → BQ/GCS/Spanner.
- Near-real-time analytics; simple UI.

## Dataflow vs Dataproc decision
| Need | Pick |
| --- | --- |
| New pipeline, batch or stream | Dataflow |
| Existing Spark / Hadoop | Dataproc |
| Simple Spark one-shot | Dataproc Serverless |
| Real-time CDC to BQ | Datastream (optionally) + Dataflow |

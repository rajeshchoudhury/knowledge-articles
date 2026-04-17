# Data Lake on AWS

```mermaid
graph LR
  subgraph Sources["Sources"]
    RDS[(Relational DBs)]
    SaaS[(SaaS apps)]
    Files[(On-prem files)]
    IoT[(IoT devices)]
  end

  subgraph Ingest["Ingest"]
    DMS["DMS"]
    AppFlow["AppFlow"]
    DataSync["DataSync"]
    Kinesis["Kinesis (Streams + Firehose)"]
  end

  subgraph Lake["Data Lake on S3"]
    Raw[(Raw zone)]
    Clean[(Curated zone)]
    Marts[(Marts zone)]
  end

  subgraph Catalog["Governance"]
    Glue["Glue Data Catalog"]
    LF["Lake Formation (permissions)"]
  end

  subgraph Process["Transform"]
    GlueETL["Glue Jobs / DataBrew"]
    EMR["EMR / EMR Serverless"]
    Redshift["Redshift Spectrum"]
  end

  subgraph Consume["Consume"]
    Athena["Athena"]
    RedshiftCluster["Redshift (cluster/serverless)"]
    QS["QuickSight + Q"]
    SM["SageMaker"]
    Bedrock["Bedrock + Knowledge Base"]
  end

  Sources --> Ingest --> Raw
  Raw --> GlueETL --> Clean --> EMR --> Marts
  Marts --> Athena
  Marts --> RedshiftCluster
  Marts --> QS
  Marts --> SM
  Catalog -. governs .-> Lake
```

**Pattern highlights**
- S3 is the storage foundation; partition data by `year/month/day` and
  use Parquet/ORC columnar formats for speed + cost.
- Use **Glue Catalog** as the metadata store; **Lake Formation** for
  fine-grained access.
- Query patterns: Athena (ad hoc), Redshift (warehouse), QuickSight
  (BI), SageMaker (ML).
- Generative AI: **Bedrock Knowledge Bases** + OpenSearch / Aurora for
  RAG.

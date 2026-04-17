# SageMaker ML Pipeline

```mermaid
graph LR
  Raw[(S3 raw)] --> Processing["SageMaker Processing"]
  Processing --> Features[(Feature Store)]
  Features --> Train["SageMaker Training<br/>(Spot-capable)"]
  Train --> Registry["Model Registry"]
  Registry --> Approval{"Manual / policy approval"}
  Approval --> Deploy["Endpoint<br/>(real-time / serverless / async / batch)"]
  Deploy --> Monitor["Model Monitor + Clarify"]
  Monitor -. drift .-> Train
  Pipelines["SageMaker Pipelines (ML CI/CD)"] -. orchestrates .-> Processing & Train & Deploy
```

**Highlights**
- Training with **Managed Spot** saves up to 90%.
- **Model Registry** governs which model version is deployed.
- **Model Monitor + Clarify** detect drift and bias in production.
- **Pipelines** provide ML-specific CI/CD.

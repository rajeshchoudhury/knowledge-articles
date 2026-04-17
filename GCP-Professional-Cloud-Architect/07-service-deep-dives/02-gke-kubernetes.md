# Service Deep Dive — Google Kubernetes Engine (GKE)

## Modes
- **Autopilot**: Google manages nodes & security; pay per pod.
- **Standard**: you manage node pools.

## Cluster types
- **Zonal** (control plane in one zone; cheap; 99.5% SLA).
- **Regional** (control plane across 3 zones; 99.95% SLA; multi-zone node pools by default).
- **Private** (nodes no external IP; control plane private/endpoint-only).

## Networking
- **VPC-native** (alias IPs) required for modern features; pods & services ranges from secondary IP ranges.
- **Network policy** (Calico / Dataplane V2) for pod-level firewalling.
- **Gateway API** (modern ingress).
- **GKE Ingress** → Global External HTTPS LB (container-native load balancing via NEGs).
- **Multi-Cluster Ingress / Gateway** for global services across clusters.
- **Private Google Access** on node subnets.

## Identity
- **Workload Identity**: `<ksa>@<proj>.svc.id.goog` → GSA; no JSON keys.
- **Workload Identity Federation** for external identities (to access GKE from outside).

## Node pools
- Multiple node pools per cluster (different machine types, taints).
- Cluster autoscaler per pool.
- Node auto-provisioning creates new pools as pods demand.
- Spot node pools with taints/tolerations.

## Autoscalers
- HPA (pod replicas on CPU / memory / custom metric).
- VPA (resource request recommendations).
- Cluster autoscaler (add/remove nodes in pool).
- Node auto-provisioning (add pools with new shapes).

## Security
- **Binary Authorization** for signed images.
- **Shielded GKE Nodes** (default in Autopilot).
- **Sandbox** nodes with **gVisor**.
- **Pod security policies** replaced by **Pod Security Standards**.
- **Network policies** for east-west.
- **Confidential GKE Nodes**.

## Observability
- Logs & metrics auto-shipped to Cloud Monitoring/Logging.
- **Managed Service for Prometheus** (GMP) for custom metrics.
- Service-level SLOs via Anthos Service Mesh or Cloud Service Monitoring.

## Storage
- PDs via PVC (ReadWriteOnce).
- **Filestore CSI** for ReadWriteMany.
- **GCS Fuse** for object-based read-heavy.
- **Hyperdisk** CSI.

## Upgrades / release channels
- Channels: **Rapid / Regular / Stable / Extended**.
- Surge upgrades, Blue-Green for node pools.
- Maintenance windows, exclusions.

## Anthos features
- Fleet management, **Config Sync** (GitOps), **Policy Controller** (OPA), **Anthos Service Mesh** (Istio), **Connect** gateway.

## Exam cues
- Regional cluster + multi-zone pool = HA.
- Use Autopilot unless you need node-level control.
- Use Workload Identity, not JSON keys.
- Gateway API / Multi-Cluster Gateway for global service.

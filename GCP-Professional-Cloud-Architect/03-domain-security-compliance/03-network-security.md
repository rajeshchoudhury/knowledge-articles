# 3.3 Network Security

Network-layer defenses, perimeter controls, and DDoS / WAF / IDS options on GCP.

---

## 1. The layered network security model

```
Edge: Cloud CDN + Cloud Armor (DDoS, WAF, bot mgmt) + reCAPTCHA Enterprise
LB: IAP for HTTPS / TCP; SSL policies; managed certs
VPC: firewall rules (hierarchical + VPC) + service accounts targeting
Inside: VPC Service Controls; Private Service Connect; Private Google Access
East-West: Cloud IDS; Packet Mirroring; service mesh mTLS (Anthos Service Mesh)
Admin: Org policies; IAM + Conditions; Access Context Manager
```

---

## 2. Cloud Armor

- **WAF** with **preconfigured OWASP Top 10** rules (XSS, SQLi, LFI, RFI, Scanners, etc.).
- **Rate limiting** and **adaptive protection** (ML-driven for DDoS L7).
- **Bot management** (reCAPTCHA Enterprise integration).
- **Geo / IP / country** filters; custom CEL expressions.
- **Edge security policies** for CDN (for Cloud CDN cache bypass).
- **Managed Protection Plus** — advanced DDoS guarantees + support; required for SLA.

### Policy example

```bash
gcloud compute security-policies create safe-policy --description "WAF"
gcloud compute security-policies rules create 1000 \
  --security-policy=safe-policy \
  --src-ip-ranges=203.0.113.0/24 --action=deny-403

gcloud compute security-policies rules create 2000 \
  --security-policy=safe-policy \
  --expression='evaluatePreconfiguredExpr("xss-v33-stable")' \
  --action=deny-403
```

Attach to backend service:

```bash
gcloud compute backend-services update app-bs \
  --global --security-policy=safe-policy
```

---

## 3. VPC Service Controls (VPC-SC)

- Creates a **service perimeter** around sensitive APIs (BQ, GCS, Spanner, Pub/Sub, AI APIs).
- Prevents **data exfiltration** even by authorized principals.
- **Access levels** for ingress (trusted IP, device, identity).
- **Ingress / egress policies** for legitimate cross-perimeter flows.
- **Dry-run mode** to observe without enforcing.
- **Perimeter bridges** (legacy; use ingress rules today).

### When to use

- Regulated workloads where a leaked key must not result in bulk data exfiltration.
- Multi-tenant environments where projects share IAM roles.

### Watch-outs

- Services must be **supported** (list grows; check docs).
- Break private connectivity if ingress/egress not configured.
- Always dry-run first; monitor denied flows.

---

## 4. Private connectivity to Google services

- **Private Google Access** (per-subnet): reach Google APIs using external Google-owned IPs via internal routes.
- **Private Google Access for on-prem hosts**: use `private.googleapis.com` (default) or `restricted.googleapis.com` (works with VPC-SC). Resolve via DNS; route via Interconnect/VPN.
- **Private Service Connect** for Google APIs: allocate IP in VPC; `*.googleapis.com` resolves to your PSC endpoint (works with VPC-SC + custom FQDN).
- **Private Service Connect** for published services (Cloud SQL, Spanner, Memorystore, partner services like Snowflake).

### Restricted Google APIs

- `restricted.googleapis.com` (199.36.153.4/30) — only VPC-SC-protected APIs.
- `private.googleapis.com` (199.36.153.8/30) — all Google APIs, VPC-SC not required.

---

## 5. Firewall rules best practices

- Use **hierarchical firewall policies** at org / folder for baseline (deny egress by default in tier-1 folders; allow ingress from IAP ranges 35.235.240.0/20 for admins).
- Use **network firewall policies** (region or global) for shared rules; VPC-level rules override locally.
- **Service accounts > tags** for identity.
- Required infrastructure allows:
  - **Health checks**: 35.191.0.0/16 + 130.211.0.0/22 → backends, port 80/443.
  - **IAP TCP forwarding**: 35.235.240.0/20.
  - **Google APIs (restricted)**: 199.36.153.4/30.
- Log all deny rules that might indicate attack surface.

---

## 6. Cloud IDS

- Managed Palo Alto Networks-based IDS.
- Uses **Packet Mirroring** to a collector; finds threats (CVEs, malware, C2).
- Output findings to Security Command Center.
- Deploy per region; attach mirroring policies.

---

## 7. Anthos Service Mesh (ASM) and mTLS

- Upstream Istio with Google operator.
- **Auto mTLS** between services; Mesh CA issues short-lived certs.
- Authorization policies per workload identity (SPIFFE ID).
- **Managed control plane (MCP)** option.
- Telemetry: automatic service graph, SLOs, metrics to Cloud Monitoring.

---

## 8. DNS security

- **DNSSEC** on public zones (signed).
- **Private zones** for internal names.
- **DNS policies**: allow/disallow DNS rebinding; alternative name servers.
- Forward logs to SIEM to detect DNS exfiltration.

---

## 9. DDoS defense

Layers:

- **Cloud Armor Standard** — L7 WAF + manual rate limiting.
- **Cloud Armor Managed Protection Plus** — advanced L3/L4 & L7 DDoS, adaptive protection, faster onboarding, support SLAs.
- **Global LB + anycast** absorbs volumetric L3/L4 at Google's edge.
- **reCAPTCHA Enterprise** — bot mitigation.

Best practice: always place user-facing apps behind Global HTTPS LB with Cloud Armor.

---

## 10. Secure remote admin

- Disable public SSH by default (no external IP).
- **OS Login** maps IAM to Linux accounts (supports 2FA).
- **IAP TCP tunneling** for SSH/RDP; no VPN.
- **Bastion / Jump Host** pattern if IAP not viable (legacy).
- **Session recording** via Ops Agent + audit logs.

---

## 11. Egress controls

- Cloud NAT without public IPs.
- **Restrict egress FQDNs** at mesh (Istio egress gateway) or via VPC firewall to allowed Google API ranges only.
- **Deny egress** via hierarchical policies; allow specific partner IPs by region.
- **Cloud Armor edge** for egress protection of APIs.

---

## 12. Web application / API protection stack

```
User → Cloud Armor (WAF, rate limit, bot)
      → Global HTTPS LB (TLS, HTTP/2)
      → IAP (optional, for employees)
      → Backend: Cloud Run / GKE / MIG (internal HTTPS LB if internal)
      → Apigee (quota, auth, mediation) for B2B APIs
      → Secret Manager + KMS for credentials
```

For public APIs:

- Add **reCAPTCHA Enterprise** to login flows.
- **Apigee** monetization + analytics if applicable.
- **Cloud Endpoints** (ESPv2) for gRPC/REST with OAuth.
- Verify JWTs at backend (GKE ingress or Cloud Run).

---

## 13. Network security exam patterns

| Scenario | Pick |
| --- | --- |
| "Block SQLi and XSS at edge" | Cloud Armor WAF |
| "Stop exfiltration of BQ data to external project" | VPC Service Controls |
| "Connect on-prem DNS to Cloud DNS private zone" | Inbound server policy + DNS forwarding |
| "No public IPs, reach Google APIs privately" | Private Google Access + `private/restricted.googleapis.com` |
| "Detect malware on VM traffic" | Cloud IDS + Packet Mirroring |
| "mTLS between microservices" | Anthos Service Mesh |
| "Employees SSH to VM without bastion" | IAP TCP tunneling + OS Login |
| "Only corp laptops can access admin UI" | Access Context Manager + IAP + Endpoint Verification |
| "Regulatory: data can't leave EU" | Org policy `gcp.resourceLocations` + VPC-SC + EU regions |

Next: `04-compliance-frameworks.md`.

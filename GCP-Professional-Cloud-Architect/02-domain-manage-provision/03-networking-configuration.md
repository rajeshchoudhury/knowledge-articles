# 2.3 Configuring Network Topology

This chapter is the operator's view of GCP networking: how to configure Shared VPC, peering, DNS, and hybrid connectivity day-to-day.

---

## 1. Shared VPC setup (org landing zone)

```bash
# Enable Shared VPC on host project
gcloud compute shared-vpc enable HOST_PROJECT_ID

# Attach service projects (can be repeated)
gcloud compute shared-vpc associated-projects add SVC_PROJECT_ID \
  --host-project HOST_PROJECT_ID

# Grant Shared VPC admin to a BU group for subnet usage
gcloud projects add-iam-policy-binding HOST_PROJECT_ID \
  --member=group:network-admins@acme.com \
  --role=roles/compute.xpnAdmin

# Grant networkUser on specific subnets (most restrictive)
gcloud compute networks subnets add-iam-policy-binding app-subnet \
  --region=us-central1 \
  --project=HOST_PROJECT_ID \
  --member=serviceAccount:app@svc.iam.gserviceaccount.com \
  --role=roles/compute.networkUser
```

### Key principles

- One or two host projects per environment (prod, non-prod).
- Networking team owns host projects; BUs own service projects.
- Grant **subnet-level** `networkUser` (not project-wide) for least privilege.
- Use **Service Project Admin** role for BU networking leads.

---

## 2. VPC Peering

```bash
# Network A side
gcloud compute networks peerings create a-to-b --network=vpc-a --peer-network=vpc-b \
  --peer-project=other-proj --import-custom-routes --export-custom-routes
# Network B side (must mirror)
gcloud compute networks peerings create b-to-a --network=vpc-b --peer-network=vpc-a \
  --peer-project=host-proj --import-custom-routes --export-custom-routes
```

Characteristics:

- Non-transitive; overlapping CIDRs not allowed.
- Firewall rules apply per VPC (each side must allow peer).
- **Export/Import custom routes** option to propagate on-prem routes across peers.
- **Subnet routes with public IPs** option to allow public-range subnets.

---

## 3. Private Service Connect (PSC)

### Consumer endpoint (connect to producer)

```bash
gcloud compute addresses create psc-ep --region=us-central1 --subnet=consumer-subnet
gcloud compute forwarding-rules create psc-rule --region=us-central1 \
  --network=consumer-vpc --address=psc-ep --target-service-attachment=PRODUCER_ATTACHMENT_URI
```

Use cases:

- Expose internal API in VPC A to VPC B without peering.
- Access Google APIs via private IP in your VPC.
- Consume SaaS services (Snowflake, MongoDB Atlas) privately.

---

## 4. Cloud DNS

```bash
# Private zone visible only to VPCs
gcloud dns managed-zones create internal-acme \
  --dns-name="internal.acme.com." --description="Internal" \
  --visibility=private --networks=vpc-a,vpc-b

# Forwarding zone to on-prem DNS
gcloud dns managed-zones create on-prem-forward \
  --dns-name="corp.acme.com." --visibility=private \
  --networks=vpc-a --forwarding-targets=10.10.0.53,10.10.1.53

# DNSSEC for public zone
gcloud dns managed-zones create acme-com --dns-name="acme.com." \
  --dnssec-state=on
```

### DNS routing policies

- **Geolocation** — different answers by source region.
- **Weighted round robin** — traffic shaping.
- **Failover** — primary / backup health-checked.
- **Primary backup** for on-prem failover.

Set on record set level.

---

## 5. Cloud Interconnect & VPN

### HA VPN

```bash
gcloud compute vpn-gateways create ha-vpn-gw --network=vpc-a --region=us-central1
gcloud compute external-vpn-gateways create peer-gw \
  --interfaces 0=203.0.113.1,1=203.0.113.2

gcloud compute routers create cr1 --network=vpc-a --region=us-central1 --asn=64512

gcloud compute vpn-tunnels create tun1 \
  --peer-external-gateway=peer-gw --peer-external-gateway-interface=0 \
  --ike-version=2 --shared-secret=XXX --router=cr1 --vpn-gateway=ha-vpn-gw \
  --vpn-gateway-interface=0 --region=us-central1

# Mirror with tun2 using interface 1; both BGP sessions active
```

SLA: 99.99% requires both tunnels up, BGP on both, across two regions ideally.

### Dedicated Interconnect order process

1. Request LOA-CFA in console (10 Gbps / 100 Gbps).
2. Cross-connect at colo (Equinix, CoreSite, Digital Realty partner facility).
3. Configure **VLAN attachment** (interconnectAttachment) per region.
4. Attach to **Cloud Router** to exchange BGP.
5. Test with ping / iperf3 / Cloud Router logs.

### Cross-Cloud Interconnect

- Private connection from GCP to AWS / Azure / Oracle / Alibaba.
- 10 / 100 Gbps; multi-region; terminates at Google edge.

---

## 6. Cloud NAT

```bash
gcloud compute routers nats create nat-gw \
  --router=cr1 --region=us-central1 \
  --nat-all-subnet-ip-ranges \
  --auto-allocate-nat-external-ips \
  --enable-logging --log-filter=ALL
```

Sizing:

- Default 64 ports/VM; large egress needs more. Allocate `--min-ports-per-vm` and reserve external IPs.
- **Endpoint-independent** by default; adopt for predictability.
- Budget: port count × concurrent connections; Cloud NAT scales horizontally by adding IPs.

---

## 7. Firewall rules

Rules:

- Direction: ingress / egress.
- Action: allow / deny.
- Priority: 0–65535 (lower first).
- Targets: all, network tags, service accounts.
- Sources: IP ranges, network tags, service accounts, geo-IP (Cloud Armor at edge).
- Ports & protocols.

Use **hierarchical firewall policies** at org/folder for baseline (e.g., block egress to 0.0.0.0/0 by default for tier-1 projects). Combine with VPC-level rules.

### Deny egress except allowed destinations (example)

```bash
gcloud compute firewall-policies create safe-egress --organization=ORG_ID
gcloud compute firewall-policies rules create 1000 \
  --firewall-policy=safe-egress \
  --direction=EGRESS --action=deny --src-ip-ranges=0.0.0.0/0 --layer4-configs=all
gcloud compute firewall-policies rules create 900 \
  --firewall-policy=safe-egress \
  --direction=EGRESS --action=allow --dest-ip-ranges=199.36.153.4/30,199.36.153.8/30 \
  --layer4-configs=tcp:443
```

---

## 8. Load balancer configuration recipe (global HTTPS)

```bash
# SSL cert (managed)
gcloud compute ssl-certificates create www-cert --domains=www.acme.com --global

# Backend service using instance group / NEG
gcloud compute backend-services create app-bs --global \
  --protocol=HTTP --port-name=http --health-checks=http-hc \
  --enable-cdn --security-policy=armor-policy

# Add backends (regional MIGs across 3 regions)
gcloud compute backend-services add-backend app-bs --global \
  --instance-group=mig-us --instance-group-region=us-central1 \
  --balancing-mode=UTILIZATION --max-utilization=0.6

# URL map → default + host rules
gcloud compute url-maps create app-urlmap --default-service=app-bs
gcloud compute target-https-proxies create app-proxy \
  --url-map=app-urlmap --ssl-certificates=www-cert --ssl-policy=tls12-modern
gcloud compute forwarding-rules create app-fr --global --target-https-proxy=app-proxy \
  --ports=443 --address=ANYCAST_VIP
```

Attach:

- **Cloud Armor** via `--security-policy` on backend service.
- **Cloud CDN** via `--enable-cdn`.
- **IAP** via `--iap=enabled` on backend service.
- **Serverless NEG** for Cloud Run: `gcloud compute network-endpoint-groups create cr-neg --region=us-central1 --network-endpoint-type=serverless --cloud-run-service=my-svc`.

---

## 9. Hybrid DNS

Patterns:

1. **On-prem → GCP**: on-prem DNS forwards googleapis to 8.8.8.8, and corp.acme.com to itself. To resolve private zones in GCP, on-prem DNS forwards `internal.acme.com` → **inbound server policy** (Cloud DNS exposes 35.199.192.0/19 inbound forwarder IPs).
2. **GCP → on-prem**: Cloud DNS **forwarding zone** → on-prem DNS IPs (reachable via Interconnect/VPN). Ensure routes allow DNS traffic.
3. Split-horizon: public + private zone with same name; Google resolvers automatically pick private.

---

## 10. Network observability

- **VPC Flow Logs**: enable per subnet; sample rate; metadata includes src/dst, ports, RTT, bytes.
- **Firewall rules logging**: optional per rule.
- **Network Intelligence Center**:
  - Connectivity Tests (source → destination emulation).
  - Performance Dashboard (latency between zones).
  - Network Topology (graph of VPCs).
  - Firewall Insights (shadowed rules, last hit).
  - Network Analyzer (config validation).

---

## 11. Common configuration mistakes on exam

| Mistake | Fix |
| --- | --- |
| VPC peering CIDR overlap | Re-plan IPAM; use /16-/24 plan org-wide |
| Static instance IPs for HA | Use internal TCP/UDP LB or unmanaged IG with health check |
| Missing firewall allow for Google health checks | Allow 35.191.0.0/16 and 130.211.0.0/22 |
| Private clusters missing NAT | Add Cloud NAT or internet gateway for pulling images (or use Artifact Registry via Private Google Access) |
| IAP TCP forwarding without role | Grant `iap.tunnelResourceAccessor` + `compute.instanceAdmin.v1` |
| Cloud SQL cross-region replica but VPC peering with overlap | Re-plan; use VPC-SC & PSC |

Next: `04-data-solutions.md`.

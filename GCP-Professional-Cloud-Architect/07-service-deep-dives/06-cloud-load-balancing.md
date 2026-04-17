# Service Deep Dive — Cloud Load Balancing

## Taxonomy (2024+ naming)

| LB | Scope | OSI | Use |
| --- | --- | --- | --- |
| Global External Application LB | Global | L7 | Worldwide web apps, CDN, Armor, IAP |
| Regional External Application LB | Regional | L7 | Regional web with regional-only requirements |
| Cross-Region Internal Application LB | Multi-region | L7 | Internal multi-region apps |
| Internal Application LB | Regional | L7 | Internal REST/gRPC |
| External Proxy Network LB | Global | L4 proxy | TCP/SSL apps |
| External Passthrough Network LB | Regional | L4 | TCP/UDP passthrough, preserve source IP |
| Internal Passthrough Network LB | Regional | L4 | Internal TCP/UDP, preserves IP |

## Backend types (NEG)
- Instance groups (managed / unmanaged).
- Zonal NEG (IP:port; common for GKE container-native).
- Serverless NEG (Cloud Run / App Engine / Functions / API Gateway).
- Internet NEG (external FQDN).
- Hybrid NEG (via Interconnect/VPN to on-prem).
- PSC NEG (Private Service Connect).

## Features
- **URL maps**: host + path rules → backend services.
- **SSL policies**: min TLS, profile (compatible / modern / restricted / custom).
- **Certificates**: Google-managed (single or wildcard), Certificate Manager, self-managed.
- **Cloud Armor** (WAF, DDoS).
- **Cloud CDN** (per-backend; cache static + signed responses).
- **IAP** (per-backend, per-resource).
- **Session affinity**: NONE / CLIENT_IP / GENERATED_COOKIE / HEADER_FIELD.
- **Health checks** (HTTP, HTTPS, HTTP/2, TCP, SSL, gRPC).
- **Connection draining**.
- **Traffic management**: weighted split, URL rewrites, header actions, retries, faults.

## Network tiers
- **Premium** (global anycast via Google backbone).
- **Standard** (regional; cheaper; not for global apps).

## Global HTTPS LB flow
```
User → DNS → anycast VIP → nearest Google PoP
      → HTTPS terminate → Armor → CDN cache hit?
      → URL map → Backend service → NEG/MIG backend
```

## Health check ranges
- 35.191.0.0/16
- 130.211.0.0/22 (legacy)

## Exam cues
- Global HTTPS LB is default for worldwide HTTP/S.
- Internal LB for internal apps.
- Use serverless NEGs to front Cloud Run with LB features.
- External passthrough preserves source IP (good for non-HTTP TCP/UDP).
- Cross-region internal ALB when internal app spans regions.

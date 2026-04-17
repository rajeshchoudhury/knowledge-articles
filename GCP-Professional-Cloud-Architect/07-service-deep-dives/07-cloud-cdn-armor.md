# Service Deep Dive — Cloud CDN & Cloud Armor

## Cloud CDN

- Enabled per backend service on external HTTPS LB (global or regional).
- Uses Google's global edge (PoPs in 100+ cities).
- **Cache modes**: USE_ORIGIN_HEADERS (default) / CACHE_ALL_STATIC / FORCE_CACHE_ALL.
- **Key configuration**: hostname, query string, specific headers, named cookies.
- **Signed URLs** / **signed cookies** for authenticated content.
- **Signed Requests** with Edge Security Policy.
- **Negative caching** (cache 404/410/500 for short TTL).
- **Bypass / purge** via cache invalidation (cost limit on invalidations).
- **Traffic origin**: GCS bucket, Cloud Run, MIG, NEG, Internet NEG.

### Cache key best practices
- Include only necessary query params (use include/exclude lists).
- Strip auth headers from key.
- Use `Cache-Control` on origin.

### Signed URLs
- HMAC-SHA1 signature over URL components.
- Include expiry; optional IP restriction.

## Media CDN
- Separate product optimized for video streaming.
- Larger edge, ISP-peered, massive throughput.

## Cloud Armor

- WAF + DDoS + bot mitigation at Global LB edge.
- Security policies with priority-ordered rules.
- Preconfigured rulesets: XSS, SQLi, LFI, RFI, Scanners, Protocol attacks (ModSecurity CRS).
- Custom rules using CEL expressions (src IP, geo, header, path).
- **Rate limiting** actions (throttle, ban, redirect, deny).
- **reCAPTCHA Enterprise** integration.
- **Adaptive Protection** (ML-based DDoS signature).
- **Edge Security Policies** (apply to CDN cached responses).

### Tiers
- **Standard** (pay per rule, per request).
- **Managed Protection Plus** (flat subscription; includes Adaptive, DDoS SLA, bot management).

### Rule actions
- `allow`, `deny(403/404/502)`, `throttle`, `rate_based_ban`, `redirect`, `capture`.

## Patterns

- **Front Cloud Run with Global LB + CDN + Armor**: use serverless NEG + backend service with `--enable-cdn --security-policy=...`.
- **Geo-block** specific countries with CEL (`origin.region_code == "XX"`).
- **Bot protection**: reCAPTCHA Enterprise + Armor bot management.
- **API protection**: rate limit per client IP key.

## Exam cues
- Always pair public LB with Armor in production.
- Use Managed Protection Plus for guaranteed DDoS SLA.
- Use Media CDN for live/on-demand video.
- CDN cache key tuning reduces origin load dramatically.

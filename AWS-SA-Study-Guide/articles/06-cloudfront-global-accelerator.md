# CloudFront & Global Accelerator

## Table of Contents
1. [Amazon CloudFront Overview](#amazon-cloudfront-overview)
2. [CloudFront Distributions](#cloudfront-distributions)
3. [Origins](#origins)
4. [Cache Behaviors](#cache-behaviors)
5. [Origin Access Control (OAC) vs Origin Access Identity (OAI)](#origin-access-control-oac-vs-origin-access-identity-oai)
6. [Cache Invalidation & Versioning](#cache-invalidation--versioning)
7. [Lambda@Edge vs CloudFront Functions](#lambdaedge-vs-cloudfront-functions)
8. [Signed URLs & Signed Cookies](#signed-urls--signed-cookies)
9. [Field-Level Encryption](#field-level-encryption)
10. [Origin Groups & Origin Failover](#origin-groups--origin-failover)
11. [Geo-Restriction](#geo-restriction)
12. [Price Classes](#price-classes)
13. [SSL/TLS & HTTPS](#ssltls--https)
14. [CloudFront Logging & Monitoring](#cloudfront-logging--monitoring)
15. [AWS Global Accelerator](#aws-global-accelerator)
16. [CloudFront vs Global Accelerator](#cloudfront-vs-global-accelerator)
17. [S3 Transfer Acceleration vs CloudFront](#s3-transfer-acceleration-vs-cloudfront)
18. [Common Exam Scenarios](#common-exam-scenarios)

---

## Amazon CloudFront Overview

Amazon CloudFront is a Content Delivery Network (CDN) that distributes content to end users with low latency and high transfer speeds. It operates from a global network of **450+ Points of Presence (edge locations)** across **90+ cities in 49 countries**.

### Key Characteristics
- **Global edge network** with edge locations and Regional Edge Caches
- **Caches content** at edge locations close to users
- **Supports dynamic content** acceleration (not just static)
- **DDoS protection** built-in with AWS Shield Standard (free)
- **Integration** with AWS WAF, ACM, S3, ALB, EC2, Lambda@Edge
- **Pay-as-you-go** pricing based on data transfer and requests

### How CloudFront Works
1. User makes a request to your domain (e.g., `cdn.example.com`)
2. DNS routes the request to the nearest CloudFront edge location
3. CloudFront checks its cache for the requested object
4. **Cache hit**: Object returned directly from edge (low latency)
5. **Cache miss**: CloudFront fetches from origin, caches it, then returns to user
6. Regional Edge Caches sit between edge locations and origins, providing an additional caching layer

### Regional Edge Caches
- Larger cache than edge locations
- Located between edge locations and your origin
- Objects that aren't popular enough to stay at an edge location are cached here
- Reduces the need to go back to the origin
- Automatically used (no configuration needed)
- **Not used for proxy methods** (PUT, POST, PATCH, DELETE) or dynamic content

---

## CloudFront Distributions

A distribution is the fundamental unit of CloudFront configuration. It tells CloudFront where to get the content and how to serve it.

### Distribution Types
| Type | Description |
|------|-------------|
| **Web Distribution** | For websites, APIs, media streaming (HTTP/HTTPS) |
| **RTMP Distribution** | **Deprecated** - Was for Adobe Flash media streaming |

### Distribution Settings
- **Alternate Domain Names (CNAMEs)**: Custom domain names (e.g., `cdn.example.com`)
- **SSL Certificate**: Default CloudFront certificate (`*.cloudfront.net`) or custom ACM certificate
- **Default Root Object**: File to return when user requests the root URL (e.g., `index.html`)
- **Logging**: Standard logs to S3 or real-time logs to Kinesis Data Streams
- **Price Class**: Which edge locations to use (affects cost)
- **WAF Web ACL**: Optional WAF integration for security
- **HTTP versions**: HTTP/1.1, HTTP/2, HTTP/3 (QUIC)
- **IPv6**: Enabled by default

---

## Origins

An origin is the source of the content that CloudFront distributes. A single distribution can have multiple origins.

### Origin Types

#### S3 Bucket Origin
- Most common origin type
- Use **Origin Access Control (OAC)** to restrict direct S3 access
- Supports S3 server-side encryption (SSE-S3, SSE-KMS)
- Can use S3 Transfer Acceleration independently

#### Custom Origin (HTTP)
- **ALB (Application Load Balancer)**: Must be public; Security Group must allow CloudFront IPs
- **EC2 Instance**: Must be public; Security Group must allow CloudFront IPs
- **S3 Static Website**: When S3 is configured as a website endpoint (different from S3 bucket origin)
- **Any HTTP server**: On-premises or other cloud servers
- **API Gateway**: For API acceleration

#### MediaStore / MediaPackage
- For video streaming use cases

### Origin Settings
- **Origin Path**: Subdirectory in the origin to use as root
- **Origin Custom Headers**: Add custom headers to origin requests (useful for origin authentication)
- **Connection Timeout**: 1-10 seconds (default 10)
- **Connection Attempts**: 1-3 (default 3)
- **Origin Shield**: Additional caching layer to reduce origin load (specific region)

### Origin Shield
- An extra caching layer between Regional Edge Caches and your origin
- Reduces load on origin by consolidating cache misses
- Best for workloads with viewers spread across multiple regions
- Choose the Origin Shield region closest to your origin
- Additional charges apply

---

## Cache Behaviors

Cache behaviors define how CloudFront handles requests for different URL patterns.

### Default Cache Behavior
- Applies to all requests that don't match any other path pattern
- Always exists in a distribution (created with the first origin)
- Path pattern is `*` (matches everything)

### Additional Cache Behaviors
- Match specific URL path patterns (e.g., `/images/*`, `/api/*`, `*.jpg`)
- Can route to different origins
- Can have different caching settings
- Evaluated in order; first match wins

### Cache Behavior Settings

#### Path Pattern
- Supports wildcards: `*` (any characters), `?` (single character)
- Examples: `/images/*`, `/api/v1/*`, `*.css`, `/static/*.js`

#### Viewer Protocol Policy
| Setting | Description |
|---------|-------------|
| **HTTP and HTTPS** | Allow both protocols |
| **Redirect HTTP to HTTPS** | Automatically redirect HTTP → HTTPS |
| **HTTPS Only** | Only allow HTTPS connections |

#### Allowed HTTP Methods
- **GET, HEAD** - Read-only (most common for static content)
- **GET, HEAD, OPTIONS** - Include CORS preflight
- **GET, HEAD, OPTIONS, PUT, POST, PATCH, DELETE** - Full read-write (for APIs)

#### Cache Key and Origin Requests

##### Cache Policy
Controls what is included in the **cache key** (determines cache hits/misses):
- **Headers**: None, specific headers, or all headers
- **Query Strings**: None, specific query strings, all query strings
- **Cookies**: None, specific cookies, all cookies
- **TTL settings**: Minimum TTL, Maximum TTL, Default TTL

##### Origin Request Policy
Controls what is forwarded to the origin (independently of cache key):
- Additional headers, query strings, cookies forwarded to origin
- Does NOT affect caching

##### Response Headers Policy
Controls headers added to responses:
- CORS headers
- Security headers (HSTS, X-Frame-Options, etc.)
- Custom headers

#### TTL (Time to Live)
| Setting | Description | Default |
|---------|-------------|---------|
| **Minimum TTL** | Minimum time in cache | 0 seconds |
| **Maximum TTL** | Maximum time in cache | 31536000 (365 days) |
| **Default TTL** | Used when origin doesn't send Cache-Control/Expires | 86400 (24 hours) |

Origin can control caching with:
- `Cache-Control: max-age=<seconds>`
- `Cache-Control: s-maxage=<seconds>` (overrides max-age for shared caches)
- `Expires: <date>`
- `Cache-Control: no-cache` or `no-store`

---

## Origin Access Control (OAC) vs Origin Access Identity (OAI)

### Origin Access Identity (OAI) - Legacy
- **Being replaced by OAC** (still works but not recommended for new distributions)
- Special CloudFront identity attached to distribution
- S3 bucket policy grants access to the OAI
- **Limitations**: Doesn't support SSE-KMS, doesn't support S3 in all regions, no POST/PUT support

### Origin Access Control (OAC) - Recommended
- **New and recommended** approach for S3 origins
- Supports ALL S3 features including:
  - SSE-KMS encryption
  - Dynamic requests (PUT, POST, DELETE)
  - S3 in all AWS regions (including opt-in regions)
- Uses IAM service principal signing (Signature Version 4)
- More granular access control

### OAC S3 Bucket Policy Example
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowCloudFrontServicePrincipal",
            "Effect": "Allow",
            "Principal": {
                "Service": "cloudfront.amazonaws.com"
            },
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::my-bucket/*",
            "Condition": {
                "StringEquals": {
                    "AWS:SourceArn": "arn:aws:cloudfront::111122223333:distribution/EDFDVBD6EXAMPLE"
                }
            }
        }
    ]
}
```

---

## Cache Invalidation & Versioning

### Cache Invalidation
- Force removal of objects from CloudFront edge caches before TTL expiration
- Use the `CreateInvalidation` API or AWS Console
- Invalidation paths support wildcards: `/images/*`, `/*` (invalidate everything)
- **First 1,000 invalidation paths per month are free**; then $0.005 per path
- Invalidation propagates to all edge locations (takes a few minutes)
- Invalidation is on the **path**, not on specific objects

### Versioned File Names (Recommended)
- Better approach than invalidation for most use cases
- Use versioned filenames: `style-v2.css`, `app-1.0.3.js`, `image-hash123.png`
- **Advantages over invalidation**:
  - Instant update (no propagation delay)
  - No cost for invalidation
  - Can roll back easily
  - Objects are cached independently
  - No risk of serving stale content
- **Disadvantage**: Requires updating references to the new filename

### Best Practice
- Use **versioned file names** for regular deployments
- Use **invalidation** only when you must keep the same URL (emergency fixes)

---

## Lambda@Edge vs CloudFront Functions

### CloudFront Functions
- **Lightweight** JavaScript functions
- **Sub-millisecond** startup, runs at edge locations
- **Millions of requests per second** capability
- **Runtime**: JavaScript (ECMAScript 5.1 compliant)
- **Execution time**: < 1 ms
- **Memory**: 2 MB
- **Package size**: 10 KB
- **Network access**: No
- **File system access**: No
- **Triggers**: Viewer Request, Viewer Response ONLY
- **Pricing**: ~$0.10 per 1 million invocations (very cheap)

#### CloudFront Functions Use Cases
- URL rewrites/redirects
- Header manipulation
- Cache key normalization
- JWT token validation/decoding (lightweight)
- A/B testing (viewer-side)
- Simple request/response transformations

### Lambda@Edge
- **Full Lambda functions** at edge locations
- **Runtime**: Node.js, Python
- **Execution time**: 5 seconds (viewer triggers) / 30 seconds (origin triggers)
- **Memory**: 128 MB - 10,240 MB (10 GB)
- **Package size**: 1 MB (viewer) / 50 MB (origin)
- **Network access**: Yes
- **File system access**: Yes (/tmp)
- **Triggers**: Viewer Request, Viewer Response, Origin Request, Origin Response
- **Pricing**: Per request + per GB-second (more expensive)

#### Lambda@Edge Use Cases
- Complex authentication/authorization (calling external services)
- Dynamic content generation at edge
- A/B testing with complex logic
- Bot mitigation with external lookups
- Image resizing/transformation
- SEO optimization
- Origin selection based on request attributes

### Comparison Table

| Feature | CloudFront Functions | Lambda@Edge |
|---------|---------------------|-------------|
| **Runtime** | JavaScript | Node.js, Python |
| **Execution time** | < 1 ms | 5s (viewer) / 30s (origin) |
| **Memory** | 2 MB | 128 MB - 10 GB |
| **Package size** | 10 KB | 1 MB / 50 MB |
| **Network access** | No | Yes |
| **File system** | No | Yes (/tmp) |
| **Triggers** | Viewer only | Viewer + Origin |
| **Scale** | Millions/sec | Thousands/sec |
| **Pricing** | ~1/6 of Lambda@Edge | Standard Lambda |
| **Deploy region** | All edge locations | us-east-1 (replicates) |

### Trigger Points

```
User → [Viewer Request] → CloudFront Cache → [Origin Request] → Origin
                                                                   ↓
User ← [Viewer Response] ← CloudFront Cache ← [Origin Response] ← Origin
```

1. **Viewer Request**: After CloudFront receives request from viewer (before cache check)
2. **Origin Request**: Before CloudFront forwards request to origin (cache miss only)
3. **Origin Response**: After CloudFront receives response from origin (before caching)
4. **Viewer Response**: Before CloudFront returns response to viewer

---

## Signed URLs & Signed Cookies

Used to restrict access to content and control who can access it and when.

### Signed URLs
- **One signed URL per file** (each URL grants access to one specific file)
- Use when you want to restrict access to **individual files**
- Use when clients don't support cookies (e.g., RTMP distribution)
- The URL contains the policy: expiration time, IP range, trusted signer
- Can use **canned policy** (simple, fixed expiration) or **custom policy** (complex conditions)

### Signed Cookies
- **One signed cookie grants access to multiple files**
- Use when you want to restrict access to **multiple files** (e.g., all files in a directory)
- Use when you don't want to change your current URLs
- Three cookies set: `CloudFront-Policy`, `CloudFront-Signature`, `CloudFront-Key-Pair-Id`

### When to Use Each

| Scenario | Use |
|----------|-----|
| Individual file access | Signed URL |
| Multiple files with same restriction | Signed Cookies |
| Can't change URLs | Signed Cookies |
| Client doesn't support cookies | Signed URL |
| API/mobile clients | Signed URL |
| Web application with multiple resources | Signed Cookies |

### Trusted Key Groups vs AWS Account (Root)
- **Trusted Key Groups (Recommended)**: Create key groups with public keys; manage with IAM
- **AWS Account**: Uses root account CloudFront key pair; must be managed in root account (not recommended)

### Signed URLs vs S3 Pre-signed URLs

| Feature | CloudFront Signed URL | S3 Pre-signed URL |
|---------|----------------------|-------------------|
| **Access through** | CloudFront (edge) | Directly to S3 |
| **Caching** | Yes (CDN caching) | No |
| **IP restrictions** | Yes | No |
| **Path-based** | Can restrict to path | Specific object only |
| **Use case** | Public content distribution | Temporary S3 access |

---

## Field-Level Encryption

- **Additional layer of encryption** on top of HTTPS
- Protects specific sensitive data fields throughout the entire application stack
- Data encrypted at the edge and can only be decrypted by authorized components
- Uses **asymmetric encryption** (public key at edge, private key at application)

### How It Works
1. Configure public key in CloudFront
2. Specify which POST body fields to encrypt (up to 10 fields)
3. CloudFront encrypts those fields at the edge using the public key
4. Encrypted data passes through your application stack
5. Only the component with the private key can decrypt

### Use Cases
- Credit card numbers that must be encrypted end-to-end
- Healthcare data (HIPAA)
- Any PII that must be protected beyond HTTPS

---

## Origin Groups & Origin Failover

### Origin Groups
- Consist of a **primary origin** and a **secondary origin**
- CloudFront automatically fails over to secondary when primary returns specific HTTP status codes
- Provides **high availability** for your origin

### Failover Configuration
- Failover criteria: Configurable HTTP status codes (e.g., 500, 502, 503, 504, 404, 403)
- Failover is per-request (each failed request tries secondary)
- Can combine with S3 for static failover page

### Use Cases
- S3 primary + S3 secondary (different regions) for static content HA
- ALB primary + S3 secondary for dynamic content with static fallback
- Active-passive origin configuration

---

## Geo-Restriction

Also called **geographic restrictions** or **geoblocking**.

### Allowlist
- Allow users in specific countries to access content
- All other countries are blocked

### Blocklist
- Block users in specific countries from accessing content
- All other countries are allowed

### How It Works
- Uses a third-party GeoIP database to map IP addresses to countries
- Returns HTTP 403 (Forbidden) to blocked users
- Based on **country** only (not state/city/region)
- For more granular geo-restriction, use a third-party geolocation service with Lambda@Edge

---

## Price Classes

CloudFront charges vary by edge location region. Price classes let you reduce costs by limiting which edge locations serve your content.

| Price Class | Regions Included |
|-------------|-----------------|
| **Price Class All** | All edge locations worldwide (best performance) |
| **Price Class 200** | Most regions excluding the most expensive (South America, Australia) |
| **Price Class 100** | Only least expensive regions (North America, Europe, Israel) |

---

## SSL/TLS & HTTPS

### Default CloudFront Certificate
- `*.cloudfront.net` domain
- Free, automatically configured
- No custom domain support

### Custom SSL Certificate
- Must be stored in **AWS Certificate Manager (ACM) in us-east-1 region**
- Or imported as IAM server certificate
- Two options for serving HTTPS:

#### SNI (Server Name Indication) - Recommended
- **Free**
- Modern browsers/clients send hostname in TLS handshake
- CloudFront uses the hostname to serve the correct certificate
- **Most clients support SNI** (browsers since ~2010)
- Some older clients may not support it

#### Dedicated IP
- **$600/month per distribution**
- CloudFront allocates dedicated IP addresses at each edge location
- Supports ALL clients (even legacy ones without SNI)
- Only needed for very old client support

### Origin Protocol Policy
| Setting | Description |
|---------|-------------|
| **HTTP Only** | CloudFront connects to origin via HTTP only |
| **HTTPS Only** | CloudFront connects to origin via HTTPS only |
| **Match Viewer** | Use same protocol as viewer used to connect to CloudFront |

### Viewer Protocol Policy + Origin Protocol Policy
```
Viewer --[HTTPS]--> CloudFront --[HTTPS]--> Origin    (end-to-end encryption)
Viewer --[HTTP]---> CloudFront --[HTTP]---> Origin     (no encryption)
Viewer --[HTTP]---> CloudFront --[redirect]--> Viewer --[HTTPS]--> CloudFront  (redirect to HTTPS)
```

---

## CloudFront Logging & Monitoring

### Standard Logs (Access Logs)
- Detailed logs of every request to CloudFront
- Delivered to S3 bucket
- Includes: date, time, edge location, client IP, HTTP method, URI, status code, bytes, user-agent, etc.
- **Delay**: Up to several hours
- No additional charge (only S3 storage)

### Real-Time Logs
- Delivered in **real-time** to **Amazon Kinesis Data Streams**
- Configure sampling rate (1-100%)
- Choose specific fields to include
- Can process with Lambda, Kinesis Data Analytics, or Kinesis Data Firehose
- Useful for real-time monitoring and anomaly detection

### CloudWatch Metrics
- Default metrics: Requests, BytesDownloaded, BytesUploaded, 4xxErrorRate, 5xxErrorRate, TotalErrorRate
- **Additional metrics** (at extra cost): Cache hit rate, origin latency, etc.

### CloudFront Reports
- Cache Statistics
- Popular Objects
- Top Referrers
- Usage Report
- Viewers Report

---

## AWS Global Accelerator

### Overview
- Uses the **AWS global network** to route traffic to optimal endpoints
- Provides **two static anycast IP addresses** as entry points
- Routes traffic through AWS backbone network (not the public internet)
- Improves availability and performance for global applications

### How It Works
1. Users connect to the nearest AWS edge location via anycast IPs
2. Traffic enters the AWS global network at the edge
3. AWS routes traffic over its private backbone to the optimal endpoint
4. Health checks determine which endpoints are healthy
5. Automatic failover to healthy endpoints

### Components

#### Accelerator
- The Global Accelerator resource
- Has two static anycast IPv4 addresses
- Can also bring your own IP addresses (BYOIP)

#### Listener
- Processes inbound connections based on port and protocol (TCP, UDP)
- One or more listeners per accelerator

#### Endpoint Group
- Associated with an AWS Region
- One or more endpoint groups per listener
- **Traffic dial**: Percentage of traffic to send to this endpoint group (0-100%)

#### Endpoints
- Resources that receive traffic: ALB, NLB, EC2 instances, Elastic IPs
- **Endpoint weight**: Proportion of traffic to this specific endpoint (0-255)

### Health Checks
- Global Accelerator performs health checks on endpoints
- **Unhealthy endpoints** are automatically removed from routing
- Failover happens within seconds (< 30 seconds)
- Can configure health check interval, threshold, and protocol

### Client Affinity
- **None (default)**: Requests distributed based on 5-tuple (source IP, source port, destination IP, destination port, protocol)
- **Source IP**: All requests from same source IP go to same endpoint
- Useful for stateful applications

### Pricing
- Fixed hourly fee per accelerator
- Data transfer premium per GB (on top of standard data transfer)

---

## CloudFront vs Global Accelerator

| Feature | CloudFront | Global Accelerator |
|---------|------------|-------------------|
| **Purpose** | Content delivery (CDN) | Network layer acceleration |
| **Caching** | Yes | No |
| **Static IPs** | No (uses DNS) | Yes (2 anycast IPs) |
| **Best for** | Static/dynamic content, APIs, streaming | TCP/UDP apps, gaming, IoT, VoIP |
| **Protocols** | HTTP/HTTPS | TCP, UDP |
| **Edge processing** | Lambda@Edge, CloudFront Functions | None |
| **DDoS protection** | Shield Standard | Shield Standard (Shield Advanced available) |
| **Health checks** | Origin-level | Endpoint-level with instant failover |
| **IP whitelisting** | Difficult (many IPs) | Easy (2 static IPs) |
| **Use case** | Websites, APIs, media | Non-HTTP, gaming, IP-dependent clients |
| **Failover speed** | DNS-based (minutes) | Instant (< 30 seconds) |
| **WebSocket** | Yes | Yes (TCP) |

### When to Use CloudFront
- Serving static assets (images, CSS, JS)
- Accelerating dynamic web content and APIs
- Video streaming (live or on-demand)
- When you need edge computing (Lambda@Edge / CloudFront Functions)
- When content can benefit from caching

### When to Use Global Accelerator
- Non-HTTP protocols (TCP/UDP: gaming, IoT, VoIP)
- Clients that require static IP addresses (firewall whitelisting)
- Applications needing deterministic, fast failover (< 30 seconds)
- When you need consistent performance over AWS backbone
- Multi-region applications needing traffic management
- Health-check-based routing with instant failover

---

## S3 Transfer Acceleration vs CloudFront

| Feature | S3 Transfer Acceleration | CloudFront |
|---------|-------------------------|------------|
| **Purpose** | Faster S3 uploads/downloads | Content delivery (CDN) |
| **Direction** | Primarily uploads (also downloads) | Primarily downloads |
| **Caching** | No | Yes |
| **Best for** | Large file uploads from distant users | Content distribution to many users |
| **How it works** | Routes through nearest edge to S3 via AWS backbone | Caches at edge, serves from cache |
| **Pricing** | Per GB transferred | Per GB transferred + per request |
| **URL** | `bucket.s3-accelerate.amazonaws.com` | `distribution.cloudfront.net` |

### When to Use S3 Transfer Acceleration
- Uploading large files to S3 from geographically distant locations
- Regular large data transfers to a centralized S3 bucket
- Cross-continent uploads

### When to Use CloudFront
- Distributing content to many end users
- Serving websites and APIs
- When caching provides benefit (same content requested multiple times)
- When you need edge compute capabilities

---

## Common Exam Scenarios

### Scenario 1: Serve Static Website from S3 Securely
**Solution**: S3 bucket (private) + CloudFront distribution with OAC + S3 bucket policy allowing CloudFront service principal

### Scenario 2: Restrict Content to Paid Users
**Solution**: CloudFront Signed URLs (individual files) or Signed Cookies (multiple files) + application generates signed URLs/cookies after authentication

### Scenario 3: Serve Different Content Based on Device Type
**Solution**: CloudFront with cache behaviors that include `CloudFront-Is-Mobile-Viewer`, `CloudFront-Is-Tablet-Viewer` headers in cache key

### Scenario 4: Website Available Globally with Low Latency
**Solution**: CloudFront with S3 origin for static, ALB origin for dynamic, with appropriate cache behaviors

### Scenario 5: Reduce Origin Load
**Solution**: Enable Origin Shield, increase TTLs, use cache policies that maximize cache hit ratio

### Scenario 6: Application Requires Static IP Addresses for Client Firewall Rules
**Solution**: Global Accelerator (provides 2 static anycast IPs) + ALB endpoints

### Scenario 7: Gaming Application with UDP Protocol Needs Global Performance
**Solution**: Global Accelerator (supports UDP) + EC2/NLB endpoints in multiple regions

### Scenario 8: HTTPS Required End-to-End with Custom Domain
**Solution**: CloudFront with custom SSL certificate (ACM in us-east-1), viewer protocol policy "Redirect HTTP to HTTPS", origin protocol policy "HTTPS Only"

### Scenario 9: Serve Content Only to Specific Countries
**Solution**: CloudFront Geo-Restriction with allowlist for permitted countries

### Scenario 10: Real-Time URL Rewriting at Edge
**Solution**: CloudFront Functions (lightweight, sub-millisecond, handles millions of requests) for simple rewrites; Lambda@Edge if complex logic or external calls needed

### Scenario 11: Instant Failover Between Regions (Non-HTTP)
**Solution**: Global Accelerator with endpoint groups in multiple regions (failover < 30 seconds)

### Scenario 12: Large File Uploads from Multiple Continents to Single S3 Bucket
**Solution**: S3 Transfer Acceleration (routes through nearest edge location to S3 via AWS backbone)

### Scenario 13: Reduce CloudFront Costs
**Solution**: Use Price Class 100 or 200 (exclude expensive regions), increase TTLs, use versioned file names instead of invalidations, compress content (gzip/brotli)

---

## Key Numbers to Remember

| Metric | Value |
|--------|-------|
| **Edge locations worldwide** | 450+ |
| **CloudFront Functions execution time** | < 1 ms |
| **CloudFront Functions memory** | 2 MB |
| **CloudFront Functions package size** | 10 KB |
| **Lambda@Edge viewer trigger timeout** | 5 seconds |
| **Lambda@Edge origin trigger timeout** | 30 seconds |
| **Lambda@Edge memory** | 128 MB - 10 GB |
| **Default TTL** | 86,400 seconds (24 hours) |
| **Maximum TTL** | 31,536,000 seconds (365 days) |
| **Free invalidation paths/month** | 1,000 |
| **Field-level encryption max fields** | 10 |
| **Global Accelerator static IPs** | 2 per accelerator |
| **Global Accelerator failover time** | < 30 seconds |
| **SNI custom SSL** | Free |
| **Dedicated IP custom SSL** | $600/month |
| **ACM certificate region for CloudFront** | us-east-1 only |
| **Maximum origins per distribution** | 25 |
| **Maximum cache behaviors per distribution** | 25 |
| **Maximum alternate domain names** | 100 |

---

## Exam Tips Summary

1. **OAC > OAI**: For new S3 origins, always use OAC (supports SSE-KMS, all regions, all methods)
2. **CloudFront Functions > Lambda@Edge**: For simple, high-volume operations (URL rewrites, header manipulation)
3. **Lambda@Edge for complex edge logic**: External API calls, image manipulation, complex auth
4. **Signed URLs for individual files, Signed Cookies for multiple files**
5. **ACM certificates must be in us-east-1** for CloudFront
6. **SNI is free and recommended** for custom SSL; Dedicated IP only for legacy client support
7. **Global Accelerator for non-HTTP, static IPs, instant failover**
8. **CloudFront for HTTP/HTTPS with caching needs**
9. **S3 Transfer Acceleration for uploads**, CloudFront for downloads
10. **Versioned filenames > cache invalidation** for regular updates
11. **Price Class 100** for cost optimization (North America + Europe only)
12. **Origin Groups** for origin failover (HA)

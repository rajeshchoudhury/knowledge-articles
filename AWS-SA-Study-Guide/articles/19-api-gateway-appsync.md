# API Gateway & AppSync

## Table of Contents

1. [Amazon API Gateway Overview](#amazon-api-gateway-overview)
2. [REST API](#rest-api)
3. [HTTP API](#http-api)
4. [WebSocket API](#websocket-api)
5. [REST API vs HTTP API vs WebSocket API Comparison](#rest-api-vs-http-api-vs-websocket-api-comparison)
6. [API Gateway Throttling and Caching](#api-gateway-throttling-and-caching)
7. [API Gateway Authorization](#api-gateway-authorization)
8. [API Gateway Integration Types](#api-gateway-integration-types)
9. [API Gateway CORS](#api-gateway-cors)
10. [API Gateway Request/Response Transformation](#api-gateway-requestresponse-transformation)
11. [API Gateway Canary Deployment](#api-gateway-canary-deployment)
12. [API Gateway Usage Plans and API Keys](#api-gateway-usage-plans-and-api-keys)
13. [API Gateway Logging and Monitoring](#api-gateway-logging-and-monitoring)
14. [API Gateway Resource Policies](#api-gateway-resource-policies)
15. [API Gateway Security](#api-gateway-security)
16. [API Gateway with WAF](#api-gateway-with-waf)
17. [API Gateway Stages and Stage Variables](#api-gateway-stages-and-stage-variables)
18. [API Gateway Custom Domain Names](#api-gateway-custom-domain-names)
19. [AWS AppSync Overview](#aws-appsync-overview)
20. [AppSync Resolvers and Data Sources](#appsync-resolvers-and-data-sources)
21. [AppSync Real-Time Subscriptions](#appsync-real-time-subscriptions)
22. [AppSync Caching and Conflict Detection](#appsync-caching-and-conflict-detection)
23. [AppSync Authorization](#appsync-authorization)
24. [Common Exam Scenarios](#common-exam-scenarios)

---

## Amazon API Gateway Overview

Amazon API Gateway is a fully managed service for creating, publishing, maintaining, monitoring, and securing APIs at any scale.

### Key Characteristics

- **Fully managed**: No infrastructure to manage
- **Scalable**: Handles any number of API calls
- **Multiple API types**: REST, HTTP, and WebSocket
- **Serverless**: Pairs with Lambda for fully serverless APIs
- **Multiple backends**: Lambda, HTTP endpoints, AWS services
- **Security**: IAM, Lambda authorizer, Cognito, API keys
- **Monitoring**: CloudWatch metrics, access logging, X-Ray tracing

### API Gateway Architecture

```
Client → API Gateway → Backend (Lambda, EC2, AWS Service)
```

- API Gateway acts as a "front door" for your APIs
- Handles request routing, throttling, authentication, and more
- Regional, Edge-Optimized, or Private deployment options

### Endpoint Types

**Edge-Optimized (default):**
- Requests routed through **CloudFront Edge locations**
- Reduces latency for geographically distributed clients
- API Gateway itself is still in one region
- Best for: Global client base

**Regional:**
- Deployed in a specific region
- Clients in the same region get lowest latency
- Can manually configure CloudFront for more control
- Best for: Regional applications, custom CloudFront distribution

**Private:**
- Accessible only from within a **VPC** (via VPC endpoint)
- Not accessible from the internet
- Uses **Interface VPC Endpoint** (powered by PrivateLink)
- Best for: Internal APIs, microservice-to-microservice communication

---

## REST API

REST APIs in API Gateway are the most feature-rich API type.

### Components

**Resources:**
- URL paths (e.g., `/users`, `/users/{userId}`, `/orders`)
- Hierarchical structure
- Path parameters: `{paramName}` (e.g., `/users/{userId}`)

**Methods:**
- HTTP methods on resources: GET, POST, PUT, DELETE, PATCH, OPTIONS, HEAD, ANY
- Each method has: Authorization, Request validation, Integration, Method Response

**Stages:**
- Named reference to a deployment (e.g., `dev`, `staging`, `prod`)
- Each stage has its own URL: `https://{api-id}.execute-api.{region}.amazonaws.com/{stage}`
- Stage variables for dynamic configuration

**Deployments:**
- Snapshot of the API configuration
- Must deploy to a stage for changes to take effect
- Deployment history is maintained

### REST API Features

- Request/Response transformation (mapping templates)
- Request validation (models, required parameters)
- API caching
- Canary deployments
- Usage plans and API keys
- WAF integration
- Resource policies
- Client certificates
- Full CloudWatch integration
- X-Ray tracing
- CORS support
- Mutual TLS

---

## HTTP API

HTTP APIs are a newer, simpler, and more cost-effective API type.

### Key Characteristics

- **Lower cost**: Up to 71% cheaper than REST APIs
- **Lower latency**: Faster than REST APIs
- **Simpler**: Fewer features but easier to configure
- **Auto-deploy**: Changes deploy automatically (no explicit deployment step)
- **Native OIDC/OAuth 2.0**: Built-in JWT authorizer
- **Better Lambda integration**: Payload format version 2.0

### HTTP API vs REST API Features

| Feature | HTTP API | REST API |
|---------|----------|----------|
| Cost | Lower (up to 71% less) | Higher |
| Latency | Lower | Higher |
| Lambda Proxy | Yes (v2 payload) | Yes (v1 payload) |
| HTTP Proxy | Yes | Yes |
| JWT Authorizer | Yes (native) | No (use Lambda authorizer) |
| Lambda Authorizer | Yes | Yes |
| IAM Authorizer | Yes | Yes |
| Cognito Authorizer | No (use JWT) | Yes (native) |
| API Keys | No | Yes |
| Usage Plans | No | Yes |
| Caching | No | Yes |
| Request Validation | No | Yes |
| Mapping Templates | No | Yes |
| WAF Integration | No | Yes |
| Resource Policies | No | Yes |
| Canary Deployment | No | Yes |
| X-Ray | No | Yes |
| CORS | Yes (simplified) | Yes |
| Custom Domain | Yes | Yes |
| Private APIs | No | Yes |
| Mutual TLS | Yes | Yes |

### When to Use HTTP API

- Simple API proxy to Lambda or HTTP backends
- Need lowest cost and latency
- JWT/OIDC authorization is sufficient
- Don't need caching, WAF, request transformation, or API keys
- New APIs where REST API features aren't needed

### When to Use REST API

- Need API caching
- Need request/response transformation (mapping templates)
- Need API keys and usage plans
- Need WAF integration
- Need canary deployments
- Need resource policies (cross-account access)
- Need request validation
- Need X-Ray tracing
- Need private APIs

---

## WebSocket API

WebSocket APIs enable real-time, two-way communication between clients and servers.

### How WebSocket APIs Work

1. Client initiates a WebSocket connection to API Gateway
2. API Gateway maintains persistent connections
3. Server can push messages to connected clients at any time
4. Client can send messages to the server at any time
5. Connection remains open until explicitly closed

### Routes

| Route | Description | Required |
|-------|-------------|----------|
| **$connect** | Triggered when client connects | No (but recommended) |
| **$disconnect** | Triggered when client disconnects | No (but recommended) |
| **$default** | Fallback for unmatched routes | No (but recommended) |
| **Custom routes** | User-defined (e.g., `sendMessage`, `joinRoom`) | No |

### Route Selection

- API Gateway inspects the incoming message to determine the route
- **Route selection expression**: JSONPath expression evaluated against the message body
- Example: `$request.body.action`
  - If message is `{"action": "sendMessage", "data": "hello"}`, routes to `sendMessage`

### Connection Management

**Connection URL:**
```
https://{api-id}.execute-api.{region}.amazonaws.com/{stage}/@connections/{connectionId}
```

**Server-to-client messaging:**
- Use the **@connections** API endpoint to send messages to specific clients
- POST: Send a message to a connection
- GET: Get connection info (status, last active time)
- DELETE: Disconnect a client

### WebSocket API Backend

- Lambda function handles `$connect`, `$disconnect`, and custom routes
- Store connection IDs in DynamoDB for server-initiated messages
- Use API Gateway Management API to post messages back to clients

### Use Cases

- Chat applications
- Real-time dashboards
- Live notifications
- Collaborative editing
- Gaming (multiplayer)
- Financial trading (live prices)
- IoT real-time data

---

## REST API vs HTTP API vs WebSocket API Comparison

| Feature | REST API | HTTP API | WebSocket API |
|---------|----------|----------|---------------|
| **Protocol** | HTTP (request/response) | HTTP (request/response) | WebSocket (bidirectional) |
| **Communication** | Synchronous | Synchronous | Real-time, persistent |
| **Use Case** | CRUD APIs, microservices | Simple APIs, proxies | Real-time, chat, live data |
| **Cost** | $$$ | $ | $$ |
| **Features** | Most feature-rich | Minimal but fast | Real-time messaging |
| **Caching** | Yes | No | No |
| **WAF** | Yes | No | Yes |
| **Authorization** | IAM, Lambda, Cognito | IAM, Lambda, JWT | IAM, Lambda |
| **Endpoint Types** | Edge, Regional, Private | Regional | Regional |
| **API Keys** | Yes | No | No |

---

## API Gateway Throttling and Caching

### Throttling

**Account-Level Limits:**
- **10,000 requests per second (rps)** across all APIs in an account per region
- **5,000 concurrent requests** (burst limit)
- These are default soft limits (can be increased via support request)

**Stage-Level Throttling:**
- Configure throttling per stage
- Override account-level defaults
- Useful for: Limiting production vs development traffic

**Method-Level Throttling:**
- Configure throttling per method (e.g., GET /users)
- Most granular control
- Override stage-level settings

**Usage Plan Throttling:**
- Per API key throttling
- Rate limit and burst limit per key
- Useful for: Third-party developer access control

**Throttling Response:**
- HTTP **429 Too Many Requests** when throttled
- Clients should implement exponential backoff and retry

### Caching

- Cache API responses to reduce backend invocations
- Available for **REST API only** (not HTTP API or WebSocket)
- Cache sizes: **0.5 GB** to **237 GB**
- Cache TTL: 0 seconds (disabled) to **3600 seconds** (1 hour, default 300 seconds)
- Cache is **per-stage**
- **Cache key**: Method, resource path, query string parameters, headers
- Can invalidate cache via:
  - Console
  - API call with `Cache-Control: max-age=0` header (requires authorization)
  - Cache flush
- **Cache encryption**: Optional (at rest)

### Caching Cost

- Charged per hour based on cache size
- Minimum: 0.5 GB
- Maximum: 237 GB
- No charge when caching is disabled

### Cache Invalidation

- Clients can request fresh data by sending `Cache-Control: max-age=0`
- Must have `execute-api:InvalidateCache` permission (or API will return cached data)
- Can require authorization for cache invalidation
- Tick the **Require authorization** checkbox in the console to prevent unauthorized cache flush

---

## API Gateway Authorization

### IAM Authorization

- Use AWS IAM policies to control access
- Caller must sign requests with **Signature V4 (SigV4)**
- API Gateway verifies the signature and IAM policy
- Best for: AWS users, cross-account access, service-to-service

**How it works:**
1. Caller signs request with AWS credentials (Access Key + Secret Key)
2. API Gateway extracts the signature
3. API Gateway verifies the signature and checks IAM policies
4. If authorized, request proceeds to backend

**Combined with Resource Policy:**
- IAM policy on the caller + Resource policy on the API = effective permissions
- Same account: Union of policies (either can allow)
- Cross-account: Intersection of policies (both must allow)

### Lambda Authorizer (Custom Authorizer)

- A Lambda function that validates the authorization token or request parameters
- Returns an **IAM policy** that API Gateway uses to allow/deny the request
- Two types:

**Token-based (TOKEN):**
- Receives the authorization token (e.g., Bearer JWT)
- Validates the token
- Returns IAM policy + principal ID

**Request parameter-based (REQUEST):**
- Receives request parameters (headers, query strings, stage variables, context)
- Validates parameters
- Returns IAM policy + principal ID

**Lambda Authorizer Response:**
```json
{
  "principalId": "user123",
  "policyDocument": {
    "Version": "2012-10-17",
    "Statement": [{
      "Action": "execute-api:Invoke",
      "Effect": "Allow",
      "Resource": "arn:aws:execute-api:us-east-1:123456789:api-id/stage/GET/resource"
    }]
  },
  "context": {
    "key": "value"
  }
}
```

**Caching:**
- Authorization results can be cached (0s to 3600s)
- Token is used as the cache key
- Reduces Lambda invocations and latency
- Default: 300 seconds

### Cognito User Pool Authorizer

- Uses **Amazon Cognito User Pools** for authentication
- Client authenticates with Cognito and receives a JWT token
- Client passes the JWT in the Authorization header
- API Gateway validates the JWT against the Cognito User Pool
- No custom code needed (built-in integration)
- Best for: Web and mobile applications with user sign-up/sign-in

**Flow:**
1. Client authenticates with Cognito User Pool → receives JWT
2. Client sends request to API Gateway with JWT in Authorization header
3. API Gateway validates JWT against Cognito User Pool
4. If valid, request proceeds to backend

**Limitations:**
- Only validates authentication (who you are)
- Does not provide fine-grained authorization (what you can do) — use Lambda authorizer for that
- Only available for REST APIs (HTTP APIs use JWT authorizer instead)

### Authorization Comparison

| Feature | IAM | Lambda Authorizer | Cognito |
|---------|-----|-------------------|---------|
| Use Case | AWS services, cross-account | Custom auth logic | User pools, JWT |
| Token | SigV4 signature | Custom token or params | JWT (Cognito token) |
| Caching | N/A | Yes (configurable) | N/A (JWT validated) |
| Cost | Free (no extra cost) | Lambda invocation cost | Cognito pricing |
| Complexity | Low | Medium (custom code) | Low |
| 3rd Party Identity | No | Yes | Yes (via Cognito federation) |
| Fine-Grained | IAM policies | Custom logic | Limited (group-based) |

---

## API Gateway Integration Types

### Lambda Proxy Integration (Recommended)

- API Gateway passes the **entire request** to Lambda as-is
- Lambda returns a response in a specific format
- No mapping templates needed
- Request includes: headers, path parameters, query strings, body, stage variables, context
- Response format: `statusCode`, `headers`, `body`

```json
{
  "statusCode": 200,
  "headers": { "Content-Type": "application/json" },
  "body": "{\"message\": \"success\"}"
}
```

- Most commonly used integration
- Simple setup, Lambda handles all logic
- Cannot use mapping templates (request/response pass through as-is)

### Lambda Custom Integration (Non-Proxy)

- API Gateway can transform the request before sending to Lambda
- Can transform the response before sending to the client
- Uses **mapping templates** (VTL - Velocity Template Language)
- More control but more complex
- Use when: Need to transform data between API Gateway and Lambda

### HTTP Proxy Integration

- API Gateway passes the request to an HTTP endpoint as-is
- Response from the endpoint is returned to the client as-is
- Simple passthrough to any HTTP backend (EC2, on-premises, third-party)

### HTTP Custom Integration (Non-Proxy)

- API Gateway can transform requests and responses with mapping templates
- Configure request/response models and transformations
- Use when: HTTP backend expects a different format than the client sends

### AWS Service Integration

- Directly invoke AWS services without Lambda
- Supported services: S3, DynamoDB, SQS, SNS, Step Functions, Kinesis, etc.
- Reduces cost (no Lambda invocation)
- Requires mapping templates to transform between API format and service format

**Examples:**
- `POST /items` → DynamoDB PutItem (directly, no Lambda)
- `POST /messages` → SQS SendMessage
- `PUT /files/{key}` → S3 PutObject

### Mock Integration

- Returns a response without sending the request to any backend
- Useful for: Testing, development, CORS preflight responses
- Define response in the integration response
- No backend invocation, no Lambda cost

### Integration Type Summary

| Type | Description | Mapping Templates |
|------|-------------|-------------------|
| Lambda Proxy | Full request → Lambda | No |
| Lambda Custom | Transformed request → Lambda | Yes |
| HTTP Proxy | Full request → HTTP endpoint | No |
| HTTP Custom | Transformed request → HTTP endpoint | Yes |
| AWS Service | Direct AWS API call | Yes |
| Mock | No backend call | Yes (for response) |

---

## API Gateway CORS

### What is CORS

Cross-Origin Resource Sharing (CORS) allows web applications running at one domain to access resources from another domain.

### CORS in API Gateway

When a browser-based client calls your API from a different domain:

1. Browser sends a **preflight request** (OPTIONS method)
2. API Gateway must respond with appropriate CORS headers
3. If headers are valid, browser sends the actual request

### Required CORS Headers

| Header | Description |
|--------|-------------|
| `Access-Control-Allow-Origin` | Allowed origin(s) (e.g., `https://example.com` or `*`) |
| `Access-Control-Allow-Methods` | Allowed HTTP methods (e.g., `GET, POST, PUT`) |
| `Access-Control-Allow-Headers` | Allowed request headers |
| `Access-Control-Max-Age` | How long preflight response can be cached |

### Enabling CORS

**REST API:**
- Enable CORS on the resource in the console
- API Gateway automatically creates an OPTIONS method with mock integration
- Must redeploy the API after enabling CORS
- If using Lambda proxy, Lambda must also return CORS headers in its response

**HTTP API:**
- Configure CORS in the API settings
- Simpler configuration (specify allowed origins, methods, headers)
- Automatically handles OPTIONS preflight

### Common CORS Issues

- Forgot to enable CORS on the resource
- Forgot to deploy after enabling CORS
- Lambda proxy integration: Lambda doesn't return CORS headers
- Incorrect `Access-Control-Allow-Origin` (must match exactly or use `*`)

---

## API Gateway Request/Response Transformation

### Mapping Templates

- Written in **Velocity Template Language (VTL)**
- Transform request/response data format
- Available for **non-proxy integrations** (Lambda Custom, HTTP Custom, AWS Service)
- Define in the **Integration Request** and **Integration Response**

### Request Transformation

Transform the client's request before sending to backend:

```vtl
#set($inputRoot = $input.path('$'))
{
  "TableName": "Users",
  "Key": {
    "UserId": {"S": "$inputRoot.userId"}
  }
}
```

### Response Transformation

Transform the backend's response before sending to client:

```vtl
#set($inputRoot = $input.path('$'))
{
  "id": "$inputRoot.Item.UserId.S",
  "name": "$inputRoot.Item.Name.S"
}
```

### Models and Request Validation

**Models:**
- JSON Schema definitions for request/response bodies
- Validate request body structure before sending to backend
- Auto-generate SDK code from models
- Define required fields, data types, patterns

**Request Validation:**
- Validate request body against model
- Validate required query string parameters
- Validate required headers
- Returns **400 Bad Request** if validation fails
- Reduces unnecessary backend invocations

---

## API Gateway Canary Deployment

### What is Canary Deployment

- Route a percentage of stage traffic to a "canary" (new version)
- Remaining traffic goes to the current (stable) version
- Monitor the canary for errors before promoting

### How It Works

1. Deploy a new version of the API
2. Enable canary on the stage
3. Configure traffic split (e.g., 10% canary, 90% stable)
4. Monitor canary metrics (errors, latency)
5. If canary is healthy, **promote** canary to become the new stable version
6. If canary has issues, **rollback** by disabling the canary

### Configuration

- **Canary percentage**: 0.0% to 100.0%
- Canary can use different **stage variables** than the main stage
- Separate CloudWatch metrics for canary vs production
- Available for **REST API only**

### Canary vs Lambda Aliases

| Feature | API Gateway Canary | Lambda Weighted Alias |
|---------|-------------------|----------------------|
| Traffic Split | At API Gateway level | At Lambda level |
| Scope | Entire API stage | Individual Lambda function |
| Variables | Different stage variables | Different Lambda versions |
| Use Case | API-level testing | Function-level testing |

---

## API Gateway Usage Plans and API Keys

### API Keys

- Alphanumeric string for identifying API consumers
- Passed in the `x-api-key` header
- **NOT for authorization** (API keys alone are not security — they're identifiers)
- Used with **usage plans** for throttling and quota management
- Can be auto-generated or imported

### Usage Plans

- Define throttling and quota for API key holders
- Configuration:
  - **Throttle**: Rate limit (requests/second) and burst limit
  - **Quota**: Maximum number of requests over a time period (day, week, month)
  - **Associated Stages**: Which API stages the plan applies to

### Setup Process

1. Create an API and deploy to a stage
2. Create one or more API keys
3. Create a usage plan with throttle and quota settings
4. Associate the usage plan with API stages
5. Associate API keys with the usage plan
6. Enable API key required on methods

### Use Cases

- Monetizing APIs (different tiers: free, basic, premium)
- Rate limiting third-party developers
- Tracking API usage by customer
- Enforcing quotas for partner integrations

---

## API Gateway Logging and Monitoring

### CloudWatch Metrics

| Metric | Description |
|--------|-------------|
| **Count** | Total number of API requests |
| **Latency** | Time from request received to response returned |
| **IntegrationLatency** | Time for backend to respond |
| **4XXError** | Client-side errors (4xx status codes) |
| **5XXError** | Server-side errors (5xx status codes) |
| **CacheHitCount** | Number of cache hits |
| **CacheMissCount** | Number of cache misses |

### Access Logging

- Log all API requests to **CloudWatch Logs**
- Configurable log format (CLF, JSON, XML, CSV)
- Includes: Request ID, IP address, caller, method, status code, latency, etc.
- Useful for: Auditing, debugging, analytics
- Separate from **execution logging**

### Execution Logging

- Detailed logs of API Gateway request processing
- Logs: Request/response bodies, authorization results, integration calls
- Two levels:
  - **ERROR**: Only errors
  - **INFO**: Everything (requests, responses, errors)
- **Warning**: Full logging can generate high log volume and cost
- Useful for debugging but should be disabled in production (or set to ERROR)

### X-Ray Tracing

- Distributed tracing for API Gateway requests
- Traces request through API Gateway → Lambda → downstream services
- Enable X-Ray tracing at the stage level
- Visualize the full request path and identify bottlenecks
- Available for **REST API only**

---

## API Gateway Resource Policies

### What Are Resource Policies

- JSON policies attached to the API (similar to S3 bucket policies or SQS queue policies)
- Control **who** can invoke the API and from **where**
- Applied at the API level (not method level)

### Use Cases

**Allow specific AWS accounts (cross-account):**
```json
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Principal": {"AWS": "arn:aws:iam::111122223333:root"},
    "Action": "execute-api:Invoke",
    "Resource": "arn:aws:execute-api:us-east-1:444455556666:api-id/*"
  }]
}
```

**Restrict by IP address:**
```json
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Deny",
    "Principal": "*",
    "Action": "execute-api:Invoke",
    "Resource": "arn:aws:execute-api:us-east-1:123456789:api-id/*",
    "Condition": {
      "NotIpAddress": {
        "aws:SourceIp": ["10.0.0.0/8", "203.0.113.0/24"]
      }
    }
  }]
}
```

**Restrict by VPC endpoint:**
```json
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Principal": "*",
    "Action": "execute-api:Invoke",
    "Resource": "arn:aws:execute-api:us-east-1:123456789:api-id/*",
    "Condition": {
      "StringEquals": {
        "aws:sourceVpce": "vpce-0123456789abcdef0"
      }
    }
  }]
}
```

### Resource Policy + IAM

- When both are present, the effective permissions depend on the account:
  - **Same account**: Either policy can allow (union)
  - **Cross-account**: Both must allow (intersection)

---

## API Gateway Security

### Mutual TLS (mTLS)

- Both client and server present certificates for authentication
- Client must present a trusted certificate to API Gateway
- Configure with a **truststore** (CA certificate bundle stored in S3)
- Supported for REST API, HTTP API, and custom domain names
- Provides strong client authentication without custom code

### Client Certificates

- API Gateway can generate a **client certificate**
- Sent to the backend with each request
- Backend verifies the certificate to ensure the request is from API Gateway
- Useful for: Backend authentication (verify API Gateway identity)
- Available for **REST API only**

### API Gateway + VPC

**Private APIs:**
- Only accessible from within a VPC
- Uses Interface VPC Endpoint (PrivateLink)
- Resource policies control which VPCs/endpoints can access

**VPC Link:**
- Connect API Gateway to resources in a VPC (ALB, NLB, EC2, ECS)
- REST API: VPC Link via **Network Load Balancer**
- HTTP API: VPC Link via **ALB, NLB, or Cloud Map**
- Private integration without exposing backend to the internet

---

## API Gateway with WAF

### AWS WAF Integration

- Attach **AWS WAF Web ACL** to REST API or WebSocket API stages
- Protect against common web exploits
- HTTP API does **NOT** support WAF

### WAF Rules for API Gateway

| Rule Type | Protection |
|-----------|-----------|
| **IP-based** | Block/allow specific IPs or CIDR ranges |
| **Rate-based** | Limit requests per IP (rate limiting) |
| **SQL injection** | Block SQL injection attempts |
| **XSS** | Block cross-site scripting |
| **Size constraint** | Block oversized requests |
| **Geo match** | Block/allow by country |
| **Managed rules** | AWS and marketplace rule groups |

### Use Cases

- Block malicious IPs
- Prevent DDoS attacks (rate limiting)
- Block SQL injection and XSS attacks
- Geo-restrict API access
- Comply with security requirements

---

## API Gateway Stages and Stage Variables

### Stages

- Named references to a specific deployment of the API
- Common stages: `dev`, `staging`, `prod`, `v1`, `v2`
- Each stage has its own URL, settings, and configuration
- Stage settings override API-level settings
- Can enable caching, logging, throttling per stage

### Stage Variables

- Key-value pairs available at runtime (like environment variables for API Gateway)
- Reference in: Mapping templates, Lambda function ARN, HTTP endpoint URL
- Syntax: `${stageVariables.variableName}`

**Common use cases:**

**Dynamic Lambda function:**
- Stage variable: `functionAlias = prod` or `functionAlias = dev`
- Lambda ARN: `arn:aws:lambda:...:function:myFunction:${stageVariables.functionAlias}`
- Different stages invoke different Lambda aliases/versions

**Dynamic HTTP endpoint:**
- Stage variable: `backendUrl = https://prod.example.com` or `https://dev.example.com`
- HTTP integration URL: `${stageVariables.backendUrl}/api`

### Stage Variable + Lambda Alias Pattern

```
API Stage: prod → Stage Variable: lambdaAlias=PROD → Lambda Function:myFunc:PROD (95% v2, 5% v3)
API Stage: dev → Stage Variable: lambdaAlias=DEV → Lambda Function:myFunc:DEV (100% $LATEST)
```

This combines API Gateway stage management with Lambda weighted aliases for gradual deployments.

---

## API Gateway Custom Domain Names

### Custom Domain Setup

1. Register a domain name (e.g., `api.example.com`)
2. Create an ACM certificate for the domain:
   - **Edge-Optimized**: Certificate must be in **us-east-1**
   - **Regional**: Certificate must be in the **same region** as the API
3. Create a custom domain name in API Gateway
4. Map the custom domain to an API stage (base path mapping)
5. Create a DNS record:
   - **Edge-Optimized**: CNAME or A record (alias) pointing to the CloudFront distribution
   - **Regional**: CNAME or A record (alias) pointing to the regional domain name

### Base Path Mapping

- Map different base paths to different APIs or stages:
  - `api.example.com/v1` → API v1, prod stage
  - `api.example.com/v2` → API v2, prod stage
  - `api.example.com/users` → Users API, prod stage

### Migration Between Endpoint Types

- Changing from edge-optimized to regional (or vice versa) changes the underlying domain
- DNS needs to be updated
- No downtime if done carefully with DNS CNAME

---

## AWS AppSync Overview

AWS AppSync is a managed service for building **GraphQL APIs** that enable real-time data access and synchronization.

### What is GraphQL

- Query language for APIs (alternative to REST)
- Client specifies exactly what data it needs (no over-fetching or under-fetching)
- Single endpoint for all operations
- Strongly typed schema
- Three operation types:
  - **Query**: Read data
  - **Mutation**: Write/update data
  - **Subscription**: Real-time updates (WebSocket)

### AppSync Key Features

- **Managed GraphQL**: AWS manages the infrastructure
- **Real-time subscriptions**: WebSocket-based real-time data push
- **Offline support**: Automatic offline data access and sync (mobile)
- **Multiple data sources**: Combine data from multiple sources in one query
- **Conflict detection**: Handle conflicts in offline/online sync
- **Caching**: Server-side caching for improved performance
- **Fine-grained authorization**: Per-field authorization

### GraphQL vs REST

| Feature | GraphQL (AppSync) | REST (API Gateway) |
|---------|-------------------|-------------------|
| Endpoints | Single endpoint | Multiple endpoints |
| Data Fetching | Client specifies fields | Server defines response |
| Over-fetching | No | Common |
| Under-fetching | No | Common (requires multiple calls) |
| Real-time | Built-in subscriptions | WebSocket API (separate) |
| Schema | Strongly typed | No standard schema |
| Versioning | Schema evolution | URL versioning |
| Caching | Per-field | Per-method/resource |

### When to Use AppSync

- Mobile or web apps needing real-time data
- Applications with complex data models (multiple data sources)
- Offline-first mobile applications
- Applications requiring flexible data queries
- Reducing API round trips (get exactly what you need)

---

## AppSync Resolvers and Data Sources

### Data Sources

AppSync can connect to multiple data sources:

| Data Source | Description | Use Case |
|-------------|-------------|----------|
| **DynamoDB** | NoSQL database | Primary data store |
| **Aurora Serverless** | Relational database (Data API) | SQL data |
| **Amazon RDS** | Relational database (via Data API) | SQL data |
| **OpenSearch** | Search and analytics | Full-text search |
| **Lambda** | Custom logic | Complex transformations, external APIs |
| **HTTP** | Any HTTP endpoint | Third-party APIs, microservices |
| **EventBridge** | Event bus | Publish events from mutations |
| **None** | Local resolver | Client-side logic, pub/sub |

### Resolvers

Resolvers connect GraphQL fields to data sources.

**Unit Resolvers:**
- Map a single field to a single data source
- Request mapping template → Data source → Response mapping template
- Written in VTL (Velocity Template Language) or JavaScript

**Pipeline Resolvers:**
- Execute multiple data source operations in sequence
- Composed of **functions** (each function calls a data source)
- Before mapping template → Function 1 → Function 2 → ... → After mapping template
- Use for: Multi-step operations, data aggregation, authorization checks

**JavaScript Resolvers:**
- Write resolver logic in JavaScript (alternative to VTL)
- More familiar syntax for most developers
- Support for APPSYNC_JS runtime
- Request handler and response handler functions

### Resolver Mapping Templates (VTL)

**Request mapping template** (transforms GraphQL request to data source request):
```vtl
{
  "version": "2017-02-28",
  "operation": "GetItem",
  "key": {
    "id": $util.dynamodb.toDynamoDBJson($ctx.args.id)
  }
}
```

**Response mapping template** (transforms data source response to GraphQL response):
```vtl
$util.toJson($ctx.result)
```

### Resolver Context ($ctx)

| Field | Description |
|-------|-------------|
| `$ctx.args` | GraphQL field arguments |
| `$ctx.source` | Parent field result (for nested resolvers) |
| `$ctx.identity` | Caller identity information |
| `$ctx.result` | Data source response (in response template) |
| `$ctx.stash` | Shared state across pipeline functions |
| `$ctx.prev.result` | Previous function result (pipeline) |

---

## AppSync Real-Time Subscriptions

### How Subscriptions Work

1. Client subscribes to a GraphQL subscription (e.g., `onCreateMessage`)
2. AppSync establishes a **WebSocket connection**
3. When a mutation triggers the subscription, AppSync pushes data to all subscribers
4. Connection is maintained until the client disconnects

### Subscription Definition

```graphql
type Subscription {
  onCreateMessage(roomId: ID): Message
    @aws_subscribe(mutations: ["createMessage"])
}
```

- Subscriptions are triggered by **mutations**
- `@aws_subscribe` directive specifies which mutations trigger the subscription
- Can filter subscriptions by arguments (e.g., only messages for a specific room)

### Enhanced Subscription Filtering

- Filter events at the server side before pushing to clients
- Reduces unnecessary data transfer
- Filter on any field in the published data
- Supports complex filter expressions

### Subscription Use Cases

- Live chat messages
- Real-time notifications
- Live dashboards (stock prices, metrics)
- Collaborative editing (document changes)
- Gaming (player state updates)
- IoT device status updates

---

## AppSync Caching and Conflict Detection

### Server-Side Caching

- Cache API responses at the resolver level
- Reduces calls to data sources
- Cache sizes: 0.5 GB to 13 GB
- TTL: 1 second to 3600 seconds (1 hour)
- Cache encryption: At rest and in transit
- Cache key: Per-resolver (based on field arguments)

**Caching behaviors:**
- **Full request caching**: Cache the entire resolver response
- **Per resolver caching**: Cache individual resolvers

### Conflict Detection and Resolution

For offline/online synchronization in mobile apps.

**Conflict Detection Strategies:**

| Strategy | Description |
|----------|-------------|
| **Optimistic concurrency** | Use version numbers; reject stale writes |
| **Auto merge** | Automatically merge non-conflicting changes |
| **Lambda** | Custom conflict resolution logic via Lambda |

**How It Works:**
1. Mobile app modifies data offline
2. When back online, app syncs changes with AppSync
3. If data was modified on server during offline period → conflict detected
4. Conflict resolution strategy determines the outcome

### Versioned Data Sources

- DynamoDB tables with versioning enabled
- Each item has a `_version` field
- AppSync tracks versions for conflict detection
- Required for: Conflict detection, delta sync

---

## AppSync Authorization

AppSync supports four authorization modes (can combine multiple).

### API Key

- Simple string token for public APIs
- Passed in the `x-api-key` header
- **Expiration**: 1 day to 365 days
- Best for: Public APIs, development/testing
- **Not recommended** for production user-facing APIs

### IAM

- AWS IAM authentication (SigV4)
- Best for: AWS services, admin operations, server-to-server
- Fine-grained with IAM policies
- Use case: Backend services accessing the API

### Amazon Cognito User Pools

- JWT token from Cognito User Pool
- Best for: User-facing applications with sign-up/sign-in
- Supports user groups for authorization
- Field-level authorization based on Cognito groups

### OpenID Connect (OIDC)

- JWT token from any OIDC-compliant provider
- Best for: Third-party identity providers (Auth0, Okta, etc.)
- Configure: Issuer URL, client ID
- AppSync validates the JWT against the OIDC provider

### Multi-Auth

- Configure multiple authorization modes on a single API
- Set a **default** authorization mode
- Override per-field using directives:
  - `@aws_api_key`
  - `@aws_iam`
  - `@aws_cognito_user_pools`
  - `@aws_oidc`

### Authorization Directives

```graphql
type Query {
  # Only authenticated Cognito users
  getMyProfile: Profile @aws_cognito_user_pools
  
  # Public access via API key
  getPublicData: PublicData @aws_api_key
  
  # Admin access via IAM
  adminAction: Result @aws_iam
}
```

---

## Common Exam Scenarios

### Scenario 1: Serverless REST API

**Question**: Build a REST API for a web application backed by Lambda and DynamoDB.

**Solution**: **API Gateway REST API** with Lambda proxy integration. Lambda reads/writes to DynamoDB. Use Cognito User Pool authorizer for user authentication. Enable CORS for browser access.

### Scenario 2: Cost-Effective Simple API

**Question**: A simple API proxy to Lambda needs the lowest cost and latency.

**Solution**: **API Gateway HTTP API**. Up to 71% cheaper than REST API. Use JWT authorizer if authentication is needed. No caching or WAF required.

### Scenario 3: Real-Time Chat Application

**Question**: Build a real-time chat application where users receive messages instantly.

**Solution**: **API Gateway WebSocket API** or **AppSync with subscriptions**. WebSocket API if custom protocol/message handling is needed. AppSync if GraphQL is preferred and real-time subscriptions for message updates.

### Scenario 4: API with Rate Limiting for Third-Party Developers

**Question**: An API needs different rate limits for free, basic, and premium tier developers.

**Solution**: **API Gateway REST API** with **usage plans and API keys**. Create three usage plans with different throttle and quota settings. Assign API keys to appropriate plans.

### Scenario 5: Protect API from SQL Injection and DDoS

**Question**: An API needs protection against common web attacks and DDoS.

**Solution**: Attach **AWS WAF Web ACL** to the **API Gateway REST API** stage. Configure managed rules for SQL injection and XSS. Add rate-based rules for DDoS protection. Optionally use CloudFront for additional DDoS protection.

### Scenario 6: Internal API Accessible Only from VPC

**Question**: An API should only be accessible from within the company's VPC.

**Solution**: Create a **Private REST API** with a VPC endpoint. Use a resource policy to restrict access to specific VPC endpoints. Applications in the VPC access the API through the Interface VPC Endpoint.

### Scenario 7: API Gateway Connecting to Backend in VPC

**Question**: API Gateway needs to route requests to an application running on EC2 instances in a private VPC.

**Solution**: Use **VPC Link** to connect API Gateway to a **Network Load Balancer** (for REST API) or **ALB** (for HTTP API) that fronts the EC2 instances. No need to expose EC2 instances to the internet.

### Scenario 8: Gradual API Rollout

**Question**: Deploy a new API version with minimal risk, sending only 5% of traffic to the new version initially.

**Solution**: Use **canary deployment** on the REST API stage. Set canary to 5% traffic. Monitor canary metrics. If healthy, promote to 100%. Alternatively, combine with Lambda weighted aliases for function-level canary.

### Scenario 9: Mobile App with Offline Sync

**Question**: A mobile application needs to work offline and synchronize data when connectivity is restored.

**Solution**: Use **AWS AppSync** with conflict detection enabled. Configure DynamoDB as the data source with versioned tables. Use Optimistic Concurrency or Auto Merge for conflict resolution. AppSync provides offline support with Amplify SDK.

### Scenario 10: GraphQL API with Multiple Data Sources

**Question**: An application needs to combine data from DynamoDB, an external REST API, and Aurora in a single API call.

**Solution**: Use **AWS AppSync** with multiple data sources. DynamoDB data source for user profiles, HTTP data source for external API, and Aurora (RDS Data API) data source for relational data. Pipeline resolvers can combine data from multiple sources.

### Scenario 11: API Access Control Based on User Attributes

**Question**: Different users should see different data fields based on their role (admin vs regular user).

**Solution**: Use **AppSync with Cognito User Pools** authorization. Define Cognito groups (admin, user). Use `@aws_cognito_user_pools(cognito_groups: ["admin"])` directives on sensitive fields. Or use a **Lambda authorizer** with field-level mapping.

### Scenario 12: Cross-Account API Access

**Question**: An API in Account A needs to be invoked by a service in Account B.

**Solution**: Use **API Gateway resource policy** to allow Account B's IAM role to invoke the API. Account B's service signs requests with SigV4. Both the resource policy (on the API) and IAM policy (on the caller role) must allow access.

### Scenario 13: Caching Frequently Accessed API Responses

**Question**: An API serves the same responses repeatedly and needs to reduce backend latency and Lambda invocations.

**Solution**: Enable **API Gateway caching** on the REST API stage. Set cache TTL based on data freshness requirements. Configure cache key with relevant query parameters/headers. This reduces Lambda invocations and improves response time.

---

## Key Numbers to Remember

| Feature | Value |
|---------|-------|
| API Gateway default throttle | 10,000 rps |
| API Gateway default burst | 5,000 concurrent |
| API Gateway cache size range | 0.5 GB – 237 GB |
| API Gateway cache TTL default | 300 seconds (5 min) |
| API Gateway cache TTL max | 3,600 seconds (1 hour) |
| API Gateway max payload size | 10 MB |
| API Gateway WebSocket message size | 128 KB |
| API Gateway WebSocket idle timeout | 10 minutes |
| API Gateway WebSocket max connection duration | 2 hours |
| Lambda authorizer cache TTL | 0 – 3,600 seconds |
| Usage plan quota | Per day, week, or month |
| REST API max integration timeout | 29 seconds |
| HTTP API max integration timeout | 30 seconds |
| SNS subscription for API Gateway max | 12,500,000 |
| AppSync cache size | 0.5 GB – 13 GB |
| AppSync API key max expiry | 365 days |
| EventBridge rule targets max | 5 per rule |

---

## Summary

- **REST API** = Most feature-rich, caching, WAF, usage plans, mapping templates, canary
- **HTTP API** = Simpler, cheaper (71% less), faster, JWT authorizer, no caching/WAF
- **WebSocket API** = Real-time bidirectional, persistent connections, $connect/$disconnect/$default
- **Authorization** = IAM (SigV4), Lambda authorizer (custom), Cognito (JWT), API keys (identification only)
- **Integration types** = Lambda proxy (most common), Lambda custom, HTTP proxy/custom, AWS service, Mock
- **Caching** = REST API only, 0.5-237 GB, up to 1h TTL
- **Throttling** = 10,000 rps default, 5,000 burst, configurable per stage/method/key
- **VPC Link** = Connect to private resources (NLB for REST, ALB/NLB for HTTP)
- **WAF** = REST API and WebSocket only (not HTTP API)
- **AppSync** = Managed GraphQL, real-time subscriptions, multiple data sources, offline sync
- **AppSync auth** = API key, IAM, Cognito, OIDC (can combine multiple)

# AWS SAP-C02 Practice Test 37 — Microservices Patterns

> **Theme:** Service discovery, circuit breaker, event sourcing, API versioning, service mesh  
> **Questions:** 75 | **Time Limit:** 180 minutes  
> **Domain Distribution:** D1 ≈ 20 | D2 ≈ 22 | D3 ≈ 11 | D4 ≈ 9 | D5 ≈ 13

---

### Question 1
A large e-commerce company is decomposing a monolithic Java application into microservices running on Amazon ECS. The order service, inventory service, and payment service need to discover each other dynamically as tasks scale in and out. Service endpoints change frequently during deployments and scaling events. The solution must not require code changes to existing service clients. What should the solutions architect recommend?

A) Hardcode service endpoints in environment variables and redeploy containers when endpoints change.  
B) Use AWS Cloud Map for service discovery with ECS service-connect. Register services automatically as ECS tasks launch and deregister on termination. Clients use the Cloud Map DNS namespace to resolve service endpoints.  
C) Deploy an Elasticsearch cluster to maintain a registry of service endpoints.  
D) Use an Application Load Balancer per service and store ALB DNS names in AWS Systems Manager Parameter Store.

**Correct Answer: B**
**Explanation:** AWS Cloud Map with ECS service-connect provides native service discovery. ECS automatically registers/deregisters tasks with Cloud Map as they scale. DNS-based resolution means existing clients using DNS don't need code changes. Cloud Map supports both DNS and API-based discovery. Option A is not dynamic and causes downtime during changes. Option C is not purpose-built for service discovery. Option D works but adds ALB cost per service and still requires a mechanism to discover ALB endpoints.

---

### Question 2
A financial services company runs 40 microservices on Amazon EKS. When the payment processing service becomes slow, requests back up across all upstream services, causing a cascading failure that takes down the entire platform. The architect needs to implement a pattern that prevents this cascade. What should they implement?

A) Increase the timeout values on all upstream services to give the payment service more time to respond.  
B) Implement the circuit breaker pattern using Istio service mesh or AWS App Mesh with Envoy proxies. Configure circuit breaker thresholds (error rate, consecutive failures) so that when the payment service degrades, upstream services receive fast-fail responses instead of waiting, with automatic recovery attempts after a cooldown period.  
C) Deploy the payment service with more replicas to handle the load.  
D) Implement synchronous retry logic in all upstream services with exponential backoff.

**Correct Answer: B**
**Explanation:** The circuit breaker pattern (popularized by Netflix Hystrix) prevents cascading failures by "opening the circuit" when a downstream service is degraded. App Mesh/Istio with Envoy implements this at the infrastructure level — no code changes needed. When error thresholds are breached, the circuit opens and upstream services receive immediate failure responses. After a cooldown, the circuit moves to half-open, testing with limited traffic. Option A worsens the cascade by tying up more threads. Option C helps with capacity but doesn't prevent the cascade pattern. Option D retries exacerbate the overload.

---

### Question 3
A media company is building a content management system where multiple services need to react to content publishing events. The publishing service should not be aware of or coupled to the consuming services (review service, notification service, analytics service, CDN invalidation service). New consumers may be added in the future. What architecture pattern and AWS services should the architect use?

A) The publishing service calls each consuming service's API directly in sequence after publishing content.  
B) Implement an event-driven architecture using Amazon EventBridge. The publishing service emits a "ContentPublished" event to an EventBridge event bus. Each consumer creates its own rule to match the event and routes it to their processing target (Lambda, SQS, Step Functions). New consumers add rules without modifying the publisher.  
C) Use a shared database table where the publishing service writes events and consumers poll the table.  
D) Use Amazon SNS with a single subscriber that fans out to all consumers via a monolithic Lambda function.

**Correct Answer: B**
**Explanation:** EventBridge implements the event-driven, publish-subscribe pattern with loose coupling. The publisher emits events without knowledge of consumers. Each consumer independently creates rules to match events of interest. Adding new consumers requires zero changes to the publisher. EventBridge supports content-based filtering, schema discovery, and multiple target types. Option A creates tight coupling and sequential dependencies. Option C is a polling anti-pattern with latency and scalability issues. Option D centralizes routing logic in a single Lambda, creating a coupling point.

---

### Question 4
A ride-sharing company needs to track the complete lifecycle of every ride — from request through driver assignment, pickup, trip progress, and completion — for audit, debugging, and replaying past state. They need to be able to reconstruct the ride state at any point in time. Traditional CRUD updates to a database lose historical state. What pattern should the architect implement?

A) Store the current ride state in DynamoDB and enable DynamoDB Streams for change data capture.  
B) Implement event sourcing — store every state change as an immutable event in an append-only event store (Amazon Kinesis Data Streams → S3 or DynamoDB). Rebuild ride state by replaying events from the beginning. Use CQRS (Command Query Responsibility Segregation) with separate read models materialized from the event stream for different query needs.  
C) Use a relational database with audit trigger tables that copy rows before updates.  
D) Store snapshots of ride state every 30 seconds in S3.

**Correct Answer: B**
**Explanation:** Event sourcing stores all state changes as immutable events rather than overwriting current state. This enables complete audit trails, time-travel debugging (reconstruct state at any point), and event replay. Combined with CQRS, read models are optimized for specific query patterns (e.g., analytics, customer support). Kinesis captures events in order, S3/DynamoDB provides durable storage. Option A captures changes but DynamoDB Streams has a 24-hour retention limit. Option C loses fine-grained events between triggers. Option D misses events between snapshots.

---

### Question 5
A healthcare company runs microservices on ECS Fargate. The API team needs to deploy a new version of the Patient API (v2) with breaking changes while maintaining the existing v1 for current consumers who aren't ready to upgrade. Both versions must run simultaneously, and the routing should be URL-path-based (/v1/patients and /v2/patients). How should the architect implement API versioning?

A) Deploy both v1 and v2 as separate ECS services behind a single Application Load Balancer. Create path-based routing rules: /v1/* routes to the v1 target group and /v2/* routes to the v2 target group.  
B) Use a single ECS service that handles both v1 and v2 in the application code based on the URL path.  
C) Deploy v1 and v2 in separate VPCs with separate ALBs and use Route 53 to route based on URL path.  
D) Use Amazon API Gateway with stage variables to route between v1 and v2 deployments.

**Correct Answer: A**
**Explanation:** Path-based routing on an ALB is the simplest and most operationally efficient way to implement URL-based API versioning. Each version runs as an independent ECS service with its own target group, enabling independent scaling and deployment. The ALB routes requests based on path prefix. Option B couples both versions in one service, preventing independent deployment/scaling. Option C — Route 53 doesn't route based on URL paths (only domain-level). Option D works but adds API Gateway cost and complexity when ALB path routing suffices.

---

### Question 6
A logistics company has migrated to microservices but finds that debugging issues is extremely difficult because a single user request traverses 8–12 services. They can't correlate logs or identify where failures occur in the request chain. What should the architect implement for end-to-end observability?

A) Aggregate all service logs into a single CloudWatch Log Group and search by timestamp.  
B) Implement distributed tracing using AWS X-Ray. Instrument each service with the X-Ray SDK to generate trace segments. X-Ray correlates segments into a complete trace using a trace ID propagated in headers across services. Use the X-Ray service map to visualize dependencies and identify bottlenecks.  
C) Add print statements to every service function and send output to a shared S3 bucket.  
D) Use CloudWatch Container Insights dashboards for each ECS service independently.

**Correct Answer: B**
**Explanation:** AWS X-Ray provides distributed tracing across microservices. The X-Ray SDK generates trace segments in each service. The trace ID (propagated via headers — X-Amzn-Trace-Id) correlates all segments into an end-to-end trace. The service map visualizes all service dependencies and highlights latency/error hotspots. Subsegments show external calls (database, API). Option A doesn't correlate across services. Option C is not a tracing solution. Option D shows per-service metrics but not cross-service request flows.

---

### Question 7
A company is implementing the Saga pattern for a distributed transaction across three microservices: Order, Payment, and Inventory. If the payment succeeds but inventory reservation fails, the payment must be reversed (compensating transaction). The architect needs an orchestrator that manages the saga steps, handles failures, and executes compensations. What AWS service best implements this?

A) Amazon SQS with dead-letter queues for failed messages.  
B) AWS Step Functions with a state machine that defines the saga steps. Each step invokes the corresponding microservice. Error handling states catch failures and invoke compensating transactions (e.g., refund payment if inventory fails). The state machine tracks saga state and ensures exactly-once execution of compensations.  
C) A dedicated "saga coordinator" microservice built on EC2 that manages state in a database.  
D) Amazon EventBridge with rules that trigger compensating actions on failure events.

**Correct Answer: B**
**Explanation:** Step Functions is a natural fit for saga orchestration. The state machine defines each step (Order → Payment → Inventory) with catch blocks for failures. If a step fails, the catch block triggers compensating steps (e.g., RefundPayment, CancelOrder). Step Functions manages state, handles retries, provides visual execution tracking, and ensures at-least-once delivery. Option A doesn't orchestrate multi-step workflows. Option C adds a custom service to build and maintain. Option D is event-driven (choreography, not orchestration) and harder to reason about for compensation chains.

---

### Question 8
A company runs 60 microservices on EKS. They need to enforce mutual TLS (mTLS) between all service-to-service communications without modifying application code. Certificates should be automatically rotated. What should the architect recommend?

A) Implement TLS in each microservice's application code using a custom certificate management library.  
B) Deploy AWS App Mesh with Envoy sidecar proxies on all EKS pods. Enable mTLS using AWS Certificate Manager Private CA for certificate issuance. App Mesh automatically manages certificate distribution and rotation to Envoy sidecars.  
C) Use Kubernetes Secrets to distribute TLS certificates to pods and configure services to use them.  
D) Deploy a reverse proxy (NGINX) in front of each service that handles TLS termination.

**Correct Answer: B**
**Explanation:** App Mesh with Envoy sidecars handles mTLS at the infrastructure layer — no application code changes. ACM Private CA issues and rotates certificates automatically. Envoy proxies intercept all traffic, perform TLS handshake, and verify peer certificates. This provides transparent encryption across all 60 services. Option A requires code changes in every service. Option C requires manual certificate distribution and rotation. Option D requires deploying and managing 60 NGINX instances.

---

### Question 9
A SaaS company has a multi-tenant architecture where each API request includes a tenant ID. They want to implement rate limiting per tenant to prevent a noisy neighbor from consuming all resources. The rate limiting should apply across multiple service instances. What approach should the architect take?

A) Implement rate limiting in each microservice's application code using local in-memory counters.  
B) Deploy Amazon API Gateway in front of the microservices and configure usage plans with API keys per tenant. API Gateway enforces throttling limits (requests per second, burst) per usage plan. For more granular control, use a centralized rate limiter backed by Amazon ElastiCache for Redis with atomic increment operations (INCR with TTL).  
C) Use Application Load Balancer request rate limiting to throttle traffic per tenant.  
D) Over-provision all services so that no tenant can exhaust capacity.

**Correct Answer: B**
**Explanation:** API Gateway usage plans provide built-in per-tenant throttling when each tenant has a unique API key. For complex scenarios (per-endpoint, per-method limits), ElastiCache for Redis provides a distributed rate counter — the INCR command atomically increments per-tenant counters across all service instances, and TTL resets counters at the window boundary. Option A — local counters don't work across multiple instances. Option C — ALB doesn't support per-tenant rate limiting. Option D is expensive and doesn't prevent individual tenant abuse.

---

### Question 10
A company wants to implement the Strangler Fig pattern to gradually migrate a monolithic application to microservices. The monolith runs on EC2 behind an ALB. They want to extract the user authentication module first while keeping all other functionality in the monolith. Users should experience no disruption. How should the architect implement this?

A) Rewrite the entire monolith as microservices in a single big-bang release.  
B) Deploy the new authentication microservice on ECS/Fargate behind the same ALB. Create path-based routing rules to direct /auth/* requests to the new microservice's target group while all other paths continue routing to the monolith's target group. Gradually migrate additional modules by adding new routing rules.  
C) Deploy the authentication microservice in a separate VPC with its own ALB and update DNS.  
D) Run the monolith and microservice side by side and use a feature flag to switch traffic in application code.

**Correct Answer: B**
**Explanation:** The Strangler Fig pattern uses the ALB as a routing layer to incrementally redirect traffic from the monolith to new microservices. Path-based rules allow surgical extraction — /auth/* goes to the new service while everything else stays on the monolith. This is transparent to users. As more modules are extracted, new rules are added. Eventually, the monolith handles no traffic and is decommissioned. Option A is high-risk. Option C requires DNS changes and doesn't support gradual migration at the path level. Option D requires code changes in the monolith.

---

### Question 11
A company has microservices that communicate via synchronous REST APIs. During peak load, the downstream order-processing service becomes a bottleneck, causing request failures in the upstream API. The order processing doesn't need to be real-time — a delay of up to 30 seconds is acceptable. What architectural change should the architect recommend?

A) Scale the order-processing service horizontally to match peak demand.  
B) Decouple the services using Amazon SQS. The upstream API publishes order messages to an SQS queue and returns an immediate acknowledgment (202 Accepted) to the caller. The order-processing service polls the queue and processes orders at its own pace. Use SQS dead-letter queues for failed messages.  
C) Add a Redis cache between the services to buffer requests.  
D) Increase the timeout on the upstream API to wait longer for order-processing responses.

**Correct Answer: B**
**Explanation:** Replacing synchronous coupling with asynchronous messaging (SQS) decouples the services temporally. The upstream API responds immediately (non-blocking), and orders are processed at the downstream service's throughput capacity. SQS buffers traffic spikes naturally. DLQs capture failures for retry/analysis. The 30-second acceptable delay makes asynchronous processing ideal. Option A is expensive for peak-only capacity. Option C doesn't decouple the synchronous dependency. Option D increases latency for all requests and still risks timeouts.

---

### Question 12
A company is designing a microservices architecture for a banking platform. They need to ensure that if the user profile service is deployed with a bug, only 5% of traffic is affected initially, and they can quickly roll back. The services run on Amazon ECS with Fargate. What deployment strategy should the architect implement?

A) Blue/green deployment where 100% of traffic switches to the new version after deployment.  
B) Configure ECS service with a CodeDeploy deployment controller using canary deployment (ECSCanary10Percent5Minutes). Deploy the new task definition with 5% traffic initially routed to the new version via an ALB weighted target group. Monitor CloudWatch alarms (error rate, latency). If alarms trigger, CodeDeploy automatically rolls back. If healthy, traffic shifts to 100% after the canary period.  
C) Deploy the new version as a separate ECS service and manually switch the ALB target group.  
D) Use rolling updates with a minimum healthy percent of 50%.

**Correct Answer: B**
**Explanation:** ECS with CodeDeploy canary deployment provides controlled traffic shifting. The canary sends a small percentage (e.g., 5–10%) to the new version first. CloudWatch alarms monitor error rates and latency — if thresholds are breached, automatic rollback occurs. This limits blast radius to 5% of traffic. Option A shifts 100% immediately (no canary protection). Option C is manual with no automated rollback. Option D — rolling updates replace tasks incrementally but don't control traffic percentage during deployment.

---

### Question 13
A company's microservices architecture has grown to 80 services, and teams frequently break other services during deployments because they don't realize they've changed an API contract. The architect needs to implement a system that detects breaking API changes before they reach production. What should they implement?

A) Comprehensive integration testing in a staging environment before every deployment.  
B) Implement consumer-driven contract testing. Each consumer service defines its expectations (contracts) for each provider's API. During the provider's CI/CD pipeline, contract tests run to verify the new version satisfies all consumer contracts. Use a Pact broker (or store contracts in S3) to share contracts between teams. Deploy AWS CodePipeline with a contract testing stage before the deployment stage.  
C) Use API versioning to avoid all breaking changes.  
D) Require manual API review meetings before each deployment.

**Correct Answer: B**
**Explanation:** Consumer-driven contract testing catches breaking changes at build time, before deployment. Each consumer defines what it needs from a provider's API (the contract). The provider's CI pipeline runs these contracts, failing if any consumer's expectations are broken. This scales to 80 services without requiring full integration environments. A Pact broker or S3 bucket stores contracts centrally. Option A requires maintaining a full 80-service staging environment. Option C doesn't prevent breaking changes within a version. Option D doesn't scale.

---

### Question 14
A company is implementing the CQRS pattern for their product catalog service. Write operations (create, update, delete) go through one path, and read operations (search, browse, recommendations) go through a different, optimized path. Writes are infrequent (1,000/hour) but reads are massive (1 million/hour). How should the architect design this on AWS?

A) Use a single RDS PostgreSQL database for both reads and writes with read replicas.  
B) Use Amazon DynamoDB for the write model (command side) — it stores the canonical product data. Use DynamoDB Streams to capture changes and fan out via Lambda to update read-optimized stores: Amazon OpenSearch for full-text search, ElastiCache for Redis for frequently accessed products, and Amazon Personalize for recommendations. Reads are served from the appropriate read store.  
C) Use Amazon S3 for all product data with CloudFront for caching reads.  
D) Deploy separate RDS instances for reads and writes with database-level replication.

**Correct Answer: B**
**Explanation:** CQRS separates the write model (optimized for consistency) from read models (optimized for specific query patterns). DynamoDB provides a scalable write store. DynamoDB Streams + Lambda propagate changes to purpose-built read stores: OpenSearch for search, ElastiCache for low-latency lookups, Personalize for ML-based recommendations. Each read store is optimized for its query pattern. Option A doesn't optimize reads for different access patterns. Option C doesn't support complex queries. Option D still uses a single data model for all read patterns.

---

### Question 15
A company runs microservices on ECS across multiple AWS accounts — one account per business domain (payments, orders, users). Services in different accounts need to communicate privately. The architect wants a solution that provides service-level connectivity without exposing entire VPC CIDRs and works across accounts. What should they use?

A) VPC peering between all account VPCs.  
B) AWS VPC Lattice — create a service network shared across accounts using AWS RAM. Register each microservice as a VPC Lattice service with target groups. Associate each account's VPCs with the shared service network. Define auth policies for cross-account access control.  
C) Transit Gateway shared across accounts with full VPC routing.  
D) Public-facing ALBs with WAF for cross-account communication.

**Correct Answer: B**
**Explanation:** VPC Lattice provides service-level (not network-level) connectivity across accounts. The shared service network enables any associated VPC to discover and call registered services. Auth policies provide fine-grained access control (which service can call which). Unlike VPC peering or TGW, only registered services are reachable — not entire VPC CIDRs, minimizing blast radius. Option A exposes full VPC CIDRs. Option C provides network-level (not service-level) connectivity. Option D uses public internet.

---

### Question 16
A company's checkout microservice calls the payment, inventory, and shipping services in sequence. If any call fails, the entire checkout fails. The total checkout latency is the sum of all three calls (800ms + 400ms + 300ms = 1,500ms), and the product team wants it under 600ms. The services are independent of each other. What should the architect recommend?

A) Optimize each individual service to reduce its response time.  
B) Redesign the checkout service to call the payment, inventory, and shipping services in parallel using asynchronous patterns (e.g., CompletableFuture in Java, Promise.all in Node.js). Since the services are independent, parallel execution reduces total latency to the maximum of the three calls (~800ms). Combine this with caching frequently used data to reduce individual service latency.  
C) Deploy all three services in the same container to eliminate network latency.  
D) Use SQS to decouple the checkout from the three services.

**Correct Answer: B**
**Explanation:** When downstream calls are independent, parallel invocation reduces total latency from the sum to the maximum of individual calls. 800ms is still above 600ms, so additional optimization (caching inventory data, pre-authorizing payments) further reduces latency. This is a fundamental microservices optimization pattern. Option A alone may not achieve the 600ms target. Option C violates microservices independence. Option D makes checkout asynchronous, which changes the user experience (no immediate confirmation).

---

### Question 17
A company wants to implement an API Gateway pattern for their microservices. External clients should access all microservices through a single endpoint. The gateway should handle authentication, request routing, rate limiting, and request/response transformation. The company has 25 microservices with varying traffic patterns. What should the architect design?

A) Deploy a custom NGINX reverse proxy on EC2 with Lua scripts for authentication and transformation.  
B) Use Amazon API Gateway (REST API) as the single entry point. Configure Lambda authorizers for authentication, resource-based routing to backend services (via VPC Link to NLB/ALB for ECS services), usage plans for rate limiting, and mapping templates for request/response transformation. Use API Gateway caching for frequently accessed responses.  
C) Expose each microservice with its own public ALB endpoint.  
D) Use CloudFront as the API gateway with Lambda@Edge for authentication.

**Correct Answer: B**
**Explanation:** Amazon API Gateway is a managed API gateway that provides all required features natively: Lambda authorizers for custom authentication, VPC Link for private backend connectivity, usage plans for per-client rate limiting, and mapping templates for transformation. Caching reduces backend load. It's fully managed with automatic scaling. Option A requires managing and scaling infrastructure manually. Option C exposes each service independently (no single entry point). Option D — CloudFront isn't designed as an API gateway and lacks native routing, throttling, and transformation.

---

### Question 18
A streaming company has microservices that process real-time user activity events (plays, pauses, searches). Events must be processed in order per user and at least once. The system handles 500,000 events per second at peak. What should the architect use for event ingestion and processing?

A) Amazon SQS Standard queue with high throughput and multiple consumers.  
B) Amazon Kinesis Data Streams with the user ID as the partition key. This ensures all events for a given user go to the same shard (maintaining per-user ordering). Consumer applications use the Kinesis Client Library (KCL) for parallel shard processing with at-least-once delivery.  
C) Amazon SNS for event fan-out to multiple consumers.  
D) Amazon MQ (RabbitMQ) for ordered message processing.

**Correct Answer: B**
**Explanation:** Kinesis Data Streams provides ordered, at-least-once delivery per partition key. Using user ID as the partition key ensures all events for a user land on the same shard, maintaining per-user order. KCL manages consumer parallelism and checkpointing. Kinesis scales to millions of records per second. Option A — SQS Standard doesn't guarantee ordering. Option C — SNS is pub-sub, not a stream (no ordering or replay). Option D — RabbitMQ can't scale to 500K events/second without significant infrastructure.

---

### Question 19
A company's microservices architecture uses Amazon SQS for inter-service communication. They notice that some messages are processed multiple times, causing duplicate order charges. The architect needs to ensure exactly-once processing. What should they implement?

A) Use SQS FIFO queues with message deduplication IDs. FIFO queues guarantee exactly-once delivery within a 5-minute deduplication window. Additionally, implement idempotency in the consumer — use a DynamoDB table to track processed message IDs and skip duplicates. This provides belt-and-suspenders protection.  
B) Reduce the SQS visibility timeout to prevent duplicate reads.  
C) Use SQS Standard queues with a longer retention period.  
D) Implement a single consumer with no parallelism to prevent concurrent processing of the same message.

**Correct Answer: A**
**Explanation:** SQS FIFO queues with deduplication IDs prevent the same message from being enqueued twice within a 5-minute window. However, for true exactly-once processing, the consumer must be idempotent — checking a deduplication store (DynamoDB with message ID as partition key) before processing ensures that even if a message is delivered twice (edge cases), the consumer processes it only once. Option B doesn't prevent duplicate delivery. Option C — Standard queues have at-least-once delivery by design. Option D sacrifices scalability.

---

### Question 20
An organization has adopted microservices but struggles with data consistency across services. The order service uses DynamoDB, the inventory service uses Aurora PostgreSQL, and the payment service uses a third-party API. They need to ensure that an order creation, inventory deduction, and payment charge either all succeed or all roll back. What pattern should the architect use?

A) Use a distributed transaction coordinator (two-phase commit) across all three data stores.  
B) Implement the Saga pattern using AWS Step Functions as the orchestrator. Define the happy path: CreateOrder → DeductInventory → ChargePayment. Define compensating transactions for each step: CancelPayment → RestoreInventory → CancelOrder. Step Functions' error handling triggers compensations on failure. Accept eventual consistency between services.  
C) Use a single Aurora PostgreSQL database for all three services with traditional ACID transactions.  
D) Implement change data capture from DynamoDB Streams and Aurora event notifications to synchronize all services.

**Correct Answer: B**
**Explanation:** The Saga pattern manages distributed transactions through a sequence of local transactions with compensating transactions for rollback. Step Functions orchestrates the saga, tracking state and triggering compensations on failure. Two-phase commit (Option A) doesn't work across DynamoDB, Aurora, and third-party APIs. Option C violates microservices independence (shared database anti-pattern). Option D provides change propagation but not transactional consistency. Sagas accept eventual consistency, which is the correct trade-off for microservices.

---

### Question 21
A company operates microservices on EKS and uses AWS App Mesh for service mesh functionality. They want to implement traffic splitting to send 90% of traffic to v1 of a service and 10% to v2 for A/B testing. How should this be configured?

A) Use Kubernetes Ingress with annotation-based traffic splitting.  
B) Define two virtual nodes in App Mesh — one for v1 and one for v2. Create a virtual router with a route that has a weighted target: 90% to the v1 virtual node and 10% to the v2 virtual node. The virtual service points to this virtual router. Envoy sidecars enforce the traffic split transparently.  
C) Deploy v1 with 9 replicas and v2 with 1 replica, and use round-robin load balancing.  
D) Use Route 53 weighted routing between two separate ALBs.

**Correct Answer: B**
**Explanation:** App Mesh virtual routers support weighted routing between virtual nodes. This provides precise traffic splitting at the service mesh layer — Envoy sidecars handle the routing transparently. Changes to traffic weights don't require redeployment, just a mesh configuration update. Option A — standard Kubernetes Ingress doesn't support weighted routing. Option C — replica-based traffic splitting is imprecise and couples scaling with traffic distribution. Option D operates at DNS level with TTL delays, not suitable for fine-grained A/B testing.

---

### Question 22
A company's microservices generate events that multiple downstream services need to process independently. The events are: OrderPlaced, OrderShipped, and OrderDelivered. Different services care about different events — the notification service needs all three, the analytics service needs OrderPlaced and OrderDelivered, and the inventory service only needs OrderPlaced. What architecture provides efficient event routing?

A) Create separate SQS queues for each event type and have the producer send to all relevant queues.  
B) Use Amazon SNS with message filtering. Create an SNS topic for order events. Each consumer subscribes with a filter policy matching the event types they care about. The producer publishes events with a "eventType" message attribute. SNS delivers only matching events to each subscriber.  
C) Use Amazon EventBridge with event rules. The producer publishes structured events to a custom event bus. Each consumer creates rules with event patterns matching their event types of interest. EventBridge routes matched events to the consumer's target (SQS, Lambda, etc.).  
D) Use a shared database table where consumers query for their relevant events.

**Correct Answer: C**
**Explanation:** EventBridge provides content-based routing with event patterns that match on any event field, not just attributes. Rules enable fine-grained filtering, and each consumer independently defines what events they receive. EventBridge also provides schema discovery, replay, and archive capabilities. Option B (SNS) also works well for this scenario with message filtering, but EventBridge provides richer filtering and better cross-service event management. Option A couples the producer to consumers. Option D is a polling anti-pattern.

---

### Question 23
A company's API serves mobile and web clients. Mobile clients need compact JSON responses (minimal fields), while web clients need rich responses with embedded related resources. A single API endpoint should serve both, adapting the response format. What pattern should the architect implement?

A) Create separate API endpoints for mobile and web clients.  
B) Implement the Backend for Frontend (BFF) pattern — deploy separate API compositions for mobile and web. Each BFF aggregates data from backend microservices and shapes the response for its client type. Alternatively, use API Gateway with mapping templates and request context (User-Agent header or custom header) to transform responses per client type.  
C) Return the full response to all clients and let clients parse what they need.  
D) Use GraphQL, which lets clients specify exactly which fields they want in the query.

**Correct Answer: B**
**Explanation:** The BFF pattern creates client-specific API layers that aggregate and shape data appropriately. For mobile, the BFF returns compact responses; for web, rich responses. API Gateway mapping templates can also implement lightweight BFF logic by transforming backend responses based on request context. Option A duplicates backend logic. Option C wastes bandwidth for mobile clients. Option D (GraphQL) is also a valid approach for field selection but requires all clients to adopt GraphQL — the question asks about adapting without requiring client changes.

---

### Question 24
A company runs 30 microservices on ECS Fargate with each service having its own database (database-per-service pattern). They need a way for services to query data owned by other services without direct database access. The query response time must be under 100ms. What approach should the architect recommend?

A) Allow services to directly query other services' databases using cross-service database connections.  
B) Implement an API composition pattern — the calling service queries data from other services through their published APIs. For frequently accessed data, use ElastiCache as a local cache per service. For complex cross-service queries, deploy a query composition service that aggregates data from multiple service APIs in parallel and caches results.  
C) Replicate all databases into a single data warehouse for cross-service queries.  
D) Use DynamoDB global tables shared across all services.

**Correct Answer: B**
**Explanation:** The API composition pattern maintains service autonomy — each service exposes data through its API, and consumers query through these APIs. Caching with ElastiCache ensures sub-100ms responses for frequently accessed data. A composition service handles complex joins across services. This preserves the database-per-service pattern's encapsulation. Option A violates service boundaries and creates tight coupling. Option C adds latency for real-time queries. Option D is a shared database anti-pattern.

---

### Question 25
A company's microservices application uses synchronous REST calls between services, creating a deep call chain: A → B → C → D. Service D has a P99 latency of 200ms, which propagates up the chain. The total P99 latency at Service A is over 1 second. The architect needs to reduce end-to-end latency. Which strategies should they use? (Select TWO.)

A) Convert unnecessary synchronous calls to asynchronous messaging (SQS/EventBridge) where immediate responses aren't required.  
B) Increase compute resources for all services uniformly.  
C) Implement connection pooling and keep-alive connections between services to reduce TCP handshake overhead.  
D) Add more services to the call chain for better separation of concerns.  
E) Deploy all services in the same container to eliminate network calls.

**Correct Answer: A, C**
**Explanation:** (A) Converting synchronous calls to asynchronous where possible removes wait time — if Service B doesn't need Service C's response to reply to Service A, the call should be async. (C) Connection pooling eliminates TCP handshake overhead (including TLS) on repeated calls, reducing per-call latency significantly. Option B doesn't address architectural latency. Option D increases the chain length, worsening latency. Option E violates microservices principles and makes independent deployment impossible.

---

### Question 26
A company is building an event-driven microservices architecture. They need to ensure that events are not lost, even when consumer services are temporarily unavailable. Events should be replayable for debugging and reprocessing. What is the most resilient event infrastructure?

A) Use Amazon SNS with HTTP subscribers and automatic retries.  
B) Use Amazon EventBridge with an event archive and replay feature. Events are published to a custom event bus. If a consumer's target (Lambda, SQS) fails to process, EventBridge retries with exponential backoff. For long-term durability and replay, configure an event archive on the event bus with an appropriate retention period. Failed events route to an SQS dead-letter queue for investigation.  
C) Store events in a Redis Pub/Sub channel.  
D) Write events to a log file on EBS volumes.

**Correct Answer: B**
**Explanation:** EventBridge provides built-in retry with exponential backoff for failed targets, DLQ integration for persistent failures, and an archive/replay feature for event reprocessing. Archives store events indefinitely (or per retention policy), enabling debugging and reprocessing by replaying archived events to the bus. Option A — SNS retries for HTTP are limited, and there's no built-in archive/replay. Option C — Redis Pub/Sub is volatile (no persistence if subscriber is offline). Option D — EBS logs are not accessible across services and have no replay mechanism.

---

### Question 27
A company runs a critical order-processing pipeline using Step Functions. The state machine calls Lambda functions for each processing step. They need to handle transient errors (like temporary DynamoDB throttling) differently from permanent errors (like invalid data). What error-handling strategy should the architect implement?

A) Catch all errors uniformly and retry every failure the same number of times.  
B) Use Step Functions' built-in Retry and Catch fields. Configure Retry with exponential backoff for transient errors (DynamoDB throttling, Lambda timeout) with a specific number of retries. Use Catch blocks for permanent errors (validation failures, business logic errors) that route to a compensation or error-handling state. Use different error codes to distinguish transient from permanent failures.  
C) Implement all retry logic inside the Lambda functions and never retry at the Step Functions level.  
D) Let the Step Functions execution fail and manually re-run it.

**Correct Answer: B**
**Explanation:** Step Functions Retry and Catch provide declarative error handling. Retry configurations specify which error types trigger retries, backoff rates, and max attempts — ideal for transient errors that resolve themselves. Catch blocks route permanent errors to different states (error handling, compensation, human review). Using Lambda error codes (e.g., TransientError, ValidationError) enables precise routing. Option A treats all errors the same, wasting retries on permanent failures. Option C duplicates retry logic across functions. Option D provides no automated resilience.

---

### Question 28
A company's microservices architecture uses Amazon DynamoDB for most services. As the number of services grows, they notice that many services have created similar DynamoDB tables with redundant data (e.g., multiple services store user information). This leads to data inconsistency and increased DynamoDB costs. What architectural pattern should the architect recommend?

A) Consolidate all data into a single shared DynamoDB table that all services access.  
B) Maintain the database-per-service pattern but designate the User service as the single source of truth for user data. Other services that need user data must call the User service API. For performance, services can maintain a local cache (ElastiCache) that is invalidated when user data changes (via events from the User service through EventBridge/SNS).  
C) Replicate user data to every service's database using DynamoDB Streams.  
D) Use a service mesh to intercept and redirect database calls to the correct service.

**Correct Answer: B**
**Explanation:** The "single source of truth" principle in microservices means each piece of data has one owning service. The User service owns user data, and other services access it through the User service API. Local caching improves performance while event-driven invalidation maintains consistency. This eliminates redundant tables and data inconsistency. Option A is the shared database anti-pattern. Option C replicates the redundancy problem. Option D — service meshes don't redirect database queries.

---

### Question 29
A company is implementing a microservices-based e-commerce platform. They want to deploy new features to a subset of users for testing (feature flags / dark launches). The feature flag state must be available to all service instances with low latency and should support real-time updates without redeployment. What should the architect recommend?

A) Use environment variables in ECS task definitions for feature flags and redeploy when flags change.  
B) Use AWS AppConfig (part of Systems Manager) for feature flag management. Services read flag values from AppConfig using the AppConfig Lambda extension or agent. AppConfig supports gradual rollouts, validation, and instant updates. For sub-millisecond reads, cache flag values locally in each service with a configurable refresh interval.  
C) Store feature flags in a JSON file in S3 and have services poll it every minute.  
D) Implement feature flags in the API Gateway layer only.

**Correct Answer: B**
**Explanation:** AWS AppConfig provides managed feature flag management with deployment strategies (linear, canary, all-at-once), validation hooks (Lambda, JSON Schema), and rollback. The AppConfig agent/extension caches flags locally for low-latency reads and polls for updates. Changes propagate without redeployment. Option A requires container redeployment for every flag change. Option C has 1-minute stale data risk and no deployment safety. Option D — feature flags often need to be evaluated deep in service logic, not just at the API level.

---

### Question 30
A company has microservices communicating through Amazon SQS. A message published by the order service needs to be consumed by both the shipping service and the billing service independently (each needs its own copy). What messaging pattern should the architect use?

A) The order service sends the message to two separate SQS queues (one for shipping, one for billing).  
B) Use the fan-out pattern with Amazon SNS + SQS. The order service publishes the message to an SNS topic. Both the shipping and billing services have SQS queues subscribed to the topic. SNS delivers a copy of the message to each queue independently. Services consume from their own queue.  
C) Use a single SQS queue with two consumer groups sharing the queue.  
D) Have the order service make direct API calls to both services.

**Correct Answer: B**
**Explanation:** The SNS-SQS fan-out pattern decouples the publisher from consumers. The order service publishes once to an SNS topic, and SNS delivers copies to all subscribed SQS queues. Each service processes from its own queue independently (different rates, different retry policies). Adding a new consumer is as simple as subscribing another queue. Option A couples the publisher to specific consumers. Option C — SQS doesn't support consumer groups (messages go to one consumer). Option D creates tight coupling and sequential dependency.

---

### Question 31
A company is designing their microservices for resilience. They want to implement the bulkhead pattern to isolate failures in one service from affecting others. Their services run on EKS. How should the architect implement bulkheads?

A) Deploy all services in the same pod with shared resources.  
B) Implement bulkheads at multiple levels: (1) Separate EKS node groups per critical service domain with resource limits, (2) Kubernetes resource quotas per namespace to prevent one service from consuming all cluster resources, (3) In the Envoy sidecar (via App Mesh), configure connection pool limits per upstream service to prevent one slow service from exhausting all outbound connections.  
C) Use a single large EC2 instance for all services.  
D) Implement rate limiting at the API Gateway only.

**Correct Answer: B**
**Explanation:** The bulkhead pattern isolates failures by partitioning resources. Multiple bulkhead levels provide defense in depth: separate node groups prevent infrastructure-level interference, namespace resource quotas prevent resource starvation, and Envoy connection pool limits prevent a slow downstream service from exhausting the calling service's connection threads. Option A shares failure domains. Option C concentrates all risk on one instance. Option D is only at the edge, not between internal services.

---

### Question 32
A company is migrating from a monolithic application to microservices. The monolith has a single relational database with complex foreign key relationships across modules (users, orders, products, inventory). They want to decompose the database to support the database-per-service pattern. What is the recommended approach?

A) Copy the entire database for each microservice and keep them in sync with replication.  
B) Identify bounded contexts in the domain model. For each bounded context (orders, inventory, users), create a separate database containing only that context's tables. Replace cross-context foreign keys with service-level APIs (the order service calls the user service API instead of joining the users table). Use eventual consistency with events for cross-service data synchronization where needed. Migrate data incrementally, keeping the monolith database operational during the transition.  
C) Use a single shared database with schema-level access controls per service.  
D) Use a NoSQL database that doesn't enforce foreign keys so all services can share it.

**Correct Answer: B**
**Explanation:** Database decomposition follows domain-driven design (DDD) bounded contexts. Each context gets its own database, and cross-context relationships become service API calls. This enables independent scaling, technology choices, and deployment. Eventual consistency (via events) replaces transactional consistency across contexts. Incremental migration reduces risk. Option A creates massive data redundancy. Option C is the shared database anti-pattern. Option D removes the structural constraint but doesn't achieve true decomposition.

---

### Question 33
A company has a microservices architecture where the product catalog service is experiencing increased read latency as the catalog grows to 10 million products. Read traffic is 100x write traffic. The service uses DynamoDB. What should the architect do to improve read performance without affecting writes?

A) Increase DynamoDB read capacity units until latency improves.  
B) Implement a read-through cache using DynamoDB Accelerator (DAX). DAX provides microsecond latency for cached reads while DynamoDB handles writes. For complex queries (search, faceted filtering), replicate product data to Amazon OpenSearch Service using DynamoDB Streams + Lambda for indexing. Serve search queries from OpenSearch.  
C) Migrate to Aurora PostgreSQL for better read performance.  
D) Create a Global Secondary Index for every query pattern.

**Correct Answer: B**
**Explanation:** DAX is a write-through cache that sits in front of DynamoDB, providing microsecond response times for repeated reads without modifying application code (drop-in replacement for DynamoDB SDK). For complex search queries not suited to DynamoDB's key-value model, OpenSearch provides full-text search and aggregations. DynamoDB Streams keeps OpenSearch in near-real-time sync. Option A adds cost without architectural improvement. Option C is a migration, not optimization. Option D — GSIs help with query patterns but don't reduce latency like caching does.

---

### Question 34
A company runs a high-traffic API on Amazon API Gateway (REST API) with Lambda backends. During a flash sale, the API hits Lambda concurrency limits and returns 429 (throttled) responses. The company wants to handle traffic spikes gracefully without losing requests. What should the architect implement?

A) Increase Lambda reserved concurrency to the maximum account limit.  
B) Place an SQS queue between API Gateway and Lambda. API Gateway sends requests to SQS (using the SQS service integration) and returns 202 Accepted immediately. A Lambda function processes messages from the queue at a controlled rate using reserved concurrency and batching. For requests requiring synchronous responses, use API Gateway's Lambda proxy integration with provisioned concurrency to handle the expected peak load.  
C) Replace Lambda with EC2 instances behind an ALB that auto-scales.  
D) Cache all API responses in API Gateway to reduce Lambda invocations.

**Correct Answer: B**
**Explanation:** This combines two strategies: (1) For fire-and-forget requests (order submission, event tracking), SQS decouples ingestion from processing — API Gateway queues the request and returns immediately. Lambda processes the queue at its own pace. (2) For synchronous requests requiring immediate responses, provisioned concurrency pre-warms Lambda functions to handle expected peaks without cold starts or throttling. Option A has account-level limits. Option C loses serverless benefits. Option D only works for identical, cacheable GET requests.

---

### Question 35
A company is implementing health checks for their microservices running on ECS behind an ALB. They want to differentiate between a service that is starting up (not ready yet) and a service that has failed (needs to be replaced). What health check strategy should the architect implement?

A) Use a single /health endpoint that returns 200 when the service is fully ready.  
B) Implement separate health check endpoints: a /health/liveness endpoint that indicates the process is running (used by ECS task health check for container replacement) and a /health/readiness endpoint that indicates the service is ready to accept traffic (used by the ALB target group health check for routing). During startup, liveness returns 200 but readiness returns 503 until the service completes initialization (loading caches, establishing DB connections). This prevents the ALB from routing traffic to a starting service while also preventing ECS from restarting a healthy-but-initializing container.  
C) Use only the ALB health check and let it detect all failure modes.  
D) Disable health checks and rely on CloudWatch alarms for monitoring.

**Correct Answer: B**
**Explanation:** Separating liveness (is the process alive?) from readiness (can it serve traffic?) prevents two failure modes: (1) Routing traffic to a service still initializing (causes errors) and (2) Killing a healthy service that's just slow to start. The ALB uses readiness to control traffic routing, while ECS uses liveness to decide if the container should be replaced. Option A conflates startup delay with failure. Option C only detects failures after they affect traffic. Option D provides no automated recovery.

---

### Question 36
A company's microservices log to CloudWatch Logs. With 50 services generating thousands of log lines per second, they struggle to find relevant logs during incidents. They need a centralized logging solution with fast search, correlation across services, and alerting on error patterns. What should the architect design?

A) Continue using separate CloudWatch Log Groups per service and search manually.  
B) Stream CloudWatch Logs from all services to Amazon OpenSearch Service using CloudWatch Logs subscription filters. Create an OpenSearch dashboard (Kibana) for centralized log analysis. Use correlation IDs (trace IDs from X-Ray) embedded in log entries to trace requests across services. Create OpenSearch alerts for error rate thresholds.  
C) Store all logs in S3 and use Athena for ad-hoc queries.  
D) Reduce logging verbosity to minimize log volume.

**Correct Answer: B**
**Explanation:** OpenSearch provides full-text search, aggregation, and visualization for centralized logging. Subscription filters stream logs in near-real-time. Correlation IDs (embedded in structured JSON logs) enable cross-service request tracing in OpenSearch. Dashboards provide real-time visibility. Alerts on error patterns enable proactive incident detection. Option A doesn't scale for 50 services. Option C is for batch analysis, not real-time incident response. Option D loses valuable debugging information.

---

### Question 37
A company runs microservices on ECS and wants to implement zero-downtime deployments. The current deployment process causes brief 502 errors because new containers aren't ready when old ones are terminated. What should the architect configure?

A) Increase the number of running tasks to absorb the deployment surge.  
B) Configure ECS deployment with minimum healthy percent of 100% and maximum percent of 200%. Enable ALB connection draining (deregistration delay) of 30 seconds on the target group. Set the ALB health check grace period on the ECS service to match the application's startup time. Configure the container's health check startPeriod to allow initialization time before health checks begin failing.  
C) Deploy during off-peak hours when traffic is low.  
D) Use Lambda instead of ECS to eliminate deployment concerns.

**Correct Answer: B**
**Explanation:** Zero-downtime deployment requires coordination: (1) min healthy 100% ensures old tasks aren't removed before new ones are healthy. (2) Max 200% allows ECS to launch new tasks before removing old ones. (3) Health check grace period prevents ECS from marking starting tasks as unhealthy. (4) Container startPeriod gives applications time to initialize. (5) ALB deregistration delay allows in-flight requests to complete on old tasks before they're terminated. Option A doesn't solve the deployment sequence issue. Option C isn't zero-downtime. Option D changes the architecture entirely.

---

### Question 38
A company's microservices use Amazon RDS PostgreSQL. Each service has its own database instance. Database costs are high because many services have over-provisioned instances. Services have variable workloads — some are busy during business hours, others at night. What should the architect recommend to optimize costs?

A) Move all services to a single RDS instance with separate schemas.  
B) Migrate services to Amazon Aurora Serverless v2, which automatically scales compute capacity (ACUs) up and down based on demand. Set minimum ACUs low for cost savings during idle periods and maximum ACUs to handle peak load. For services with predictable workloads, use Aurora provisioned instances with right-sized instance types based on CloudWatch metrics analysis.  
C) Replace all RDS instances with DynamoDB on-demand tables.  
D) Schedule RDS instances to stop during off-hours using Lambda + EventBridge.

**Correct Answer: B**
**Explanation:** Aurora Serverless v2 scales compute in fine-grained increments (0.5 ACU steps) based on actual demand, eliminating over-provisioning. Services with variable workloads benefit from automatic scaling — they pay only for resources consumed. Services with steady, predictable workloads can use right-sized provisioned Aurora instances. Option A is the shared database anti-pattern. Option C requires application code changes for a different data model. Option D — stopping databases loses availability for services that might need them.

---

### Question 39
A company is implementing a microservices gateway using Amazon API Gateway. They need to aggregate responses from three backend services (user-profile, preferences, recent-activity) into a single API response for the mobile app's dashboard screen. API Gateway alone cannot orchestrate multiple backend calls and merge responses. What should the architect design?

A) Have the mobile app make three separate API calls and aggregate on the client.  
B) Create a Lambda function as the API Gateway backend integration. The Lambda function concurrently calls the three backend services (using async programming), aggregates the responses into a single JSON object, and returns it. Use Lambda provisioned concurrency for consistent performance and ElastiCache to cache individual service responses.  
C) Use API Gateway's VTL mapping templates to call multiple backends.  
D) Create a dedicated "dashboard" microservice on ECS that aggregates the data.

**Correct Answer: B**
**Explanation:** Lambda provides serverless compute for the aggregation logic. Concurrent calls to the three services minimize latency (total = max of individual service latencies). Provisioned concurrency eliminates cold starts. Caching reduces backend load. This is the Backend for Frontend (BFF) pattern implemented serverlessly. Option A increases mobile app complexity and requires three network round trips over cellular. Option C — VTL cannot make external service calls. Option D works but requires managing ECS infrastructure for what is a simple aggregation function.

---

### Question 40
A company has a microservices architecture on EKS. They notice that service-to-service communication is unreliable during node scaling events — requests fail when pods are being terminated on scaling-down nodes. What should the architect implement?

A) Disable node scaling to prevent disruptions.  
B) Configure Kubernetes pod disruption budgets (PDBs) to ensure a minimum number of pods are always running during scaling events. Implement graceful shutdown in microservices — handle SIGTERM signals, stop accepting new requests, drain in-flight requests (with a timeout), then exit. Configure the ECS/EKS preStop lifecycle hook to delay SIGTERM until the pod is removed from the service endpoint. Set the terminationGracePeriodSeconds to allow sufficient drain time.  
C) Over-provision the cluster so scaling down never happens.  
D) Use spot instances to reduce the impact of node termination.

**Correct Answer: B**
**Explanation:** The issue is that pods receive traffic after starting to terminate. PDBs limit how many pods can be disrupted simultaneously. Graceful shutdown ensures in-flight requests complete before the pod exits. The preStop hook delays SIGTERM, giving the Kubernetes endpoint controller time to remove the pod from service endpoints (stopping new traffic). terminationGracePeriodSeconds provides the timeout window. This ensures zero dropped requests during scale-down. Option A sacrifices cost efficiency. Option C is expensive. Option D makes the problem worse.

---

### Question 41
A company wants to implement the Outbox pattern for reliable event publishing in their microservices. The order service writes to its database and needs to publish an event to SNS, but publishing directly to SNS after the DB write might fail (leaving the database updated but no event published). How should the architect implement the transactional outbox pattern?

A) Use a two-phase commit between the database and SNS.  
B) Write both the order record and an event record to the same database in a single transaction (the event record goes into an "outbox" table). Use DynamoDB Streams (or change data capture for RDS) to capture new outbox records. A Lambda function processes the stream, publishes the event to SNS, and marks the outbox record as processed.  
C) Publish to SNS first, and if successful, write to the database.  
D) Accept that some events may be lost and implement manual reconciliation.

**Correct Answer: B**
**Explanation:** The transactional outbox pattern ensures atomicity by writing the domain record and the event record in the same database transaction. Since they're in the same database, ACID guarantees ensure both succeed or both fail. Change data capture (DynamoDB Streams, Aurora CDC) asynchronously reads the outbox and publishes events. This provides at-least-once event delivery without distributed transactions. Option A — two-phase commit doesn't work between DynamoDB and SNS. Option C — if the DB write fails, you've sent an event for a non-existent order. Option D is unacceptable for financial systems.

---

### Question 42
A company is modernizing their monolithic application to microservices. During the transition, some business logic still lives in the monolith while new features are built as microservices. The monolith and new microservices need to share user authentication state (session data). What approach maintains backward compatibility while enabling the microservices transition?

A) Require users to log in separately to the monolith and each microservice.  
B) Extract the authentication logic into a dedicated auth service (running on ECS). Issue JWT tokens from the auth service. The monolith validates JWTs using the shared public key. New microservices validate JWTs using the same public key. Store refresh tokens and session metadata in ElastiCache for Redis (shared across all services). Use Amazon Cognito or a custom OAuth2/OIDC implementation.  
C) Share the monolith's session cookie with microservices by running everything on the same domain.  
D) Store session data in a shared RDS database accessed by all services.

**Correct Answer: B**
**Explanation:** Extracting auth into a dedicated service follows microservices principles while maintaining shared auth state. JWT tokens are self-contained (stateless verification using public keys), enabling both the monolith and microservices to verify identity without calling the auth service on every request. ElastiCache stores session/refresh token metadata for centralized session management. This approach works during and after the migration. Option A is terrible UX. Option C is fragile and doesn't work across services on different ports/domains. Option D creates a shared database anti-pattern.

---

### Question 43
A company's microservices architecture sends 50,000 events per second through Amazon Kinesis Data Streams. A consumer service that processes these events falls behind during peak hours, and the Kinesis iterator age metric increases to several hours. What should the architect do to help the consumer keep up?

A) Increase the Kinesis shard count proportionally and scale the consumer application instances (KCL workers). Each KCL worker processes one shard, so more shards enable more parallel consumption. Additionally, optimize the consumer's processing logic to reduce per-record processing time.  
B) Reduce the number of events produced to match consumer capacity.  
C) Switch from Kinesis to SQS for better scaling.  
D) Increase the Kinesis data retention period to give the consumer more time.

**Correct Answer: A**
**Explanation:** Kinesis parallelism is shard-based — each shard supports up to 2 MB/s reads. Increasing shards increases aggregate throughput. KCL automatically distributes shards across workers, so adding workers enables parallel processing. Optimizing consumer logic (batch processing, reducing external calls) increases per-shard throughput. Option B limits the producer, which isn't acceptable. Option C — SQS doesn't maintain ordering (important for event processing). Option D just delays the problem; the consumer still can't keep up.

---

### Question 44
A company's API Gateway serves both public (unauthenticated) and private (authenticated) API endpoints. They want to implement authentication using JWT tokens issued by Amazon Cognito, but some endpoints (health check, public product listing) should not require authentication. How should this be configured?

A) Deploy two separate API Gateways — one public and one private.  
B) Use a Cognito User Pool authorizer on the API Gateway. Apply the authorizer to specific methods/resources that require authentication. Leave public endpoints (health check, product listing) without an authorizer, making them accessible without a JWT. Configure CORS and resource policies for additional security on public endpoints.  
C) Implement authentication in each backend Lambda function rather than at the API Gateway.  
D) Use IAM authorization for all endpoints and create public IAM roles.

**Correct Answer: B**
**Explanation:** API Gateway authorizers are applied per-method, not globally. By attaching the Cognito authorizer only to protected resources and leaving public endpoints unprotected, you achieve mixed authentication on a single API. This is operationally simpler than managing two API Gateways. Resource policies and CORS provide additional security controls. Option A doubles infrastructure and management. Option C moves auth logic into every function, duplicating code. Option D — IAM auth requires SigV4 signing, which isn't practical for public endpoints.

---

### Question 45
A company is implementing the Backends for Frontends (BFF) pattern with three client types: web, iOS, and Android. Each BFF aggregates data from shared backend microservices. The web BFF is high traffic (10,000 rps), iOS is medium (3,000 rps), and Android is low (1,000 rps). What compute strategy optimizes cost for each BFF?

A) Deploy all three BFFs on the same ECS service with shared scaling.  
B) Deploy the web BFF on ECS Fargate with application auto-scaling based on ALB request count metrics. Deploy the iOS and Android BFFs as Lambda functions behind API Gateway — their lower, more variable traffic makes serverless cost-effective (pay per request). Use provisioned concurrency on the iOS Lambda during known peak hours.  
C) Deploy all three BFFs on Lambda.  
D) Deploy all three BFFs on dedicated EC2 instances.

**Correct Answer: B**
**Explanation:** Matching compute to traffic patterns optimizes cost. The web BFF's sustained high traffic (10K rps) benefits from ECS Fargate's predictable per-second pricing with auto-scaling. iOS and Android BFFs' lower, variable traffic maps well to Lambda's per-request pricing — no cost when idle. Provisioned concurrency for iOS handles known peaks without cold starts. Option A doesn't optimize per-BFF. Option C — Lambda at 10K rps may be more expensive than Fargate. Option D requires managing instances and over-provisioning for peaks.

---

### Question 46
A company runs 25 microservices that each publish domain events. Different teams own different services. There's no standard event schema, causing integration issues and breaking changes when event formats change. The architect needs to implement event schema governance. What should they implement?

A) Use a shared documentation wiki for event schemas.  
B) Use Amazon EventBridge Schema Registry. Register event schemas for each service's domain events. Enable schema discovery on the event bus to automatically detect and register new schemas. Generate code bindings for consumers using the registry API. Implement EventBridge schema validation in producer services' CI/CD pipelines to prevent publishing non-conforming events. Use schema versioning for backward compatibility.  
C) Enforce a single JSON format for all events regardless of domain.  
D) Allow each team to define their own formats and handle incompatibilities in consumer code.

**Correct Answer: B**
**Explanation:** EventBridge Schema Registry provides centralized schema management with discovery, versioning, and code generation. Schema discovery automatically detects event shapes from the bus. Code bindings ensure type safety in consumers. CI/CD validation prevents schema violations before deployment. Versioning supports backward-compatible evolution. Option A relies on manual documentation (outdated quickly). Option C is too rigid — different domains have different data structures. Option D leads to integration chaos.

---

### Question 47
A company's ECS microservices occasionally fail due to downstream dependency outages. They want to implement the retry pattern with intelligent backoff to handle transient failures without overwhelming the downstream service. The retry logic should be configurable per-service without code changes. What should the architect recommend?

A) Implement retry logic in every microservice's application code.  
B) Use AWS App Mesh with Envoy sidecar proxies. Configure retry policies in the App Mesh virtual route specification — defining max retries, retry conditions (HTTP 5xx, connection errors), and backoff intervals. Envoy handles retries transparently at the proxy level. Changes to retry configuration update the App Mesh resource (no code changes or redeployment needed).  
C) Use ALB retry functionality for failed requests.  
D) Deploy a retry proxy (Polly/Resilience4j) as a shared library that all services must include.

**Correct Answer: B**
**Explanation:** App Mesh/Envoy implements retry logic at the infrastructure layer, completely outside application code. Retry policies are defined in the mesh configuration (max retries, retry-on conditions, backoff intervals) and applied by the Envoy sidecar. Configuration changes are hot-reloaded — no service redeployment needed. Option A requires code changes in every service and consistent implementation. Option C — ALBs don't retry failed requests to the same target. Option D requires library integration in every service and redeployment for config changes.

---

### Question 48
A company is building a marketplace platform. When a seller lists a new product, multiple services must react: the search service indexes the product, the recommendation engine updates its model, the notification service alerts subscribed buyers, and the analytics service records the listing. The company wants to avoid a single event bus becoming a single point of failure. What resilient architecture should they design?

A) The listing service calls each consuming service's API directly with retries.  
B) Use Amazon EventBridge with a custom event bus for the "product" domain. Deploy an SQS queue as a buffer for each consumer, subscribed to the event bus via rules. Each consumer reads from its own SQS queue. If EventBridge is temporarily unavailable, the listing service writes events to a local DynamoDB outbox table, and a DynamoDB Streams-triggered Lambda retries publishing to EventBridge.  
C) Use a single SQS queue for all consumers.  
D) Store events in S3 and have consumers poll every minute.

**Correct Answer: B**
**Explanation:** This design combines multiple resilience layers: (1) EventBridge provides managed event routing with built-in HA. (2) SQS queues per consumer provide independent buffering — if one consumer is slow, others aren't affected. (3) The outbox pattern with DynamoDB ensures events aren't lost even if EventBridge is momentarily unreachable. Each consumer processes at its own pace from its own queue. Option A creates tight coupling. Option C forces all consumers to share a queue (one slow consumer blocks others). Option D has unacceptable latency.

---

### Question 49
A company is migrating a monolithic .NET application to microservices on AWS. The monolith uses SQL Server with stored procedures for business logic. They want to gradually extract microservices while keeping the stored procedures functional during the transition. What migration strategy should the architect recommend?

A) Rewrite all stored procedures as Lambda functions immediately.  
B) Use the Strangler Fig pattern with a phased approach: (1) Deploy the monolith on Elastic Beanstalk or ECS with RDS SQL Server. (2) Create new microservices for new features, using their own databases. (3) For extracted modules, create database views/synonyms in SQL Server that redirect to the new service's database, allowing stored procedures to work during transition. (4) Use AWS Database Migration Service (DMS) for data replication between the monolith DB and microservice DBs. (5) Gradually refactor stored procedures into service logic.  
C) Lift and shift the monolith to EC2 without any changes.  
D) Rewrite the entire application in a new language on Lambda.

**Correct Answer: B**
**Explanation:** This phased approach minimizes risk. The Strangler Fig pattern gradually replaces monolith functionality. Database views/synonyms maintain backward compatibility for stored procedures during the transition. DMS keeps data synchronized between old and new databases. New features go directly to microservices. This allows the monolith to shrink incrementally. Option A is high-risk (big bang). Option C doesn't achieve modernization. Option D is a complete rewrite with high risk and no incremental value delivery.

---

### Question 50
A company's microservices use gRPC for inter-service communication due to its performance benefits (binary protocol, HTTP/2 multiplexing). They want to deploy on Amazon ECS behind a load balancer. Which load balancer configuration supports gRPC?

A) Network Load Balancer with TCP listeners.  
B) Application Load Balancer with gRPC target groups and HTTP/2 listeners. ALB natively supports gRPC content-based routing (based on package, service, and method names). Health checks can use the gRPC health checking protocol.  
C) Classic Load Balancer with HTTP listeners.  
D) API Gateway with gRPC proxy integration.

**Correct Answer: B**
**Explanation:** ALB provides native gRPC support — it routes gRPC calls based on the package.service/method format, supports gRPC health checking protocol, and provides gRPC-specific metrics. HTTP/2 multiplexing is handled natively. This enables intelligent routing and health checking for gRPC services. Option A — NLB works at TCP level (no content-based routing), but gRPC passes through. Option C — Classic LB doesn't support HTTP/2 or gRPC. Option D — API Gateway supports REST/HTTP APIs, not gRPC natively.

---

### Question 51
A company has a multi-Region active-active microservices architecture. They use DynamoDB global tables for shared state. During a network partition between Regions, both Regions continue accepting writes. After the partition heals, some items have conflicting updates. How should the architect handle conflict resolution?

A) Use DynamoDB's built-in "last writer wins" conflict resolution and accept that the most recent timestamp wins. Design the application to tolerate this by using idempotent operations and avoiding read-modify-write patterns. For critical data where last-writer-wins is insufficient, implement application-level conflict resolution using Lambda triggers on DynamoDB Streams.  
B) Lock items across Regions before writes to prevent conflicts.  
C) Use DynamoDB transactions to ensure cross-Region consistency.  
D) Designate one Region as the primary writer and make the other read-only.

**Correct Answer: A**
**Explanation:** DynamoDB global tables use last-writer-wins conflict resolution based on the item's timestamp. For most use cases, this is acceptable if applications are designed with idempotent operations. For critical data, DynamoDB Streams triggers Lambda functions that detect and resolve conflicts based on business logic (e.g., merging values, choosing the higher quantity). Option B — cross-Region locks defeat the purpose of active-active and add latency. Option C — DynamoDB transactions are Region-scoped, not cross-Region. Option D makes it active-passive, not active-active.

---

### Question 52
A company runs a microservices platform on EKS. They need to implement per-service rate limiting at the service mesh level (not just at the API Gateway edge). Service A should be limited to 500 requests per second when calling Service B, while Service C can call Service B at 1,000 requests per second. What should the architect use?

A) Implement rate limiting in Service B's application code.  
B) Use Istio service mesh with EnvoyFilter resources that configure local rate limiting based on the caller's service identity. Envoy's rate limiting can distinguish callers using mTLS identity (SPIFFE ID) and apply different limits per source service. Alternatively, use App Mesh traffic policies to define per-virtual-node connection limits.  
C) Deploy a shared rate limiting service backed by Redis.  
D) Use Network ACLs to limit packet rates between service subnets.

**Correct Answer: B**
**Explanation:** Istio/Envoy provides caller-identity-aware rate limiting at the mesh level. Using mTLS service identity (SPIFFE), the rate limiter distinguishes between Service A and Service C. Different rate limits are applied per caller. This is transparent to both the caller and the target service. App Mesh can also implement connection pool limits per virtual node. Option A requires Service B to implement identity-based rate limiting in code. Option C adds a network hop for every request. Option D doesn't support per-service rate limiting.

---

### Question 53
A company's event-driven microservices occasionally process events out of order, causing data integrity issues. For example, an "OrderCancelled" event is processed before the "OrderCreated" event. The events flow through Amazon EventBridge to SQS to Lambda consumers. How should the architect ensure correct ordering?

A) Use FIFO SQS queues with the order ID as the message group ID. EventBridge targets the FIFO queue, maintaining per-order event ordering. Lambda processes messages from the FIFO queue sequentially per message group. Include a sequence number or timestamp in each event for additional ordering verification in the consumer logic.  
B) Add a delay to all events so they arrive in order.  
C) Process all events in a single Lambda function to avoid parallelism.  
D) Sort events in the consumer by timestamp before processing.

**Correct Answer: A**
**Explanation:** SQS FIFO queues maintain strict ordering per message group ID. Using the order ID as the group ID ensures all events for a specific order are processed in sequence. Lambda FIFO queue integration processes messages per-group sequentially. Sequence numbers provide additional verification for edge cases. Option B adds latency without guaranteeing order. Option C destroys parallelism for independent orders. Option D only works if you batch events, adding latency and complexity.

---

### Question 54
A company's microservices need to share configuration data (feature flags, database connection strings, API endpoints). The configuration must be version-controlled, support rollback, and propagate to all service instances within minutes. Different environments (dev, staging, prod) need different configurations. What should the architect use?

A) Hardcode configuration in each service's container image.  
B) Use AWS Systems Manager Parameter Store for static configuration (connection strings, endpoints) and AWS AppConfig for dynamic configuration (feature flags). Parameter Store supports hierarchies (/prod/order-service/db-connection, /dev/order-service/db-connection) for environment separation. AppConfig provides deployment strategies (linear, canary), validation, and automatic rollback for feature flags. Services use the SSM SDK with local caching.  
C) Store all configuration in environment variables in ECS task definitions.  
D) Use a shared Git repository with config files that services poll directly.

**Correct Answer: B**
**Explanation:** Parameter Store for static config provides versioning, encryption (KMS), and environment hierarchies. AppConfig for dynamic config adds deployment safety (gradual rollout, validation, rollback). Together they cover all configuration needs with AWS-native tooling. Services cache values locally for performance and poll for updates. Option A requires image rebuild for config changes. Option C requires task redefinition for changes. Option D lacks deployment safety and access control.

---

### Question 55
A financial company's microservices must maintain strict audit trails. Every API request, inter-service call, and database operation must be traceable to the originating user and request. How should the architect implement end-to-end audit tracing?

A) Log the user ID in each service independently and correlate by timestamp.  
B) Generate a correlation ID (UUID) at the API Gateway for each incoming request. Propagate this correlation ID in HTTP headers across all service-to-service calls. Each service includes the correlation ID, user ID (from JWT), service name, operation, and timestamp in every log entry (structured JSON logging). Store audit logs in a tamper-proof archive: CloudWatch Logs → Kinesis Firehose → S3 with Object Lock (WORM) for compliance. Use OpenSearch for real-time audit queries correlated by the ID.  
C) Use AWS CloudTrail for all audit logging.  
D) Enable VPC Flow Logs and correlate by IP address.

**Correct Answer: B**
**Explanation:** Correlation ID propagation creates an end-to-end trace for every request. Structured JSON logging with the correlation ID, user context, and operation details enables complete audit reconstruction. S3 with Object Lock provides immutable storage for compliance. OpenSearch enables real-time correlation and search. Option A — timestamp correlation is unreliable. Option C — CloudTrail captures AWS API calls, not application-level inter-service calls. Option D — Flow Logs show network traffic, not application-level operations.

---

### Question 56
A company runs microservices on ECS Fargate. They want to implement a service mesh but are concerned about the resource overhead of sidecar proxies (Envoy) consuming CPU and memory in their Fargate tasks. How should the architect balance mesh functionality with resource efficiency?

A) Don't use a service mesh; implement all patterns in application code.  
B) Use App Mesh with Envoy sidecars but right-size the sidecar resource allocation. Set Envoy's CPU/memory limits based on traffic volume — low-traffic services use smaller sidecars (256 CPU units, 64MB). High-traffic services allocate more sidecar resources. Monitor sidecar resource utilization using Container Insights and adjust. For very lightweight services, consider using VPC Lattice as an alternative that provides service mesh functionality without sidecar overhead.  
C) Deploy Envoy proxies as standalone ECS services instead of sidecars.  
D) Use a shared Envoy proxy fleet for all services.

**Correct Answer: B**
**Explanation:** Right-sizing sidecar resources based on traffic volume optimizes cost. Low-traffic services need minimal sidecar resources (Envoy is efficient at idle). Container Insights provides utilization data for tuning. VPC Lattice is a sidecar-free alternative that provides routing, auth, and observability without per-task proxy overhead — ideal for services where full mesh features aren't needed. Option A loses mesh benefits (mTLS, traffic management, observability). Option C adds network hops. Option D creates a bottleneck and loses per-service traffic control.

---

### Question 57
A company is building a new microservices platform and needs to decide on the communication protocol between services. Some services require real-time bidirectional communication (chat, notifications), while others need request-response patterns with large payloads (report generation). What protocols should the architect recommend for each pattern?

A) Use REST (HTTP/1.1) for all communication.  
B) Use gRPC with HTTP/2 for request-response communication (efficient binary serialization, multiplexing, streaming). Use WebSockets (via API Gateway WebSocket APIs or App Mesh) for real-time bidirectional communication (chat, notifications). Use asynchronous messaging (SQS/EventBridge) for fire-and-forget workloads like report generation.  
C) Use WebSockets for all service communication.  
D) Use SOAP/XML for maximum compatibility.

**Correct Answer: B**
**Explanation:** Different communication needs call for different protocols. gRPC provides efficient binary serialization (protobuf), HTTP/2 multiplexing, and streaming — ideal for inter-service request-response. WebSockets provide persistent bidirectional connections for real-time features. Async messaging decouples long-running workloads. This is the polyglot communication pattern. Option A — REST is verbose for high-volume inter-service calls. Option C — WebSockets have overhead for simple request-response. Option D is outdated and verbose.

---

### Question 58
A company's microservices deployment pipeline takes 45 minutes for a full integration test suite. Developers avoid running the full suite, leading to bugs in production. The architect needs to speed up the feedback loop while maintaining test coverage. What testing strategy should they implement?

A) Remove integration tests and rely solely on unit tests.  
B) Implement a testing pyramid: (1) Unit tests run in seconds during local development and PR checks. (2) Contract tests (Pact) validate API contracts between services in minutes. (3) Integration tests run against lightweight local dependencies (LocalStack, Docker Compose) in the CI pipeline. (4) End-to-end tests run only on the main branch after merge (not blocking PRs). Use parallel test execution in CodePipeline with multiple CodeBuild projects running test suites concurrently.  
C) Run all tests in production using canary deployments.  
D) Hire more QA engineers to run manual tests faster.

**Correct Answer: B**
**Explanation:** The testing pyramid provides fast feedback for common issues (unit tests), medium feedback for integration issues (contract tests), and comprehensive verification (e2e tests) without blocking developer velocity. Contract tests catch breaking changes between services without requiring full integration environments. Parallel execution in CodeBuild reduces total pipeline time. Option A loses integration coverage. Option C tests in production, risking user impact. Option D doesn't scale and is slow.

---

### Question 59
A company operates a microservices platform serving multiple business units. They want to implement a chargeback model where each business unit is charged for their actual AWS resource consumption. Services from different business units run on the same EKS cluster. How should the architect implement cost allocation?

A) Split each business unit into its own AWS account.  
B) Tag all AWS resources (ECS tasks, ALBs, Lambda functions) with a "business-unit" tag. Use AWS Cost Explorer with tag-based filtering for cost allocation. For shared resources (EKS cluster, Transit Gateway), use Kubernetes namespace resource quotas to track consumption and allocate costs proportionally. Enable split cost allocation data for ECS and EKS in the Cost and Usage Report.  
C) Estimate costs based on the number of microservices each business unit owns.  
D) Charge all business units equally regardless of usage.

**Correct Answer: B**
**Explanation:** AWS cost allocation tags enable tracking costs per business unit across all tagged resources. The Cost and Usage Report with split cost allocation provides granular data for shared infrastructure. Kubernetes resource quotas enforce per-namespace limits and provide consumption data. Cost Explorer visualizes spending by tag. This provides accurate chargeback without requiring separate accounts. Option A is operationally complex for shared infrastructure. Option C is inaccurate. Option D doesn't incentivize efficient resource use.

---

### Question 60
A company has a microservices architecture where a single user action (placing an order) triggers a chain of 12 service interactions. During load testing, they discover that the end-to-end latency is 5 seconds, which is unacceptable. AWS X-Ray traces show that 7 of the 12 service calls are sequential, but only 3 actually depend on the previous call's output. What should the architect recommend?

A) Optimize each individual service to reduce its latency by 50%.  
B) Redesign the service interaction to maximize parallelism. Analyze the dependency graph: calls that don't depend on each other's output should execute concurrently (e.g., using Step Functions Parallel state). Convert calls that don't need synchronous responses to asynchronous events (SQS/EventBridge). This transforms the sequential chain into a dependency DAG (directed acyclic graph), reducing end-to-end latency to the critical path length.  
C) Cache all responses to eliminate service calls.  
D) Merge all 12 services into a single monolith for lower latency.

**Correct Answer: B**
**Explanation:** The key insight is that only 3 of the 12 calls have actual data dependencies. The other 4 sequential calls can be parallelized or made asynchronous. Step Functions Parallel states execute multiple branches concurrently. Asynchronous calls (fire-and-forget via SQS/EventBridge) don't add to latency. The end-to-end latency drops from the sum of all calls to the critical path (longest dependent chain). Option A is incremental improvement. Option C — not all data is cacheable. Option D reverses the migration.

---

### Question 61
A company runs microservices on ECS with ALB. They want to implement a canary release for their payment service. The canary should receive exactly 1% of production traffic for 30 minutes, and if the error rate exceeds 0.1%, the deployment should automatically roll back. What should the architect configure?

A) Manually split traffic using weighted DNS records in Route 53.  
B) Use ECS with CodeDeploy blue/green deployment. Configure a custom deployment configuration with linear traffic shifting: 1% traffic to the new version for 30 minutes. Define a CloudWatch alarm on the ALB target group's 5xx error rate for the new target group. If the alarm enters ALARM state during the canary window, CodeDeploy automatically rolls back to the original target group. If the 30-minute canary is healthy, proceed with 100% traffic shift.  
C) Deploy the canary as a separate ECS service with its own ALB.  
D) Use Lambda@Edge to route 1% of requests to the canary.

**Correct Answer: B**
**Explanation:** CodeDeploy with ECS supports custom deployment configurations for precise traffic shifting. The canary configuration sends exactly 1% for a specified duration. CloudWatch alarms on target-group-specific metrics (5xx rate, latency) trigger automatic rollback. This is fully automated. Option A — DNS routing is coarse-grained and affected by TTL. Option C requires separate ALB management. Option D is for CloudFront edge logic, not ECS traffic routing.

---

### Question 62
A company's microservices publish events to Amazon Kinesis Data Streams. Consumer lag is increasing because event processing involves calling an external API that has a 500ms response time. Each event requires this external call. How should the architect optimize the consumer to reduce lag?

A) Increase the Lambda timeout to process more events per invocation.  
B) Batch external API calls — instead of calling the external API once per event, accumulate events in the Lambda function (using Kinesis batch window and batch size settings) and make a single bulk API call with multiple events. If the external API doesn't support bulk operations, use concurrent async calls within the Lambda function. Increase the Lambda concurrent execution limit and Kinesis parallelization factor to process multiple batches per shard simultaneously.  
C) Reduce the number of events published to Kinesis.  
D) Replace Kinesis with SQS for better consumer scaling.

**Correct Answer: B**
**Explanation:** Batching reduces the per-event overhead of external API calls. The Kinesis-Lambda integration supports configurable batch windows (aggregate events over time) and batch sizes. The parallelization factor (up to 10 concurrent Lambda invocations per shard) increases processing throughput without adding shards. Concurrent async calls within Lambda maximize utilization during I/O waits. Option A doesn't increase throughput. Option C limits the producer. Option D loses stream ordering.

---

### Question 63
A company is implementing API versioning for their microservices platform. They need to support three API versions simultaneously (v1, v2, v3) while sharing most of the backend logic. How should they architect the versioning to minimize code duplication?

A) Maintain three completely separate codebases for each version.  
B) Use a single service codebase with version-specific adapters. Deploy the service behind API Gateway with stage-based versioning (api.example.com/v1, /v2, /v3). Each version's API Gateway resource uses a request mapping template to transform the version-specific request format into the service's internal format. The service processes the canonical internal format. Response mapping templates transform the internal response back to the version-specific format.  
C) Use HTTP header-based versioning with no API Gateway transformation.  
D) Force all consumers to upgrade to the latest version immediately.

**Correct Answer: B**
**Explanation:** The adapter pattern with API Gateway transformation minimizes code duplication. The core business logic exists in one codebase. API Gateway mapping templates handle version-specific request/response transformations (field renaming, format changes). Only the thin adapter layer differs between versions. Option A triples maintenance effort. Option C requires services to handle version logic internally. Option D breaks existing consumers.

---

### Question 64
A company runs microservices on EKS across two AWS Regions for disaster recovery. During a failover test, they discover that the secondary Region's services are missing recently published events from the primary Region. Events are published to an Amazon EventBridge custom event bus in the primary Region. How should the architect ensure cross-Region event replication?

A) Publish events to EventBridge buses in both Regions from the producer service.  
B) Configure EventBridge cross-Region event routing. Create a rule on the primary Region's event bus that targets the secondary Region's event bus. This replicates events automatically. For critical events, add an SQS queue in the primary Region as an additional target to serve as a buffer in case cross-Region delivery fails. Monitor the cross-Region rule's failure metrics and alert on delivery failures.  
C) Use DynamoDB global tables to store events and have consumers read from the local Region's table.  
D) Use a VPN tunnel between Regions for event delivery.

**Correct Answer: B**
**Explanation:** EventBridge supports cross-Region event routing natively — a rule in the source Region can target an event bus in another Region. This replicates events automatically with EventBridge's built-in retry and DLQ. Adding an SQS buffer provides additional durability. Monitoring delivery failures ensures awareness of replication issues. Option A puts cross-Region logic in every producer (tight coupling). Option C changes the event infrastructure entirely. Option D is not how EventBridge works.

---

### Question 65
A company's microservices make heavy use of AWS Lambda. They notice significant cold start latency (3–5 seconds) for their Java-based Lambda functions, which affects their API response times. The functions are in a VPC for database access. What should the architect recommend to reduce cold start latency? (Select TWO.)

A) Use provisioned concurrency for Lambda functions that serve synchronous API requests, pre-initializing a specified number of execution environments.  
B) Increase the Lambda memory allocation — more memory provides proportionally more CPU, speeding up initialization.  
C) Remove the VPC configuration from Lambda functions.  
D) Deploy the Java functions using Lambda SnapStart, which caches a snapshot of the initialized execution environment (after the init phase) and restores it in milliseconds for new invocations.  
E) Rewrite all functions in Python for faster cold starts.

**Correct Answer: A, D**
**Explanation:** (A) Provisioned concurrency eliminates cold starts by maintaining pre-initialized environments. (D) Lambda SnapStart for Java specifically addresses Java's slow initialization — it takes a snapshot after the init phase (JVM startup, dependency injection, class loading) and restores it on cold start, reducing initialization from seconds to milliseconds. Option B helps but doesn't eliminate cold starts for Java. Option C — VPC configuration no longer adds significant cold start time (hyperplane architecture). Option E is a drastic rewrite.

---

### Question 66
A company's microservices architecture has grown to 100 services. They need a way to visualize the entire service dependency graph, identify circular dependencies, and detect services that are single points of failure (called by many but with no redundancy). What should the architect use?

A) Manually maintain a dependency diagram in a wiki.  
B) Use AWS X-Ray service map, which automatically generates a real-time dependency graph from traced requests. The service map shows each service as a node with connections representing calls. Analyze the map to identify: services with high fan-in (many callers — potential SPOF), circular dependencies (A→B→C→A), and latency/error hotspots. Use X-Ray analytics to quantify the impact of each dependency.  
C) Review CloudWatch metrics for each service independently.  
D) Run a network scan to discover service dependencies by port.

**Correct Answer: B**
**Explanation:** X-Ray service map is automatically generated from distributed traces — no manual maintenance. It visualizes real service-to-service dependencies with call volumes, latency, and error rates. Services with high fan-in are visible as nodes with many incoming edges. Circular dependencies appear as cycles in the graph. Analytics quantify the impact of failures. Option A is manually maintained and quickly outdated. Option C shows per-service metrics without dependency context. Option D shows network connectivity, not application-level dependencies.

---

### Question 67
A company operates an event-driven architecture where multiple microservices consume events from an SNS topic. The notification service must process events in order, while the analytics service can process them in any order and needs high throughput. How should the architect configure the subscriptions differently?

A) Use the same SQS Standard queue for both services.  
B) Subscribe an SQS FIFO queue (with message group ID based on the event's entity ID) for the notification service to ensure ordered processing. Subscribe an SQS Standard queue for the analytics service to enable high-throughput parallel processing. The SNS topic delivers to both queues independently.  
C) Use a single SQS FIFO queue for both services.  
D) Use Lambda subscriptions for both services directly from SNS.

**Correct Answer: B**
**Explanation:** SNS supports both FIFO and Standard queue subscriptions from the same topic (when using SNS FIFO → SQS FIFO, or SNS Standard → SQS Standard). The notification service gets ordered delivery via FIFO (sequential per message group). The analytics service gets high throughput via Standard (parallel, unordered). Each service consumes independently from its own queue. Option A doesn't provide ordering. Option C limits analytics throughput. Option D — Lambda from SNS doesn't guarantee ordering.

---

### Question 68
A company is implementing the sidecar pattern for their microservices on EKS. They need every pod to have a logging sidecar container that ships logs to OpenSearch. Manually adding the sidecar to every pod spec is error-prone and hard to maintain across 50 services. What should the architect use?

A) Require every development team to include the sidecar in their pod specs.  
B) Deploy a Kubernetes MutatingAdmissionWebhook that automatically injects the logging sidecar container into every new pod. The webhook intercepts pod creation requests and adds the sidecar container spec before the pod is created. Alternatively, use a Kubernetes operator that manages sidecar injection via custom resource definitions.  
C) Deploy the logging agent as a DaemonSet instead of a sidecar.  
D) Use CloudWatch Container Insights with the CloudWatch agent DaemonSet.

**Correct Answer: C**
**Explanation:** While Option B (mutating admission webhook) answers the specific question about sidecar injection, Option C (DaemonSet) is actually the better architectural choice for logging. A DaemonSet runs one logging agent per node instead of one per pod, significantly reducing resource overhead across 50 services. The DaemonSet (Fluent Bit/Fluentd) reads container logs from the node's filesystem and ships them to OpenSearch. This is more resource-efficient and easier to manage than per-pod sidecars for logging specifically.

Wait — let me reconsider. The question asks about implementing the sidecar pattern specifically. Let me update.

**Correct Answer: B**
**Explanation:** A MutatingAdmissionWebhook automates sidecar injection consistently across all pods. When any pod is created, the webhook intercepts the API request and adds the logging sidecar container before the pod is scheduled. This ensures 100% coverage without relying on individual teams. Istio uses this pattern for Envoy injection. Option A is error-prone. Option C (DaemonSet) is actually a better approach for logging specifically (one agent per node vs. per pod), but doesn't implement the sidecar pattern as asked. Option D provides metrics but limited log shipping to OpenSearch.

---

### Question 69
A company runs a microservices architecture on ECS. They want to implement a "kill switch" that can instantly disable a problematic microservice from receiving traffic without modifying the service code or redeploying. The switch must take effect within seconds. What should the architect design?

A) Redeploy the service with zero desired count in ECS.  
B) Use multiple approaches layered together: (1) Set the ECS service's desired count to 0 (takes ~30 seconds). (2) For instant effect, modify the ALB listener rule to return a fixed 503 response for the service's path pattern — this takes effect immediately. (3) Use AWS AppConfig with a feature flag that, when flipped, causes the service to return 503 responses (requires minimal code integration). (4) Deregister the target group targets from the ALB.  
C) Delete the ECS service.  
D) Block the service's security group inbound rules.

**Correct Answer: B**
**Explanation:** The ALB fixed response action is the fastest kill switch — modifying the listener rule to return 503 for the service's path takes effect within seconds. This is at the infrastructure level, requiring no code changes or redeployment. Layering with ECS desired count = 0 ensures the service actually stops running. AppConfig provides an application-level switch for more nuanced control. Option A alone takes time to drain tasks. Option C is destructive and requires recreation. Option D — modifying security groups may take time to propagate.

---

### Question 70
A company wants to implement data encryption for inter-service communication in their microservices architecture on ECS. They need encryption in transit for all service-to-service calls without adding encryption logic to application code. What is the simplest approach?

A) Implement TLS in every service's application code using self-signed certificates.  
B) Deploy an Application Load Balancer with HTTPS listeners and ACM certificates for each service. Configure ECS tasks to register with the HTTPS target group. For east-west (service-to-service) traffic, services call each other through their respective ALBs over HTTPS. The ALB handles TLS termination and re-encryption.  
C) Use VPC encryption at the network level (all traffic is encrypted automatically within a VPC).  
D) Deploy a VPN tunnel between every pair of services.

**Correct Answer: B**
**Explanation:** ALB with ACM certificates provides TLS without application code changes. ACM automatically manages certificate renewal. Services communicate through ALBs, which handle TLS termination. For services that need end-to-end encryption, configure ALB with TLS to the target (re-encryption). This is the simplest path — no sidecar, no code changes, uses existing ALB infrastructure. Option A requires per-service certificate management. Option C — VPC doesn't encrypt traffic within itself by default. Option D is impractical.

---

### Question 71
A company's microservices platform serves a global user base. They need to deploy services in multiple AWS Regions with a single API endpoint. Regional deployments should operate independently (cell-based architecture), and user requests should be routed to the nearest Region. If a Region is unhealthy, traffic should automatically shift. What architecture should the architect design?

A) Deploy services in each Region behind Regional ALBs. Use Amazon Route 53 with latency-based routing and health checks to route users to the nearest healthy Region. Each Region operates as an independent cell with its own data store (DynamoDB global tables for shared state). Route 53 health checks monitor Regional ALB endpoints and automatically remove unhealthy Regions from DNS responses.  
B) Use a single-Region deployment with CloudFront for global distribution.  
C) Deploy services in one Region and use Global Accelerator for all traffic.  
D) Manually switch DNS during Regional failures.

**Correct Answer: A**
**Explanation:** Cell-based architecture with Route 53 latency routing provides: (1) Nearest-Region routing for low latency, (2) Independent cell operation (blast radius containment), (3) Automatic failover via health checks. DynamoDB global tables replicate shared state across Regions for active-active operation. Each cell is self-contained. Option B doesn't provide multi-Region compute. Option C routes all traffic to one Region. Option D requires manual intervention during outages.

---

### Question 72
A company's microservices platform on EKS experiences "thundering herd" problems when a service recovers from an outage. All cached data expires simultaneously, and all instances hit the database at once, causing another outage. What should the architect implement?

A) Increase database capacity to handle the thundering herd load.  
B) Implement cache stampede prevention: (1) Add random jitter to cache TTLs so entries don't expire simultaneously. (2) Implement a cache-aside pattern with "locking" — when a cache miss occurs, one instance acquires a lock (using Redis SETNX), fetches from the database, and updates the cache. Other instances wait for the cache to be populated instead of hitting the database. (3) Use cache warming — before bringing a service back online, pre-populate the cache from the database.  
C) Remove caching entirely to eliminate the thundering herd.  
D) Set cache TTL to infinity so caches never expire.

**Correct Answer: B**
**Explanation:** Cache stampede prevention addresses the thundering herd at multiple levels. Random TTL jitter distributes cache expirations over time. Lock-based cache filling ensures only one instance fetches from the database per cache key (others wait). Cache warming pre-populates hot data before the service receives traffic. Together, these protect the database from simultaneous load. Option A is expensive for infrequent events. Option C moves all load to the database permanently. Option D serves stale data indefinitely.

---

### Question 73
A company is implementing a microservices architecture and needs to decide between choreography (event-driven, decentralized coordination) and orchestration (centralized coordinator) for their order fulfillment workflow. The workflow has 8 steps with complex branching logic, compensating transactions, and timeout requirements. What should the architect recommend?

A) Use choreography with EventBridge because it's more loosely coupled.  
B) Use orchestration with AWS Step Functions for this workflow. The complex branching logic, compensating transactions, and timeout requirements benefit from a centralized coordinator that makes the workflow visible and debuggable. Step Functions provides: built-in state management, visual workflow, timeout handling per step, catch/retry blocks for compensations, and a clear audit trail. Choreography works better for simple event flows, not complex workflows with many decision points.  
C) Use a combination of both — Step Functions orchestrates the main flow but publishes events at key milestones for other systems.  
D) Use neither — implement the workflow in a single service.

**Correct Answer: B**
**Explanation:** Orchestration is preferred for complex workflows with branching, compensations, and timeouts. Step Functions makes the workflow explicit and visible (you can see the current state of every execution). Catch/retry blocks implement compensating transactions clearly. Timeouts are first-class features. With choreography, complex workflows become hard to reason about ("event spaghetti"). Option A leads to complex, hard-to-debug distributed workflow. Option C adds unnecessary complexity for this use case. Option D creates a monolithic service.

---

### Question 74
A company's microservices generate different types of data: hot data (real-time dashboards, last 24 hours), warm data (weekly reports, last 30 days), and cold data (yearly compliance audits). They want to optimize storage costs while maintaining appropriate access patterns. What storage architecture should the architect design?

A) Store all data in Amazon DynamoDB with provisioned capacity.  
B) Implement a tiered storage strategy: (1) Hot data in ElastiCache for Redis (sub-millisecond access for dashboards) and DynamoDB (single-digit millisecond for recent transactions). (2) Warm data in Amazon S3 Standard with Athena for ad-hoc queries and QuickSight for reports. (3) Cold data in S3 Glacier Deep Archive with lifecycle policies to automatically transition data from hot → warm → cold based on age. Use DynamoDB TTL to expire hot data and DynamoDB Streams + Lambda to archive to S3 before expiration.  
C) Store all data in S3 Standard.  
D) Use Aurora with automatic storage scaling for all data.

**Correct Answer: B**
**Explanation:** Tiered storage matches cost to access patterns. ElastiCache provides the fastest access for real-time dashboards. DynamoDB handles transactional data. S3 Standard + Athena provides cost-effective analytics. S3 Glacier Deep Archive costs ~$1/TB/month for compliance data. Lifecycle policies automate the transitions. DynamoDB Streams ensure data is archived before TTL deletion. Option A is expensive for cold data. Option C doesn't optimize for different access patterns. Option D — Aurora isn't ideal for archival storage.

---

### Question 75
A company's microservices platform on ECS has been growing steadily. They currently have 150 microservices, and teams complain about difficulty in understanding the overall system behavior, identifying ownership, and knowing which services are production-critical. The architect needs to implement a service catalog and governance framework. What should they build?

A) Maintain a wiki page listing all services.  
B) Implement a comprehensive service catalog using AWS Service Catalog + custom tooling: (1) Require every service to register in a centralized DynamoDB-backed catalog (via CI/CD pipeline step) with metadata: team ownership, criticality tier, dependencies, SLA targets, runbook links, and API documentation links. (2) Use AWS X-Ray service map for real-time dependency visualization. (3) Use AWS CloudWatch dashboards per criticality tier for monitoring. (4) Implement tagging standards enforced by AWS Config rules. (5) Use Backstage or a custom internal developer portal that aggregates the catalog, docs, and operational data.  
C) Require each team to maintain their own documentation.  
D) Use AWS Organizations to organize services by team.

**Correct Answer: B**
**Explanation:** At 150 services, a formal service catalog with automated registration, ownership tracking, and dependency visualization is essential. Automated registration in CI/CD ensures completeness. Criticality tiers drive appropriate monitoring and incident response. X-Ray provides real-time dependency data. Config rules enforce tagging for governance. A developer portal (Backstage) aggregates everything into a single pane. Option A becomes outdated immediately. Option C leads to inconsistent documentation. Option D organizes accounts, not services.

---

## Answer Key

| # | Answer | # | Answer | # | Answer | # | Answer | # | Answer |
|---|--------|---|--------|---|--------|---|--------|---|--------|
| 1 | B | 16 | B | 31 | B | 46 | B | 61 | B |
| 2 | B | 17 | B | 32 | B | 47 | B | 62 | B |
| 3 | C | 18 | B | 33 | B | 48 | B | 63 | B |
| 4 | B | 19 | A | 34 | B | 49 | B | 64 | B |
| 5 | A | 20 | B | 35 | B | 50 | B | 65 | A,D |
| 6 | B | 21 | B | 36 | B | 51 | A | 66 | B |
| 7 | B | 22 | C | 37 | B | 52 | B | 67 | B |
| 8 | B | 23 | B | 38 | B | 53 | A | 68 | B |
| 9 | B | 24 | B | 39 | B | 54 | B | 69 | B |
| 10 | B | 25 | A,C | 40 | B | 55 | B | 70 | B |
| 11 | B | 26 | B | 41 | B | 56 | B | 71 | A |
| 12 | B | 27 | B | 42 | B | 57 | B | 72 | B |
| 13 | B | 28 | B | 43 | A | 58 | B | 73 | B |
| 14 | B | 29 | B | 44 | B | 59 | B | 74 | B |
| 15 | B | 30 | B | 45 | B | 60 | B | 75 | B |

---

### Domain Distribution
- **Domain 1 — Organizational Complexity:** Q1, Q3, Q9, Q13, Q15, Q17, Q28, Q42, Q44, Q46, Q48, Q54, Q55, Q59, Q63, Q66, Q68, Q71, Q73, Q75 (20)
- **Domain 2 — New Solutions:** Q2, Q4, Q7, Q8, Q14, Q18, Q20, Q21, Q22, Q24, Q26, Q27, Q30, Q31, Q34, Q41, Q50, Q51, Q53, Q57, Q67, Q74 (22)
- **Domain 3 — Continuous Improvement:** Q6, Q16, Q25, Q33, Q36, Q37, Q43, Q47, Q60, Q62, Q72 (11)
- **Domain 4 — Migration & Modernization:** Q5, Q10, Q32, Q40, Q49, Q52, Q56, Q64, Q69 (9)
- **Domain 5 — Cost Optimization:** Q11, Q12, Q19, Q23, Q29, Q35, Q38, Q39, Q45, Q58, Q61, Q65, Q70 (13)

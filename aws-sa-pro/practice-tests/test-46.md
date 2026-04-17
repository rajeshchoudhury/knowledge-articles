# AWS Certified Solutions Architect - Professional (SAP-C02) Practice Test 46

## Global Architectures: Multi-Region Active-Active, Data Sovereignty, Global Routing, Content Delivery, Global Databases

**Test Focus:** Global-scale architectures including multi-region deployments, data sovereignty compliance, global traffic management, content delivery optimization, and globally distributed database strategies.

**Exam Distribution:**
- Domain 1: Design Solutions for Organizational Complexity (~20 questions)
- Domain 2: Design for New Solutions (~22 questions)
- Domain 3: Continuous Improvement for Existing Solutions (~11 questions)
- Domain 4: Accelerate Workload Migration and Modernization (~9 questions)
- Domain 5: Cost-Optimized Architectures (~13 questions)

---

### Question 1
A global financial services company operates in 12 AWS regions across North America, Europe, and Asia-Pacific. They need to deploy an active-active architecture for their trading platform that requires sub-50ms latency for all users globally. The application relies on strongly consistent reads and writes to a relational database. Data sovereignty laws require that European customer data stays in EU regions and APAC data stays in APAC regions. How should the solutions architect design the database layer?

A) Deploy Amazon Aurora Global Database with the primary cluster in us-east-1 and read replicas in EU and APAC regions, using application-level routing to direct reads to the nearest region
B) Deploy separate Amazon Aurora clusters in each regulatory zone (NA, EU, APAC) with AWS DMS for cross-region replication, using Amazon Route 53 geolocation routing to direct users to the appropriate regional cluster
C) Deploy Amazon DynamoDB Global Tables across all 12 regions with partition keys designed to keep data within regulatory boundaries, using DynamoDB Streams for cross-region event processing
D) Deploy Amazon Aurora clusters in each regulatory zone with Amazon Aurora Global Database for disaster recovery, using application-level sharding to ensure data residency compliance while maintaining local strong consistency

**Correct Answer: D**
**Explanation:** This scenario requires balancing three constraints: sub-50ms latency (requiring local writes), strong consistency (ruling out eventually consistent cross-region replication), and data sovereignty (requiring data to remain in specific regions). Option D is correct because deploying separate Aurora clusters per regulatory zone with application-level sharding ensures data stays within compliance boundaries while providing strong consistency for local reads and writes. Aurora Global Database is used here specifically for DR, not for active replication of regulated data across zones. Option A fails because Aurora Global Database replicates all data globally, violating data sovereignty. Option B uses DMS which adds latency and doesn't provide real-time consistency. Option C uses DynamoDB Global Tables which are eventually consistent across regions and don't enforce data residency at the partition level.

---

### Question 2
A media streaming company serves 200 million users worldwide. Their current architecture uses Amazon CloudFront with origins in us-east-1 for all content. Users in Southeast Asia report buffering issues during peak hours. The company wants to implement a multi-origin strategy to reduce latency globally while maintaining a single content management workflow. Video files average 4GB and are encoded in multiple bitrates. What architecture change would MOST effectively address the latency issues?

A) Add CloudFront Origin Shield in the ap-southeast-1 region and configure origin failover groups with S3 buckets in us-east-1 and ap-southeast-1 using S3 Cross-Region Replication
B) Deploy AWS Global Accelerator endpoints in Southeast Asian regions to route traffic to the nearest CloudFront distribution
C) Create a second CloudFront distribution with origins in ap-southeast-1, using Route 53 latency-based routing to direct users to the nearest distribution
D) Enable CloudFront Origin Shield in us-east-1 and increase the CloudFront cache TTL to reduce origin fetches, with Lambda@Edge for cache key normalization

**Correct Answer: A**
**Explanation:** The key issue is that users in Southeast Asia experience high latency when CloudFront needs to fetch content from the us-east-1 origin (cache misses). Option A addresses this by: (1) enabling Origin Shield in ap-southeast-1 which acts as a centralized caching layer for that region, reducing the number of origin fetches; and (2) using S3 Cross-Region Replication to place content closer to the regional Origin Shield, dramatically reducing origin fetch latency. This maintains the single content management workflow since CRR handles replication automatically. Option B is incorrect because Global Accelerator doesn't integrate with CloudFront in this way and doesn't solve origin fetch latency. Option C creates operational complexity with two distributions and doesn't maintain a single workflow. Option D only reduces the number of origin fetches but doesn't reduce latency when fetches are needed, and Origin Shield in us-east-1 doesn't help APAC users.

---

### Question 3
A multinational corporation is implementing a global identity platform on AWS. The platform must authenticate users across 8 regions with sub-100ms authentication response times. User profiles include personal data subject to GDPR (EU), LGPD (Brazil), and PDPA (Singapore). The company needs a solution where user profile data is stored only in the region where the user registered but authentication tokens can be validated globally. Which architecture best meets these requirements?

A) Deploy Amazon Cognito User Pools in each regulatory region with separate identity pools, use AWS Lambda to replicate authentication tokens to Amazon ElastiCache Global Datastore for global token validation
B) Deploy a single Amazon Cognito User Pool in us-east-1 with Lambda triggers to enforce data residency policies, using CloudFront to cache authentication responses globally
C) Deploy Amazon DynamoDB Global Tables for user profiles with attribute-level encryption per region, using Amazon Cognito with a custom authentication flow that queries the local DynamoDB table
D) Deploy regional Amazon Cognito User Pools for profile storage with JWT-based authentication tokens, using Amazon CloudFront with signed URLs and Lambda@Edge to validate JWTs at edge locations without needing to contact the origin region

**Correct Answer: D**
**Explanation:** This question requires data residency for profiles while enabling global authentication. Option D is optimal because: (1) Regional Cognito User Pools ensure profile data stays in the registration region, satisfying GDPR/LGPD/PDPA; (2) JWT tokens are self-contained and can be validated using the public key without contacting the issuing region; (3) Lambda@Edge can validate JWTs at CloudFront edge locations, achieving sub-100ms response times globally. Option A is unnecessarily complex and ElastiCache Global Datastore adds latency for writes. Option B centralizes data in us-east-1, violating data residency requirements. Option C uses DynamoDB Global Tables which replicate all data globally, violating data sovereignty regulations.

---

### Question 4
A company operates a global e-commerce platform with primary infrastructure in us-west-2. They are expanding to serve customers in the Middle East and Africa. The platform uses microservices on Amazon EKS with an Amazon Aurora MySQL database. They need the new regions to have full read-write capability with automatic failover. Regional regulations require that order processing data for Middle Eastern customers must be processable within the me-south-1 region even if connectivity to us-west-2 is lost. What is the MOST appropriate architecture?

A) Deploy EKS clusters in me-south-1 and af-south-1, use Aurora Global Database with the primary in us-west-2 and secondary clusters in the new regions, implement write forwarding from secondary clusters
B) Deploy EKS clusters in me-south-1 and af-south-1, create independent Aurora clusters in each region with bi-directional AWS DMS replication, use Route 53 failover routing for regional independence
C) Deploy EKS clusters in me-south-1 and af-south-1, use Amazon DynamoDB Global Tables for order processing data with a separate Aurora Global Database for non-regulated data, implement a CQRS pattern to separate read and write operations regionally
D) Deploy EKS clusters in me-south-1 and af-south-1 with Aurora Global Database, use Amazon SQS cross-region message forwarding for write operations and local Aurora read replicas for reads

**Correct Answer: C**
**Explanation:** The critical requirement is that me-south-1 must independently process orders even when disconnected from us-west-2. Option C addresses this by using DynamoDB Global Tables for order processing data, which provides multi-region active-active write capability with eventual consistency and continues to function independently in each region. The CQRS pattern separates the write path (DynamoDB for orders) from the read path, and Aurora Global Database handles non-regulated data that doesn't need regional independence. Option A fails because Aurora write forwarding still requires connectivity to the primary cluster in us-west-2. Option B's bi-directional DMS replication creates consistency issues and doesn't provide true independence during disconnection. Option D uses SQS which would queue writes during disconnection but not process them locally.

---

### Question 5
A solutions architect is designing a multi-region disaster recovery strategy for a healthcare application that must maintain an RPO of 1 second and an RTO of 5 minutes. The application stack includes Amazon EKS, Amazon Aurora PostgreSQL, Amazon ElastiCache Redis, and Amazon S3. The primary region is eu-west-1 and the DR region is eu-central-1. Regulatory requirements mandate that the DR region must be within the EU. Which combination of services and configurations achieves the RPO/RTO targets? (Choose THREE)

A) Aurora Global Database with replication lag monitoring and automated managed planned failover
B) ElastiCache Global Datastore with automatic failover configuration
C) S3 Cross-Region Replication with S3 Replication Time Control (RTC)
D) AWS Elastic Disaster Recovery for the EKS worker nodes
E) EKS cluster pre-deployed in eu-central-1 with GitOps-based configuration sync using Flux or ArgoCD, with container images replicated via Amazon ECR cross-region replication

**Correct Answer: A, C, E**
**Explanation:** For 1-second RPO and 5-minute RTO across the full stack: (A) Aurora Global Database provides sub-second replication lag and managed planned failover within minutes, meeting both RPO and RTO. (C) S3 CRR with Replication Time Control guarantees 99.99% of objects replicated within 15 minutes (with most under seconds), and RTC ensures compliance with replication SLAs. (E) Pre-deployed EKS clusters with GitOps sync and ECR replication ensures the compute layer is ready to serve traffic within minutes, meeting RTO. Option B (ElastiCache Global Datastore) provides cross-region replication but Redis cache data is typically regenerable from the database and doesn't require the same RPO guarantees — it adds complexity without addressing the core RPO/RTO requirements. Option D (Elastic Disaster Recovery) is designed for EC2-based workloads and doesn't directly apply to EKS managed infrastructure.

---

### Question 6
A global logistics company needs to implement a routing solution for their fleet management API that serves clients across 6 continents. The API experiences highly variable traffic patterns — 10x spikes during business hours in each timezone. They need intelligent request routing that considers both geographic proximity and backend health. Current API Gateway deployment in us-east-1 experiences timeout issues for clients in Australia and Southeast Asia. Which solution provides the BEST global API experience?

A) Deploy API Gateway in multiple regions behind Route 53 latency-based routing with health checks, using DynamoDB Global Tables as the backend datastore
B) Deploy a single API Gateway with Amazon CloudFront as the frontend, enable API caching, and use Lambda@Edge for request preprocessing
C) Deploy API Gateway endpoints in multiple regions, use AWS Global Accelerator for traffic routing with endpoint health checks and traffic dial controls, and implement regional auto-scaling
D) Deploy Amazon CloudFront with API Gateway regional endpoints as origins in multiple regions, using CloudFront origin failover groups and origin request Lambda@Edge functions for routing logic

**Correct Answer: C**
**Explanation:** For a global API with variable traffic and health-aware routing, Option C is best because: (1) Global Accelerator provides static anycast IP addresses that route to the nearest healthy endpoint using the AWS global network, reducing latency from Australia/SEA; (2) Built-in health checks automatically route away from unhealthy endpoints; (3) Traffic dial controls allow gradual regional traffic shifting during deployments or incidents; (4) Regional auto-scaling handles the 10x traffic spikes per timezone. Option A with Route 53 provides latency-based routing but DNS-based routing has TTL delays and doesn't leverage the AWS backbone network as effectively. Option B with a single API Gateway doesn't solve the core latency issue for distant clients. Option D adds unnecessary complexity; CloudFront is optimized for cacheable content, not dynamic API calls that need consistent low latency.

---

### Question 7
A financial institution is implementing a global market data distribution system. The system receives real-time stock prices from exchanges in New York, London, and Tokyo, and must distribute this data to trading desks worldwide with less than 10ms added latency. The data volume is approximately 500,000 messages per second during peak trading hours. Messages are small (average 256 bytes) and must be delivered in order per stock symbol. Which architecture achieves these requirements?

A) Amazon Kinesis Data Streams in each exchange region with cross-region stream replication using AWS Lambda, consumers in each trading desk region
B) Amazon MSK (Managed Streaming for Apache Kafka) clusters in each exchange region with MirrorMaker 2.0 for cross-region topic replication, consumers using Kafka consumer groups in each trading desk region
C) Amazon SNS with message filtering in each exchange region, SQS queues in trading desk regions subscribed to the SNS topics, with FIFO queues for ordering
D) AWS AppSync with real-time subscriptions, backed by DynamoDB Global Tables with streams for event distribution

**Correct Answer: B**
**Explanation:** This scenario requires ultra-low latency, high throughput, and per-key ordering for financial market data. Option B is optimal because: (1) MSK (Kafka) handles 500K+ messages/second with very low latency; (2) Kafka provides per-partition ordering which maps to per-symbol ordering; (3) MirrorMaker 2.0 provides efficient cross-region replication with configurable consistency; (4) Consumer groups enable parallel processing while maintaining partition ordering. Option A with Kinesis can handle the throughput but cross-region replication via Lambda adds significant latency and complexity. Option C with SNS/SQS introduces higher per-message latency, FIFO queues have a 300 messages/second per message group limit, and cross-region SNS to SQS subscriptions add latency. Option D with AppSync is designed for web/mobile applications, not high-frequency market data distribution.

---

### Question 8
A multinational insurance company has a regulatory requirement to ensure that data never leaves specific geographic boundaries while maintaining a globally unified view of customer information for their underwriting team. They have operations in the US, EU, Germany (with additional BaFin requirements), and Japan. Each jurisdiction has different data retention periods (US: 7 years, EU: 5 years, Germany: 10 years, Japan: 3 years). How should the architect design the data layer?

A) Use Amazon S3 buckets in each region with Object Lock for retention, implement a data catalog using AWS Glue Data Catalog federated across regions, and use Amazon Athena federated queries for the unified view
B) Use Amazon Redshift with data sharing across regional clusters, implementing row-level security to enforce geographic boundaries and lifecycle policies for retention
C) Use a single Amazon Redshift cluster in eu-central-1 (Frankfurt) with customer-managed encryption keys per jurisdiction, S3 lifecycle policies for retention compliance
D) Use Amazon Aurora PostgreSQL in each region with the global view provided by a GraphQL federation layer on AWS AppSync that queries each regional database and merges results, with region-specific TTL-based data expiration

**Correct Answer: A**
**Explanation:** This scenario requires strict data residency with a unified analytical view and varying retention periods. Option A is correct because: (1) S3 buckets in each region ensure data never leaves geographic boundaries; (2) S3 Object Lock enforces jurisdiction-specific retention periods immutably (7/5/10/3 years); (3) AWS Glue Data Catalog provides a unified metadata layer without moving data; (4) Athena federated queries can query across regional S3 buckets, providing the unified view while data stays in place. Option B's Redshift data sharing requires data to be accessible across clusters which may violate strict residency requirements, and row-level security doesn't prevent data from being stored in the wrong region. Option C centralizes all data in Frankfurt, violating US and Japan data residency. Option D is complex and AppSync/Aurora isn't optimized for analytical workloads needed by underwriting teams.

---

### Question 9
A company is migrating their global content delivery network from a third-party CDN to Amazon CloudFront. They currently serve 50TB of static content and 200TB of video-on-demand content. Their existing CDN uses a tiered caching architecture with 3 super-POPs and 45 edge locations. They need to replicate similar caching efficiency during migration to avoid origin overload. The origin is an S3 bucket in us-east-1. During the migration period, both CDNs will serve traffic. What is the recommended migration strategy?

A) Configure CloudFront with Origin Shield enabled in 3 strategic regions matching the super-POP locations, use weighted DNS routing to gradually shift traffic from the old CDN to CloudFront, monitor origin request rates to ensure cache hit ratios stabilize before increasing CloudFront traffic weight
B) Create a CloudFront distribution with the S3 bucket as origin, add the old CDN as a custom origin failover, use CloudFront Functions for cache key normalization, and switch DNS in one cut-over
C) Deploy CloudFront with multiple S3 origin buckets in 3 regions using S3 CRR, configure CloudFront origin groups for failover, shift traffic using Route 53 geolocation routing
D) Configure CloudFront with Lambda@Edge to forward cache misses to the existing CDN instead of the origin during the migration period, gradually reducing the Lambda@Edge routing percentage

**Correct Answer: A**
**Explanation:** Option A is the correct migration strategy because: (1) Origin Shield replicates the tiered caching architecture (super-POP equivalent), reducing origin load by consolidating cache misses through a single additional caching layer per region; (2) Weighted DNS allows gradual traffic migration, letting CloudFront caches warm up progressively; (3) Monitoring origin request rates ensures the origin isn't overwhelmed as CloudFront's cache population grows. Option B's single cut-over risks overwhelming the origin with cache misses from an empty CloudFront cache. Option C adds unnecessary complexity with multi-region S3 buckets and doesn't address the cache warming concern. Option D is creative but adds significant cost and latency through Lambda@Edge invocations, and creates a dependency on the old CDN that complicates decommissioning.

---

### Question 10
A gaming company operates a global multiplayer platform with 50 million daily active users. Game state must be synchronized across all players in a session (typically 4-100 players) with less than 50ms latency. Players in the same session can be from different continents. The company uses Amazon GameLift for game server hosting. Which architecture pattern best handles global game state synchronization?

A) Use Amazon ElastiCache Global Datastore with Redis Pub/Sub for real-time game state synchronization, placing game servers in the region closest to the session's center of mass
B) Place game sessions on GameLift instances in the region that minimizes maximum latency across all session players using GameLift FlexMatch latency-based matchmaking, use UDP-based game state synchronization directly between the game server and players via AWS Global Accelerator
C) Deploy game servers in all regions with DynamoDB Global Tables for game state, synchronize state through DynamoDB Streams with Lambda triggers that push updates to players
D) Use AWS AppSync with real-time subscriptions for game state synchronization, backed by DynamoDB with DAX for sub-millisecond reads

**Correct Answer: B**
**Explanation:** For real-time multiplayer gaming with cross-continent players, Option B is optimal because: (1) GameLift FlexMatch with latency-based matchmaking places the game server in the region that minimizes the worst-case latency across all players; (2) UDP-based synchronization is standard for real-time games as it eliminates TCP overhead; (3) Global Accelerator provides consistent, low-latency paths from players to the game server using the AWS backbone network, critical for cross-continent sessions. The game server itself maintains authoritative game state in memory. Option A adds unnecessary latency through ElastiCache; game servers should own state in memory. Option C's DynamoDB with Lambda introduces too much latency for real-time game state (50ms+ just for DynamoDB operations plus Lambda cold starts). Option D's AppSync uses WebSocket which adds protocol overhead compared to UDP, and DynamoDB/DAX aren't needed for ephemeral game state.

---

### Question 11
A global SaaS company needs to implement a service mesh for their microservices architecture spanning 4 AWS regions. They have 200 microservices deployed on Amazon EKS, and require end-to-end mTLS, traffic management between regions, and observability across all clusters. Cross-region communication accounts for 30% of total service-to-service traffic. Which approach provides the MOST operationally efficient global service mesh?

A) Deploy AWS App Mesh with virtual services and virtual routers in each region, use Cloud Map for service discovery, and implement custom Envoy filters for cross-region routing with AWS PrivateLink for inter-region connectivity
B) Deploy Istio with a multi-primary multi-cluster configuration across all 4 EKS clusters, using AWS Transit Gateway inter-region peering for the data plane and shared trust domain for mTLS
C) Deploy AWS App Mesh across all regions with Cloud Map namespaces, use App Mesh's cross-VPC service discovery with Transit Gateway for cross-region networking, and Amazon CloudWatch Container Insights for observability
D) Deploy a Consul Connect service mesh with WAN federation across regions, using Consul's built-in key-value store for configuration management and Envoy proxy for the data plane

**Correct Answer: B**
**Explanation:** For a complex multi-region service mesh with 200 microservices, Option B is optimal because: (1) Istio multi-primary multi-cluster provides a proven, feature-rich service mesh with native multi-cluster support; (2) Multi-primary topology means each cluster has its own control plane, avoiding single points of failure; (3) Shared trust domain enables automatic mTLS across all clusters/regions; (4) Transit Gateway inter-region peering provides reliable cross-region data plane connectivity; (5) Istio provides rich traffic management (weighted routing, fault injection, circuit breaking) and observability (Kiali, Jaeger, Prometheus) out of the box. Option A's App Mesh requires more custom work for cross-region scenarios and has fewer traffic management features. Option C is similar but App Mesh's cross-region capabilities are less mature than Istio's multi-cluster. Option D introduces Consul as an additional component that's not natively integrated with EKS.

---

### Question 12
A media company needs to deliver live sports events to viewers in 190 countries. Peak concurrent viewership reaches 10 million viewers. The video pipeline includes ingest, transcoding, packaging, and delivery. They require less than 5 seconds end-to-end latency (glass-to-glass) and automatic quality adaptation based on viewer network conditions. Which architecture provides the MOST scalable and low-latency live streaming solution?

A) AWS Elemental MediaLive for ingest and transcoding in multiple regions, MediaPackage for just-in-time packaging with CMAF low-latency HLS, CloudFront for global delivery with cache-control headers optimized for live content
B) AWS Elemental MediaConnect for reliable ingest, MediaLive for transcoding, MediaStore for origin storage, and CloudFront with HTTP/3 enabled for delivery
C) Direct RTMP ingest to EC2 instances running FFmpeg in multiple regions, HLS packaging on EC2, S3 for segment storage, and CloudFront with real-time log monitoring
D) AWS Elemental MediaLive with SRT ingest, MediaPackage v2 with low-latency DASH, CloudFront with origin request policies optimized for live streaming, and AWS Global Accelerator for ingest point failover

**Correct Answer: A**
**Explanation:** For sub-5-second live streaming at 10M concurrent scale, Option A is correct because: (1) MediaLive handles real-time transcoding with redundant pipelines across regions; (2) MediaPackage with CMAF low-latency HLS achieves 2-5 second latency using chunked transfer encoding; (3) CloudFront efficiently caches and delivers live segments globally; (4) Multi-region deployment ensures ingest resilience. This is AWS's recommended architecture for large-scale low-latency live streaming. Option B uses MediaStore as origin which adds latency compared to MediaPackage's just-in-time packaging. Option C uses custom FFmpeg which doesn't scale as reliably and adds operational burden. Option D is close but MediaPackage v2 with low-latency DASH has less broad device support than CMAF low-latency HLS, and Global Accelerator for ingest is an additional optimization but not the primary differentiator.

---

### Question 13
An organization with strict data sovereignty requirements operates in the EU and needs to implement a global application while ensuring ALL data processing occurs within EU boundaries. They need a CI/CD pipeline that deploys to multiple EU regions (eu-west-1, eu-central-1, eu-south-1) simultaneously. Build artifacts, container images, and deployment configurations must never transit outside the EU. The source code repository is in eu-west-1. How should they design the CI/CD pipeline?

A) AWS CodeCommit in eu-west-1, CodeBuild in eu-west-1, CodePipeline deploying to all EU regions using CloudFormation StackSets with EU-only constraints, ECR with cross-region replication to EU regions only
B) AWS CodeCommit in eu-west-1, CodeBuild projects in each target EU region building independently, CodePipeline with parallel deploy stages, S3 artifact buckets in each EU region
C) GitHub Enterprise in eu-west-1 on EC2, AWS CodePipeline with CodeBuild, artifacts stored in S3 with EU-only bucket policies, deploy using AWS CDK Pipelines with cross-region support limited to EU regions
D) AWS CodeCommit in eu-west-1, single CodePipeline with CodeBuild, artifacts in S3 with eu-west-1 bucket, deploy to other EU regions using cross-region actions with artifact replication limited to EU using S3 bucket policies and ECR replication configuration restricted to EU regions

**Correct Answer: D**
**Explanation:** Option D correctly addresses all sovereignty requirements because: (1) CodeCommit and CodeBuild in eu-west-1 keep all source and build processing in the EU; (2) CodePipeline cross-region actions handle deployment to multiple EU regions natively; (3) S3 bucket policies can restrict artifact replication to EU regions only; (4) ECR replication configuration can be explicitly limited to EU target regions; (5) This is a single, manageable pipeline versus multiple pipelines. Option A with CloudFormation StackSets is good but doesn't explicitly address ECR image distribution and StackSets uses a service-linked role that may process metadata outside the EU. Option B requires maintaining separate build configurations per region, increasing operational overhead. Option C introduces GitHub as a non-AWS component that may complicate sovereignty compliance.

---

### Question 14
A company needs to architect a global DNS strategy for their multi-region application. The application has different tiers: a marketing website (static), a web application (dynamic, session-based), and an API (stateless). Each tier has different routing requirements. The marketing site should route to the nearest healthy endpoint, the web app should maintain session affinity to a specific region, and the API should distribute load based on available capacity. All tiers share the same domain (example.com). Which Route 53 configuration achieves these requirements?

A) Use Route 53 with alias records: marketing site uses latency-based routing, web app uses geolocation routing with cookie-based session management at the application level, API uses weighted routing adjusted manually based on capacity
B) Use a single CloudFront distribution for all tiers with Lambda@Edge routing to the appropriate regional backend based on request path and headers, using CloudFront sticky sessions for the web app
C) Use Route 53 with separate hosted zone configurations per subdomain: marketing (www) with latency-based routing and health checks, web app (app) with geoproximity routing with bias and application-level session cookies encoding the region, API (api) with Route 53 weighted routing integrated with CloudWatch capacity metrics through Route 53 health checks
D) Use AWS Global Accelerator with custom routing accelerators for all three tiers, configuring listener rules based on path patterns

**Correct Answer: C**
**Explanation:** Option C provides the most appropriate per-tier routing strategy: (1) Marketing site with latency-based routing and health checks directs users to the nearest healthy endpoint for best performance; (2) Web app with geoproximity routing with regional bias provides initial regional assignment, and application-level session cookies encoding the region ensure subsequent requests return to the same region; (3) API with weighted routing can be dynamically adjusted, and integration with CloudWatch metrics through Route 53 health checks enables capacity-aware distribution. Option A's manual weight adjustment for the API doesn't scale. Option B uses CloudFront for everything which doesn't optimally serve session-based applications, and sticky sessions at CloudFront don't guarantee regional affinity. Option D's Global Accelerator custom routing is designed for specific use cases like game servers and doesn't support path-based routing patterns.

---

### Question 15
A healthcare organization is building a global clinical trials platform that must comply with 21 CFR Part 11 (US), EU GMP Annex 11, and Japan's MHLW guidelines. The platform processes clinical trial data from sites in 30 countries. Electronic signatures must be legally binding in all jurisdictions, audit trails must be immutable, and data must be accessible for regulatory inspection in each country within 24 hours. Which architecture satisfies all regulatory requirements?

A) Central deployment in us-east-1 with CloudFront for global access, Aurora PostgreSQL with IAM database authentication for access control, S3 with Object Lock for immutable audit trails, and AWS CloudTrail for API audit logging
B) Regional deployments in US, EU, and Japan with data stored in Amazon QLDB for immutable audit trails, AWS Certificate Manager Private CA for digital signatures, DynamoDB Global Tables for global metadata, and AWS Backup with cross-region copy for regulatory access
C) Multi-region deployment using Aurora Global Database, Amazon Managed Blockchain for immutable audit trails, AWS KMS for digital signatures, and S3 Intelligent-Tiering with cross-region replication for document storage
D) Regional deployments with Amazon QLDB in each regulatory zone for immutable ledger-based audit trails, ACM Private CA with region-specific certificate hierarchies for electronic signatures, S3 with Object Lock in each region for document storage, and AWS RAM for cross-account regulatory access during inspections

**Correct Answer: D**
**Explanation:** Clinical trials regulations require specific capabilities that Option D uniquely addresses: (1) QLDB provides a verifiable, immutable ledger for audit trails — critical for 21 CFR Part 11 and Annex 11 compliance, which require tamper-proof records; (2) ACM Private CA with region-specific hierarchies enables legally binding electronic signatures that comply with different jurisdictions' requirements; (3) Regional deployments ensure data residency compliance; (4) S3 Object Lock provides WORM storage for clinical documents; (5) AWS RAM enables sharing resources with regulatory bodies during inspections without data transfer. Option A centralizes data violating residency requirements. Option B is close but DynamoDB Global Tables replicate data globally which may violate some jurisdictions' requirements. Option C's Managed Blockchain is overly complex for audit trails and KMS isn't appropriate for electronic signatures that must be attributable to individuals.

---

### Question 16
A global retail company needs to synchronize inventory data across 15 fulfillment centers in 8 AWS regions. Each center processes 10,000 inventory updates per second. The system must handle network partitions gracefully — if a region loses connectivity, local operations must continue and reconcile when connectivity is restored. Inventory counts must be eventually consistent with conflict resolution favoring the most recent update. Which design provides the MOST resilient inventory synchronization?

A) Amazon DynamoDB Global Tables with last-writer-wins conflict resolution, using DynamoDB Streams in each region for local event processing and inventory adjustment workflows
B) Amazon Aurora Global Database with application-level conflict resolution using timestamp-based versioning, combined with SQS queues for buffering during network partitions
C) Apache Kafka (Amazon MSK) clusters in each region with MirrorMaker 2.0 for cross-region replication, using Kafka Streams for inventory aggregation with custom conflict resolution
D) Amazon ElastiCache for Redis Global Datastore with Redis Sorted Sets for inventory tracking, using Redis Streams for event sourcing with automatic conflict resolution on reconnection

**Correct Answer: A**
**Explanation:** Option A is correct because DynamoDB Global Tables are specifically designed for this use case: (1) Multi-region active-active writes with last-writer-wins conflict resolution, matching the "most recent update wins" requirement; (2) During network partitions, each region's DynamoDB table continues to accept reads and writes locally; (3) When connectivity is restored, DynamoDB automatically reconciles using last-writer-wins; (4) DynamoDB Streams provide local event processing for inventory workflows; (5) 10,000 writes per second per region is well within DynamoDB's capacity. Option B's Aurora Global Database doesn't support multi-region writes (only the primary cluster accepts writes). Option C with MSK is viable but adds significant operational complexity for cross-region Kafka management and custom conflict resolution. Option D's ElastiCache Global Datastore only supports one primary cluster for writes, not multi-region active-active.

---

### Question 17
A multinational bank needs to implement a global transaction processing system that ensures exactly-once processing semantics for financial transactions across 3 regions (us-east-1, eu-west-1, ap-northeast-1). Each region must be able to independently process transactions for local customers, but cross-border transactions must be coordinated. The system processes 50,000 transactions per second globally. Which architecture provides exactly-once processing guarantees for cross-border transactions?

A) Amazon SQS FIFO queues in each region with exactly-once processing, a central orchestrator using Step Functions for cross-border transactions that implements a two-phase commit protocol across regional services
B) Amazon MSK clusters in each region configured with idempotent producers and exactly-once semantics (EOS), using a custom Saga pattern implemented with Step Functions for cross-border transaction coordination
C) Amazon Kinesis Data Streams with enhanced fan-out in each region, Lambda consumers with DynamoDB-based idempotency tracking, and a distributed lock using DynamoDB for cross-border transaction coordination
D) Amazon EventBridge in each region with event replay capability, Lambda functions with built-in retry and dead-letter queues, using DynamoDB conditional writes for idempotent transaction processing

**Correct Answer: B**
**Explanation:** For exactly-once processing of financial transactions across regions, Option B is optimal because: (1) MSK with idempotent producers and EOS provides exactly-once processing semantics within each region, critical for financial transactions; (2) The Saga pattern (via Step Functions) handles distributed cross-border transactions with compensating transactions for failure scenarios, which is the accepted pattern for distributed financial transactions; (3) Each region can independently process local transactions through its MSK cluster. Option A's SQS FIFO has a 300 TPS limit per message group, and two-phase commit is fragile across regions. Option C with Kinesis doesn't natively provide exactly-once semantics and the DIY idempotency adds complexity. Option D's EventBridge lacks native exactly-once processing guarantees.

---

### Question 18
A solutions architect needs to design a global data lake that serves analytics teams across 5 regions. The raw data volume is 500TB and grows by 5TB daily. Each region needs access to the full dataset for analytics, but data transfer costs are a major concern. The analytics workload is primarily SQL-based using Amazon Athena and Amazon Redshift Spectrum. 80% of queries access data from the last 30 days. How should the architect optimize for both performance and cost?

A) Central S3 data lake in us-east-1 with S3 Intelligent-Tiering, Athena in each region querying directly from the central bucket, using Athena result caching to reduce repeated queries
B) S3 data lake in us-east-1, replicate only the last 30 days of data to regional S3 buckets using S3 Replication with prefix-based rules, use Athena in each region with AWS Glue Data Catalog replicated across regions, fall back to cross-region queries for older data
C) Full S3 data lake replicated to all 5 regions using S3 Cross-Region Replication, with S3 Lifecycle policies to move data older than 30 days to S3 Glacier in non-primary regions
D) Central S3 data lake with Amazon Redshift clusters in each region using Redshift Spectrum, data is cached locally in Redshift managed storage after first access

**Correct Answer: B**
**Explanation:** Option B optimally balances performance and cost: (1) Replicating only the last 30 days (covering 80% of queries) to each region dramatically reduces data transfer costs compared to full replication; (2) Prefix-based S3 replication rules (e.g., partitioned by date) enable selective replication; (3) Glue Data Catalog replication ensures consistent metadata across regions; (4) The 20% of queries accessing older data can query cross-region, which is an acceptable trade-off. Option A forces all queries to cross-region to us-east-1, incurring significant data transfer costs. Option C replicates 500TB+ to all 5 regions, costing approximately $10,000+/month in data transfer alone plus storage costs, with Glacier access being slow for analytics. Option D requires Redshift clusters in every region which is expensive and Spectrum still needs to pull data cross-region on first access.

---

### Question 19
A company operates a global IoT platform with 10 million devices deployed across 50 countries. Devices send telemetry data every 5 seconds. The platform must process device data locally for real-time alerts (sub-second) while also aggregating data globally for analytics. Different countries have different data localization requirements. The company wants to minimize the number of AWS regions used while meeting all requirements. Which architecture provides the MOST efficient solution?

A) AWS IoT Core in every available AWS region, with IoT Rules Engine routing data to local Kinesis streams for real-time processing and cross-region replication to a central data lake
B) AWS IoT Core in 4 strategic regions with IoT Greengrass on local gateways for edge processing and real-time alerts, IoT Core forwarding aggregated data to regional S3 buckets for data localization, and Amazon Kinesis Data Firehose to a central analytics data lake with PII stripped
C) AWS IoT Core in all regions, using AWS IoT SiteWise for edge processing, data stored in regional Timestream databases with cross-region queries for analytics
D) Direct MQTT connections to Amazon MQ (ActiveMQ) deployed in each region, Lambda consumers for real-time processing, and S3 with CRR for analytics aggregation

**Correct Answer: B**
**Explanation:** Option B minimizes regional footprint while meeting all requirements: (1) IoT Greengrass at the edge handles sub-second real-time alerts locally without requiring cloud round-trips, satisfying the low-latency alerting requirement; (2) 4 strategic regions (e.g., us-east-1, eu-west-1, ap-northeast-1, ap-southeast-1) minimize operational overhead; (3) Regional S3 buckets satisfy data localization requirements; (4) Kinesis Data Firehose to a central data lake with PII stripped enables global analytics without violating data sovereignty. Option A requires many more regions and doesn't address edge processing for sub-second alerts. Option C uses Timestream which is more expensive and IoT SiteWise is designed for industrial equipment, not general IoT. Option D uses Amazon MQ which isn't designed for IoT scale (10M devices × 0.2 messages/second = 2M messages/second).

---

### Question 20
A company is designing a global application that requires users to upload large files (up to 10GB) from anywhere in the world. The files must be processed in us-east-1 where the processing pipeline exists. Currently, users in remote regions experience very slow upload speeds and frequent timeouts. The architect needs to improve upload performance while minimizing changes to the processing pipeline. Which solution provides the BEST upload experience globally?

A) Deploy S3 buckets in each region with S3 Transfer Acceleration enabled, use S3 Cross-Region Replication to replicate uploaded files to the processing bucket in us-east-1, trigger processing via S3 event notifications
B) Use Amazon S3 Transfer Acceleration with multipart upload to upload directly to the us-east-1 bucket, with retry logic in the client for failed parts
C) Deploy AWS Global Accelerator endpoints pointing to an S3 bucket in us-east-1, using S3 multipart upload with the AWS SDK's built-in retry mechanism
D) Use Amazon CloudFront with a signed URL pointing to the S3 bucket in us-east-1, configured with POST/PUT allowed in the CloudFront cache behavior, and enable Origin Shield

**Correct Answer: A**
**Explanation:** Option A provides the best experience because: (1) Regional S3 buckets give users the fastest possible upload speeds to the nearest region; (2) S3 Transfer Acceleration further optimizes uploads by using CloudFront's edge network; (3) S3 Cross-Region Replication automatically moves files to us-east-1 for processing; (4) The existing processing pipeline in us-east-1 remains unchanged as it's triggered by S3 event notifications on the destination bucket. Option B still requires data to traverse the public internet to reach us-east-1 (Transfer Acceleration helps but uploading to a local bucket is faster). Option C doesn't work because Global Accelerator doesn't directly integrate with S3. Option D uses CloudFront for uploads which works but has a 20GB object size limit and the upload still needs to reach the origin in us-east-1, adding latency for large files from distant regions.

---

### Question 21
A global technology company operates a machine learning platform that trains models using data from 6 regions. Training data cannot leave its source region due to privacy regulations, but the company wants to create models that learn from all regional data. The combined dataset is 50TB across regions. Models must be updated daily with new data from all regions. Which architecture enables global model training while maintaining data residency?

A) Use Amazon SageMaker with federated learning — deploy training jobs in each region that train local models on regional data, aggregate model weights in a central region using a custom parameter server on EC2
B) Use Amazon SageMaker Multi-Model Endpoints in each region, training separate models per region and ensembling predictions at inference time
C) Copy anonymized/pseudonymized data to a central region using AWS DataSync with data transformation, train a single model in the central region using SageMaker
D) Use AWS Step Functions to orchestrate distributed training: each region runs a SageMaker training job producing model gradients, a central aggregation Step Function collects gradients via S3 CRR, and a final training job in the central region combines gradients to update the global model

**Correct Answer: D**
**Explanation:** Option D implements federated learning using AWS-native services: (1) Regional SageMaker training jobs process data locally, respecting data residency; (2) Only model gradients (small compared to training data) are transferred across regions via S3 CRR; (3) Central aggregation combines gradients to produce a global model, effectively learning from all regional data without moving raw data; (4) Step Functions orchestrate the daily workflow. Option A describes federated learning but uses a custom parameter server which adds operational complexity compared to the S3-based gradient exchange. Option B trains independent models which don't learn from cross-regional patterns. Option C moves data centrally, violating residency requirements (pseudonymization alone may not satisfy all privacy regulations, especially GDPR where pseudonymized data is still personal data).

---

### Question 22
A solutions architect is designing a multi-region architecture for a critical government application. The requirements specify that the application must survive the complete loss of any single AWS region with zero data loss (RPO=0) and recovery within 15 minutes (RTO=15 min). The application uses PostgreSQL with 2TB of data and processes 5,000 write transactions per second. All data must remain within the country's borders (the country has 2 AWS regions). Which architecture achieves RPO=0?

A) Amazon Aurora Global Database with the primary in Region A and secondary in Region B, using Aurora's storage-level replication with write forwarding enabled on the secondary
B) Amazon RDS for PostgreSQL with Multi-AZ in Region A, cross-region read replica in Region B, application-level synchronous replication using a proxy layer that confirms writes to both regions before acknowledging
C) Amazon Aurora PostgreSQL with Multi-AZ in Region A, Aurora cross-region replica in Region B, with application-level validation comparing LSN (Log Sequence Number) positions between primary and replica
D) Two Amazon Aurora PostgreSQL clusters, one in each region, with bi-directional logical replication using pg_logical, application writes to both clusters synchronously through a custom middleware layer

**Correct Answer: D**
**Explanation:** RPO=0 (zero data loss) is the critical requirement. This means every committed transaction must exist in both regions before being acknowledged to the client. Option D achieves this through synchronous writes to both regions — the application middleware writes to both Aurora clusters and only confirms success when both acknowledge, guaranteeing zero data loss. The trade-off is increased write latency. Option A's Aurora Global Database uses asynchronous replication (typically <1 second lag) which cannot guarantee RPO=0. Option B's cross-region read replicas use asynchronous replication. Option C's LSN comparison is monitoring, not prevention — it detects lag but doesn't prevent data loss during a failure. The question specifically asks for RPO=0 which eliminates all asynchronous replication options.

---

### Question 23
A company wants to deploy a globally distributed GraphQL API that aggregates data from microservices running in 4 regions. Each microservice owns its data and can be queried independently. The API must provide a unified schema to clients while routing sub-queries to the appropriate regional service. Client requests should be routed to the nearest API endpoint, but the API must be able to fetch data from any regional microservice. Average response time requirement is under 200ms. Which approach provides the BEST architecture?

A) Deploy AWS AppSync in each region with merged APIs combining regional schemas, use CloudFront to route clients to the nearest AppSync endpoint, configure AppSync resolvers to call remote microservices via VPC endpoints and Transit Gateway inter-region peering
B) Deploy a single Apollo Federation Gateway on Amazon ECS behind Global Accelerator, with subgraph services in each region connected via Transit Gateway
C) Deploy Apollo Federation Gateways on ECS in each region behind Route 53 latency-based routing, each gateway configured with all subgraph services across all regions, using AWS PrivateLink for cross-region subgraph calls
D) Deploy AWS AppSync in a single region with HTTP data sources pointing to regional microservice endpoints, using CloudFront for global caching of GraphQL responses

**Correct Answer: C**
**Explanation:** Option C is optimal because: (1) Regional Apollo Federation Gateways provide the unified schema while enabling federation of subgraphs across regions; (2) Route 53 latency-based routing directs clients to the nearest gateway; (3) Each gateway knows all subgraph locations and routes sub-queries to the appropriate regional service; (4) PrivateLink provides secure, low-latency cross-region connectivity for sub-queries. Option A with AppSync merged APIs is close but AppSync's resolver pipeline adds latency for cross-region calls and merged APIs have limitations on resolver complexity. Option B's single gateway is a single point of failure and adds latency for distant clients. Option D centralizes the API in one region, degrading performance for distant clients and not leveraging data locality.

---

### Question 24
A company is migrating from a global Oracle RAC deployment to AWS. The current deployment spans 3 data centers with synchronous replication and serves as the system of record for all business transactions globally. The database handles 20,000 transactions per second with complex stored procedures. Application teams cannot modify their database access patterns in the short term. The company requires a phased migration approach. What is the MOST appropriate first phase?

A) Migrate directly to Amazon Aurora PostgreSQL Global Database using AWS SCT for schema conversion and DMS for continuous replication, rewriting stored procedures in PL/pgSQL
B) Deploy Amazon RDS Custom for Oracle in the primary region with cross-region read replicas, use Oracle GoldenGate for replication from on-premises during cutover, maintaining Oracle compatibility
C) Migrate to Amazon DynamoDB with a CQRS pattern, using DMS to convert relational data to NoSQL format during migration, with DynamoDB Global Tables for multi-region capability
D) Deploy Oracle on Amazon EC2 with dedicated hosts for license compliance in the primary region, use Oracle Data Guard for cross-region DR, while planning the application modernization needed for a future move to Aurora

**Correct Answer: D**
**Explanation:** Given the constraints (complex stored procedures, no short-term application changes, Oracle RAC), Option D is the most appropriate first phase because: (1) Oracle on EC2 with dedicated hosts preserves full Oracle compatibility including RAC and stored procedures; (2) Oracle Data Guard provides cross-region DR comparable to the current synchronous replication; (3) Dedicated Hosts enable BYOL (Bring Your Own License) for Oracle; (4) This lift-and-shift enables cloud benefits while buying time for application modernization. Option A requires rewriting stored procedures (short-term constraint violation). Option B's RDS Custom for Oracle doesn't support Oracle RAC and has limitations on customization. Option C's DynamoDB migration requires fundamental application redesign. The question asks for the first phase of a phased migration, making the conservative approach correct.

---

### Question 25
A company operates a global real-time bidding (RTB) platform for digital advertising. Bid requests must be processed within 100ms. The platform receives 3 million bid requests per second globally. Each bid decision requires looking up user profiles (10KB average), campaign rules (cached), and making a real-time price calculation. User profiles are updated every 5 minutes from a batch pipeline. Which architecture achieves the latency and throughput requirements?

A) Regional API Gateway endpoints backed by Lambda functions, DynamoDB with DAX for user profiles, ElastiCache for Redis for campaign rules, all in each bidding region
B) Regional Network Load Balancers with ECS Fargate tasks, DynamoDB Global Tables for user profiles with DAX, ElastiCache for Redis for campaign rules, EC2 placement groups for compute
C) Regional Application Load Balancers with EC2 instances in placement groups, ElastiCache for Redis Global Datastore for user profiles (pre-loaded from batch pipeline), local ElastiCache for campaign rules
D) Regional API Gateway with Lambda Provisioned Concurrency, DynamoDB for user profiles with on-demand capacity, ElastiCache for campaign rules

**Correct Answer: C**
**Explanation:** For 100ms latency at 3M requests/second in real-time bidding, Option C is optimal because: (1) EC2 instances in placement groups provide the lowest, most consistent network latency; (2) ElastiCache for Redis provides sub-millisecond reads for user profiles — critical since every bid request needs a profile lookup; (3) Pre-loading profiles from the batch pipeline into Redis (updated every 5 minutes) eliminates database calls during bid processing; (4) Local ElastiCache for campaign rules provides microsecond-level access; (5) This architecture minimizes the number of network hops. Option A with Lambda adds cold start latency even with provisioned concurrency, and API Gateway adds overhead for this scale. Option B with DynamoDB/DAX has higher read latency than Redis and Fargate has slower startup. Option D with Lambda and DynamoDB on-demand would have unpredictable latency at this scale.

---

### Question 26
A multinational corporation is implementing a global network architecture to connect 40 VPCs across 8 AWS regions with their 15 on-premises data centers worldwide. Requirements include: segmentation between production and non-production workloads, centralized egress through security appliances, inter-region transit, and support for overlapping CIDR ranges in non-production VPCs. Which networking design meets ALL requirements?

A) AWS Transit Gateway in each region with inter-region peering, Transit Gateway route tables for production/non-production segmentation, centralized egress VPC with NAT Gateway and firewall appliances, AWS PrivateLink for overlapping CIDRs
B) AWS Transit Gateway in each region with inter-region peering, multiple route tables for segmentation, centralized inspection VPC with AWS Network Firewall using Gateway Load Balancer, and AWS Cloud WAN for inter-region connectivity with network policies for segmentation, using Transit Gateway Connect for overlapping CIDR support through GRE tunnels
C) AWS Cloud WAN with segment-based policies (production and non-production segments), Transit Gateway attachments in each region, centralized egress through a shared services segment with Network Firewall, and PrivateLink endpoints for services with overlapping CIDRs
D) Hub-and-spoke VPC peering in each region with a transit VPC using EC2-based VPN appliances, VPN connections between regions, and NAT instances for centralized egress

**Correct Answer: C**
**Explanation:** Option C is the best design because: (1) AWS Cloud WAN provides centralized management of the global network with native segment-based policies, perfect for production/non-production isolation; (2) Cloud WAN natively handles inter-region transit without manual peering management; (3) Network policies in Cloud WAN enforce segmentation rules globally; (4) Centralized egress through a shared services segment with Network Firewall provides security appliance inspection; (5) PrivateLink handles overlapping CIDRs by providing service-level access without IP routing. Option A's Transit Gateway approach works but requires manual management of peering and route tables across 8 regions. Option B is over-engineered with both Cloud WAN and Transit Gateway Connect, and GRE tunnels add complexity. Option D's transit VPC with EC2 appliances is the legacy pattern, limited in scalability and not recommended for 40+ VPCs.

---

### Question 27
A global financial services firm needs to replicate their Oracle database (15TB) with real-time change data capture to feed multiple downstream systems in different AWS regions. Downstream systems include: an analytics data lake in us-east-1 (needs data in Parquet format), a microservices event bus in eu-west-1 (needs data as events), and a reporting database in ap-northeast-1 (needs data in PostgreSQL format). The CDC feed must maintain transactional consistency and handle 10,000 changes per second. Which architecture provides the MOST efficient multi-target CDC?

A) AWS DMS with a single replication instance reading from Oracle, with three separate tasks writing to S3 (Parquet), Amazon MSK (events), and RDS PostgreSQL respectively
B) Oracle GoldenGate on EC2 reading CDC from the Oracle database, publishing to Amazon MSK in the source region, then three separate Kafka consumers: one using MSK Connect with S3 Sink Connector (Parquet output) in us-east-1, one subscribing from MSK in eu-west-1 for events, and one using MSK Connect with JDBC Sink Connector to RDS PostgreSQL in ap-northeast-1
C) AWS DMS with ongoing replication to Amazon Kinesis Data Streams, Kinesis Data Firehose to S3 in Parquet format for analytics, Lambda consumers for event generation in eu-west-1, and a separate DMS task from Kinesis to RDS PostgreSQL in ap-northeast-1
D) AWS Database Migration Service reading from Oracle, writing to a central Amazon Aurora PostgreSQL via continuous replication, then Aurora change data capture via DMS to feed the three downstream systems

**Correct Answer: B**
**Explanation:** Option B provides the most efficient and reliable multi-target CDC architecture: (1) Oracle GoldenGate provides robust, low-latency CDC from Oracle with transactional consistency; (2) MSK (Kafka) as the central streaming platform enables durable, replayable CDC events; (3) MSK Connect with the S3 Sink Connector natively produces Parquet output for the data lake; (4) Cross-region MSK replication or direct consumption provides events for the microservices bus; (5) MSK Connect JDBC Sink writes to PostgreSQL maintaining order. This "CDC to central stream, fan out to targets" pattern is the standard for multi-target CDC. Option A with a single DMS instance is a bottleneck and DMS doesn't natively produce Parquet. Option C chains multiple services adding latency and complexity. Option D adds an unnecessary intermediate database and double CDC processing.

---

### Question 28
A company wants to implement blue-green deployments for their global application running across 5 regions. Each region runs an EKS cluster with 50 microservices. A deployment must be validated in each region sequentially (canary in region 1, then roll to region 2, etc.) with automatic rollback if error rates exceed 0.1%. The entire global rollout should complete within 2 hours. Which deployment strategy provides the MOST reliable global blue-green deployment?

A) Use AWS CodeDeploy with ECS blue-green deployment type in each region, coordinated by a central CodePipeline with manual approval gates between regions and CloudWatch alarms for automatic rollback
B) Use Argo Rollouts in each EKS cluster with canary strategy, coordinated by a central Argo Workflows pipeline that sequentially promotes each region after validating CloudWatch metrics through a custom analysis template, with automatic rollback on failure
C) Use Flux CD with progressive delivery (Flagger) in each EKS cluster, with a central Step Functions workflow orchestrating regional rollouts, querying CloudWatch for error rates and triggering rollback through Flux GitOps if thresholds are exceeded
D) Use AWS App Mesh with virtual router traffic splitting for canary in each region, coordinated by a Lambda-based orchestrator that updates traffic weights and monitors CloudWatch metrics, rolling back by updating the virtual router configuration

**Correct Answer: B**
**Explanation:** For EKS-based global blue-green deployments with automatic rollback, Option B is optimal: (1) Argo Rollouts provides native Kubernetes canary and blue-green deployment strategies with metric-based automated analysis; (2) Argo Workflows can orchestrate the sequential regional rollout, promoting each region only after the previous region's canary is validated; (3) CloudWatch integration through custom analysis templates enables automatic 0.1% error rate threshold monitoring; (4) Argo Rollouts' native rollback is instantaneous by switching the traffic back. Option A uses CodeDeploy which is designed for ECS, not EKS. Option C with Flux/Flagger is viable but Flagger's analysis capabilities are less mature than Argo Rollouts'. Option D requires custom Lambda orchestration which adds development and maintenance burden compared to using purpose-built tools.

---

### Question 29
A media company needs to build a content recommendation engine that serves personalized recommendations to 100 million users across 6 regions. The recommendation model is retrained daily and is approximately 20GB. Each API call requires loading user features (from a user profile store) and running inference against the model. Response time must be under 50ms at p99. The model and user features must be available in all 6 regions. Which architecture minimizes inference latency?

A) Amazon SageMaker real-time endpoints with multi-model endpoints in each region, models stored in regional S3 buckets via CRR, user features in DynamoDB Global Tables queried inline during inference
B) Amazon SageMaker real-time endpoints in each region with models pre-loaded on GPU instances, user features pre-computed and stored in ElastiCache for Redis in each region, model artifacts replicated via S3 CRR
C) Amazon SageMaker Serverless Inference endpoints in each region for cost optimization, models loaded on-demand, user features in DynamoDB with DAX in each region
D) Custom inference containers on ECS Fargate in each region with models loaded from EFS, user features queried from Aurora Global Database read replicas

**Correct Answer: B**
**Explanation:** For sub-50ms p99 inference latency, Option B is optimal because: (1) Pre-loaded models on dedicated GPU instances eliminate model loading latency; (2) ElastiCache for Redis provides sub-millisecond access to pre-computed user features, which is critical since querying a database inline would add significant p99 latency; (3) Pre-computing user features (rather than computing on each request) reduces inference-time computation; (4) S3 CRR ensures model availability in all regions. Option A's multi-model endpoints may need to load models on demand and DynamoDB queries inline add 5-10ms at p99. Option C's Serverless Inference has cold starts that would violate the 50ms p99 requirement. Option D's Fargate with EFS model loading is slower than dedicated instances and Aurora queries add latency.

---

### Question 30
A company is designing a global event-driven architecture where events generated in any region must be available to consumers in all regions within 5 seconds. The system processes 100,000 events per second globally. Events are categorized into 500 event types. Consumers subscribe to specific event types and need exactly-once processing semantics. Which architecture provides the required global event distribution?

A) Amazon EventBridge in each region with event rules forwarding events to EventBridge in all other regions using cross-region event routing, consumers as Lambda functions with idempotency middleware
B) Amazon SNS with message filtering in each region, SNS cross-region subscriptions distributing to SQS FIFO queues in each consuming region, using message deduplication for exactly-once semantics
C) Amazon MSK clusters in each region with MirrorMaker 2.0 for cross-region topic replication, event types mapped to Kafka topics, consumers using Kafka's exactly-once semantics with idempotent consumers
D) Amazon Kinesis Data Streams in each region with cross-region replication using Lambda, consumers with enhanced fan-out and DynamoDB-based checkpoint deduplication

**Correct Answer: C**
**Explanation:** For high-throughput global event distribution with exactly-once semantics, Option C is correct: (1) MSK handles 100K+ events/second with low latency; (2) MirrorMaker 2.0 provides efficient cross-region topic replication within the 5-second window; (3) 500 event types map naturally to Kafka topics, enabling consumer subscriptions; (4) Kafka's exactly-once semantics (EOS) with transactional producers and consumers provides the strongest exactly-once guarantee available. Option A with EventBridge has cross-region delivery latency and doesn't guarantee exactly-once. Option B's SNS/SQS FIFO has throughput limitations (300 TPS per message group, 3000 per queue with batching). Option D with Kinesis requires custom cross-region replication and doesn't provide native exactly-once semantics.

---

### Question 31
A global automotive manufacturer needs to process vehicle telemetry data from 5 million connected cars worldwide. Each vehicle sends 1KB of telemetry data every second. The data must be processed in real-time for safety alerts and stored for historical analysis. Safety alerts must be delivered to the vehicle within 500ms. Data retention is 7 years. The company operates in regions with varying connectivity quality. Which architecture handles the ingestion, processing, and storage requirements?

A) AWS IoT Core with Basic Ingest in 4 regions, IoT Rules Engine routing safety-critical data to Lambda for real-time processing and all data to Kinesis Data Firehose for S3 storage, IoT Device Shadow for bidirectional vehicle communication
B) AWS IoT Core with MQTT in 4 regions, Amazon Kinesis Data Streams for real-time processing with Kinesis Data Analytics (Apache Flink) for safety alert detection, S3 with Intelligent-Tiering for storage, MQTT retained messages for vehicle alerts
C) AWS IoT Core in 4 regions with IoT Greengrass on vehicle head units for edge safety processing, IoT Core forwarding data to Kinesis Data Firehose for S3 storage, IoT Device Shadow for alert delivery, S3 lifecycle policies transitioning to Glacier after 90 days
D) Direct MQTT to Amazon MQ (RabbitMQ) clusters in each region, EC2 consumers for processing, S3 for storage with lifecycle policies

**Correct Answer: C**
**Explanation:** For connected car telemetry at 5M vehicles, Option C is correct: (1) IoT Greengrass on vehicle head units provides edge processing for safety alerts, achieving sub-500ms response without requiring cloud round-trips — critical given variable connectivity; (2) IoT Core handles cloud ingestion at scale (5M × 1 msg/sec = 5M messages/second globally); (3) Kinesis Data Firehose efficiently batches and stores data to S3; (4) S3 lifecycle policies to Glacier after 90 days optimize the 7-year retention cost; (5) IoT Device Shadow provides reliable bidirectional communication even with intermittent connectivity. Option A's Lambda processing can't guarantee 500ms alerts through the cloud path. Option B's cloud-based Flink processing doesn't address poor connectivity scenarios. Option D's Amazon MQ isn't designed for IoT scale.

---

### Question 32
A multinational company needs to implement a global secrets management strategy. They have applications in 8 AWS regions, 3 on-premises data centers, and workloads in Azure. All secrets must be centrally managed, automatically rotated, and auditable. Cross-region secret access must have sub-100ms latency. The company uses AWS Organizations with 50 accounts. Which architecture provides comprehensive global secrets management?

A) AWS Secrets Manager in each region with multi-region secret replication enabled, cross-account access using AWS Organizations-based resource policies, custom Lambda rotation functions, CloudTrail for audit logging
B) HashiCorp Vault Enterprise on EKS with Vault replication across regions, integrated with AWS KMS for auto-unseal, Vault Agent sidecar for application integration across AWS and Azure
C) AWS Secrets Manager in the primary region with cross-region read replicas, AWS Resource Access Manager (RAM) for cross-account sharing, built-in rotation for supported services
D) AWS Systems Manager Parameter Store SecureString parameters in each region, synced via a custom Lambda-based replication pipeline, KMS encryption with cross-region keys

**Correct Answer: A**
**Explanation:** For global secrets management across multiple AWS regions and accounts, Option A is correct: (1) Secrets Manager multi-region secret replication provides automatic secret synchronization across all 8 regions with sub-100ms read access from local replicas; (2) Organizations-based resource policies enable centralized cross-account access management across 50 accounts; (3) Custom Lambda rotation functions support automatic rotation for any secret type; (4) CloudTrail provides comprehensive audit logging. Option B with HashiCorp Vault adds operational complexity and is better suited when multi-cloud secret management is the primary requirement — but the question prioritizes AWS-centric management with Azure being secondary. Option C's read replicas don't exist as a Secrets Manager feature (multi-region replication is the correct term). Option D with Parameter Store lacks native multi-region replication and has lower secrets management capabilities than Secrets Manager.

---

### Question 33
A global e-commerce company experiences a 30-minute regional outage in us-east-1 during Black Friday, resulting in $5 million in lost revenue. They want to implement a multi-region active-active architecture that can handle the complete failure of any single region with zero user-visible impact. The application uses Amazon EKS, Amazon Aurora MySQL, Amazon ElastiCache, Amazon SQS, and Amazon S3. Users are distributed 40% in NA, 35% in EU, and 25% in APAC. Which combination of actions achieves zero user-visible impact during a regional failure? (Choose THREE)

A) Deploy Aurora Global Database with managed planned failover and write forwarding from secondary regions, allowing continued writes during failover
B) Use Route 53 Application Recovery Controller (ARC) with routing controls and readiness checks to manage traffic failover between regions with pre-validated health checks
C) Implement an active-active architecture where each region has a complete application stack with its own Aurora writer, using DynamoDB Global Tables for the session store and order queue instead of SQS, and application-level conflict resolution for Aurora databases
D) Deploy Global Accelerator with endpoint groups in each region and instant failover using traffic dial controls
E) Pre-warm all resources in secondary regions to handle full production traffic, including EC2 instances, ELB pre-warming, and ElastiCache cluster sizing to handle regional failover traffic

**Correct Answer: B, C, E**
**Explanation:** Zero user-visible impact during a regional failure requires true active-active with no failover delay: (B) Route 53 ARC provides orchestrated, pre-validated traffic management with routing controls that can shift traffic within seconds, crucial for meeting the "zero user-visible impact" requirement. (C) True active-active with each region having its own Aurora writer eliminates the failover delay inherent in Aurora Global Database; DynamoDB Global Tables for sessions and order queues replace SQS (which is regional) with multi-region active-active capability. (E) Pre-warming is essential — secondary regions must already be handling traffic and sized to absorb failover traffic instantly. Option A's Aurora Global Database failover takes minutes and write forwarding has limitations during failover, preventing "zero" impact. Option D's Global Accelerator helps with routing but doesn't address the underlying application-level requirements for active-active.

---

### Question 34
A data analytics company operates a global data processing platform. They need to implement a data mesh architecture where domain teams in different regions own their data products. Each domain team must be able to publish data products that are discoverable and accessible by other teams globally. Data governance policies must be enforced centrally, including data classification, access control, and lineage tracking. Which AWS services and architecture best implement this data mesh?

A) AWS Lake Formation with cross-account data sharing via RAM, AWS Glue Data Catalog for metadata, Amazon DataZone for data product publishing and discovery, IAM Lake Formation permissions for centralized governance
B) Amazon DataZone domains for each business domain with cross-account data subscriptions, AWS Glue Data Catalog for technical metadata, Lake Formation for fine-grained access control, and CloudTrail with AWS Config for governance auditing
C) Regional S3 data lakes with AWS Glue Data Catalog in each region, a custom data marketplace application for discovery, IAM-based access control, and a custom data lineage tracking system
D) Amazon Redshift datashares across regional clusters for data product distribution, Redshift Spectrum for cross-region data access, Lake Formation for governance

**Correct Answer: B**
**Explanation:** A data mesh architecture requires domain ownership, data product discoverability, and centralized governance. Option B is optimal: (1) Amazon DataZone provides the data product publishing, discovery, and subscription mechanism — the marketplace layer of data mesh; (2) Cross-account subscriptions enable domain teams to share data products globally; (3) AWS Glue Data Catalog provides the technical metadata layer; (4) Lake Formation enables centralized fine-grained access control policies including column-level security and data filtering; (5) CloudTrail and Config provide governance auditing. Option A is similar but doesn't leverage DataZone's marketplace capabilities fully. Option C requires building custom marketplace and lineage systems. Option D limits the data mesh to Redshift-only, which doesn't accommodate diverse data processing tools.

---

### Question 35
A company is building a globally distributed configuration management system for their microservices. Configuration changes must propagate to all regions within 30 seconds. The system must support configuration versioning, rollback, canary deployments (applying config to a percentage of instances), and emergency overrides. Configurations are hierarchical (global > regional > service-level). Which design provides the MOST robust configuration management?

A) AWS AppConfig with feature flags, using AppConfig environments per region and deployment strategies for canary rollouts, configuration stored in SSM Parameter Store with hierarchical namespaces, CloudWatch alarms for automatic rollback
B) Amazon DynamoDB Global Tables storing configurations with version attributes, Lambda functions triggered by DynamoDB Streams for propagation validation, custom application logic for canary and rollback functionality
C) HashiCorp Consul with cross-region WAN federation for configuration distribution, Consul KV store for hierarchical configs, Consul watches for propagation
D) AWS Systems Manager Parameter Store with cross-region replication via Lambda, SSM Automation documents for canary deployment, CloudFormation for version tracking

**Correct Answer: A**
**Explanation:** Option A provides the most robust solution using AWS-native services: (1) AWS AppConfig natively supports deployment strategies including canary (percentage-based rollout), linear, and all-at-once; (2) SSM Parameter Store with hierarchical paths (/global/regional/service) naturally implements the configuration hierarchy; (3) AppConfig feature flags enable emergency overrides; (4) CloudWatch alarms integration enables automatic rollback if configuration changes cause errors; (5) AppConfig tracks configuration versions and supports instant rollback. Multi-region deployment can be orchestrated across AppConfig environments in each region. Option B requires building canary, rollback, and versioning logic from scratch. Option C introduces non-AWS components adding operational overhead. Option D's SSM doesn't natively support canary deployments.

---

### Question 36
A company needs to design a global API rate limiting strategy for their multi-region API platform. The platform serves 50,000 requests per second globally. Rate limits must be enforced per customer across all regions (global rate limit, not per-region). A customer's rate limit is 1,000 requests per second regardless of which regions they use. The solution must not add more than 5ms of latency to each request. Which approach provides accurate global rate limiting within the latency constraint?

A) ElastiCache for Redis Global Datastore with a single primary cluster, using Redis INCR commands with TTL for rate counting, all regions reading from and writing to the global Redis instance
B) Local ElastiCache for Redis in each region with approximate rate limiting using a token bucket algorithm, periodic synchronization between regions every 1 second via Lambda, accepting up to 2x over-limit as an approximation trade-off
C) Amazon API Gateway with usage plans and API keys for rate limiting, deployed in each region with the same usage plan configuration
D) DynamoDB Global Tables with atomic counters for rate limit tracking, conditional writes to enforce limits, DAX for sub-millisecond reads

**Correct Answer: B**
**Explanation:** Global rate limiting with <5ms latency is a classic distributed systems trade-off between accuracy and latency. Option B is correct because: (1) Local Redis provides sub-millisecond rate checking, well within the 5ms budget; (2) The token bucket algorithm with periodic synchronization gives a good approximation of global rate limits; (3) Accepting up to 2x over-limit during the synchronization window is an acceptable trade-off for most API platforms; (4) 1-second synchronization frequency keeps the approximation tight. Option A's global Redis would add cross-region latency (50-200ms) for every request, far exceeding the 5ms requirement. Option C's API Gateway usage plans are per-region, not global. Option D's DynamoDB with global tables has eventual consistency for cross-region writes and conditional writes would have high latency for cross-region counter updates.

---

### Question 37
A healthcare company operates in 20 countries and needs to implement a global audit logging system that meets HIPAA, GDPR, and SOC 2 requirements. Audit logs must be immutable, retained for 7 years, searchable within 30 seconds for the last 90 days, and retrievable within 4 hours for older logs. The system generates 50,000 audit events per second globally. Which architecture meets all compliance and operational requirements?

A) CloudTrail with organization trail enabled, CloudTrail Lake for queryable storage (90-day retention), CloudTrail logs archived to S3 with Object Lock (Governance mode) in each region for 7-year retention, Athena for older log queries
B) CloudTrail organization trail to S3, Amazon OpenSearch Service for the last 90 days of searchable logs, S3 with Object Lock (Compliance mode) for 7-year immutable retention, S3 Glacier Flexible Retrieval for cost-optimized older storage with 4-hour retrieval
C) Custom audit logging service publishing to Amazon Kinesis Data Streams in each region, Lambda consumers writing to Amazon Timestream for 90-day queryable storage, and S3 with versioning for 7-year retention
D) CloudTrail organization trail with S3 Intelligent-Tiering, Amazon OpenSearch Serverless for log analysis, AWS Backup with vault lock for immutable storage

**Correct Answer: B**
**Explanation:** For compliance-grade global audit logging, Option B is optimal: (1) CloudTrail organization trail captures all API events across all accounts and regions; (2) OpenSearch Service provides sub-30-second searchability for the 90-day window at 50K events/second ingestion rate; (3) S3 Object Lock in Compliance mode (not Governance) provides truly immutable storage that cannot be overridden by any user including root — required for HIPAA/SOC 2; (4) S3 Glacier Flexible Retrieval provides within-4-hour retrieval for older logs; (5) 7-year S3 lifecycle policies meet retention requirements. Option A uses Governance mode which can be overridden by privileged users, not meeting HIPAA's immutability requirements. Option C's Timestream isn't designed for audit log queryability at this scale and S3 versioning isn't immutable. Option D's Intelligent-Tiering doesn't guarantee 4-hour retrieval for archived data.

---

### Question 38
A company runs a global video surveillance system with 100,000 cameras across 30 countries. Video feeds must be analyzed in real-time for security events using ML models. Detected events must trigger alerts within 2 seconds. Raw video must be stored for 30 days with specific retention requirements per country. The total video ingest rate is 500 Gbps globally. Network bandwidth from camera sites to AWS is limited to 1 Gbps per site (100 cameras per site). What is the MOST feasible architecture?

A) Stream all video to Amazon Kinesis Video Streams in the nearest AWS region, use Amazon Rekognition Video for real-time analysis, store raw video in S3 with lifecycle policies per country
B) Deploy AWS Panorama appliances at each camera site for local ML inference and real-time alerting, stream only detected events and metadata to the nearest AWS region via Kinesis Data Streams, store raw video on local NAS with lifecycle management, and upload video clips of interest to S3 in the relevant country's region
C) Deploy AWS Outposts at each site for local ML processing and temporary storage, with Store and Forward replication to the nearest AWS region for long-term storage
D) Deploy EC2 instances with GPUs at edge locations using AWS Local Zones for video processing, with S3 for storage in the nearest region

**Correct Answer: B**
**Explanation:** The key constraint is bandwidth: 100 cameras per site at even low quality generate far more than 1 Gbps, making full video streaming to AWS infeasible. Option B solves this: (1) AWS Panorama appliances process video locally at each site using ML models, enabling sub-2-second alerting without cloud round-trips; (2) Only events and metadata are sent to AWS, dramatically reducing bandwidth requirements; (3) Raw video stays on local NAS (cost-effective for 30-day retention); (4) Only relevant video clips are uploaded to S3 in country-specific regions for compliance. Option A's approach of streaming all video to AWS would require 500 Gbps of bandwidth which exceeds site limits. Option C's Outposts at 1,000 sites (100K cameras / 100 per site) is extremely expensive. Option D's Local Zones aren't available at 1,000 camera sites.

---

### Question 39
A financial technology company is designing a multi-region architecture for their payment processing platform. The platform must process payments in the region where the merchant is located (regulatory requirement). If the merchant's region becomes unavailable, payments must be queued and processed when the region recovers — they cannot be processed in a different region. The platform handles 10,000 payments per second during peak hours. Which architecture ensures regulatory compliance while maximizing availability?

A) Regional payment processing services with Amazon SQS in each region for payment queuing, Route 53 health checks to detect regional failures, and a global DynamoDB table tracking payment status across regions
B) Regional payment processing services with Amazon SQS FIFO queues for payment ordering, dead-letter queues for failed payments, S3 for payment event archival, and a separate retry processor that reprocesses payments when the region recovers, with CloudWatch alarms for regional health monitoring
C) Amazon MSK in each region for payment event streaming, payment processors as ECS services, Amazon EventBridge for cross-region payment status updates, with automatic region failover for payment processing
D) Regional payment processors behind API Gateway with Lambda, DynamoDB for payment state, and Step Functions for payment workflow orchestration with cross-region execution transfer on failure

**Correct Answer: B**
**Explanation:** The unique constraint here is that payments CANNOT be processed in a different region — they must queue and wait. Option B correctly addresses this: (1) SQS FIFO queues ensure payment ordering within each region; (2) DLQ captures payments that can't be processed during an outage; (3) The retry processor automatically reprocesses queued/failed payments when the region recovers; (4) S3 archival provides durable payment event storage even during extended outages; (5) CloudWatch alarms provide visibility into regional health. Option A's global DynamoDB table introduces cross-region data movement which may violate regulatory requirements. Option C's automatic region failover directly violates the requirement that payments can't be processed in different regions. Option D's cross-region execution transfer also violates the regional processing requirement.

---

### Question 40
A company is implementing a global single sign-on (SSO) solution for their 50,000 employees across 25 countries. The SSO must integrate with their existing on-premises Active Directory, support MFA, and provide access to 200 AWS accounts and 50 third-party SaaS applications. Employees traveling internationally must be able to authenticate with sub-3-second login times regardless of location. Which architecture provides the BEST global SSO experience?

A) AWS IAM Identity Center (successor to AWS SSO) with AD Connector to on-premises Active Directory, MFA using hardware tokens, SAML federation to SaaS applications, with a single IAM Identity Center instance in the management account
B) AWS IAM Identity Center with AWS Managed Microsoft AD in the primary region synced from on-premises AD, AWS Managed Microsoft AD multi-region replication for additional regions, IAM Identity Center with MFA, ABAC policies for fine-grained access control
C) Deploy Okta Universal Directory federating with on-premises AD, with Okta Access Gateway deployed in multiple AWS regions for low-latency authentication, SAML/OIDC integration for AWS accounts via IAM Identity Center
D) AWS IAM Identity Center with a self-managed Active Directory on EC2 in multiple regions (multi-site AD topology), AD Connector in each region, IAM Identity Center with MFA enabled, and CloudFront for accelerating the SSO portal

**Correct Answer: B**
**Explanation:** For global SSO with sub-3-second authentication, Option B is optimal: (1) IAM Identity Center is the recommended AWS service for managing SSO to multiple AWS accounts and SaaS apps; (2) AWS Managed Microsoft AD provides a fully managed Active Directory that syncs with on-premises AD; (3) Multi-region replication of Managed AD ensures authentication requests are served locally, achieving sub-3-second logins globally; (4) IAM Identity Center's built-in MFA adds security; (5) ABAC (Attribute-Based Access Control) enables fine-grained access across 200 accounts. Option A's AD Connector requires connectivity to on-premises AD for every authentication, adding latency for distant users. Option C introduces a third-party dependency (Okta) which adds cost and operational complexity. Option D's self-managed AD on EC2 requires significant operational overhead for managing multi-site AD topology.

---

### Question 41
A multinational company is evaluating whether to use a single AWS Organization with SCPs or multiple AWS Organizations for their global presence. They have autonomous business units in the US, EU, and Asia, each with their own CTO and compliance requirements. The EU business unit must demonstrate to regulators that US personnel cannot access EU data or infrastructure. The Asian business unit operates joint ventures that require sharing specific AWS resources with non-company entities. Which organizational structure BEST meets these requirements?

A) A single AWS Organization with OUs per business unit, SCPs restricting access by region, IAM permission boundaries per business unit, and AWS CloudTrail for audit evidence of access controls
B) Three separate AWS Organizations (one per business unit), with cross-organization resource sharing via AWS RAM for shared services, independent CloudTrail trails, and manual billing consolidation
C) A single AWS Organization with the management account in a neutral region, SCPs enforcing regional restrictions per OU, dedicated Security OU per business unit with independent GuardDuty and Security Hub configurations, and cross-account access limited by SCP-enforced conditions
D) Three separate AWS Organizations with a central shared services Organization for common infrastructure, connected via Transit Gateway inter-organization peering, with independent governance and billing per organization

**Correct Answer: B**
**Explanation:** The key requirement is demonstrable isolation — the EU regulator needs evidence that US personnel CANNOT access EU infrastructure. Option B provides this: (1) Separate Organizations provide the strongest isolation boundary — each Organization has its own management account, IAM, and policies with no cross-organization trust; (2) Independent CloudTrail provides clear audit evidence to EU regulators that no US accounts exist within the EU organization; (3) AWS RAM enables the Asian business unit to share specific resources with non-company entities (RAM supports sharing with external accounts); (4) Manual billing consolidation is a trade-off for the stronger isolation. Options A and C use a single Organization where the management account (controlled by one entity) could theoretically access all accounts, which may not satisfy EU regulators. Option D's shared services organization reintroduces shared infrastructure concerns.

---

### Question 42
A global news organization needs to serve breaking news content that goes from 0 to 10 million requests per second within minutes of a major event. The content includes text articles (5KB), images (500KB-5MB), and live video streams. During normal operations, traffic is 100,000 requests per second. The current architecture occasionally returns 503 errors during traffic spikes. Which architecture handles the extreme scaling pattern of breaking news?

A) Amazon CloudFront with auto-scaling origin using ALB and EC2 Auto Scaling with predictive scaling policies, S3 for static content, CloudFront functions for URL normalization
B) Amazon CloudFront with S3 as origin for static content (articles and images), CloudFront Origin Shield for origin protection, Lambda@Edge for dynamic content assembly, AWS Elemental MediaLive/MediaPackage for live video, with pre-warmed CloudFront distributions using custom cache policies with high TTLs for breaking news content
C) AWS Global Accelerator with multi-region ALB backends, EC2 Auto Scaling with target tracking on request count, S3 for media files, and ElastiCache for article caching
D) CloudFront with API Gateway and Lambda for article delivery, S3 for images, Kinesis Video Streams for live video, with API Gateway throttling to prevent 503 errors

**Correct Answer: B**
**Explanation:** Breaking news creates extreme, sudden traffic spikes requiring an architecture that can absorb them without scaling delay. Option B is correct: (1) CloudFront with S3 origin can handle millions of requests per second for static content because both services scale automatically; (2) Origin Shield reduces origin load during spikes by consolidating cache misses; (3) High TTL cache policies for breaking news content maximizes cache hit ratio — once news is published, it doesn't change frequently; (4) Lambda@Edge assembles dynamic content at the edge without origin round-trips; (5) MediaLive/MediaPackage provide scalable live video delivery. Option A relies on EC2 Auto Scaling which can't scale fast enough (minutes to launch instances) for a 100x traffic spike. Option C similarly depends on EC2 scaling. Option D's API Gateway and Lambda have concurrency limits that would throttle during a 10M RPS spike.

---

### Question 43
A company is designing a cross-region disaster recovery strategy for their AWS-hosted application. They currently use Infrastructure as Code (CloudFormation) for deployments. The DR region must have an exact replica of the primary region's infrastructure that stays continuously in sync. Any changes to the primary region's infrastructure must be automatically reflected in the DR region. What is the MOST reliable approach to keeping DR infrastructure synchronized?

A) Use CloudFormation StackSets to deploy the same template to both primary and DR regions, with auto-deployment enabled for new accounts and regions
B) Use CloudFormation StackSets with a CI/CD pipeline that deploys to both regions simultaneously, with drift detection running hourly in the DR region and automated remediation via a Lambda function that triggers stack updates when drift is detected
C) Maintain two separate CloudFormation stacks (one per region) in a Git repository, use a CI/CD pipeline (CodePipeline) that deploys changes to the primary region first, runs integration tests, then automatically deploys the same changes to the DR region
D) Use AWS CloudFormation with a custom resource that triggers a Lambda function to replicate stack changes to the DR region in real-time

**Correct Answer: C**
**Explanation:** Option C provides the most reliable synchronized DR infrastructure: (1) Two separate stacks allow region-specific configurations (different AMI IDs, AZ names, etc.) while sharing the same templates; (2) The CI/CD pipeline ensures every change to primary is automatically deployed to DR; (3) Sequential deployment with testing in primary first catches issues before they reach DR; (4) Git repository provides version control and audit trail for all infrastructure changes. Option A's StackSets deploys the same template to both regions but doesn't handle region-specific parameters well and doesn't include testing between deployments. Option B adds drift detection which is reactive rather than proactive — it detects drift after it happens rather than preventing it. Option D's custom resource approach is fragile and doesn't handle all CloudFormation change types reliably.

---

### Question 44
A large enterprise is implementing a hub-and-spoke network topology across 6 AWS regions. The hub region (us-east-1) hosts shared services including DNS, monitoring, and security tools. Spoke regions host application workloads. The enterprise requires that: all inter-region traffic is encrypted, spoke regions cannot communicate directly with each other, all traffic flows through the hub for inspection, and the solution must handle 40 Gbps of aggregate inter-region traffic. Which network architecture meets these requirements?

A) AWS Transit Gateway in each region with inter-region peering in a hub-and-spoke topology (all spokes peer with hub only), Transit Gateway route tables in each spoke configured to route all traffic through the hub TGW, AWS Network Firewall in the hub for inspection
B) AWS Cloud WAN with a hub-and-spoke segment policy, network function appliance in the hub segment using Gateway Load Balancer, Cloud WAN service insertion for traffic inspection
C) VPC peering between each spoke and the hub VPC, with route tables configured to route inter-spoke traffic through the hub, NAT Gateway in the hub for internet egress, and VPN encryption between regions
D) AWS Site-to-Site VPN connections between each spoke's Transit Gateway and the hub Transit Gateway, using VPN for encryption, firewall appliances in the hub VPC for inspection

**Correct Answer: B**
**Explanation:** Option B using AWS Cloud WAN is optimal for this enterprise-grade hub-and-spoke topology: (1) Cloud WAN segment policies natively enforce that spokes cannot communicate directly — segments are isolated by default; (2) Service insertion routes traffic through network function appliances (firewalls) in the hub segment transparently; (3) Gateway Load Balancer scales inspection to handle 40 Gbps; (4) Cloud WAN encrypts all inter-region traffic by default using the AWS global network; (5) Centralized management through network policies reduces operational complexity across 6 regions. Option A works but requires manual route management across regions and TGW inter-region peering encrypts traffic but routing configuration is more complex. Option C's VPC peering doesn't support transitive routing needed for hub-based inspection. Option D's VPN connections have throughput limitations (1.25 Gbps per VPN tunnel) and would need many tunnels for 40 Gbps.

---

### Question 45
A company is building a global search platform that must return results within 200ms regardless of the user's location. The search index is 2TB and updated continuously with 5,000 document changes per second. The platform serves 100,000 search queries per second globally. They need full-text search, faceted search, and geospatial queries. Which architecture provides the required performance and functionality?

A) Amazon OpenSearch Service domains in each region with cross-cluster replication, global search routing using Route 53 latency-based routing, UltraWarm nodes for cost optimization of older indices
B) Amazon CloudSearch domains in multiple regions with manual index synchronization, Route 53 for traffic routing
C) Amazon OpenSearch Serverless collections in each region, with a central document pipeline using Kinesis Data Streams distributing document changes to all regions, Route 53 latency-based routing for query distribution
D) Amazon DynamoDB Global Tables for document storage with Amazon Kendra for search functionality, deployed in multiple regions

**Correct Answer: A**
**Explanation:** For a high-performance global search platform, Option A is optimal: (1) OpenSearch Service provides full-text search, faceted search, and geospatial queries natively; (2) Cross-cluster replication keeps indices synchronized across regions with near-real-time replication; (3) 2TB index size is well within OpenSearch cluster capabilities; (4) Route 53 latency-based routing directs users to the nearest search cluster; (5) UltraWarm nodes reduce costs for older indices that are queried less frequently but still need to be searchable. Option B's CloudSearch has limited features compared to OpenSearch and manual sync is error-prone. Option C's OpenSearch Serverless doesn't support cross-cluster replication and has limitations on collection size. Option D's Kendra is designed for enterprise search with natural language, not high-throughput search with 100K queries/second.

---

### Question 46
A global e-commerce company needs to implement a product catalog that is consistent across all regions. The catalog has 10 million products, each with 50+ attributes, and receives 2,000 product updates per minute. Product searches must return results within 100ms from any region. The catalog must support complex queries including filtering by multiple attributes, full-text search on product descriptions, and sorting by various criteria. Which data architecture supports these requirements?

A) Amazon DynamoDB Global Tables for the catalog with DynamoDB Streams feeding into Amazon OpenSearch Service in each region for complex queries
B) Amazon Aurora Global Database for the catalog with application-level caching using ElastiCache for Redis in each region
C) Amazon DocumentDB Global Clusters for the catalog, leveraging MongoDB-compatible queries for complex attribute filtering
D) Amazon Neptune Global Database for the catalog, modeling products as graph nodes with attributes as properties

**Correct Answer: A**
**Explanation:** For a globally consistent product catalog with complex search requirements, Option A provides the best architecture: (1) DynamoDB Global Tables provide multi-region active-active replication for the authoritative product data, handling 2,000 updates/minute easily; (2) DynamoDB Streams automatically captures changes and feeds them to OpenSearch in each region; (3) OpenSearch in each region provides sub-100ms complex queries including full-text search, multi-attribute filtering, and sorting; (4) This separation of the write store (DynamoDB) from the read/search store (OpenSearch) is the correct pattern for this use case. Option B's Aurora Global Database is good for relational queries but read replicas in secondary regions have replication lag and complex search queries on a relational database at this scale would be challenging. Option C's DocumentDB Global Clusters have higher latency for cross-region replication. Option D's Neptune is designed for graph queries, not product catalog search.

---

### Question 47
A company with headquarters in Singapore (ap-southeast-1) acquires a company headquartered in Frankfurt (eu-central-1). Both companies have extensive AWS deployments using separate AWS Organizations. They need to integrate their networks, share specific services, and establish unified security monitoring while maintaining separate billing and independent operations for 12 months until full integration. Which approach enables integration while maintaining operational independence?

A) Create a new AWS Organization and migrate all accounts from both organizations, using OUs to maintain separation, with consolidated billing from day one
B) Keep both Organizations separate, establish Transit Gateway inter-region peering between their networks, use AWS RAM to share specific resources cross-organization, deploy a shared Amazon Security Lake aggregating findings from both organizations' GuardDuty, Security Hub, and CloudTrail
C) Merge the smaller organization into the larger one, maintaining the smaller company's accounts in a dedicated OU with limited SCPs
D) Keep both Organizations and connect them via VPN between their networks, share data through S3 cross-account access, and use separate security monitoring tools

**Correct Answer: B**
**Explanation:** For a 12-month integration period maintaining independence, Option B is correct: (1) Keeping both Organizations maintains separate billing, SCPs, and operational independence as required; (2) Transit Gateway inter-region peering connects networks between Organizations without merging them; (3) AWS RAM enables cross-organization resource sharing for specific services; (4) Amazon Security Lake provides unified security monitoring by aggregating findings from both organizations' security services into a central data lake. Option A's immediate migration disrupts operations and doesn't maintain independence for 12 months. Option C's merge is premature and one-directional. Option D's VPN connection is less capable than Transit Gateway peering and separate security tools don't provide unified monitoring.

---

### Question 48
A company operates a global SaaS platform and needs to implement tenant isolation in a multi-region deployment. They have 500 enterprise tenants and 50,000 SMB tenants. Enterprise tenants require dedicated compute resources and separate data stores. SMB tenants share resources for cost efficiency. All tenants must be routable to their nearest region. How should the architect design the multi-tenant multi-region isolation?

A) Separate AWS accounts per enterprise tenant using AWS Organizations, pooled accounts for SMB tenants with application-level tenant isolation, Route 53 latency-based routing with tenant-aware DNS resolution
B) Separate VPCs per enterprise tenant in each region, shared VPCs for SMB tenants with namespace-based isolation in EKS, Amazon API Gateway with API keys per tenant, DynamoDB with tenant-ID partition keys for SMB data isolation
C) Dedicated EKS namespaces per enterprise tenant with resource quotas and network policies, shared EKS namespaces for SMB tenants with pod-level isolation, separate DynamoDB tables per enterprise tenant, shared DynamoDB tables with tenant-ID partition keys for SMB tenants, Global Accelerator for global routing with custom routing to direct enterprise tenants to dedicated endpoints
D) Single shared infrastructure with IAM session policies for tenant isolation, application-level data filtering based on tenant context, CloudFront for global routing

**Correct Answer: C**
**Explanation:** Option C provides the right balance of isolation and efficiency: (1) Dedicated EKS namespaces with resource quotas and network policies give enterprise tenants compute isolation without the overhead of separate accounts/VPCs; (2) Separate DynamoDB tables per enterprise tenant provide data isolation with independent throughput settings; (3) Shared namespaces and tables for SMB tenants optimize costs; (4) Global Accelerator with custom routing can direct enterprise tenants to dedicated endpoints while SMB tenants share standard endpoints. Option A's separate accounts per enterprise tenant across multiple regions creates unmanageable complexity at 500 tenants × multiple regions. Option B's separate VPCs per enterprise tenant similarly explodes in complexity. Option D's single shared infrastructure with only IAM-based isolation doesn't provide the dedicated compute resources enterprise tenants require.

---

### Question 49
A company needs to implement a global disaster recovery test that validates their multi-region failover without impacting production. The production environment spans 3 regions with a primary in us-east-1. They want to simulate the complete loss of us-east-1 and validate that eu-west-1 takes over all traffic within 5 minutes. The test must be repeatable, auditable, and reversible. Which approach provides the MOST realistic DR test?

A) Use Route 53 ARC (Application Recovery Controller) with routing controls to simulate the failure by disabling the us-east-1 routing control, monitor failover metrics in CloudWatch, and re-enable the routing control after validation
B) Use AWS Fault Injection Service (FIS) to create an experiment that stops EC2 instances, pauses RDS clusters, and blocks network traffic in us-east-1, combined with Route 53 health checks to trigger automatic failover to eu-west-1
C) Manually update Route 53 records to point away from us-east-1, monitor application behavior, and revert DNS changes after testing
D) Deploy a parallel testing environment that mirrors production, simulate the failure in the testing environment using FIS, and extrapolate results to production

**Correct Answer: B**
**Explanation:** Option B provides the most realistic DR test: (1) AWS FIS creates controlled chaos engineering experiments that simulate actual resource failures in us-east-1; (2) Stopping EC2 instances, pausing RDS, and blocking network traffic closely simulates a real regional failure; (3) Route 53 health checks detect the simulated failure and trigger automatic failover, testing the actual failover mechanism; (4) FIS experiments are repeatable (saved as templates), auditable (CloudTrail logging), and reversible (automatic rollback or stop conditions); (5) Testing the actual failover path in production validates real behavior. Option A only tests DNS routing but doesn't validate that the DR region's applications and databases actually take over correctly. Option C is manual and not repeatable/auditable. Option D tests a parallel environment which may not accurately reflect production behavior.

---

### Question 50
A telecommunications company processes call detail records (CDRs) from 200 million subscribers globally. CDRs must be processed within 5 minutes for billing, stored for 5 years for regulatory compliance, and available for real-time fraud detection. The system generates 2 million CDRs per second during peak hours. Each CDR is 1KB. Data sovereignty requires CDRs to be stored in the subscriber's home country. Which architecture handles this workload?

A) Amazon Kinesis Data Streams with enhanced fan-out in each region for ingestion, Kinesis Data Analytics (Apache Flink) for real-time fraud detection, Kinesis Data Firehose to S3 for storage with partition by country, AWS Glue for ETL to the billing system
B) Amazon MSK in each region for CDR ingestion, Apache Flink on Amazon EMR for fraud detection, MSK Connect with S3 Sink Connector for country-partitioned storage, Apache Spark on EMR for billing batch processing
C) Amazon Kinesis Data Streams for ingestion, Lambda for CDR processing and routing, DynamoDB for real-time fraud detection state, S3 for storage with country-specific buckets and prefixes, Step Functions for billing orchestration
D) Amazon SQS for CDR queuing, EC2 consumer fleet for processing, Amazon Redshift for storage and analytics, custom fraud detection on EC2

**Correct Answer: A**
**Explanation:** For 2M CDRs/second with real-time fraud detection and country-based data sovereignty, Option A is optimal: (1) Kinesis Data Streams with enhanced fan-out handles 2M records/second per region with dedicated throughput per consumer; (2) Kinesis Data Analytics (Flink) provides stateful real-time fraud detection with windowed aggregations and pattern matching; (3) Firehose to S3 with dynamic partitioning by country ensures CDRs are stored in the correct country's S3 path, meeting data sovereignty; (4) Glue ETL processes CDRs into billing-ready format within the 5-minute window; (5) S3 lifecycle policies handle the 5-year retention. Option B is viable but adds operational complexity with self-managed Flink on EMR. Option C's Lambda has concurrency limits that make 2M/second challenging and DynamoDB isn't ideal for complex fraud pattern detection. Option D's SQS and Redshift aren't designed for this real-time ingestion scale.

---

### Question 51
A company needs to implement global database encryption key management for their multi-region deployment. They have Aurora databases in 5 regions, each encrypted with AWS KMS. Regulatory requirements mandate that encryption keys must be rotated annually, the key material must be generated by the company's on-premises HSM, and the company must be able to immediately revoke access to encrypted data in any region during a security incident. Which KMS configuration meets these requirements?

A) AWS KMS customer-managed keys (CMKs) in each region created with imported key material from the on-premises HSM, with manual annual rotation creating new keys and re-encrypting databases, key deletion with a 7-day waiting period for revocation
B) AWS KMS with custom key stores backed by AWS CloudHSM clusters in each region, annual automatic key rotation enabled, and key disabling for immediate access revocation
C) AWS KMS CMKs with imported key material in each region, CloudWatch Events triggering Lambda for annual rotation with new imported key material, and key policies that can be updated to deny all access for immediate revocation during incidents
D) AWS KMS multi-Region keys created from the on-premises HSM key material, with centralized rotation and management from a single primary region

**Correct Answer: C**
**Explanation:** Option C meets all three regulatory requirements: (1) Imported key material from the on-premises HSM satisfies the requirement that key material must be generated by the company's HSM; (2) CloudWatch Events (EventBridge) with Lambda automates annual rotation by importing new key material — note that automatic rotation is NOT available for KMS keys with imported key material, requiring this custom approach; (3) Updating key policies to deny all access provides immediate revocation, faster than key deletion which has a mandatory waiting period. Option A's 7-day deletion waiting period doesn't provide immediate revocation. Option B's CloudHSM custom key stores use AWS-managed CloudHSM clusters, not the company's on-premises HSM. Option D's multi-Region keys don't support imported key material for the primary key in this way, and centralized management may not meet per-region key management requirements.

---

### Question 52
A solutions architect needs to design a content localization system that automatically adapts website content for users in 50 countries. Content adaptations include language translation, currency conversion, regulatory disclaimer insertion, and image localization. The system must support A/B testing of localized content and serve 500,000 requests per second. Localization rules change frequently (multiple times per day). Which architecture provides the MOST flexible and performant localization?

A) CloudFront with Lambda@Edge for content transformation at the edge, localization rules stored in DynamoDB Global Tables, A/B testing implemented through CloudFront headers and Lambda@Edge routing, with ElastiCache at the origin for rule caching
B) CloudFront with CloudFront Functions for viewer request handling (country detection, A/B assignment), Lambda@Edge for origin request content transformation, localization rules cached in Lambda@Edge function environment with 5-minute refresh from a central configuration store, and S3 pre-generated localized content for static assets
C) Multiple CloudFront distributions per locale, Route 53 geolocation routing to the appropriate distribution, origin servers generating localized content on demand
D) Single CloudFront distribution with origin-side localization using EC2 instances behind ALB, with ALB rules routing to locale-specific target groups

**Correct Answer: B**
**Explanation:** Option B provides the optimal balance of performance and flexibility: (1) CloudFront Functions handle lightweight viewer-request operations (country detection, A/B group assignment) at massive scale with sub-millisecond execution; (2) Lambda@Edge at origin request performs the heavier content transformation (translation, currency, disclaimers); (3) Caching rules in Lambda@Edge with 5-minute refresh from a central store supports frequent rule changes without origin calls; (4) Pre-generated localized static assets in S3 avoid runtime transformation for images; (5) The combination of CloudFront Functions and Lambda@Edge optimizes cost and performance. Option A queries DynamoDB on every request from Lambda@Edge, adding latency. Option C requires managing 50+ distributions which is operationally infeasible. Option D pushes all localization to the origin, not leveraging edge computing for performance.

---

### Question 53
A company is designing a global data pipeline that processes financial market data from 20 stock exchanges worldwide. Each exchange provides data in a different format and protocol (FIX, ITCH, OUCH, etc.). The pipeline must normalize data into a common format, enrich it with reference data, and make it available for downstream consumers within 50ms of receipt. The total message rate across all exchanges is 5 million messages per second. Which architecture handles the protocol diversity and latency requirements?

A) Amazon Kinesis Data Streams with custom producers per exchange protocol, Kinesis Data Analytics (Flink) for normalization and enrichment, Kinesis Data Streams for normalized output
B) Protocol-specific ingest adapters on EC2 instances in placement groups (one adapter per exchange protocol), publishing normalized messages to Amazon MSK, MSK consumers for enrichment using a local Redis cache of reference data, enriched data published to a separate MSK topic for downstream consumers
C) AWS AppSync with protocol transformation Lambda resolvers, DynamoDB for reference data, AppSync subscriptions for downstream consumers
D) Amazon MQ (ActiveMQ) with protocol bridges for each exchange format, message transformation using Camel routes, forwarding to Amazon SQS for downstream processing

**Correct Answer: B**
**Explanation:** For ultra-low-latency financial data processing at 5M messages/second, Option B is correct: (1) EC2 instances in placement groups provide the lowest network latency for protocol adapters — financial protocols like FIX/ITCH require custom implementations that Lambda can't handle efficiently; (2) Placement groups ensure sub-millisecond network latency between adapters and MSK; (3) MSK handles 5M messages/second with partitioned topics; (4) Local Redis cache for reference data enrichment avoids network calls during the critical path; (5) The two-topic pattern (raw → enriched) provides clear separation. Option A with Kinesis can handle the throughput but custom producers add complexity and Flink enrichment adds latency. Option C with AppSync isn't designed for financial protocol processing or this message rate. Option D with ActiveMQ has throughput limitations and Camel routes add processing latency.

---

### Question 54
A government agency needs to deploy a classified application on AWS GovCloud that serves users in the continental US, Hawaii, and overseas military installations. The application requires FIPS 140-2 Level 3 encryption for data at rest and in transit, FedRAMP High authorization, and must be accessible from SIPR (Secret Internet Protocol Router) networks through approved cross-domain solutions. The application uses machine learning for intelligence analysis. Which architecture meets these requirements?

A) AWS GovCloud (US-West) with KMS CloudHSM for FIPS 140-2 Level 3, Direct Connect with MACSec encryption, SageMaker for ML, CloudFront in GovCloud for content delivery
B) AWS GovCloud (US-West and US-East) with AWS CloudHSM clusters for FIPS 140-2 Level 3 key management, AWS Direct Connect with dedicated connections through approved CDS facilities for SIPR connectivity, SageMaker with VPC-only mode and FIPS endpoints, private connectivity only (no public internet exposure)
C) Standard AWS regions with FIPS 140-2 endpoints enabled, KMS with customer-managed keys, VPN connections from military networks, Rekognition for ML analysis
D) AWS Outposts deployed at military installations connected to GovCloud, CloudHSM on the Outposts, direct SIPR connectivity through local network infrastructure

**Correct Answer: B**
**Explanation:** For classified workloads accessible from SIPR networks, Option B is correct: (1) AWS GovCloud is required for FedRAMP High workloads and provides the necessary authorization; (2) AWS CloudHSM provides FIPS 140-2 Level 3 validated hardware security modules (KMS is Level 2 only); (3) Direct Connect through approved Cross-Domain Solutions (CDS) facilities is the only approved method for SIPR connectivity to AWS; (4) Both GovCloud regions (US-West and US-East) provide redundancy; (5) SageMaker in VPC-only mode with FIPS endpoints ensures ML processing stays within the security boundary. Option A uses KMS CloudHSM which doesn't exist — CloudHSM is a separate service. Option C uses standard regions which don't meet FedRAMP High requirements. Option D's Outposts deployment doesn't solve the CDS requirement for SIPR connectivity.

---

### Question 55
A company operates a global API platform that needs to implement request deduplication across regions. When a client retries a request (due to network timeout), the same request may hit a different region. The platform must ensure that each unique request is processed exactly once, even if received in multiple regions simultaneously. The API processes financial transactions, so duplicate processing would cause monetary loss. Transaction volume is 10,000 per second globally. Which architecture provides cross-region request deduplication?

A) Use API Gateway with request validators and client-generated idempotency keys, stored in DynamoDB Global Tables with conditional writes to detect duplicates before processing
B) Use ElastiCache for Redis Global Datastore with SET NX (set if not exists) for idempotency key checking, with a TTL matching the retry window
C) Use Amazon SQS FIFO queues with content-based deduplication in each region, with a cross-region deduplication check using DynamoDB before queue processing
D) Implement API-level idempotency with client-provided idempotency keys stored in DynamoDB Global Tables, where the processing Lambda function performs a conditional PutItem (attribute_not_exists) before processing, and the DynamoDB record stores the processing result for replay on duplicate requests

**Correct Answer: D**
**Explanation:** Option D provides robust cross-region deduplication for financial transactions: (1) Client-provided idempotency keys ensure the same request is identifiable across regions; (2) DynamoDB Global Tables replicate the idempotency key store across all regions within ~1 second; (3) Conditional PutItem with attribute_not_exists provides atomic check-and-set, preventing duplicate processing; (4) Storing the processing result enables returning the same response for duplicate requests without reprocessing — critical for financial transactions where clients need a consistent response. The eventual consistency window of DynamoDB Global Tables (~1 second) is acceptable since network retry timeouts are typically longer. Option A is similar but doesn't mention storing and replaying results. Option B's Redis Global Datastore only has one writable primary, creating a bottleneck. Option C adds unnecessary SQS complexity.

---

### Question 56
A company is designing a multi-region architecture for their ERP system that requires strong data consistency for financial transactions but can tolerate eventual consistency for non-financial data. The system has 100 database tables, of which 15 are financial (requiring strong consistency) and 85 are operational (eventually consistent is acceptable). Write traffic is 70% operational and 30% financial. The system must operate in 3 regions with read and write capability in each. How should the architect design the database layer?

A) Amazon Aurora Global Database for all tables, with application logic distinguishing between financial and operational queries for routing decisions
B) Amazon Aurora Global Database for financial tables with the primary writer in one region and write forwarding from others, and DynamoDB Global Tables for operational tables with multi-region active-active writes
C) Amazon Aurora Multi-Master for financial tables across all 3 regions, and DynamoDB Global Tables for operational tables
D) All tables in DynamoDB Global Tables with DynamoDB Transactions for financial table operations to ensure consistency

**Correct Answer: B**
**Explanation:** This architecture correctly separates the two data consistency requirements: (1) Aurora Global Database for the 15 financial tables provides strong consistency — all writes go through the primary cluster, and write forwarding from secondary regions enables write capability from any region while maintaining ACID guarantees; (2) DynamoDB Global Tables for the 85 operational tables provides multi-region active-active writes with eventual consistency, which meets the stated requirements; (3) 70% of writes (operational) benefit from DynamoDB's multi-region write scalability. Option A uses Aurora for everything but doesn't optimize for the operational data that can tolerate eventual consistency. Option C mentions Aurora Multi-Master which was deprecated. Option D's DynamoDB Transactions provide ACID within a single region but not strong cross-region consistency — DynamoDB Global Tables are eventually consistent across regions.

---

### Question 57
A large enterprise is implementing centralized logging across their global AWS deployment spanning 500 accounts across 5 regions. Log volume is 50TB per day. They need real-time log analysis for security alerts, 90-day hot storage for investigation, and 7-year cold storage for compliance. The security team needs to search across all accounts and regions from a single interface. Which architecture provides the MOST cost-effective centralized logging at this scale?

A) CloudWatch Logs in each account with cross-account subscription filters to a central account's Kinesis Data Streams, Lambda consumers writing to Amazon OpenSearch for hot storage, S3 lifecycle policies for cold storage
B) CloudWatch Logs in each account forwarded to S3 via Kinesis Data Firehose in each region, S3 replication to a central logging account, Amazon OpenSearch Ingestion pipelines for hot data processing to OpenSearch, S3 Intelligent-Tiering with Glacier transition for cold storage, OpenSearch Dashboards for the investigation interface
C) Each account ships logs directly to a central Amazon OpenSearch Service cluster, with UltraWarm for 90-day storage and S3 cold storage for 7-year retention
D) AWS CloudTrail Lake for all API audit logs, CloudWatch Logs Insights for application log analysis with cross-account query capability, S3 with Glacier for long-term retention

**Correct Answer: B**
**Explanation:** At 50TB/day across 500 accounts, Option B provides the most cost-effective and scalable solution: (1) Firehose in each region efficiently batches and compresses logs to S3, which is the most cost-effective storage at this scale; (2) S3 replication centralizes logs for unified access; (3) OpenSearch Ingestion pipelines process only the relevant subset for hot/searchable storage, reducing OpenSearch cluster size; (4) S3 Intelligent-Tiering automatically optimizes storage costs, with Glacier for long-term compliance storage; (5) OpenSearch Dashboards provides the unified search interface. Option A's Lambda consumers at this scale would be expensive and complex. Option C would require an enormous OpenSearch cluster to ingest 50TB/day directly, which is cost-prohibitive. Option D's CloudWatch Logs Insights has cross-account capability but isn't optimized for 50TB/day search at scale.

---

### Question 58
A gaming company needs to implement a global leaderboard system that ranks 100 million players in real-time. The leaderboard must support: querying a player's global rank, retrieving the top-N players, and retrieving players near a specific rank. Score updates happen at a rate of 500,000 per second globally. The leaderboard must be consistent across all regions within 2 seconds. Which data store and architecture provides these capabilities?

A) Amazon ElastiCache for Redis with Sorted Sets in each region, using a Lambda-based synchronization mechanism that publishes score updates to all regions via SNS, with Redis ZRANK, ZRANGE, and ZREVRANGE operations for leaderboard queries
B) Amazon DynamoDB Global Tables with a GSI on score for ranking, using Scan operations for rank calculation
C) Amazon Aurora Global Database with a score-indexed table, using SQL window functions (RANK() OVER) for real-time rank calculation
D) Amazon Neptune in each region for graph-based ranking relationships, with cross-region replication via Neptune Streams

**Correct Answer: A**
**Explanation:** For real-time global leaderboard operations at scale, Option A is optimal: (1) Redis Sorted Sets are purpose-built for leaderboard operations — ZADD for score updates (O(log N)), ZRANK for rank lookups (O(log N)), ZRANGE/ZREVRANGE for top-N and nearby player queries (O(log N + M)); (2) These operations on 100M elements complete in microseconds; (3) Cross-region synchronization via SNS ensures global consistency within 2 seconds; (4) ElastiCache handles 500K operations/second. Option B's DynamoDB with GSI can't efficiently return a player's rank among 100M items — it would require expensive Scan operations. Option C's SQL window functions over 100M rows would be too slow for real-time queries at 500K updates/second. Option D's Neptune is designed for relationship traversal, not sorted ranking operations.

---

### Question 59
A company operates a multi-cloud environment with primary workloads on AWS and secondary workloads on Azure. They need to implement a unified networking strategy that connects AWS VPCs in 3 regions with Azure VNets in 2 regions, with consistent network policies and monitoring. Total cross-cloud traffic is 10 Gbps. They also need service discovery across both clouds. Which architecture provides the MOST integrated multi-cloud connectivity?

A) AWS Transit Gateway with VPN connections to Azure Virtual WAN, Transit Gateway inter-region peering for AWS-side connectivity, Azure VNet peering for Azure-side connectivity, and a shared DNS zone using Amazon Route 53 with conditional forwarding to Azure DNS
B) Equinix Cloud Exchange (or similar) providing Layer 2 connectivity between AWS Direct Connect and Azure ExpressRoute, with BGP routing for traffic management, HashiCorp Consul for cross-cloud service discovery
C) Site-to-site VPN between each AWS VPC and each Azure VNet, with route tables configured for full mesh connectivity
D) AWS Cloud WAN for AWS-side networking with IPsec VPN tunnels to Azure, Azure Virtual WAN for Azure-side networking, with AWS Cloud Map and Azure DNS Private Resolver for service discovery through shared DNS zones

**Correct Answer: D**
**Explanation:** Option D provides the most integrated multi-cloud networking: (1) AWS Cloud WAN provides centralized AWS network management with built-in inter-region connectivity and network policies; (2) Azure Virtual WAN similarly manages Azure networking centrally; (3) IPsec VPN tunnels between Cloud WAN and Azure Virtual WAN provide encrypted cross-cloud connectivity without requiring physical infrastructure; (4) AWS Cloud Map combined with Azure DNS Private Resolver with shared DNS zones enables service discovery across both clouds; (5) Both Cloud WAN and Virtual WAN provide consistent network policy enforcement on their respective platforms. Option A works but Transit Gateway requires more manual management than Cloud WAN. Option B requires physical colocation infrastructure (costly, complex). Option C's full mesh VPN doesn't scale and lacks centralized management.

---

### Question 60
A pharmaceutical company needs to share clinical trial results with regulatory agencies in 10 countries. Each agency requires access to different subsets of the data, and access must be auditable. The data is stored in S3 in the company's AWS account. Some agencies use AWS, some use Azure, and some use on-premises infrastructure. Data transfers must be encrypted and must go directly to the agency (no third-party intermediation). Which solution provides secure, auditable data sharing across different environments?

A) S3 pre-signed URLs with expiration, shared via encrypted email, with CloudTrail logging access
B) AWS Transfer Family SFTP endpoints with agency-specific credentials, S3 access logging for auditing, VPN connections for agencies requiring direct connectivity
C) Amazon S3 Access Points per agency with VPC endpoint policies for AWS-based agencies, AWS Transfer Family for non-AWS agencies with SFTP/FTPS endpoints, IAM policies restricting each agency to their specific data subset, and CloudTrail with S3 access logging for comprehensive audit trails
D) AWS DataSync with cross-account/cross-cloud capabilities for automated data delivery, scheduled transfers to each agency's storage

**Correct Answer: C**
**Explanation:** Option C addresses the multi-environment requirements: (1) S3 Access Points per agency provide isolated, scoped access to specific data subsets — each Access Point has its own IAM policy restricting to relevant data; (2) VPC endpoint policies secure access for AWS-based agencies; (3) AWS Transfer Family provides SFTP/FTPS endpoints for non-AWS agencies (Azure, on-premises) with encryption in transit; (4) Comprehensive auditing through both CloudTrail (API-level) and S3 access logs (object-level); (5) Direct access without third-party intermediation. Option A's pre-signed URLs are temporary and lack fine-grained access control. Option B provides SFTP but lacks the S3 Access Points' per-agency access scoping. Option D's DataSync pushes data which doesn't meet the direct-access model and creates copies.

---

### Question 61
A company has a globally distributed workforce of 100,000 employees who access internal applications through a VPN. VPN connections to the primary datacenter in us-east-1 cause latency for employees in Asia and Europe. The company wants to migrate to a zero-trust architecture that provides secure application access without VPN while maintaining DLP (Data Loss Prevention) controls. Which AWS-based architecture replaces the traditional VPN?

A) AWS Client VPN with endpoints in multiple regions, split-tunnel configuration to route only internal traffic through the VPN, with AWS Network Firewall for DLP inspection
B) AWS Verified Access with identity-based access policies integrated with their IdP, deployed in multiple regions with Route 53 latency-based routing, AWS WAF for DLP rule enforcement, and CloudWatch for access monitoring
C) Amazon WorkSpaces deployed in each region for application access, with WorkSpaces Web for browser-based access, application streaming to user devices
D) AWS PrivateLink endpoints in each region for each internal application, Direct Connect from regional offices, IAM Identity Center for authentication

**Correct Answer: B**
**Explanation:** For a zero-trust replacement of VPN, Option B is correct: (1) AWS Verified Access provides application-level access based on identity and device trust signals without requiring VPN — core to zero-trust architecture; (2) Integration with the company's IdP enables identity-based access policies; (3) Multi-region deployment with Route 53 latency-based routing solves the latency problem for global employees; (4) AWS WAF provides DLP rule enforcement by inspecting request/response content; (5) CloudWatch provides monitoring and audit logging. Option A still uses VPN which the company wants to eliminate. Option C with WorkSpaces is a virtual desktop solution, not a zero-trust access solution, and adds significant cost for 100K users. Option D's PrivateLink requires Direct Connect or VPN for non-office locations and doesn't implement zero-trust principles.

---

### Question 62
A company is designing a global weather data platform that ingests satellite imagery, radar data, and sensor readings from 50,000 weather stations globally. The platform must process this data into weather forecasts using ML models and distribute forecasts to millions of consumers via API within 15 minutes of data ingestion. Raw data volume is 100TB per day. Forecast accuracy depends on having the complete global dataset available for ML inference. Which architecture handles the ingestion, processing, and distribution requirements?

A) Regional S3 buckets for data ingestion with S3 Event Notifications triggering Step Functions for processing, SageMaker batch transform for ML inference, API Gateway with CloudFront for forecast distribution
B) Amazon Kinesis Data Streams in each region for real-time data ingestion, S3 Cross-Region Replication to aggregate all data in a central processing region, SageMaker Processing jobs for data preparation, SageMaker training and batch inference for forecast generation, CloudFront with API Gateway in multiple regions for forecast distribution
C) AWS IoT Core for station data ingestion, Amazon Timestream for time-series storage, custom ML on EC2 GPU instances, API Gateway for distribution
D) Direct S3 multipart uploads from all stations to a single central bucket, EMR for data processing and ML training, API Gateway for distribution

**Correct Answer: B**
**Explanation:** For a 100TB/day global weather processing pipeline with a 15-minute SLA, Option B is correct: (1) Kinesis Data Streams provides real-time ingestion at each region's edge; (2) S3 CRR aggregates all global data to a central region — necessary because forecast accuracy requires the complete global dataset; (3) SageMaker Processing handles the data preparation at scale; (4) SageMaker batch inference generates forecasts from the trained model; (5) CloudFront with regional API Gateways distributes forecasts globally with low latency. The 15-minute window accommodates CRR replication time plus processing. Option A's Step Functions approach is complex for 100TB/day processing. Option C's Timestream isn't suited for satellite imagery and radar data at this scale. Option D's direct upload to a single bucket creates an ingestion bottleneck for 50,000 stations.

---

### Question 63
A company needs to design a disaster recovery strategy for their Amazon Redshift data warehouse that contains 50TB of data. The primary cluster is in us-east-1. They need an RPO of 1 hour and RTO of 2 hours. The DR cluster in eu-west-1 must be available for read-only analytics queries at all times. During a disaster, the DR cluster must be promoted to accept writes. What is the MOST cost-effective architecture?

A) Redshift cross-region snapshot copy to eu-west-1, with automated snapshots every hour, and a scripted restoration process for DR activation
B) Two separate Redshift clusters with ETL-based data synchronization using AWS Glue, with the DR cluster always available for reads
C) Amazon Redshift cross-region data sharing from the primary cluster (us-east-1) to a consumer cluster in eu-west-1 for read-only queries, combined with automated cross-region snapshot copy (1-hour interval) for DR promotion capability
D) Amazon Redshift with RA3 nodes using Redshift Managed Storage backed by S3, with S3 Cross-Region Replication for the underlying data, and a standby cluster in eu-west-1

**Correct Answer: C**
**Explanation:** Option C optimally meets all requirements at lowest cost: (1) Cross-region data sharing provides the always-available read-only analytics capability in eu-west-1 without maintaining a full copy of the data — the consumer cluster accesses the producer's data in near-real-time; (2) Automated cross-region snapshots every hour meet the 1-hour RPO; (3) During a disaster, a new cluster can be restored from the latest snapshot in eu-west-1 within the 2-hour RTO; (4) This is cost-effective because the consumer cluster for data sharing can be smaller since it's just for queries. Option A meets RPO/RTO but doesn't provide always-available read queries. Option B requires full ETL synchronization which is expensive and complex. Option D's approach with S3 CRR doesn't actually work with Redshift Managed Storage in this way.

---

### Question 64
A company is designing a global content management system where content authors in 5 regions create and edit content simultaneously. The system must handle concurrent edits to the same document with conflict resolution. Documents average 100KB and the system stores 10 million documents. Each document has metadata, version history, and access control lists. Which architecture supports collaborative content editing with conflict resolution?

A) Amazon S3 with versioning for document storage, DynamoDB for metadata with optimistic locking using version numbers, Lambda-based conflict resolution that merges concurrent edits using operational transformation (OT)
B) Amazon S3 for document storage with DynamoDB Global Tables for metadata and lock management, using DynamoDB's last-writer-wins for automatic conflict resolution
C) Amazon DocumentDB Global Clusters for document and metadata storage, with application-level locking using distributed locks in DynamoDB
D) Amazon S3 for document storage, DynamoDB Global Tables for document metadata with version vectors for conflict detection, a conflict resolution service using Step Functions that presents conflicting versions to authors for manual resolution when automatic merge fails, and S3 event notifications for triggering version sync across regions

**Correct Answer: D**
**Explanation:** For global collaborative editing with proper conflict resolution, Option D is correct: (1) S3 provides durable document storage; (2) DynamoDB Global Tables replicate metadata globally with multi-region write capability; (3) Version vectors (not simple version numbers) correctly detect concurrent edits from different regions — this is the theoretically correct approach for distributed conflict detection; (4) Step Functions orchestrate the conflict resolution workflow; (5) Automatic merge for compatible changes with manual resolution fallback provides the best user experience; (6) S3 event notifications propagate document changes. Option A's optimistic locking doesn't work well across regions with replication lag. Option B's last-writer-wins silently loses data — unacceptable for content management. Option C's DocumentDB Global Clusters have higher latency for cross-region replication.

---

### Question 65
A company running a multi-region application needs to implement a canary deployment strategy that tests new deployments against real production traffic in each region before full rollout. The canary must process 5% of production traffic, compare response times and error rates between the canary and the stable version, and automatically rollback if the canary performs worse. The application runs on EKS across 3 regions. Which architecture automates this canary process?

A) Kubernetes native canary with Istio VirtualService weighted routing (95/5 split), Prometheus metrics collection, and a custom operator that evaluates metrics and updates the VirtualService weights
B) AWS App Mesh with virtual router traffic splitting (95/5), CloudWatch metrics for comparison, Lambda-based evaluator triggered by CloudWatch Events that updates traffic weights
C) Argo Rollouts with canary strategy in each EKS cluster, integrated with Amazon Managed Prometheus for metrics collection, Argo Rollouts AnalysisTemplates querying Prometheus for latency and error rate comparison, automated promotion or rollback based on analysis results
D) Blue-green deployment using CodeDeploy with ECS, with a 5% traffic weight during the test phase, CloudWatch alarms for rollback

**Correct Answer: C**
**Explanation:** For EKS-based canary deployments with automated metric-driven promotion/rollback, Option C is best: (1) Argo Rollouts is the de facto standard for progressive delivery on Kubernetes; (2) Canary strategy natively supports percentage-based traffic splitting; (3) AnalysisTemplates define the success criteria (latency and error rate thresholds); (4) Integration with Amazon Managed Prometheus provides reliable metric collection across regions; (5) Automated promotion on success or rollback on failure requires no custom code; (6) The entire workflow is declarative and version-controlled. Option A requires building a custom operator for metric evaluation. Option B uses App Mesh and Lambda which requires more custom development. Option D uses CodeDeploy which is designed for ECS, not EKS.

---

### Question 66
A company needs to serve different content to users based on their country, but the determination must be more granular than CloudFront's geo-restriction feature. They need to consider: the user's country, whether the user has a valid subscription (stored in a database), and the user's device type. Based on these factors, different versions of content should be served. Content is stored in S3 with 100,000 objects across 50 country-specific prefixes. The system serves 200,000 requests per second. How should the solution architect design this?

A) CloudFront with Lambda@Edge at the origin request event, querying DynamoDB for subscription validation, constructing the S3 object path based on country (from CloudFront-Viewer-Country header), subscription status, and device type (from User-Agent header)
B) CloudFront with CloudFront Functions at the viewer request event for device detection and country-based routing, Lambda@Edge at the origin request event for subscription validation against DynamoDB with DAX, and S3 origin with the path modified based on all three factors
C) API Gateway with Lambda authorizer for subscription validation, S3 for content storage, CloudFront with custom origin pointing to API Gateway
D) CloudFront with signed cookies containing country, subscription, and device information, with a custom origin that validates cookies and serves appropriate content

**Correct Answer: B**
**Explanation:** Option B optimally distributes work between CloudFront Functions and Lambda@Edge: (1) CloudFront Functions at viewer request handles lightweight operations (device detection from User-Agent, country from CloudFront-Viewer-Country header) with sub-millisecond execution and can set these as cache key headers; (2) Lambda@Edge at origin request handles the heavier subscription validation against DynamoDB/DAX — this runs only on cache misses, not every request; (3) Including country, subscription status, and device type in the cache key ensures different content versions are cached separately; (4) DAX provides sub-millisecond DynamoDB reads for subscription checks. Option A puts all logic in Lambda@Edge at origin request which is more expensive. Option C routes all traffic through API Gateway which adds latency and cost. Option D requires pre-generating signed cookies and doesn't handle dynamic subscription changes.

---

### Question 67
A company is architecting a global notification system that must deliver push notifications, emails, and SMS to 500 million users. Notifications must be delivered within 30 seconds of being triggered. The system must support notification preferences (channel, frequency, quiet hours based on user timezone), and must not exceed rate limits imposed by downstream providers (Apple APNs, Google FCM, email providers). The system handles 100,000 notification triggers per second during peak events. Which architecture provides reliable, preference-aware global notification delivery?

A) Amazon SNS for push notifications and SMS, Amazon SES for email, with a custom preference engine on Lambda that queries DynamoDB for user preferences and routes to the appropriate channel
B) Amazon Pinpoint for all channels with custom segments based on preferences, Pinpoint campaigns triggered by events, with Kinesis Data Streams for high-volume event processing
C) Amazon Kinesis Data Streams for notification event ingestion, a preference resolution service on ECS reading from ElastiCache (pre-loaded user preferences), fan-out to channel-specific SQS queues with rate limiting, SNS for push notifications, SES for email, SNS for SMS, with per-provider rate limiters using SQS message timers and concurrency controls on Lambda consumers
D) Amazon EventBridge for notification event routing based on preference rules, Lambda consumers for each channel, SES for email, SNS for push and SMS

**Correct Answer: C**
**Explanation:** At 100K triggers/second to 500M users with preference-aware, rate-limited delivery, Option C provides the necessary architecture: (1) Kinesis ingests the high-volume notification triggers; (2) ECS-based preference resolution with ElastiCache provides sub-millisecond preference lookups without database bottlenecks; (3) Channel-specific SQS queues separate the delivery paths, enabling independent rate limiting per provider; (4) Per-provider rate limiters using SQS message timers and Lambda concurrency controls prevent exceeding APNs/FCM/email provider rate limits; (5) SNS and SES provide the actual delivery capability. Option A's Lambda-based approach may struggle with 100K/second throughput and doesn't address rate limiting. Option B's Pinpoint has throughput limits that may not handle 100K triggers/second. Option D's EventBridge has invocation rate limits.

---

### Question 68
A company with a global presence needs to implement a centralized networking solution that provides inter-region connectivity, centralized internet egress, and shared services access for 200 VPCs across 6 regions and 50 AWS accounts. The solution must enforce that development VPCs cannot communicate with production VPCs, all internet-bound traffic flows through centralized security inspection, and shared services (DNS, logging, monitoring) are accessible from all VPCs. Which architecture meets these requirements with MINIMUM operational overhead?

A) AWS Transit Gateway in each region with inter-region peering, separate route tables for production and development segments, inspection VPC with AWS Network Firewall for internet egress, shared services VPC peered with all Transit Gateways
B) AWS Cloud WAN with production and development segments, Network Firewall in a centralized inspection segment using service insertion, shared services segment accessible from both production and development segments, all managed through Cloud WAN network policies
C) VPC peering between all VPCs with security groups and NACLs for segmentation, NAT Gateway in each VPC for internet access, shared services VPC with peering connections
D) AWS Transit Gateway with a single route table per region using blackhole routes for prod/dev isolation, centralized NAT Gateway for internet egress, Resource Access Manager for shared services

**Correct Answer: B**
**Explanation:** For minimum operational overhead with these requirements, Option B with AWS Cloud WAN is optimal: (1) Cloud WAN segments natively enforce production/development isolation through network policies — no manual route table management; (2) Service insertion transparently routes internet-bound traffic through centralized Network Firewall inspection without complex routing configurations; (3) The shared services segment can be configured to be accessible from both production and development segments through segment policies; (4) Cloud WAN's centralized policy management handles all 200 VPCs across 6 regions from a single interface, dramatically reducing operational overhead compared to managing Transit Gateways individually. Option A requires manually managing Transit Gateway route tables, peering, and routing across 6 regions. Option C with VPC peering doesn't scale to 200 VPCs and doesn't provide centralized inspection. Option D's single route table approach doesn't properly implement segmentation.

---

### Question 69
A company is implementing a global database migration from MongoDB (self-hosted across 3 data centers) to AWS. The MongoDB deployment has 10TB of data across 50 collections, with 20 collections requiring real-time sync during migration (zero-downtime cutover). The application code uses MongoDB-specific features including aggregation pipelines, geospatial queries, and change streams. The target state must support multi-region active-active reads with a primary write region. Which migration strategy and target architecture is MOST appropriate?

A) Use AWS DMS with MongoDB as source to migrate to Amazon DocumentDB, configure DocumentDB Global Clusters for multi-region read access, rewrite aggregation pipelines to DocumentDB-compatible syntax during migration
B) Deploy Amazon DocumentDB in the primary region, use mongodump/mongorestore for initial data load, AWS DMS with ongoing replication for the 20 real-time collections, DocumentDB Global Clusters for multi-region access, with application compatibility testing and minor adjustments for unsupported MongoDB features
C) Migrate to DynamoDB using a custom ETL pipeline, redesigning the data model from document-oriented to key-value, using DynamoDB Global Tables for multi-region active-active
D) Deploy MongoDB Atlas on AWS with multi-region clusters, using native MongoDB tools for migration with change stream-based replication for zero-downtime cutover

**Correct Answer: B**
**Explanation:** Option B provides the most practical migration approach: (1) DocumentDB is MongoDB-compatible, supporting aggregation pipelines and geospatial queries, minimizing application changes; (2) mongodump/mongorestore provides the fastest initial bulk data load for 10TB; (3) DMS with ongoing replication handles the 20 collections requiring zero-downtime cutover; (4) DocumentDB Global Clusters provide multi-region read access with a primary write region, matching the requirement; (5) Minor adjustments for DocumentDB's MongoDB compatibility gaps (some operations differ slightly) are manageable. Option A uses DMS for the entire migration including initial load, which is slower for bulk data. Option C requires a complete data model redesign. Option D moves to MongoDB Atlas (a third-party service) rather than an AWS-managed service, which may not align with the company's AWS-first strategy.

---

### Question 70
A company wants to implement a global data classification and protection system across all their AWS accounts (100 accounts, 5 regions). The system must automatically discover and classify sensitive data (PII, PHI, financial data), enforce data protection policies based on classification, and provide a centralized compliance dashboard. Which architecture provides comprehensive data protection?

A) Amazon Macie across all accounts and regions for S3 data discovery and classification, AWS Security Hub for centralized findings aggregation, IAM policies and S3 bucket policies for data protection enforcement, and a custom QuickSight dashboard for compliance reporting
B) Amazon Macie for S3 data discovery, Amazon Comprehend for text classification in non-S3 data stores, AWS Config rules for data protection policy enforcement, Security Hub for centralized monitoring, and Organizations-level Macie management with delegated administrator
C) Custom data classification using Lambda functions triggered by S3 events, regular expressions for PII detection, CloudWatch dashboards for compliance reporting
D) AWS Audit Manager for compliance frameworks, Amazon Inspector for vulnerability assessment, and manual data classification through tagging policies

**Correct Answer: B**
**Explanation:** For comprehensive global data classification and protection, Option B is correct: (1) Amazon Macie provides automated S3 data discovery using ML-based classification for PII, PHI, and financial data across all accounts; (2) Amazon Comprehend extends classification capability to non-S3 data stores (databases, files) using NLP; (3) AWS Config rules enforce data protection policies (encryption requirements, access controls) and detect non-compliance; (4) Security Hub aggregates findings from Macie, Config, and other services for centralized monitoring; (5) Organizations-level Macie management with a delegated administrator enables centralized management across 100 accounts. Option A lacks classification for non-S3 data and relies on custom dashboards. Option C's regex-based approach misses complex PII patterns. Option D's manual classification doesn't scale to 100 accounts.

---

### Question 71
A company is building a global auction platform where auctions run simultaneously in multiple time zones. The platform must ensure that bid timestamps are globally consistent (using a trusted time source), highest-bid determination is conflict-free across regions, and bid history is immutable and legally verifiable. An auction can receive 10,000 bids per second from bidders worldwide. Which architecture ensures fair and verifiable auction processing?

A) Regional API endpoints with Amazon Time Sync Service for trusted timestamps, DynamoDB Global Tables with conditional writes for highest-bid tracking (using version numbers), Amazon QLDB for immutable bid history
B) Single-region auction processor in us-east-1 behind Global Accelerator for low-latency global access, DynamoDB with strong consistent reads for bid tracking, S3 with Object Lock for bid records
C) Regional auction processors using AWS Time Sync for timestamps, a central coordinator service using Step Functions for cross-region bid reconciliation, Amazon Timestream for bid history with immutable write-once semantics
D) Regional bid intake with Amazon Kinesis, all streams consumed by a single-region Flink application that determines winners with exactly-once processing, QLDB for bid record immutability

**Correct Answer: A**
**Explanation:** Option A addresses all three core requirements for a global auction: (1) Amazon Time Sync Service provides a trusted, accurate time source traceable to atomic clocks — critical for legally defensible bid timestamps; (2) DynamoDB Global Tables with conditional writes using version numbers (optimistic concurrency) ensures that highest-bid tracking handles concurrent bids correctly — the conditional write fails if another bid has already been recorded, preventing lost bids; (3) QLDB's immutable, cryptographically verifiable ledger provides legally verifiable bid history; (4) Regional API endpoints minimize latency for global bidders. Option B's single-region approach adds latency for distant bidders and creates a single point of failure. Option C's Step Functions coordination adds latency for bid processing. Option D's single-region Flink consumer creates a bottleneck and single point of failure.

---

### Question 72
A company needs to implement a multi-region blue-green infrastructure swap for their entire production environment, including compute (EKS), databases (Aurora), caching (ElastiCache), and storage (S3). The swap must be atomic — all services switch simultaneously to prevent requests from hitting a mix of old and new components. The environment serves 50,000 requests per second. What is the MOST reliable approach for an atomic multi-service swap?

A) Route 53 weighted routing with a 0/100 weight swap, updating all DNS records simultaneously using the Route 53 ChangeResourceRecordSets API with a batch of changes
B) AWS Global Accelerator endpoint group weight adjustment, swapping traffic from the blue endpoint group to the green endpoint group in a single API call
C) Route 53 ARC (Application Recovery Controller) with routing controls — one routing control per service, wrapped in a safety rule that requires all controls to be updated together (gating rule), with a single API call to update the routing control state that atomically shifts all traffic from blue to green
D) CloudFront with origin groups, swapping the primary origin from blue to green environment, with CloudFront cache invalidation

**Correct Answer: C**
**Explanation:** For atomic multi-service blue-green swap, Option C is correct: (1) Route 53 ARC routing controls provide a single abstraction for traffic switching; (2) Gating rules ensure that all services switch together — if any service can't switch, none do, preventing mixed-version serving; (3) The routing control state update atomically shifts all traffic; (4) ARC's safety rules prevent accidental partial switches; (5) The switch is near-instantaneous and can be reversed just as quickly. Option A's batch DNS update isn't truly atomic — DNS propagation means some clients may resolve old records while others get new ones. Option B's Global Accelerator only handles the routing layer, not the database and cache layer switching. Option D with CloudFront doesn't handle database and cache atomically.

---

### Question 73
A company is designing a global feature flag system for their microservices platform. The system must support: boolean, string, and JSON feature flags; percentage-based rollouts; user segment targeting; flag evaluation in under 5ms; flag changes propagating to all services in all 4 regions within 30 seconds; and rollback of any flag change within 10 seconds. The platform has 500 microservices making 1 million flag evaluations per second. Which architecture meets these requirements?

A) AWS AppConfig with feature flags, deployed in each region with AppConfig agents in each microservice, configuration profile per service, deployment strategies for controlled rollout, instant rollback using AppConfig's rollback feature
B) DynamoDB Global Tables storing flag definitions, local in-process caching in each microservice with 30-second refresh, custom evaluation logic for percentage and segment targeting
C) Amazon ElastiCache for Redis in each region with Pub/Sub for flag change notifications, microservices subscribing to flag change channels, flag evaluation against local Redis with sub-millisecond latency
D) LaunchDarkly SaaS integrated with each microservice via SDK, with LaunchDarkly's built-in streaming infrastructure for real-time updates

**Correct Answer: A**
**Explanation:** Option A provides a comprehensive AWS-native solution: (1) AWS AppConfig natively supports feature flags with boolean, string, and JSON types; (2) AppConfig agents run as a local sidecar, providing sub-5ms flag evaluation from local cache; (3) Deployment strategies support percentage-based rollouts; (4) AppConfig configuration profiles support user segment targeting through validators and transforms; (5) Flag changes propagate through AppConfig's deployment mechanism; (6) AppConfig's instant rollback reverts flag changes within seconds; (7) Being an AWS-managed service, it integrates natively with IAM, CloudTrail, and other AWS services. Option B requires building custom evaluation logic. Option C needs custom flag management tooling. Option D introduces a third-party SaaS dependency.

---

### Question 74
A global transportation company needs to track the real-time position of 1 million vehicles and provide ETAs to customers. Each vehicle reports its GPS position every 2 seconds. The system must calculate shortest routes considering real-time traffic, provide sub-second position lookups for any vehicle, and store 30 days of historical position data for analytics. Which architecture handles the real-time geospatial requirements?

A) Amazon Location Service for vehicle tracking and route calculation, Kinesis Data Streams for position ingestion, DynamoDB for current position storage with geospatial queries, S3 for historical data
B) Amazon Kinesis Data Streams for position ingestion (500K messages/second), Amazon ElastiCache for Redis with geospatial commands (GEOADD, GEORADIUS) for real-time position storage and lookup, Amazon Location Service for route calculation with real-time traffic data, Kinesis Data Firehose to S3 for historical position archival, Amazon Athena for historical analytics
C) AWS IoT Core for vehicle position ingestion, Amazon Timestream for time-series position data, custom routing engine on EC2 using OpenStreetMap data, ElastiCache for caching routes
D) Amazon MSK for position streaming, Amazon OpenSearch with geo_point field type for position storage and geospatial queries, custom routing engine on ECS

**Correct Answer: B**
**Explanation:** Option B provides the optimal architecture for real-time vehicle tracking at scale: (1) Kinesis Data Streams handles 500K messages/second (1M vehicles ÷ 2 seconds) reliably; (2) Redis geospatial commands provide O(log(N)) position updates and lookups — sub-millisecond for current position queries; (3) Amazon Location Service provides route calculation with real-time traffic data integration, handling ETA calculations; (4) Firehose to S3 provides efficient historical data archival; (5) Athena enables SQL-based analytics on historical S3 data. Option A's DynamoDB geospatial queries are less efficient than Redis for real-time lookups. Option C's IoT Core is designed for IoT protocols, not pure GPS position streaming at this rate, and Timestream is expensive for this volume. Option D's OpenSearch adds unnecessary complexity for simple position storage.

---

### Question 75
A company is designing a global application that must comply with data residency requirements in 15 different countries, each with different regulations. They need a system that automatically routes data to the correct regional storage based on the data subject's nationality, prevents accidental data movement across borders, detects and alerts on data residency violations, and provides compliance reporting to regulators in each country. Which architecture automates comprehensive data residency compliance?

A) Manual data classification and routing using application logic, S3 bucket policies restricting cross-region access, CloudTrail for compliance auditing
B) Amazon Macie for data classification, SCP policies restricting data services to specific regions per OU, AWS Config rules detecting cross-region data replication configurations, CloudTrail organization trail for audit logging
C) AWS Control Tower with customized guardrails per region, SCPs restricting data service operations to allowed regions, Amazon Macie for PII detection and data classification, AWS Config custom rules detecting S3 CRR, DynamoDB Global Tables, or any cross-region data replication to non-compliant regions, Amazon EventBridge triggering automated remediation via Lambda, and a centralized compliance dashboard in Amazon QuickSight fed by AWS Config aggregator data
D) Application-level data routing with country-specific endpoints, encryption at rest with country-specific KMS keys, CloudWatch dashboards for monitoring

**Correct Answer: C**
**Explanation:** For automated, comprehensive data residency compliance across 15 countries, Option C provides the most complete solution: (1) Control Tower with customized guardrails provides the foundational governance framework; (2) SCPs prevent data service operations in non-allowed regions at the API level — the strongest preventive control; (3) Macie identifies and classifies sensitive data for proper routing; (4) AWS Config custom rules detect any cross-region data replication configurations (S3 CRR, DynamoDB Global Tables, etc.) that might violate residency requirements; (5) EventBridge + Lambda provides automated remediation of violations; (6) QuickSight with Config aggregator data provides the compliance dashboard for regulators. Option A lacks automation. Option B is good but misses the automated remediation and comprehensive dashboard. Option D relies on application logic which can be bypassed.

---

## Answer Key

| Q# | Answer | Q# | Answer | Q# | Answer | Q# | Answer | Q# | Answer |
|----|--------|----|--------|----|--------|----|--------|----|--------|
| 1  | D      | 16 | A      | 31 | C      | 46 | A      | 61 | B      |
| 2  | A      | 17 | B      | 32 | A      | 47 | B      | 62 | B      |
| 3  | D      | 18 | B      | 33 | B,C,E  | 48 | C      | 63 | C      |
| 4  | C      | 19 | B      | 34 | B      | 49 | B      | 64 | D      |
| 5  | A,C,E  | 20 | A      | 35 | A      | 50 | A      | 65 | C      |
| 6  | C      | 21 | D      | 36 | B      | 51 | C      | 66 | B      |
| 7  | B      | 22 | D      | 37 | B      | 52 | B      | 67 | C      |
| 8  | A      | 23 | C      | 38 | B      | 53 | B      | 68 | B      |
| 9  | A      | 24 | D      | 39 | B      | 54 | B      | 69 | B      |
| 10 | B      | 25 | C      | 40 | B      | 55 | D      | 70 | B      |
| 11 | B      | 26 | C      | 41 | B      | 56 | B      | 71 | A      |
| 12 | A      | 27 | B      | 42 | B      | 57 | B      | 72 | C      |
| 13 | D      | 28 | B      | 43 | C      | 58 | A      | 73 | A      |
| 14 | C      | 29 | B      | 44 | B      | 59 | D      | 74 | B      |
| 15 | D      | 30 | C      | 45 | A      | 60 | C      | 75 | C      |

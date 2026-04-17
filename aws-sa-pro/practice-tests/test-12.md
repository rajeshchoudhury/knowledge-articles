# AWS Certified Solutions Architect - Professional (SAP-C02) Practice Test 12

**Focus Areas:** ECS/EKS Production, Service Mesh, CI/CD, Deployment Strategies, Blue/Green
**Time Limit:** 180 minutes
**Total Questions:** 75
**Passing Score:** 750/1000

---

## Domain Distribution
- Domain 1 – Organizational Complexity: Questions 1–20
- Domain 2 – Design New Solutions: Questions 21–42
- Domain 3 – Continuous Improvement: Questions 43–53
- Domain 4 – Migration: Questions 54–62
- Domain 5 – Cost Optimization: Questions 63–75

---

### Question 1

A company runs 50 microservices on Amazon ECS across three AWS accounts (dev, staging, production). Each account has its own ECR repositories. The security team requires that production ECS tasks only pull container images that have been scanned for vulnerabilities and signed by the CI/CD pipeline. Images must flow from dev → staging → production with promotion gates.

Which architecture enforces this requirement?

A. Use a single ECR registry in the production account with cross-account pull permissions. Enable ECR image scanning on push. Implement a CodePipeline that promotes images between accounts by retagging in the production ECR only after manual approval and scan results show no critical vulnerabilities.

B. Use ECR replication to automatically replicate images from dev to staging to production. Enable enhanced scanning on all registries. Use an SCP to deny ecs:CreateService unless the image tag matches approved patterns.

C. Create ECR repositories in each account. Use ECR cross-account replication rules from dev to staging and staging to production. Implement ECR lifecycle policies to remove unscanned images. Use a Lambda function triggered by ECR image push events to validate scan results before allowing ECS task deployment.

D. Store all images in a single S3 bucket. Use CodeBuild to scan images before uploading. ECS tasks pull images from S3 using a custom entrypoint script.

**Correct Answer: A**

**Explanation:** A centralized ECR registry in the production account with cross-account pull permissions provides a single source of truth for production images. ECR image scanning on push detects vulnerabilities automatically. CodePipeline with manual approval gates and scan result validation ensures only vetted images reach production. This creates a clear promotion path: dev builds → staging testing → production promotion. Option B's automatic replication bypasses promotion gates. Option C is more complex and the Lambda validation creates a race condition between image push and ECS deployment. Option D doesn't use ECR—ECS pulls from ECR, not S3.

---

### Question 2

A company is deploying a microservices application on Amazon EKS. The platform team needs to enforce that all pods in the production namespace must have resource requests and limits defined, must not run as root, and must use read-only root filesystems. Developers should be prevented from deploying non-compliant pods.

Which approach enforces these requirements at the cluster level?

A. Deploy the OPA Gatekeeper admission controller on the EKS cluster. Define ConstraintTemplates for resource requirements, non-root execution, and read-only root filesystem. Apply Constraints to the production namespace.

B. Create Kubernetes NetworkPolicies in the production namespace that restrict pod specifications to compliant configurations.

C. Use Amazon EKS Pod Identity to enforce pod security policies based on the IAM role associated with the service account.

D. Configure Kubernetes PodDisruptionBudgets with compliance requirements that reject non-compliant pod deployments.

**Correct Answer: A**

**Explanation:** OPA Gatekeeper is a Kubernetes-native admission controller that evaluates pod specifications against defined policies before allowing creation. ConstraintTemplates define the policy logic (Rego), and Constraints apply them to specific namespaces. This preventively blocks non-compliant pods during the admission phase. Option B (NetworkPolicies) control network traffic, not pod security specifications. Option C (Pod Identity) manages IAM permissions for pods, not security constraints on pod specifications. Option D (PodDisruptionBudgets) control disruption during voluntary events, not deployment compliance.

---

### Question 3

A company has an ECS cluster running 30 services. Each service communicates with multiple other services using HTTP. The operations team needs end-to-end request tracing, traffic management (canary deployments between service versions), and mutual TLS between all services without modifying application code.

Which solution provides all these capabilities?

A. Deploy AWS App Mesh with Envoy proxy sidecars injected into each ECS task. Configure virtual services, virtual nodes, and virtual routers for traffic management. Enable mTLS in the mesh configuration. Integrate with AWS X-Ray for distributed tracing.

B. Deploy an Application Load Balancer per service with weighted target groups for canary deployments. Use AWS Certificate Manager for TLS and X-Ray SDK instrumented in each service for tracing.

C. Deploy Istio service mesh on the ECS cluster with Envoy sidecars. Configure Istio virtual services for traffic management and Istio Citadel for mTLS.

D. Use AWS Cloud Map for service discovery with Route 53 weighted routing for canary deployments. Implement application-level TLS and X-Ray SDK for tracing.

**Correct Answer: A**

**Explanation:** AWS App Mesh is the AWS-native service mesh for ECS that provides all three capabilities without application code changes. Envoy sidecars handle traffic routing (canary through weighted virtual routers), mTLS (configured at the mesh level), and X-Ray tracing (Envoy exports trace data automatically). This is fully managed and integrates with ECS task definitions. Option B requires per-service ALBs (costly) and X-Ray SDK requires code changes. Option C (Istio) isn't natively supported on ECS and adds significant operational complexity. Option D requires application-level TLS implementation and X-Ray SDK code changes.

---

### Question 4

An organization uses AWS Organizations with 100 accounts. They need to deploy a standardized EKS platform across 20 production accounts with consistent add-ons (CoreDNS, kube-proxy, VPC CNI, AWS Load Balancer Controller, Fluent Bit). New accounts added to the production OU should automatically receive the EKS platform.

Which approach provides the MOST automated deployment?

A. Create a CloudFormation StackSet with the organization as the deployment target and the production OU as the organizational unit filter. Define the EKS cluster, managed node groups, and EKS add-ons in the template. Use CloudFormation hooks for post-deployment add-on configuration.

B. Use AWS Service Catalog with a portfolio shared across the organization. Create a product for the EKS platform. Require new accounts to launch the product during account onboarding.

C. Create a CodePipeline in a central tools account that detects new accounts in the production OU via EventBridge. The pipeline executes a CodeBuild project that provisions EKS using Terraform.

D. Use AWS Control Tower Account Factory for Terraform (AFT) with customization templates that deploy the EKS platform as part of account provisioning.

**Correct Answer: A**

**Explanation:** CloudFormation StackSets with organization targets and OU filters provide automatic deployment to current and future accounts in the production OU. When a new account joins the OU, StackSets automatically deploys the template. EKS add-ons (CoreDNS, kube-proxy, VPC CNI) can be defined as managed add-ons in CloudFormation, and the Load Balancer Controller and Fluent Bit can be deployed via Helm charts in CloudFormation. Option B (Service Catalog) requires manual action per account. Option C (CodePipeline) works but requires custom event detection and pipeline maintenance. Option D (AFT) is viable if using Control Tower but adds Terraform dependency.

---

### Question 5

A company runs a CI/CD pipeline using CodePipeline that deploys to ECS Fargate. The pipeline includes source (CodeCommit), build (CodeBuild), and deploy (ECS) stages. A security requirement mandates that the build stage must not have internet access to prevent dependency confusion attacks, but it must still pull base images from ECR and download approved dependencies from an internal artifact repository.

Which configuration enables this?

A. Configure CodeBuild to run in a VPC with private subnets. Create VPC endpoints for ECR (both ecr.api and ecr.dkr), S3 (gateway endpoint for ECR layer storage), and the internal artifact repository. Remove the NAT gateway.

B. Configure CodeBuild with a restrictive security group that only allows outbound traffic to ECR and the artifact repository IP addresses.

C. Use a custom CodeBuild image that has all dependencies pre-baked, eliminating the need for network access during the build.

D. Configure CodeBuild outside a VPC and use an IAM policy that restricts network access to only ECR and the artifact repository endpoints.

**Correct Answer: A**

**Explanation:** Running CodeBuild in a VPC with private subnets and no NAT gateway blocks internet access. VPC endpoints for ECR API, ECR DKR (Docker registry), and S3 (for ECR image layers) enable pulling base images privately. A VPC endpoint or PrivateLink connection to the internal artifact repository enables approved dependency access. This architecture provides network-level isolation. Option B (security groups) can't block internet access—security groups filter by IP/port, and internet-bound traffic still flows through the NAT/IGW. Option C (pre-baked image) is brittle and hard to maintain. Option D—IAM doesn't control network access, only API authorization.

---

### Question 6

A financial services company runs containerized trading applications on EKS. Regulatory compliance requires that containers run on dedicated infrastructure not shared with other AWS customers. The applications need high network performance (100 Gbps) and low latency.

Which EKS deployment configuration meets these requirements?

A. Use EKS with EC2 managed node groups using dedicated hosts (host tenancy). Select metal instance types (e.g., m5.metal) placed in a cluster placement group. Enable Elastic Fabric Adapter (EFA) for low-latency networking.

B. Use EKS with Fargate profiles configured with dedicated tenancy. Place Fargate tasks in a VPC with dedicated instance tenancy.

C. Use EKS with EC2 managed node groups using dedicated instances (dedicated tenancy) with enhanced networking enabled. Deploy in a spread placement group.

D. Use EKS Anywhere on AWS Outposts to ensure physical isolation from other AWS customers.

**Correct Answer: A**

**Explanation:** Dedicated hosts provide physical server isolation, meeting the regulatory compliance requirement. Metal instance types (m5.metal, c5.metal) provide bare-metal access with up to 100 Gbps networking. Cluster placement groups minimize inter-node latency. EFA provides kernel-bypass networking for ultra-low latency. Option B—Fargate doesn't support dedicated tenancy or provide metal-level performance. Option C (dedicated instances) provides hardware isolation but spread placement groups separate instances, increasing latency. Option D (Outposts) is for on-premises deployment, not AWS Region isolation.

---

### Question 7

A company deploys 100 ECS services across 5 ECS clusters. They need centralized visibility into container logs, metrics, and traces. Each service must send logs to a specific log group based on the service name, metrics must include custom business metrics, and traces must show end-to-end request flows across services.

Which observability architecture provides this?

A. Deploy the AWS Distro for OpenTelemetry (ADOT) collector as a sidecar in each ECS task. Configure the collector to export logs to CloudWatch Logs (with service-name-based log groups), metrics to CloudWatch (including custom metrics), and traces to AWS X-Ray. Use CloudWatch Container Insights for cluster-level dashboards.

B. Deploy the CloudWatch agent as a daemon service on each ECS host. Configure each service to write logs to stdout, which the agent forwards to CloudWatch. Use embedded metric format for custom metrics and X-Ray SDK for tracing.

C. Deploy Fluent Bit as a sidecar in each ECS task for log routing. Deploy a Prometheus server on the cluster for custom metrics. Deploy Jaeger for distributed tracing.

D. Configure ECS to use the awslogs log driver for all tasks. Create CloudWatch metric filters for custom business metrics. Deploy X-Ray daemon as a sidecar for tracing.

**Correct Answer: A**

**Explanation:** ADOT (AWS Distro for OpenTelemetry) provides a unified collection pipeline for logs, metrics, and traces—the three pillars of observability—through a single sidecar. It exports to CloudWatch Logs (with flexible log group routing), CloudWatch Metrics (supporting custom metrics), and X-Ray (for distributed traces). Container Insights adds cluster-level dashboards. This is the most comprehensive, AWS-native solution. Option B works for EC2 launch type but the daemon approach doesn't work with Fargate. Option C uses non-AWS tools requiring self-management. Option D's CloudWatch metric filters are limited for custom business metrics and require specific log formatting.

---

### Question 8

A company needs to implement a blue/green deployment for an ECS service running behind an Application Load Balancer. The deployment must run automated integration tests against the green environment before shifting traffic. If tests fail, the deployment must automatically roll back.

Which deployment configuration implements this?

A. Use AWS CodeDeploy with ECS blue/green deployment type. Configure two target groups (blue and green) on the ALB. Define a test listener on a separate port for the green target group. Create a CodeDeploy lifecycle hook that triggers a Lambda function running integration tests during the AfterAllowTestTraffic hook. Configure automatic rollback on deployment failure.

B. Create two ECS services (blue and green) manually. Use a Lambda function to update the ALB listener rules to switch between target groups after running tests via a separate test ALB.

C. Use ECS rolling updates with a deployment circuit breaker. The circuit breaker automatically rolls back if health checks fail during the deployment.

D. Deploy a second ECS cluster for the green environment. Use Route 53 weighted routing to shift traffic between clusters after testing.

**Correct Answer: A**

**Explanation:** CodeDeploy's ECS blue/green deployment natively supports test listeners and lifecycle hooks. The test listener routes traffic on a separate port to the green target group, allowing integration tests without affecting production traffic. The AfterAllowTestTraffic hook triggers a Lambda function that runs tests. If the Lambda returns a failure, CodeDeploy automatically rolls back by routing traffic back to the blue target group. Option B is a manual implementation of what CodeDeploy automates. Option C (rolling update with circuit breaker) only checks health checks, not integration tests, and partially deploys before detecting issues. Option D is overly complex with Route 53.

---

### Question 9

A company's EKS cluster hosts services for multiple teams. Team A's service is consuming excessive CPU, causing Team B's service to be throttled. The cluster has 10 nodes. The platform team needs to ensure fair resource allocation between teams while allowing burst capacity.

Which combination of Kubernetes features addresses this? (Choose TWO.)

A. Create a ResourceQuota for each team's namespace that limits total CPU and memory requests/limits. This prevents any team from over-allocating resources.

B. Create a LimitRange in each team's namespace that sets default resource requests and limits for containers that don't specify them.

C. Deploy the Kubernetes Cluster Autoscaler to add nodes when pod scheduling fails due to insufficient resources.

D. Configure Kubernetes PodSecurityPolicies to restrict CPU usage per pod.

E. Use Kubernetes Priority Classes to ensure Team B's pods are scheduled before Team A's pods if resources are constrained.

**Correct Answer: A, B**

**Explanation:** ResourceQuotas (A) cap the total resources each team's namespace can consume, preventing any single team from monopolizing cluster resources. LimitRanges (B) ensure every container has resource requests and limits, even if developers don't specify them—preventing unbounded resource consumption. Together, they provide fair allocation at both the namespace and container level. Option C (Cluster Autoscaler) adds capacity but doesn't prevent one team from consuming all of it. Option D—PodSecurityPolicies control security contexts, not resource limits. Option E (Priority Classes) helps during resource contention but doesn't prevent the contention.

---

### Question 10

A company uses AWS CodePipeline with CodeBuild and deploys to both ECS and EKS. They need a unified deployment strategy that supports canary releases to both platforms, with automatic rollback based on CloudWatch alarms monitoring error rates and latency.

Which approach provides a unified canary deployment across both ECS and EKS?

A. Use AWS CodeDeploy with ECS deployment group (blue/green with traffic shifting) and EKS deployment group (using CodeDeploy agent on EKS). Configure CloudWatch alarms as rollback triggers on both deployment groups.

B. Use AWS App Mesh for both ECS and EKS services. Implement traffic splitting in App Mesh virtual routers (90/10, then 50/50, then 0/100). Create a Step Functions workflow that adjusts weights and checks CloudWatch alarms between each step.

C. Use Flagger with App Mesh on EKS and CodeDeploy for ECS. Flagger provides canary analysis on EKS while CodeDeploy handles ECS canary deployments.

D. Use Argo Rollouts for EKS and CodeDeploy for ECS. Both support canary deployments with CloudWatch alarm integration.

**Correct Answer: B**

**Explanation:** App Mesh provides a unified service mesh across both ECS and EKS, enabling consistent traffic management through virtual routers. Traffic splitting in virtual routers works identically regardless of the underlying compute platform. A Step Functions workflow provides orchestrated canary progression—adjusting traffic weights and validating CloudWatch alarms at each stage, rolling back if thresholds are breached. Option A—CodeDeploy doesn't natively support EKS canary deployments. Option C uses two different tools for two platforms, not unified. Option D also uses two different tools.

---

### Question 11

A company runs a microservices architecture on ECS Fargate. Each service has its own CodePipeline for CI/CD. When Service A deploys a breaking API change, dependent services (B, C, D) fail until they're updated. The team needs to coordinate deployments of interdependent services.

Which approach BEST handles coordinated deployments?

A. Create a parent CodePipeline that orchestrates child pipelines for interdependent services. The parent pipeline deploys services in the correct order with approval gates between groups. Use contract testing in the build stage to detect breaking changes before deployment.

B. Implement semantic versioning for all service APIs. Use API Gateway with stage variables to route traffic to specific service versions. Deploy new versions alongside old ones and update routing only when all dependent services are updated.

C. Use AWS Step Functions to orchestrate the deployment of interdependent services in a specific order, with wait states for health check validation between deployments.

D. Deploy all interdependent services in a single ECS task definition so they deploy atomically as a unit.

**Correct Answer: A**

**Explanation:** A parent CodePipeline orchestrating child pipelines provides coordinated deployment with proper ordering. Contract testing (e.g., Pact) in the build stage catches breaking API changes before deployment, preventing the problem proactively. Approval gates between service groups ensure each group is healthy before the next deploys. This balances automation with safety. Option B (API versioning) works long-term but doesn't address the immediate coordination problem and adds routing complexity. Option C (Step Functions) provides orchestration but lacks the CI/CD integration (source, build, test stages) of CodePipeline. Option D (single task) defeats the purpose of microservices.

---

### Question 12

A company runs an EKS cluster with sensitive workloads. The security team requires that all container images must come from the company's ECR registry, and no images from public registries (Docker Hub, etc.) should be allowed. This must be enforced at the cluster level.

Which approach provides the MOST reliable enforcement?

A. Deploy OPA Gatekeeper with a constraint that validates all pod image references match the company's ECR registry URL pattern. Reject pods with images from any other registry.

B. Configure the VPC's security groups and NACLs to block outbound traffic to Docker Hub IP ranges.

C. Create an ECR pull-through cache rule for Docker Hub. Configure the cluster to use the pull-through cache endpoint, then remove internet access from worker nodes.

D. Use Kubernetes RBAC to restrict which service accounts can create pods with non-ECR images.

**Correct Answer: A**

**Explanation:** OPA Gatekeeper operates as a Kubernetes admission controller, validating pod specifications before creation. A constraint that checks image references against the ECR registry URL pattern provides reliable, preventive enforcement at the API server level. Any pod with a non-ECR image is rejected immediately with a clear error message. Option B (network blocking) is fragile—Docker Hub uses CDN IPs that change, and this doesn't prevent other public registries. Option C (pull-through cache) helps but doesn't prevent someone from specifying a non-ECR image directly. Option D—RBAC can't filter based on image source in pod specifications.

---

### Question 13

A company operates a CI/CD pipeline that builds Docker images for 50 microservices. Build times average 15 minutes per service because each build downloads base images and dependencies from scratch. The team wants to reduce build times to under 5 minutes.

Which combination of optimizations MOST effectively reduces build times? (Choose TWO.)

A. Implement Docker layer caching in CodeBuild by configuring the local cache mode with docker-layer caching type. This reuses previously built layers between builds.

B. Use multi-stage Docker builds with a dependency installation stage that changes infrequently. Order Dockerfile instructions so frequently changing layers (application code) are at the end.

C. Pre-build and maintain base images in ECR with all common dependencies installed. Reference these base images in each service's Dockerfile.

D. Increase the CodeBuild compute type from BUILD_GENERAL1_SMALL to BUILD_GENERAL1_2XLARGE for all builds.

E. Migrate from CodeBuild to Jenkins running on EC2 instances with larger instance types.

**Correct Answer: A, B**

**Explanation:** Docker layer caching in CodeBuild (A) preserves built layers between builds, so only changed layers are rebuilt. Multi-stage builds with optimized layer ordering (B) ensure that dependency installation layers (which change rarely) are cached while application code layers are at the end. Combined, these changes can reduce build times by 70-80% since most builds only change application code. Option C (base images) helps but still requires dependency installation specific to each service. Option D (larger compute) speeds up builds linearly but doesn't address the root cause of redundant work. Option E offers no inherent advantage over CodeBuild.

---

### Question 14

A company uses Amazon ECS with the EC2 launch type. They notice that during deployments, new tasks take 3-4 minutes to start serving traffic. Investigation reveals that the Docker images are 2GB and take significant time to pull. The services need to handle traffic spikes with minimal warm-up time.

Which combination of changes reduces task startup time? (Choose TWO.)

A. Switch from EC2 launch type to Fargate with ephemeral storage configuration. Fargate caches commonly used base images, reducing pull times.

B. Reduce Docker image sizes by using multi-stage builds with Alpine or distroless base images. Strip unnecessary build tools, documentation, and unused dependencies from the final image.

C. Enable Amazon ECR with SOCI (Seekable OCI) index for the container images. SOCI enables lazy loading of container images, allowing containers to start before the full image is downloaded.

D. Increase the ECS container instance size to provide more network bandwidth for faster image pulls.

E. Pre-pull the container images to ECS container instances using a custom daemon set that runs on launch.

**Correct Answer: B, C**

**Explanation:** Reducing image size from 2GB to a few hundred MB (B) directly reduces pull time proportionally. SOCI indexes (C) enable lazy loading—the container starts with only the layers needed for the entrypoint, and remaining layers are pulled on-demand in the background. This can reduce startup time from minutes to seconds for large images. Option A—Fargate doesn't inherently cache your private images faster. Option D—larger instances help marginally but don't address the fundamental image size problem. Option E (pre-pull) works but adds operational complexity and delays the first deployment to new instances.

---

### Question 15

A company runs an EKS cluster with 200 pods across 20 nodes. They need to implement pod-to-pod encryption for all traffic within the cluster without modifying application code. The solution must also provide network-level access control between namespaces.

Which approach provides both capabilities?

A. Deploy AWS App Mesh with mTLS enabled between all virtual nodes. Configure App Mesh virtual routers with routing rules that enforce namespace-level access control.

B. Deploy Calico network policies for namespace-level access control. Use the Amazon VPC CNI plugin with network policy enforcement enabled. For encryption, enable Wireguard encryption in Calico.

C. Configure Kubernetes NetworkPolicies for namespace isolation. Use AWS Certificate Manager Private CA to issue certificates to each pod for application-level TLS.

D. Enable envelope encryption on EKS secrets. Configure security groups per pod using the VPC CNI plugin for network access control.

**Correct Answer: B**

**Explanation:** Calico on EKS provides both network policies (namespace-level access control) and Wireguard-based encryption (pod-to-pod encryption without application changes). The VPC CNI plugin supports Calico network policy enforcement natively on EKS. Wireguard encrypts traffic at the node level transparently—no sidecar or application modification needed. Option A (App Mesh) provides mTLS but requires sidecar injection and doesn't provide network-policy-level namespace isolation natively. Option C requires application-level TLS implementation, violating the "no code changes" requirement. Option D—secrets encryption and security groups don't provide pod-to-pod traffic encryption.

---

### Question 16

A company has an ECS service running behind an ALB. The service processes long-running requests that take up to 5 minutes. During deployments, in-flight requests are being terminated, causing errors for users.

Which configuration prevents request termination during deployments?

A. Configure the ECS service with a deployment configuration that sets minimumHealthyPercent to 100 and maximumPercent to 200. Set the ALB target group deregistration delay to 300 seconds (matching the maximum request duration). Configure the ECS task stop timeout to 300 seconds.

B. Enable connection draining on the ALB with a timeout of 5 minutes. Set the ECS service's deployment circuit breaker to prevent new deployments if errors are detected.

C. Use an NLB instead of an ALB because NLBs natively support long-running connections without timeout issues during deployments.

D. Implement a pre-stop lifecycle hook in the application container that waits for all in-flight requests to complete before the container exits.

**Correct Answer: A**

**Explanation:** The deregistration delay (300 seconds) tells the ALB to continue routing in-flight requests to deregistering targets for up to 5 minutes. The ECS stop timeout gives the container 300 seconds to gracefully shut down. Setting minimumHealthyPercent to 100 ensures old tasks aren't stopped until new tasks are healthy. Together, these ensure in-flight requests complete before old tasks are terminated. Option B's connection draining is the same as deregistration delay but doesn't address the ECS-side timeout. Option C—NLBs still terminate connections to deregistered targets without proper timeout configuration. Option D is application-level handling but doesn't prevent ECS from force-killing the container after the default 30-second timeout.

---

### Question 17

A SaaS company runs 200 microservices on EKS. They want to enable each team to independently deploy their services while maintaining organization-wide standards (resource limits, security policies, networking rules). New teams should be onboarded in minutes, not days.

Which platform engineering approach enables this?

A. Use Kubernetes namespaces per team with pre-configured ResourceQuotas, LimitRanges, NetworkPolicies, and RBAC roles. Create a self-service portal backed by a Go operator that provisions new team namespaces with all standard configurations when teams register through an internal tool.

B. Create a separate EKS cluster per team to provide complete isolation. Use a central platform cluster to manage the fleet.

C. Use Helm charts with organization-standard templates for each team's services. Require all teams to use the standard Helm chart.

D. Implement a GitOps workflow with ArgoCD where the platform team maintains a central repository with all team configurations.

**Correct Answer: A**

**Explanation:** Namespace-based multi-tenancy with a custom operator provides the best balance of isolation, standardization, and self-service. The operator automatically applies ResourceQuotas (preventing resource abuse), LimitRanges (enforcing container-level limits), NetworkPolicies (isolating team traffic), and RBAC roles (controlling access). Self-service onboarding takes minutes. Option B (cluster-per-team) is expensive and operationally heavy for 200 services. Option C (Helm templates) standardizes deployments but doesn't enforce namespace-level quotas and policies. Option D (GitOps) helps with deployment consistency but doesn't address the self-service namespace provisioning and policy enforcement.

---

### Question 18

A company uses CodePipeline for CI/CD. Their pipeline takes 30 minutes from commit to production deployment. The CEO wants to reduce this to under 10 minutes without sacrificing quality. Current pipeline stages: Source (1 min) → Build (8 min) → Unit Tests (5 min) → Integration Tests (10 min) → Deploy to Staging (3 min) → Deploy to Production (3 min).

Which combination of changes is MOST effective? (Choose TWO.)

A. Run unit tests and integration tests in parallel as separate CodeBuild projects within the same pipeline stage instead of sequentially.

B. Implement incremental builds that only rebuild changed microservices. Use CodeBuild's local cache for Docker layers and dependencies.

C. Remove the staging deployment and deploy directly to production with feature flags for gradual rollout.

D. Migrate from CodePipeline to GitHub Actions for faster pipeline execution.

E. Replace integration tests with contract tests that run during the build stage, eliminating the separate integration test stage.

**Correct Answer: A, B**

**Explanation:** Running tests in parallel (A) reduces the testing phase from 15 minutes (5+10) to 10 minutes (the longer of the two). Incremental builds with caching (B) can reduce build time from 8 minutes to 2-3 minutes by only rebuilding changed services and caching dependencies. Combined: ~1 (source) + 3 (cached build) + 10 (parallel tests) + 3 (staging) + 3 (production) ≈ 10 minutes. Option C (removing staging) sacrifices quality validation. Option D provides no inherent speed advantage—pipeline speed depends on build/test efficiency. Option E (contract tests) is faster but provides less confidence than integration tests.

---

### Question 19

A company runs an API on ECS Fargate behind an ALB. During a deployment, they want zero-downtime with the ability to test the new version with a small percentage of production traffic before full rollout. They also want to run automated smoke tests against the new version before any production traffic reaches it.

Which deployment strategy achieves ALL these requirements?

A. Use CodeDeploy ECS blue/green deployment with the following configuration: deploy the green task set, route test traffic via the test listener, run smoke tests via a Lambda hook in the BeforeAllowTraffic lifecycle event, then shift 10% of production traffic to green. Monitor for 10 minutes, then shift remaining 90%.

B. Use ECS rolling deployment with minimum healthy percent set to 100% and maximum percent to 150%. Configure health checks on the ALB target group.

C. Deploy a canary version as a separate ECS service registered to the same ALB target group with a lower weight.

D. Use Route 53 weighted routing between two ALBs—one for the current version and one for the new version.

**Correct Answer: A**

**Explanation:** CodeDeploy ECS blue/green deployment provides the complete workflow: deploy green → test via test listener (smoke tests without production impact) → gradual traffic shifting (10% canary → 100%) → automatic rollback if alarms trigger. The BeforeAllowTraffic hook runs before any production traffic reaches the new version, satisfying the smoke test requirement. The traffic shifting provides the canary percentage control. Option B (rolling update) doesn't support pre-production testing or percentage-based traffic shifting. Option C can't route specific percentages with a single target group. Option D (Route 53) has DNS propagation delays and doesn't support pre-traffic testing.

---

### Question 20

A company manages Kubernetes manifests for 50 microservices across 3 EKS clusters (dev, staging, prod). They need a GitOps approach where the Git repository is the single source of truth, changes are applied automatically when merged, and drift detection alerts the team when cluster state differs from Git.

Which implementation is MOST appropriate?

A. Deploy Flux CD on each EKS cluster, configured to watch a Git repository with environment-specific directories (dev/, staging/, prod/). Use Flux's reconciliation loop for automatic application and drift detection. Configure Flux alerts to send notifications via SNS when drift is detected.

B. Create a CodePipeline triggered by Git commits that runs kubectl apply against each cluster sequentially.

C. Use Helm with a centralized Helm chart museum. Deploy Helmsman to manage releases across clusters from a single configuration file in Git.

D. Write a Lambda function triggered by CodeCommit events that updates EKS deployments using the Kubernetes API.

**Correct Answer: A**

**Explanation:** Flux CD is a CNCF GitOps operator that runs within each cluster, continuously reconciling cluster state with the Git repository. It automatically applies changes when manifests are updated in Git and detects drift when manual changes are made to the cluster (reverting them or alerting). Environment-specific directories in the repo provide clean separation. SNS integration enables alerting. Option B (CodePipeline) applies changes on commit but doesn't detect drift. Option C (Helmsman) manages Helm releases but doesn't provide continuous reconciliation or drift detection. Option D (Lambda) is fragile and doesn't support drift detection.

---

### Question 21

A company is building a real-time multiplayer game backend on AWS. The architecture must support 100,000 concurrent WebSocket connections, handle game state updates at 60 messages per second per connection, and maintain sub-50ms latency for state synchronization between players in the same game session.

Which architecture BEST meets these requirements?

A. Use Amazon API Gateway WebSocket APIs for connection management. Route game state messages to Lambda functions that read/write game state from DynamoDB with DAX. Use DynamoDB Streams to propagate state changes to connected players.

B. Deploy a fleet of EC2 instances behind a Network Load Balancer running a custom WebSocket server. Use ElastiCache Redis with pub/sub for real-time state synchronization between instances. Store persistent game state in DynamoDB.

C. Use AWS AppSync with real-time subscriptions over WebSocket. Store game state in DynamoDB with subscriptions triggering state updates to connected clients.

D. Deploy Amazon MQ (ActiveMQ) for message routing between players. Use ECS containers for game logic and DynamoDB for state storage.

**Correct Answer: B**

**Explanation:** At 100,000 connections × 60 messages/sec = 6 million messages/sec, this requires high-throughput WebSocket handling. Custom EC2 instances behind an NLB provide the throughput and sub-50ms latency needed. ElastiCache Redis pub/sub provides microsecond-latency state synchronization between server instances handling different players in the same game session. NLB supports WebSocket natively with minimal overhead. Option A—API Gateway WebSocket has per-connection message limits and Lambda invocation latency that can't sustain 60 msg/sec per connection at this scale. Option C—AppSync subscriptions have higher latency and throughput limits. Option D—Amazon MQ doesn't scale to millions of messages per second.

---

### Question 22

A company needs to implement a CI/CD pipeline for infrastructure as code (Terraform) that provisions AWS resources across 20 accounts. The pipeline must plan changes, require approval for production environments, and apply changes atomically. State files must be securely stored and locked during operations.

Which architecture implements this securely?

A. Store Terraform configurations in CodeCommit. Use CodePipeline with CodeBuild for terraform plan and terraform apply stages. Store state files in S3 with DynamoDB for state locking. Use cross-account IAM roles for provisioning. Add a manual approval action before the production apply stage.

B. Store configurations in GitHub. Use GitHub Actions with OIDC federation to AWS for each account. Store state files locally in the build environment.

C. Use AWS CloudFormation StackSets instead of Terraform for native multi-account provisioning with built-in state management.

D. Store configurations in CodeCommit. Use a Lambda function triggered by CodeCommit events to run Terraform commands in a Fargate task.

**Correct Answer: A**

**Explanation:** This architecture provides the complete CI/CD workflow for Terraform: CodeCommit stores configurations, CodePipeline orchestrates the workflow with plan → approve → apply stages, S3+DynamoDB provides secure state management with locking, and cross-account IAM roles enable provisioning across all 20 accounts with least-privilege access. Manual approval for production prevents accidental changes. Option B stores state locally—state is lost between builds, breaking Terraform. Option C doesn't address the Terraform requirement. Option D lacks the pipeline orchestration, approval gates, and audit trail that CodePipeline provides.

---

### Question 23

A company is deploying a containerized application that processes sensitive healthcare data. The application must be deployed on ECS Fargate with the following security requirements: encryption at rest for container storage, encryption in transit for all inter-container communication, and secrets injected at runtime without being visible in the task definition.

Which combination of configurations meets ALL requirements? (Choose THREE.)

A. Enable Fargate platform version 1.4+ which provides encrypted ephemeral storage by default using AWS-managed keys.

B. Deploy AWS App Mesh with mTLS enabled for inter-container communication encryption.

C. Store secrets in AWS Secrets Manager and reference them in the ECS task definition using the secrets property with the valueFrom field pointing to the Secrets Manager ARN.

D. Use S3 server-side encryption to encrypt container images stored in ECR.

E. Configure the VPC with a Network Firewall inspecting all traffic between containers.

**Correct Answer: A, B, C**

**Explanation:** Fargate platform version 1.4+ (A) encrypts ephemeral storage by default, satisfying encryption at rest. App Mesh with mTLS (B) encrypts all inter-container communication using mutual TLS certificates, satisfying encryption in transit. Secrets Manager references in task definitions (C) inject secrets at runtime—they appear as environment variables in the container but the actual values aren't stored in the task definition (only the ARN reference). Option D—ECR already encrypts images at rest; S3 encryption for ECR is redundant. Option E—Network Firewall inspects traffic but doesn't encrypt it.

---

### Question 24

A company needs to deploy a machine learning inference service that receives batches of 1,000 images via HTTP, processes them through a TensorFlow model, and returns results. Processing takes 30 seconds per batch. The service must handle 100 concurrent batch requests during peak hours and scale to zero during off-peak.

Which deployment architecture is MOST cost-effective?

A. Deploy on ECS Fargate with GPU-enabled tasks (using AWS Inferentia2 instances). Configure Service Auto Scaling based on the number of running tasks relative to SQS queue depth.

B. Deploy on EKS with Karpenter for node provisioning. Use GPU node pools (g5.xlarge) that scale based on pending pod count. Configure Horizontal Pod Autoscaler targeting request queue length.

C. Deploy on SageMaker Serverless Inference endpoints with automatic scaling.

D. Deploy on Lambda with container images and provisioned concurrency for 100 concurrent executions.

**Correct Answer: B**

**Explanation:** EKS with Karpenter provides the fastest node scaling for GPU workloads. Karpenter provisions GPU nodes (g5.xlarge) within minutes based on pending pod demand and deprovisions when idle. HPA scales pods based on queue depth, and Karpenter responds by adding/removing GPU nodes. This scales to zero (Karpenter removes all GPU nodes) during off-peak. Option A—Fargate doesn't support GPU tasks (as of current offerings). Option C—SageMaker Serverless Inference has a 6MB payload limit and 60-second timeout, insufficient for 1,000-image batches taking 30 seconds. Option D—Lambda has a 15-minute timeout and 10GB storage limit, insufficient for GPU-based TensorFlow inference.

---

### Question 25

A company wants to implement progressive delivery for their EKS-based microservices. They need automated canary analysis that compares metrics between the canary and stable versions, automatically promoting or rolling back based on metric analysis. The solution should integrate with their existing Prometheus monitoring.

Which tool BEST implements this on EKS?

A. Deploy Flagger with the App Mesh provider on EKS. Configure canary analysis with Prometheus metrics queries that compare error rates and latency between canary and stable. Flagger automatically promotes or rolls back based on the analysis results.

B. Use ArgoCD with Argo Rollouts for canary deployments. Configure Rollouts with a Prometheus analysis template that queries metrics for canary analysis. Set success criteria for automatic promotion.

C. Implement a custom controller that watches Deployment rollout status and queries Prometheus to compare versions.

D. Use AWS CodeDeploy for EKS with CloudWatch alarms based on Prometheus metrics exported via CloudWatch Container Insights.

**Correct Answer: B**

**Explanation:** Argo Rollouts is purpose-built for progressive delivery on Kubernetes with native Prometheus integration. The analysis template defines Prometheus queries that compare canary metrics against baselines, with configurable success criteria. It supports automatic promotion on success and rollback on failure. Integration with ArgoCD provides GitOps-driven progressive delivery. Option A (Flagger) also works well but Argo Rollouts has broader community adoption and more analysis providers. Option C is a custom solution with significant development effort. Option D—CodeDeploy doesn't natively support EKS canary deployments with Prometheus analysis.

---

### Question 26

A company needs to deploy a stateful application (database) on EKS that requires persistent storage. The storage must survive pod restarts, node failures, and support snapshotting for backups. IOPS must be consistent at 10,000 IOPS.

Which storage configuration meets these requirements?

A. Use the Amazon EBS CSI driver with a StorageClass configured for gp3 volumes with 10,000 provisioned IOPS. Enable volume snapshots using the EBS CSI snapshotter. Use a StatefulSet for the database pods with volumeClaimTemplates.

B. Use the Amazon EFS CSI driver with a StorageClass for EFS. Configure provisioned throughput mode for consistent performance.

C. Use instance store volumes on the EKS worker nodes for maximum IOPS performance. Implement application-level replication for durability.

D. Use hostPath volumes on the worker nodes with EBS volumes attached to each node.

**Correct Answer: A**

**Explanation:** The EBS CSI driver with gp3 volumes provides persistent block storage with configurable IOPS (up to 16,000 IOPS on gp3). PersistentVolumeClaims in a StatefulSet ensure each pod gets a dedicated volume that persists across pod restarts and rescheduling. The EBS CSI snapshotter enables Kubernetes-native volume snapshots for backups. Option B (EFS) provides shared file storage but doesn't guarantee consistent IOPS at the volume level—EFS performance depends on total filesystem throughput. Option C (instance store) is ephemeral—data is lost on node failure. Option D (hostPath) ties pods to specific nodes and doesn't survive node failures.

---

### Question 27

A company deploys a multi-container application on ECS where the main application container generates logs to a local file, and a sidecar container collects and forwards these logs. The main container writes 1GB of logs per hour. The team needs to share the log files between containers in the same task without using a network-based solution.

Which configuration enables this?

A. Define a bind mount volume in the ECS task definition. Mount it at /var/log/app in the main container and /var/log/source in the sidecar container. Both containers share the same file system path.

B. Create an EFS volume and mount it in both containers for shared storage.

C. Use the awslogs log driver on the main container and have the sidecar read from CloudWatch Logs.

D. Configure the main container to write logs to stdout and use FireLens (Fluent Bit sidecar) to route them.

**Correct Answer: A**

**Explanation:** Bind mount volumes in ECS task definitions create shared storage within a task. Both containers mount the same volume at their respective paths, allowing the sidecar to read files written by the main container. This is local to the task with no network overhead—ideal for high-volume log sharing. On Fargate, bind mounts use the task's ephemeral storage (up to 200GB). Option B (EFS) works but adds network latency and cost unnecessary for intra-task sharing. Option C routes logs through CloudWatch, adding latency and cost. Option D works for stdout logs but the question specifies file-based logging that can't be easily changed.

---

### Question 28

A company runs a CI/CD pipeline that builds and deploys to ECS. They want to implement policy-as-code to validate that all ECS task definitions meet security requirements before deployment: no privileged containers, no host networking, secrets from Secrets Manager only (not plaintext environment variables), and specific log configurations.

Which stage in the pipeline enforces these policies?

A. Add a CodeBuild stage before the deployment stage that runs Open Policy Agent (OPA) against the ECS task definition JSON. OPA evaluates Rego policies that check for privileged mode, host networking, plaintext secrets, and log configuration. Fail the pipeline if policies are violated.

B. Create an AWS Config rule that evaluates ECS task definitions after deployment and triggers remediation to stop non-compliant tasks.

C. Use CloudFormation Guard to validate the CloudFormation template containing the ECS task definition against policy rules before stack creation.

D. Implement a Lambda function triggered by ECS RegisterTaskDefinition API calls that validates the task definition and deregisters non-compliant ones.

**Correct Answer: A**

**Explanation:** OPA in a CodeBuild stage provides pre-deployment policy validation—non-compliant task definitions never reach ECS. Rego policies can express complex rules checking JSON structure of task definitions: containerDefinitions[].privileged must be false, networkMode must not be "host", secrets must use valueFrom (Secrets Manager), and logConfiguration must be present. Pipeline failure prevents deployment. Option B (Config) is reactive—non-compliant tasks run before detection. Option C (cfn-guard) works if using CloudFormation but many ECS deployments use the CLI or SDK directly. Option D is reactive and creates a race condition.

---

### Question 29

A company's EKS cluster runs in a private VPC with no internet access. They need to pull container images from ECR, access the EKS API server, and allow pods to access AWS services (S3, DynamoDB, Secrets Manager). All traffic must remain within the AWS network.

Which networking configuration enables this?

A. Create the following VPC endpoints: interface endpoints for ECR API (com.amazonaws.region.ecr.api), ECR DKR (com.amazonaws.region.ecr.dkr), EKS API (com.amazonaws.region.eks), S3 (gateway), DynamoDB (gateway), Secrets Manager (interface), STS (interface), and CloudWatch Logs (interface). Configure endpoint security groups to allow cluster traffic.

B. Deploy a NAT gateway in a public subnet and route all outbound traffic through it.

C. Create a VPC peering connection to a shared services VPC that has internet access through a NAT gateway.

D. Use AWS PrivateLink for ECR only and allow internet access for other services through a proxy server.

**Correct Answer: A**

**Explanation:** For a fully private EKS cluster, VPC endpoints are required for all AWS service access. ECR needs both API and DKR endpoints plus S3 (for image layer storage). EKS API endpoint enables kubectl access. STS is needed for IRSA (IAM Roles for Service Accounts). CloudWatch Logs is needed for logging. S3 and DynamoDB use gateway endpoints (free). This keeps all traffic within the AWS network. Option B (NAT gateway) routes traffic through the internet path, violating the private network requirement. Option C (VPC peering) also requires internet access in the peered VPC. Option D only partially solves the problem.

---

### Question 30

A company needs to deploy a REST API that requires authentication, rate limiting, request validation, and response caching. The API backend is a set of microservices running on ECS Fargate. The API must handle 50,000 requests per second with sub-100ms latency.

Which architecture meets these performance requirements?

A. Deploy Amazon API Gateway REST API with Cognito authorizer, usage plans for rate limiting, request model validation, and response caching. Use VPC Link to connect to the ECS services through a Network Load Balancer.

B. Deploy Amazon API Gateway HTTP API with JWT authorizer and a Lambda authorizer for rate limiting. Use VPC Link to connect to ECS services through an ALB.

C. Deploy an Application Load Balancer with WAF for rate limiting. Implement authentication in a Lambda@Edge function. Add CloudFront for response caching.

D. Deploy Amazon CloudFront with Lambda@Edge for authentication and rate limiting. Use ALB as the origin for the ECS services.

**Correct Answer: A**

**Explanation:** API Gateway REST API provides all required features natively: Cognito authorizer (authentication), usage plans with API keys (rate limiting), request model validation (JSON schema), and built-in response caching. VPC Link through NLB provides private connectivity to Fargate services. At 50,000 req/sec, API Gateway scales automatically. NLB provides the lowest latency for the VPC Link. Option B (HTTP API) lacks built-in response caching and request model validation. Option C requires custom Lambda@Edge code for authentication and doesn't provide request validation. Option D also requires custom code for auth and rate limiting.

---

### Question 31

A company needs to implement a service discovery mechanism for 100 ECS services. Services must discover each other by name, health status must be updated automatically when tasks start or stop, and DNS resolution must reflect changes within 5 seconds.

Which service discovery approach meets these requirements?

A. Use AWS Cloud Map with ECS service discovery integration. Configure each ECS service with a Cloud Map namespace and service. ECS automatically registers/deregisters task IPs in Cloud Map when tasks start/stop. Use Cloud Map DNS for resolution.

B. Create Route 53 private hosted zones with A records for each service. Use a Lambda function triggered by ECS events to update DNS records when tasks change.

C. Deploy Consul on the ECS cluster as a daemon service. Each service registers with Consul on startup and uses Consul DNS for discovery.

D. Use an internal ALB per service and create CNAME records in Route 53 pointing to each ALB's DNS name.

**Correct Answer: A**

**Explanation:** AWS Cloud Map with ECS service discovery provides automatic registration—ECS registers task IPs when tasks launch and deregisters when they stop. Cloud Map supports DNS-based discovery with TTLs as low as 1 second, meeting the 5-second requirement. Health checks automatically mark unhealthy tasks. This is fully managed with zero operational overhead for 100 services. Option B (Lambda + Route 53) works but adds operational complexity and latency in the event-processing pipeline. Option C (Consul) requires managing Consul infrastructure. Option D (ALB per service) adds $16/month per service ($1,600/month for 100 services) plus doesn't reflect individual task health.

---

### Question 32

A company deploys containerized applications on ECS Fargate. A new compliance requirement mandates that all containers must run as non-root users and must not have any Linux capabilities (CAP_ADD). The team needs to enforce this across all ECS task definitions.

Which approach provides preventive enforcement?

A. Create an SCP in AWS Organizations that denies ecs:RegisterTaskDefinition unless the task definition JSON contains a user field set to a non-root UID and has no added Linux capabilities.

B. Deploy AWS CloudFormation hooks (Lambda-based) that intercept CloudFormation stack operations and validate ECS task definition resources for non-root users and no CAP_ADD before allowing creation.

C. Use AWS Config with a custom rule that evaluates registered task definitions and flags non-compliant ones. Trigger a Lambda remediation to deregister non-compliant definitions.

D. Create a CodeBuild stage in the CI/CD pipeline that validates task definition JSON files against compliance rules before the deployment stage.

**Correct Answer: B**

**Explanation:** CloudFormation hooks intercept resource creation and can validate task definitions before they're registered with ECS. The Lambda function inspects the task definition JSON for containerDefinitions[].user (non-root) and linuxParameters.capabilities.add (must be empty). If validation fails, CloudFormation rejects the resource creation. This is preventive and works for all CloudFormation-based deployments. Option A—SCPs can't inspect the content of API request bodies (task definition JSON). Option C is detective, not preventive. Option D only enforces in the CI/CD pipeline—manual API calls bypass it.

---

### Question 33

A company has a microservices architecture where Service A calls Service B, which calls Service C. Under load, Service C becomes slow (5-second response time), causing Service B to accumulate connections and eventually fail, which cascades to Service A. All services run on ECS.

Which resilience pattern prevents this cascade?

A. Configure Service B with a circuit breaker pattern using App Mesh. When Service C's error rate exceeds 50%, the circuit breaker opens and Service B returns a fallback response instead of calling Service C. Configure retry policies with exponential backoff and timeout limits.

B. Increase the number of ECS tasks for Service C to handle the load, preventing it from becoming slow.

C. Add an SQS queue between Service B and Service C to decouple the synchronous dependency.

D. Configure the ALB in front of Service C with connection idle timeout set to 1 second to quickly close slow connections.

**Correct Answer: A**

**Explanation:** The circuit breaker pattern is specifically designed to prevent cascading failures. When Service C is slow, the circuit breaker in Service B opens (after detecting the error rate threshold), immediately returning a fallback response without waiting for Service C. This prevents connection accumulation in Service B and cascading failure to Service A. Retry policies with exponential backoff handle transient failures, and timeouts prevent indefinite waiting. Option B (scaling) helps but doesn't prevent cascading failure during the scaling delay. Option C (SQS) changes the communication pattern from synchronous to asynchronous, which may not be acceptable. Option D (1-second timeout) would reject valid slow requests.

---

### Question 34

A company wants to run a mixed workload on EKS: some pods require GPU access for machine learning inference, some require high-memory for in-memory caching, and some are general-purpose web servers. The cluster should automatically provision the right instance type for each workload.

Which approach provides the MOST efficient node provisioning?

A. Deploy Karpenter with multiple NodePool configurations: one for GPU workloads (selecting g5 instance types based on nvidia.com/gpu resource requests), one for high-memory workloads (selecting r6i instances based on memory requests), and a default for general-purpose workloads (selecting m6i instances). Karpenter provisions optimal instances based on pending pod requirements.

B. Create three EKS managed node groups: GPU (p3.2xlarge), high-memory (r5.4xlarge), and general-purpose (m5.2xlarge). Configure Cluster Autoscaler to scale each group independently based on pending pods.

C. Use a single managed node group with large instances (m5.24xlarge) that have enough resources for all workload types, including GPU tasks.

D. Use Fargate profiles for each workload type, mapping namespaces to appropriate compute profiles.

**Correct Answer: A**

**Explanation:** Karpenter analyzes pending pod resource requirements (CPU, memory, GPU) and provisions the most efficient instance type from each NodePool. GPU pods trigger g5 instance provisioning, high-memory pods trigger r6i provisioning, and general-purpose pods get m6i instances. Karpenter consolidates pods onto appropriately sized instances and deprovisions underutilized nodes. Option B (managed node groups + Cluster Autoscaler) works but provisions in fixed increments—less cost-efficient than Karpenter's right-sizing. Option C wastes resources; m5 instances don't have GPUs. Option D—Fargate doesn't support GPU workloads.

---

### Question 35

A company is designing a deployment pipeline for a containerized application that must meet SOC 2 compliance requirements. The pipeline must enforce: image vulnerability scanning with zero critical findings, signed images only, audit trail of all deployments, and separation of duties between developers and deployers.

Which pipeline architecture meets these compliance requirements?

A. CodeCommit → CodeBuild (build + ECR enhanced scanning) → Lambda gate (reject if critical vulnerabilities) → Docker Content Trust signing → CodeDeploy (ECS deployment with IAM role restricted to deployment-only actions). Enable CloudTrail for audit trail. Developers have CodeCommit and CodeBuild permissions; deployers have CodeDeploy permissions only.

B. CodeCommit → CodeBuild (build + scan + deploy in a single project). Use IAM roles to restrict access.

C. GitHub → GitHub Actions with scanning, signing, and deployment in a single workflow. Use GitHub audit log for compliance.

D. CodeCommit → CodeBuild → manual approval via email → developer runs deployment script from their workstation.

**Correct Answer: A**

**Explanation:** This architecture addresses every SOC 2 requirement: ECR enhanced scanning with a Lambda gate prevents deploying images with critical vulnerabilities; Docker Content Trust provides cryptographic image signing; CloudTrail provides a comprehensive audit trail; and IAM role separation between build (developer) and deploy (deployer) stages enforces separation of duties. Option B combines all stages in one CodeBuild project, eliminating separation of duties. Option C relies on GitHub's non-AWS audit system. Option D involves manual deployment from workstations, which lacks audit trail and access control.

---

### Question 36

A company has an ECS service that processes messages from an SQS queue. Each message takes 2-5 minutes to process. The service needs to scale based on the queue depth, processing messages within 15 minutes of arrival. The backlog varies from 0 to 10,000 messages throughout the day.

Which auto-scaling configuration meets these requirements?

A. Configure ECS Service Auto Scaling with a target tracking policy based on a custom CloudWatch metric: ApproximateNumberOfMessagesVisible / NumberOfRunningTasks. Set the target value to the acceptable backlog per task (calculated as: 15 minutes / average processing time × messages per minute per task).

B. Use a step scaling policy based on the SQS ApproximateNumberOfMessagesVisible metric with thresholds at 100, 500, 1000, and 5000 messages.

C. Configure a scheduled scaling policy that increases task count during known peak hours and decreases during off-peak.

D. Set the ECS service desired count to handle the maximum backlog (10,000 messages) at all times.

**Correct Answer: A**

**Explanation:** Target tracking with backlog-per-task is the recommended SQS scaling approach. The target value represents how many messages each task should have in its backlog. If average processing is 3.5 minutes/message and a task processes one at a time, each task processes ~4 messages in 15 minutes. Target = acceptable backlog per task = 4. When the queue has 10,000 messages, the scaler provisions 2,500 tasks. When the queue is empty, it scales to the minimum. Option B (step scaling) requires manual threshold tuning and responds less smoothly. Option C (scheduled) doesn't adapt to variable backlogs. Option D wastes resources during zero-backlog periods.

---

### Question 37

A company needs to build a real-time data pipeline that ingests events from an application running on ECS, processes them for fraud detection using a machine learning model, and stores flagged transactions. The pipeline must process each event within 500ms.

Which architecture meets the latency requirement?

A. Application → Amazon Kinesis Data Streams → AWS Lambda (invokes SageMaker endpoint for fraud detection) → DynamoDB for flagged transactions and Kinesis Data Firehose for all transactions to S3.

B. Application → Amazon SQS → Lambda → SageMaker batch transform → S3.

C. Application → Amazon MSK → Kafka Streams consumer on ECS (calls SageMaker endpoint) → DynamoDB for flagged transactions.

D. Application → Amazon EventBridge → Step Functions → Lambda → SageMaker endpoint → DynamoDB.

**Correct Answer: A**

**Explanation:** Kinesis Data Streams provides sub-second latency for event ingestion. Lambda processes each record and invokes a SageMaker real-time endpoint (which responds in milliseconds for single-record inference). Flagged transactions write to DynamoDB (single-digit millisecond writes). The entire pipeline can complete within 500ms. Firehose archives all transactions to S3 without affecting the critical path. Option B—SQS + batch transform has much higher latency. Option C—MSK works but adds operational complexity without latency benefit. Option D—Step Functions adds state management latency (100ms+ per state transition).

---

### Question 38

A company uses ArgoCD for GitOps-based deployments to EKS. They want to implement a progressive delivery strategy where new versions are first deployed to a small canary, metrics are analyzed for 10 minutes, and then the full rollout proceeds. If the canary shows degraded metrics, the deployment should automatically roll back.

Which configuration implements this with ArgoCD?

A. Use Argo Rollouts as the deployment controller. Define a Rollout resource with canary strategy: 20% weight for canary, a pause of 10 minutes with analysis, and AnalysisTemplates that query Prometheus for error rate and latency comparisons. ArgoCD syncs the Rollout resource from Git.

B. Configure ArgoCD sync waves with a canary deployment as wave 1 and full deployment as wave 2. Use a PreSync hook to run analysis between waves.

C. Create two ArgoCD Applications—one for the canary and one for the stable version. Use ArgoCD ApplicationSets to manage them together.

D. Use ArgoCD with Helm charts that include canary deployment templates. Configure Helm rollback on failure.

**Correct Answer: A**

**Explanation:** Argo Rollouts integrates with ArgoCD to provide progressive delivery. The Rollout resource replaces the standard Deployment resource and supports canary strategy with configurable traffic weights, pause durations, and automated analysis. AnalysisTemplates define Prometheus queries that compare canary metrics against baselines. ArgoCD manages the Rollout resource through GitOps—the canary configuration is defined in Git. Option B—sync waves don't provide traffic splitting or metric analysis. Option C—separate applications don't share traffic management. Option D—Helm rollback is manual and doesn't include metric analysis.

---

### Question 39

A company has 10 development teams, each with their own CI/CD pipeline deploying to a shared EKS cluster. Pipeline builds frequently fail because one team's CodeBuild project consumes all available build concurrency. The company has a soft limit of 20 concurrent CodeBuild builds.

Which approach ensures fair resource allocation across teams?

A. Request a CodeBuild concurrent build limit increase to 200. Create separate CodeBuild projects per team with reserved capacity allocations using CodeBuild compute fleets with maximum concurrency limits per fleet.

B. Deploy Jenkins on ECS with a dedicated build agent pool per team, each limited to a specific number of concurrent executors.

C. Stagger pipeline triggers using EventBridge Scheduler to ensure teams' builds don't overlap.

D. Create a single CodeBuild project for all teams and use a priority queue backed by SQS to order build requests.

**Correct Answer: A**

**Explanation:** CodeBuild compute fleets allow you to create dedicated pools of build capacity with configurable maximum concurrency per fleet. Each team gets their own fleet with a fair allocation (e.g., 20 concurrent builds each). This prevents one team from consuming all build resources while providing reserved capacity for each team. Option B (Jenkins) adds significant operational overhead. Option C (staggering) delays builds and doesn't work when teams need to build simultaneously. Option D (single project) still suffers from the concurrency limit without fair allocation.

---

### Question 40

A company needs to deploy a multi-container application on ECS Fargate where the main application container must complete initialization before the sidecar containers start. The main container runs a database migration on startup that must finish before the API container begins accepting traffic.

Which ECS feature addresses this container ordering requirement?

A. Use ECS container dependency with a dependsOn configuration in the task definition. Set the database migration container with an "essential" flag of false and a "condition" of SUCCESS. Configure the API container to depend on the migration container with condition COMPLETE.

B. Create two separate ECS task definitions—one for migration and one for the API. Use a Step Functions workflow to run the migration task first and the API task second.

C. Use an entrypoint script in the API container that waits for a health check signal from the migration container before starting the application.

D. Deploy the migration as an ECS scheduled task and the API as an ECS service. Schedule the migration to run before the service starts.

**Correct Answer: A**

**Explanation:** ECS container dependencies allow ordering of container startup within a task. The dependsOn configuration with condition COMPLETE ensures the API container doesn't start until the migration container finishes and exits successfully. Setting the migration container as non-essential (essential: false) prevents the task from failing when the migration container exits after completion. Option B works but adds complexity with separate tasks and Step Functions. Option C is a custom solution that requires managing health check mechanisms. Option D can't guarantee timing and doesn't work for dynamic deployments.

---

### Question 41

A company is designing a blue/green deployment strategy for an EKS application that uses persistent volumes (EBS-backed). During the green deployment, the new version needs access to the same data as the blue version. The blue and green deployments run simultaneously during the transition period.

Which approach handles persistent storage during blue/green deployments?

A. Use EBS snapshots of the blue PersistentVolumes to create new PersistentVolumes for the green deployment. After cutover, the green volumes become the primary data source.

B. Replace EBS-backed PersistentVolumes with Amazon EFS-backed PersistentVolumes. Both blue and green deployments can mount the same EFS file system simultaneously with ReadWriteMany access mode.

C. Use a database service (RDS or DynamoDB) for persistent data instead of PersistentVolumes. Both blue and green deployments connect to the same database.

D. Share EBS volumes between blue and green pods by using multi-attach io2 Block Express volumes.

**Correct Answer: B**

**Explanation:** EFS supports ReadWriteMany (RWX) access mode, allowing both blue and green deployments to simultaneously access the same data. During the transition period, both versions read and write to the same filesystem. After cutover, the blue deployment is terminated. This provides seamless data continuity. Option A (EBS snapshots) creates a point-in-time copy—writes to the blue version after the snapshot aren't visible to the green version, causing data divergence. Option C changes the data architecture, which may not be feasible. Option D—multi-attach EBS requires careful coordination and has filesystem-level limitations (cluster-aware filesystems only).

---

### Question 42

A company builds containerized microservices and needs to share common libraries (logging, authentication, monitoring) across 50 services. Currently, each service copies these libraries into its Dockerfile, causing inconsistency and duplicated maintenance. The team wants a centralized approach.

Which approach provides the BEST library sharing strategy for containerized services?

A. Create ECR repositories for base images that include the common libraries. Maintain versioned base images (e.g., company/base-java:1.2.0, company/base-python:3.1.0). Each service's Dockerfile uses FROM company/base-java:1.2.0. Automate base image rebuilds with security patches.

B. Publish common libraries as packages to AWS CodeArtifact. Each service's Dockerfile installs libraries from CodeArtifact during the build process.

C. Create a shared Lambda layer for common libraries and reference it from all services.

D. Use Git submodules to include the common library repositories in each service repository.

**Correct Answer: B**

**Explanation:** Publishing libraries to CodeArtifact as versioned packages (Maven, npm, pip) provides the best combination of centralization, versioning, and flexibility. Each service declares dependencies in its standard package manager file and installs from CodeArtifact during the build. Services can pin specific versions and upgrade independently. This follows standard dependency management practices. Option A (base images) tightly couples services to specific base image versions and doesn't work across different language ecosystems. Option C (Lambda layers) don't apply to ECS/EKS containers. Option D (Git submodules) is fragile and doesn't support proper version management.

---

### Question 43

A company runs 30 ECS services that have been deployed using CodePipeline for two years. The team notices that deployments are becoming slower and less reliable. Build times have increased from 5 to 20 minutes, and 10% of deployments fail due to flaky integration tests. The team wants to improve the CI/CD pipeline's health.

Which combination of improvements provides the MOST impact? (Choose TWO.)

A. Implement a build cache strategy: cache Docker layers in ECR, cache dependency artifacts in S3, and use incremental compilation. This reduces build times by avoiding redundant work.

B. Replace flaky integration tests with contract tests (consumer-driven contracts) that verify API compatibility without end-to-end dependencies. Run integration tests in a separate, non-blocking pipeline.

C. Migrate from CodePipeline to Tekton Pipelines running on the EKS cluster for better performance.

D. Add more CodeBuild compute resources by upgrading to BUILD_GENERAL1_2XLARGE.

E. Remove all tests from the pipeline to reduce deployment time.

**Correct Answer: A, B**

**Explanation:** Build caching (A) directly addresses the 5→20 minute build time increase. Docker layer caching, S3-cached dependencies, and incremental compilation eliminate redundant downloads and compilation. Contract tests (B) replace flaky integration tests with deterministic API compatibility checks that run fast and don't fail due to environment issues. Integration tests move to a separate pipeline for additional confidence without blocking deployments. Option C (Tekton migration) doesn't address the root causes. Option D (larger compute) helps but doesn't address cached dependencies or flaky tests. Option E removes quality gates entirely.

---

### Question 44

A company has an ECS service with 50 tasks that frequently need updated configuration values (feature flags, API endpoints, database connection strings). Currently, configuration changes require redeploying the service. The team wants to update configurations without redeployment.

Which approach enables dynamic configuration updates?

A. Store configurations in AWS AppConfig. Use the AppConfig agent as a sidecar container in the ECS task that polls for configuration changes and writes updates to a shared volume. The application reads configuration from the shared volume with a file watcher.

B. Store configurations in SSM Parameter Store. Reference parameters in the ECS task definition environment variables. Update parameters and force a new deployment.

C. Store configurations in DynamoDB. Have the application poll DynamoDB every 30 seconds for configuration changes.

D. Store configurations in S3 as JSON files. Mount the S3 bucket using s3fs in the container and read configurations from the mounted path.

**Correct Answer: A**

**Explanation:** AWS AppConfig provides managed configuration delivery with the AppConfig agent sidecar that handles polling, caching, and delivery without application restarts or redeployments. The agent retrieves configuration updates and makes them available to the application via a local endpoint or shared file. AppConfig supports validation, gradual rollout, and automatic rollback of bad configurations. Option B requires redeployment to pick up new parameter values. Option C works but requires custom polling code and doesn't provide validation or rollback. Option D—s3fs is unreliable in containers and doesn't provide change notification.

---

### Question 45

A company's EKS cluster has 100 nodes running 500 pods. The operations team reports that kubectl commands are slow and the API server is experiencing high latency. Investigation shows that many custom controllers and operators are making excessive API calls.

Which combination of optimizations improves EKS control plane performance? (Choose TWO.)

A. Configure API Priority and Fairness (APF) settings to limit the API request rate from custom controllers. Create FlowSchemas that prioritize critical system components over custom operators.

B. Scale the EKS control plane by upgrading to a larger cluster tier with more API server capacity.

C. Review custom controllers and operators to implement proper watch-based patterns (using informers/shared informers) instead of polling the API server. Add resource version-based caching to reduce unnecessary list calls.

D. Increase the number of worker nodes to distribute the API server load across more nodes.

E. Reduce the number of namespaces to decrease the API server's metadata overhead.

**Correct Answer: A, C**

**Explanation:** API Priority and Fairness (A) throttles excessive API calls from misbehaving controllers while protecting critical system components (scheduler, kubelet, etc.). Optimizing custom controllers (C) addresses the root cause—replacing polling with watch-based patterns (informers) dramatically reduces API calls. Informers maintain a local cache and receive incremental updates, rather than repeatedly listing all resources. Option B—EKS automatically manages control plane scaling; there's no "tier" to upgrade. Option D—worker node count doesn't affect API server load directly. Option E—namespace count has minimal impact on API server performance.

---

### Question 46

A company deployed a new version of their ECS service using a rolling update. After deployment, they noticed that response latency increased by 200ms. They need to investigate whether the increase is caused by the new code or by infrastructure issues. The service uses 20 Fargate tasks.

Which approach provides the MOST efficient root cause analysis?

A. Use AWS X-Ray traces to compare latency breakdowns between the old and new service versions. X-Ray shows per-segment timing for each downstream call, revealing if the latency increase is in the application code, database calls, or external service calls.

B. Check CloudWatch Container Insights for CPU and memory utilization changes between the old and new deployment.

C. Review CloudWatch Logs for error messages or slow query logs from the new deployment.

D. Roll back to the previous version and observe if latency returns to normal.

**Correct Answer: A**

**Explanation:** X-Ray distributed tracing provides granular visibility into where time is spent within a request. By comparing trace maps and segment timelines between the old and new versions, you can pinpoint whether the latency increase is in the application code (handler duration), database calls (DynamoDB/RDS segments), external API calls, or internal processing. This identifies the root cause without guessing. Option B (Container Insights) shows resource utilization but doesn't explain where latency increased. Option C (logs) may not contain timing information unless explicitly logged. Option D (rollback) confirms the version is the cause but doesn't identify the root cause within the new version.

---

### Question 47

A company runs an ECS cluster with 100 services using the EC2 launch type. They want to migrate to Fargate for reduced operational overhead but are concerned about cost increases. Their current EC2 instances (m5.xlarge) average 65% utilization.

Which analysis determines the cost-effective migration approach?

A. Compare the current EC2 cost (including instance management overhead) with Fargate pricing by calculating: for each service, multiply the task CPU/memory by the number of tasks by the running hours, then apply Fargate per-vCPU-hour and per-GB-hour pricing. Include savings from eliminating EC2 instance management overhead (patching, AMI updates, capacity planning).

B. Simply compare the On-Demand EC2 hourly rate with the equivalent Fargate pricing per task.

C. Migrate all services to Fargate simultaneously and compare monthly bills.

D. Use the AWS Pricing Calculator to estimate Fargate costs based on current task definitions and task counts.

**Correct Answer: A**

**Explanation:** Accurate cost comparison requires calculating the total Fargate cost based on actual resource allocation per task (not per instance) and factoring in operational savings. At 65% utilization, EC2 instances have 35% waste. Fargate charges for exact resources allocated per task with no waste. Including operational overhead savings (reduced engineer time for patching, AMI management, capacity planning) provides the complete picture. Some services may be cheaper on Fargate; others may need right-sizing first. Option B ignores utilization efficiency and operational costs. Option C is risky without analysis. Option D doesn't factor in operational savings or utilization efficiency.

---

### Question 48

A company's CI/CD pipeline deploys to ECS and uses manual approval gates before production deployment. The approval process is slow because approvers must check multiple dashboards to verify staging health. The team wants to automate the approval decision.

Which approach automates the approval gate?

A. Replace the manual approval action with a Lambda function invoke action in CodePipeline. The Lambda function queries CloudWatch for staging environment metrics (error rate, latency, throughput), checks CodeDeploy deployment health, and approves or rejects the pipeline continuation based on predefined thresholds.

B. Remove the approval gate and rely on the deployment circuit breaker to detect issues in production.

C. Use AWS ChatOps with Slack notifications that allow approvers to approve with a single click after viewing an automated health summary.

D. Create a CloudWatch composite alarm that triggers a CodePipeline approval when all staging metrics are healthy.

**Correct Answer: A**

**Explanation:** A Lambda-based automated gate replaces the manual approval with programmatic validation. The function aggregates metrics from multiple sources (CloudWatch metrics, deployment status, test results), evaluates them against defined thresholds, and calls the CodePipeline PutApprovalResult API to approve or reject. This eliminates the human bottleneck while maintaining quality gates. Option B removes quality validation entirely. Option C still requires human action. Option D—CodePipeline doesn't support alarm-based automatic approval; composite alarms can trigger SNS but not pipeline approvals directly.

---

### Question 49

A company has identified that their EKS application experiences memory leaks that cause pods to restart every 24-48 hours. The operations team wants to proactively detect memory leaks before they cause OOMKills and implement automated remediation.

Which monitoring and remediation approach is MOST effective?

A. Configure Prometheus to scrape container memory metrics. Create alerting rules that detect memory growth trends (increasing memory usage without corresponding load increase). Use the Vertical Pod Autoscaler (VPA) in recommendation mode to identify pods that consistently need more memory. Implement a custom controller that gracefully restarts pods showing leak patterns during low-traffic windows.

B. Set Kubernetes memory limits equal to memory requests to ensure pods are killed immediately when they exceed allocated memory.

C. Use CloudWatch Container Insights to monitor memory utilization and set alarms at 80% threshold to page the operations team.

D. Increase the pod memory limits to accommodate the memory leak, allowing pods to run longer between restarts.

**Correct Answer: A**

**Explanation:** Prometheus-based trend detection identifies memory leaks early by analyzing growth patterns (memory increasing without proportional load increase). Alerting before OOMKill provides time for graceful handling. A custom controller that performs rolling restarts during low-traffic windows prevents service disruption. VPA recommendations help right-size memory allocations. This provides proactive detection and automated remediation. Option B causes immediate OOMKills, which disrupts service. Option C requires human intervention. Option D masks the problem and increases resource waste.

---

### Question 50

A company runs a batch processing system on ECS Fargate that processes 10,000 jobs daily. Each job runs as a separate Fargate task. Tasks frequently fail due to transient errors (network timeouts, throttling), requiring manual resubmission. The team wants automatic retry handling.

Which approach provides reliable job execution with automatic retries?

A. Use AWS Step Functions with an ECS RunTask integration. Configure retry policies on the ECS task state with exponential backoff (maxAttempts: 3, backoffRate: 2). Use a Map state for parallel job processing with a maximum concurrency limit.

B. Use an SQS queue to submit jobs. A Lambda function polls the queue and runs ECS tasks. Configure the SQS queue with maxReceiveCount for retry handling.

C. Write a custom ECS scheduler application that tracks task status and resubmits failed tasks.

D. Use AWS Batch with retry strategy configured on job definitions. Batch handles job queuing, scheduling, and retries natively.

**Correct Answer: D**

**Explanation:** AWS Batch is purpose-built for batch job processing with native retry strategies. You configure retry attempts on job definitions, and Batch automatically retries failed jobs with the specified strategy. Batch handles job queuing, scheduling, and resource management. For Fargate compute environments, Batch manages task lifecycle including retries without custom orchestration. Option A (Step Functions) works but adds complexity for simple batch processing. Option B (SQS + Lambda) requires custom task management logic. Option C is a custom solution replicating what Batch provides natively.

---

### Question 51

A company deploys new ECS service versions multiple times per day. After a recent deployment, a memory leak caused cascading failures. The team needs a deployment safety net that automatically detects and rolls back unhealthy deployments.

Which ECS feature provides this?

A. Enable the ECS deployment circuit breaker with automatic rollback. The circuit breaker monitors task launch failures and health check failures. If the deployment fails to reach a steady state, it automatically rolls back to the last known good deployment.

B. Use CodeDeploy blue/green deployments with CloudWatch alarms as rollback triggers. Define alarms for memory utilization and task health.

C. Configure an ALB health check with a strict threshold (2 consecutive failures) that marks tasks as unhealthy, causing ECS to replace them.

D. Implement a canary deployment with a Lambda function that monitors CloudWatch metrics and calls ecs:UpdateService to roll back if thresholds are breached.

**Correct Answer: A**

**Explanation:** The ECS deployment circuit breaker is a native feature that monitors deployment health during rolling updates. If new tasks repeatedly fail to start (crash loops, health check failures), the circuit breaker triggers and ECS automatically rolls back to the previous task definition. No external tooling or CloudWatch alarms are needed. It detects both startup failures and runtime health issues during the deployment window. Option B (CodeDeploy) adds complexity for simple deployment protection. Option C replaces individual unhealthy tasks but doesn't trigger a full rollback to the previous version. Option D requires custom implementation.

---

### Question 52

A company's EKS cluster runs in multiple Availability Zones. During an AZ failure, pods in the failed AZ took 10 minutes to reschedule to healthy AZs because the Cluster Autoscaler needed to provision new nodes. The target recovery time is 2 minutes.

Which configuration reduces the recovery time?

A. Configure Karpenter with ttlSecondsUntilExpired for proactive node rotation and overprovisioning by deploying low-priority "pause" pods that reserve capacity in each AZ. When real pods need scheduling, they preempt the pause pods, getting immediate capacity without waiting for new nodes.

B. Increase the Cluster Autoscaler scan interval from 10 seconds to 1 second for faster detection.

C. Use a larger number of smaller nodes so the impact of losing an AZ is distributed across more nodes.

D. Deploy pods with anti-affinity rules to spread them evenly across AZs and set PodDisruptionBudgets to ensure minimum availability.

**Correct Answer: A**

**Explanation:** Overprovisioning with low-priority "pause" pods reserves spare capacity across AZs. When pods from a failed AZ need rescheduling, they preempt the pause pods and start immediately on existing nodes—no waiting for new node provisioning. Karpenter then provisions replacement nodes for the preempted pause pods in the background. This achieves sub-minute pod rescheduling. Option B—faster scanning helps detection but not provisioning speed. Option C reduces per-node impact but doesn't speed up rescheduling when nodes are full. Option D spreads pods but doesn't ensure spare capacity exists for rescheduling.

---

### Question 53

A company uses CodePipeline to deploy Lambda functions. The pipeline builds the function, runs tests, and deploys. Recently, a deployed function failed because a dependency was deprecated and removed from the public registry between the test and deploy stages. The team wants to ensure that builds are reproducible.

Which practice ensures reproducible builds?

A. Pin all dependency versions exactly in the requirements/package lock file. Use a private artifact repository (CodeArtifact) to cache dependencies. Configure CodeBuild to pull dependencies only from CodeArtifact, not from public registries. The artifact repository serves as a stable source even if upstream packages are removed.

B. Include all dependencies in the source repository (vendoring) so the build doesn't need to download anything.

C. Use Docker images for Lambda deployment that include all dependencies baked into the image during the build stage.

D. Add a pre-deploy stage that re-downloads and re-tests dependencies before deployment.

**Correct Answer: A**

**Explanation:** Pinned versions in lock files ensure exact version resolution. CodeArtifact acts as a proxy cache—when dependencies are first downloaded, they're cached in CodeArtifact. Even if the upstream package is removed, the cached version remains available. Configuring CodeBuild to use only CodeArtifact prevents dependency confusion attacks and ensures build reproducibility. Option B (vendoring) bloats the repository and makes dependency updates harder. Option C (Docker images) works for container-based Lambda but doesn't address the root cause for zip-based deployments. Option D doesn't help if the dependency is already removed.

---

### Question 54

A company is migrating a legacy .NET Framework 4.8 application from on-premises Windows servers to AWS. The application cannot be recompiled for .NET Core. It consists of an IIS web frontend, a Windows Service for background processing, and a SQL Server database.

Which migration target provides the BEST operational efficiency?

A. Deploy the IIS frontend and Windows Service on Amazon ECS with Windows containers. Migrate the SQL Server database to Amazon RDS for SQL Server. Use a Network Load Balancer for the frontend.

B. Deploy the application on EC2 instances running Windows Server 2019 with IIS. Migrate SQL Server to RDS for SQL Server.

C. Containerize the application on EKS with Windows node groups. Migrate SQL Server to Aurora PostgreSQL using AWS SCT.

D. Use AWS App Runner for the IIS frontend and Lambda for the background processing. Migrate SQL Server to Aurora Serverless.

**Correct Answer: A**

**Explanation:** ECS with Windows containers supports .NET Framework 4.8 applications without recompilation. The IIS frontend can be containerized using the Windows Server Core with IIS base image, and the Windows Service can run as a container with a custom entrypoint. RDS for SQL Server provides managed database services. ECS handles container orchestration, health checks, and scaling. Option B (EC2) requires managing Windows Server instances directly. Option C—Aurora PostgreSQL is not compatible with SQL Server applications without significant code changes. Option D—App Runner and Lambda don't support .NET Framework 4.8.

---

### Question 55

A company is migrating a monolithic Java application to microservices on EKS. The monolith has 15 distinct business capabilities. The team wants to decompose incrementally while keeping the application functional throughout the migration.

Which migration strategy allows incremental decomposition?

A. Implement the Strangler Fig pattern: deploy the monolith on EKS as a single pod. Incrementally extract business capabilities into separate microservices. Use an API Gateway or Ingress controller to route traffic—new capabilities to microservices, remaining capabilities to the monolith. Gradually shift all traffic until the monolith is empty.

B. Rewrite all 15 capabilities as microservices simultaneously, then perform a big-bang cutover from the monolith to the microservices.

C. Fork the monolith into 15 copies and remove all but one capability from each copy to create 15 services.

D. Deploy the monolith on EKS and use a service mesh to intercept calls between internal modules, gradually replacing intercepted calls with microservice calls.

**Correct Answer: A**

**Explanation:** The Strangler Fig pattern allows incremental migration by routing traffic at the API level. The Ingress controller (or API Gateway) directs requests to either the monolith or the extracted microservice based on the URL path/capability. Each capability is extracted independently, tested, and promoted. The monolith remains functional throughout—handling unextracted capabilities. Option B (big-bang rewrite) is high-risk and takes long before any capability is migrated. Option C (fork) creates 15 monoliths that are hard to maintain. Option D (service mesh interception) works but requires the monolith to have well-defined internal interfaces, which monoliths typically don't have.

---

### Question 56

A company has 500 on-premises virtual machines running various applications. They need to migrate to containers on EKS. Not all applications are suitable for containerization. The team needs to assess which applications can be containerized and plan the migration.

Which approach provides the MOST accurate assessment?

A. Use AWS App2Container (A2C) to analyze running applications on the VMs. A2C discovers application components, dependencies, and configurations, then generates Dockerfiles and Kubernetes deployment manifests for containerizable applications. Applications that can't be containerized are flagged for alternative migration paths.

B. Manually review each application's architecture documentation and code to determine containerization feasibility.

C. Use AWS Migration Hub with the Strategy Recommendations feature to assess each application's migration strategy (rehost, replatform, refactor) based on discovered application data.

D. Containerize every application and test which ones work—those that don't are migrated to EC2.

**Correct Answer: A**

**Explanation:** AWS App2Container specifically analyzes running applications (Java and .NET) and generates container artifacts (Dockerfiles, task definitions, Kubernetes manifests). It discovers application processes, network connections, and file system dependencies to create accurate container configurations. This provides a concrete assessment of containerization feasibility with actionable artifacts. Option B (manual review) is time-consuming for 500 VMs and documentation may be outdated. Option C (Strategy Recommendations) provides high-level migration strategy recommendations but doesn't generate container artifacts. Option D (trial and error) is wasteful and time-consuming.

---

### Question 57

A company wants to migrate their Jenkins-based CI/CD pipeline to AWS-native services. The current pipeline: pulls code from GitHub, runs Maven builds, executes JUnit tests, builds Docker images, pushes to a private registry, and deploys to Kubernetes.

Which AWS-native pipeline provides equivalent functionality?

A. Use CodePipeline with GitHub as the source provider (using a CodeStar connection). CodeBuild for Maven builds, JUnit tests, Docker image building, and pushing to ECR. CodeDeploy with EKS for the deployment stage.

B. Use CodePipeline with CodeCommit as the source. Migrate from GitHub to CodeCommit. Use CodeBuild for all build and test steps. Deploy to EKS using kubectl commands in a CodeBuild step.

C. Use EventBridge to trigger a Step Functions workflow on GitHub pushes. Use CodeBuild for build steps and Lambda for deployment to EKS.

D. Deploy a managed Jenkins instance on ECS Fargate and continue using the existing Jenkins pipeline.

**Correct Answer: A**

**Explanation:** CodePipeline with a CodeStar GitHub connection provides native GitHub integration without migrating repositories. CodeBuild handles Maven builds, JUnit test execution, Docker image building, and ECR push in a single or multi-step build specification. CodeDeploy supports EKS deployments. This is a 1:1 replacement of each Jenkins pipeline stage with AWS-native services. Option B requires migrating from GitHub to CodeCommit, which adds unnecessary work. Option C (Step Functions) adds complexity for a straightforward CI/CD flow. Option D doesn't migrate away from Jenkins.

---

### Question 58

A company runs a microservices application on Docker Compose locally and Docker Swarm in production on-premises. They want to migrate to AWS containers with minimal changes to their Docker Compose files.

Which AWS service provides the smoothest migration from Docker Compose?

A. Use Amazon ECS with the AWS Copilot CLI, which can import Docker Compose files and generate ECS task definitions, services, and associated infrastructure (ALB, VPC, logging).

B. Deploy Docker Swarm on EC2 instances to maintain compatibility with existing Docker Compose files.

C. Use Amazon EKS and convert Docker Compose files to Kubernetes manifests using Kompose.

D. Deploy Amazon Lightsail containers, which support Docker Compose-style deployments.

**Correct Answer: A**

**Explanation:** AWS Copilot CLI is designed for developers familiar with Docker Compose. It can read Docker Compose configurations and generate ECS service definitions, task definitions, and supporting infrastructure. Copilot manages the ALB, VPC, logging (CloudWatch), and service discovery, providing a production-ready environment with minimal effort. Option B (Docker Swarm on EC2) doesn't leverage managed container services. Option C (Kompose) converts Compose to Kubernetes manifests but loses some Compose semantics and requires EKS knowledge. Option D (Lightsail containers) has limited scalability for production workloads.

---

### Question 59

A company has a legacy application running on ECS with the EC2 launch type that uses host networking mode and accesses the EC2 instance metadata service (IMDS) at 169.254.169.254. They want to migrate to Fargate for reduced operational overhead.

Which challenges must be addressed? (Choose TWO.)

A. Fargate doesn't support host networking mode. The application must be updated to use awsvpc networking mode, where each task gets its own ENI and IP address.

B. Fargate tasks cannot access the EC2 IMDS because they don't run on EC2 instances. The application must be updated to use the ECS Task Metadata endpoint or IAM Roles for Tasks (task role) instead of instance credentials.

C. Fargate doesn't support persistent storage, so any volumes used in the current configuration must be migrated to EFS.

D. Fargate tasks cannot access the VPC DNS resolver, requiring manual DNS configuration.

E. Fargate doesn't support custom AMIs, so any customizations on the current EC2 instances must be replicated in the container image.

**Correct Answer: A, B**

**Explanation:** Fargate only supports awsvpc networking mode (A)—the application must handle running with its own ENI rather than sharing the host network stack, which affects port binding (no port conflicts) and network interface behavior. Fargate tasks don't have access to EC2 IMDS (B) because they don't run on traditional EC2 instances. Any code relying on IMDS for credentials or instance metadata must use the ECS task metadata endpoint (169.254.170.2) or task IAM roles. Option C is incorrect—Fargate supports ephemeral storage and EFS volumes. Option D is incorrect—Fargate tasks use VPC DNS. Option E is a consideration but not a "challenge"—it's standard containerization.

---

### Question 60

A company runs a real-time video streaming application on EC2 instances with custom GPU encoding software. They want to containerize the application on EKS to improve deployment speed and resource utilization.

Which EKS configuration supports GPU-accelerated containers?

A. Create an EKS managed node group with GPU instances (g5.xlarge). Install the NVIDIA device plugin for Kubernetes as a DaemonSet. Configure pod resource requests with nvidia.com/gpu: 1 to schedule pods on GPU nodes. Use the NVIDIA CUDA base image for the application container.

B. Use Fargate profiles with GPU resource requests. Fargate automatically provisions GPU-capable infrastructure for pods requesting GPU resources.

C. Create standard managed node groups and install GPU drivers on the worker nodes. Mount the GPU device as a hostPath volume in the pod.

D. Use EKS Anywhere with GPU-enabled bare metal servers for better GPU utilization.

**Correct Answer: A**

**Explanation:** GPU support on EKS requires: GPU-capable EC2 instances in the node group (g5, p3, p4 families), the NVIDIA device plugin DaemonSet (which discovers GPUs and makes them available as a Kubernetes resource), and pod specifications that request nvidia.com/gpu resources. The CUDA base image provides the necessary NVIDIA runtime libraries. EKS-optimized AMIs with GPU support come pre-installed with NVIDIA drivers. Option B—Fargate doesn't support GPU instances. Option C—hostPath GPU access is fragile and doesn't integrate with the Kubernetes scheduler. Option D is for on-premises deployment.

---

### Question 61

A company is migrating from a self-managed RabbitMQ cluster used for inter-service communication to an AWS-managed messaging service. The application uses advanced RabbitMQ features: exchanges (direct, topic, fanout), dead letter exchanges, message TTL, and consumer acknowledgments.

Which AWS service provides the BEST compatibility?

A. Use Amazon MQ with the RabbitMQ engine. Amazon MQ supports native RabbitMQ protocol (AMQP 0.9.1), including exchanges, dead letter exchanges, message TTL, and consumer acknowledgments. Existing application code works with minimal endpoint configuration changes.

B. Migrate to Amazon SQS with SNS for the fanout pattern. Implement dead letter queues and message delays using SQS features.

C. Use Amazon MSK (Kafka) to replace RabbitMQ. Kafka supports topic-based messaging and consumer groups.

D. Use Amazon EventBridge for message routing and SQS for queuing. Map RabbitMQ exchange types to EventBridge rules.

**Correct Answer: A**

**Explanation:** Amazon MQ for RabbitMQ provides a fully managed RabbitMQ broker that supports the native AMQP 0.9.1 protocol. All RabbitMQ features—exchanges (direct, topic, fanout), dead letter exchanges, message TTL, consumer acknowledgments—work identically. Existing application code only needs the broker endpoint updated. Option B (SQS/SNS) requires significant code changes to map RabbitMQ concepts to SQS/SNS patterns. Option C (Kafka) has a fundamentally different messaging model. Option D (EventBridge) doesn't support the RabbitMQ protocol or exchange patterns.

---

### Question 62

A company is migrating a Kubernetes application from GKE (Google Kubernetes Engine) to Amazon EKS. The application uses GKE-specific features: Config Connector for managing GCP resources, GKE Ingress for load balancing, and Workload Identity for GCP service authentication.

Which replacements provide equivalent functionality on EKS?

A. Replace Config Connector with AWS Controllers for Kubernetes (ACK) for managing AWS resources declaratively. Replace GKE Ingress with AWS Load Balancer Controller for ALB/NLB provisioning via Kubernetes Ingress resources. Replace Workload Identity with EKS Pod Identity (or IRSA) for AWS service authentication from pods.

B. Replace all GKE-specific features with Helm charts that create AWS resources using the AWS CLI in init containers.

C. Use Crossplane for managing AWS resources instead of Config Connector, maintain the same Ingress controller, and use environment variable-based AWS credentials.

D. Deploy Terraform operators on EKS for resource management, Traefik for ingress, and IAM access keys stored in Kubernetes secrets.

**Correct Answer: A**

**Explanation:** ACK provides the EKS equivalent of Config Connector—declarative AWS resource management via Kubernetes custom resources. AWS Load Balancer Controller replaces GKE Ingress by provisioning ALBs and NLBs from Kubernetes Ingress resources. EKS Pod Identity (or IRSA) provides the same security model as GKE Workload Identity—pods assume IAM roles without static credentials. These are 1:1 replacements using AWS-native EKS tools. Option B is fragile and non-declarative. Option C (Crossplane) works but is non-AWS-native, and environment variable credentials are a security anti-pattern. Option D uses non-standard tools and static credentials.

---

### Question 63

A company runs 100 ECS Fargate tasks for a production service. Each task is configured with 2 vCPU and 8GB memory. CloudWatch metrics show average CPU utilization is 15% and memory utilization is 25% across all tasks. Monthly Fargate costs are $15,000.

Which optimization provides the GREATEST cost reduction?

A. Right-size tasks to 0.5 vCPU and 2GB memory based on actual utilization (with headroom). Reduce the task count based on throughput testing at the new resource level. Apply a Compute Savings Plan for the optimized workload.

B. Switch from Fargate to EC2 launch type with Reserved Instances for better per-resource pricing.

C. Enable Fargate Spot for all tasks since the service is stateless.

D. Reduce only the task count from 100 to 25 while keeping the same resource configuration per task.

**Correct Answer: A**

**Explanation:** The 15% CPU and 25% memory utilization indicate 4x over-provisioning on CPU and 3x on memory. Right-sizing from 2vCPU/8GB to 0.5vCPU/2GB reduces per-task cost by ~75%. With reduced per-task resources, throughput testing determines the correct task count (may need more small tasks, but the total cost is still lower). A Savings Plan adds another ~20% savings. Combined savings: approximately 80%. Option B (EC2) adds operational overhead. Option C (Fargate Spot) saves ~70% but risks interruptions. Option D (reduce count only) may degrade performance without right-sizing first.

---

### Question 64

A company uses CodePipeline with CodeBuild for CI/CD. They have 50 pipelines running an average of 10 builds per day each. CodeBuild costs are $3,000/month. Most builds wait 2-3 minutes for the build environment to provision before the actual build starts.

Which approach reduces both costs and build environment provisioning time?

A. Use CodeBuild reserved capacity (compute fleet) with a fleet of warm instances that eliminate provisioning wait time. Size the fleet based on average concurrent builds with on-demand overflow for peak times. The fleet provides pre-provisioned environments that start builds immediately.

B. Migrate from CodeBuild to self-hosted build agents on EC2 Spot Instances in an Auto Scaling group.

C. Reduce the number of pipelines by combining multiple services into single builds.

D. Cache the CodeBuild Docker images in ECR to reduce provisioning time.

**Correct Answer: A**

**Explanation:** CodeBuild compute fleets maintain warm build instances that eliminate the 2-3 minute provisioning time. You define a fleet with a baseline capacity (warm instances) and maximum capacity (for burst). Warm instances start builds immediately. Fleet pricing can be more cost-effective than on-demand CodeBuild pricing for consistent workloads (500 builds/day). Option B (self-hosted agents) adds significant operational overhead. Option C (combining builds) reduces isolation and increases build times. Option D—image caching helps marginally but doesn't eliminate the environment provisioning time.

---

### Question 65

A company runs a batch processing workload on ECS Fargate that scales from 0 to 500 tasks during processing windows. Tasks run for 30-60 minutes each. The workload runs every 4 hours. Monthly cost is $10,000.

Which pricing strategy provides the BEST savings for this workload pattern?

A. Use Fargate Spot for the batch tasks. Configure the ECS service with a capacity provider strategy that uses 100% Fargate Spot. Implement checkpoint/retry logic in the application to handle Spot interruptions.

B. Purchase a Compute Savings Plan covering the average compute usage.

C. Switch from Fargate to EC2 Spot Instances using AWS Batch for job management.

D. Use Fargate with the standard pricing and optimize task sizes to reduce waste.

**Correct Answer: A**

**Explanation:** Fargate Spot provides up to 70% discount off Fargate pricing. For batch workloads that can tolerate interruptions (with checkpoint/retry logic), Spot is ideal. The intermittent nature (every 4 hours, 30-60 minute tasks) means Savings Plans would be less effective since they cover steady-state usage, not spiky batch workloads. Monthly savings: ~$7,000 (70% of $10,000). Option B (Savings Plans) covers average usage but the spiky pattern means most Spot interruptions and start/stop costs are wasted. Option C (EC2 Spot + Batch) adds operational complexity. Option D doesn't leverage any discount mechanism.

---

### Question 66

A company has an EKS cluster with 50 nodes (m5.2xlarge). Pod scheduling shows that 30% of nodes have less than 10% CPU utilization while other nodes are at 90%. This uneven distribution wastes resources.

Which approach improves cluster utilization efficiency?

A. Deploy Karpenter to replace the Cluster Autoscaler and managed node groups. Karpenter consolidates underutilized nodes by moving pods and terminating empty or underutilized nodes. Configure Karpenter's consolidation policy to actively right-size the cluster.

B. Configure the Kubernetes scheduler with custom profiles that use MostRequestedPriority to pack pods onto fewer nodes.

C. Enable Cluster Autoscaler with the scale-down-utilization-threshold set to 0.5, allowing it to remove nodes below 50% utilization.

D. Manually cordon underutilized nodes and drain pods to consolidate workloads on fewer nodes.

**Correct Answer: A**

**Explanation:** Karpenter's consolidation feature actively evaluates whether running pods can be consolidated onto fewer or smaller nodes. It identifies underutilized nodes, cordons them, drains pods to other nodes, and terminates the empty nodes—automatically and continuously. This directly addresses the 30% underutilized nodes. Karpenter also right-sizes replacement nodes based on actual pod requirements. Option B (scheduler profiles) only affects new pod placement, not existing imbalances. Option C (Cluster Autoscaler) is less aggressive at consolidation than Karpenter. Option D is manual and not sustainable.

---

### Question 67

A company runs ECS services across three AWS accounts (dev, staging, prod). Each environment has its own ECR repositories with copies of the same images. ECR storage costs are $500/month across all accounts due to image duplication.

Which approach reduces ECR costs?

A. Use a single ECR registry in a shared services account with cross-account pull permissions. All environments pull images from this central registry. Implement ECR lifecycle policies to remove untagged and old images, retaining only the last 10 tagged versions per repository.

B. Enable ECR replication across accounts and use lifecycle policies to manage storage.

C. Move container images to S3 and use custom scripts to pull images during task startup.

D. Use public ECR repositories instead of private ones to reduce costs.

**Correct Answer: A**

**Explanation:** Centralizing ECR in a single account eliminates image duplication across three accounts, reducing storage by ~67%. Cross-account pull permissions allow dev, staging, and prod to pull directly from the central registry. Lifecycle policies automatically clean old images, retaining only necessary versions. This reduces storage costs from $500 to approximately $150-200/month. Option B (replication) adds copies, increasing storage costs. Option C (S3) doesn't integrate with ECS image pulling. Option D (public ECR) exposes images publicly—a security risk for proprietary applications.

---

### Question 68

A company uses Amazon API Gateway with Lambda backend. Monthly API Gateway costs are $5,000 for 100 million API calls. The API handles mostly read requests with the same response for identical requests within a 5-minute window.

Which optimization provides the GREATEST cost reduction?

A. Enable API Gateway caching with a 5-minute TTL and a cache size appropriate for the working set. Cached responses are served directly from the API Gateway cache without invoking the Lambda function, reducing both API Gateway execution costs and Lambda invocation costs.

B. Migrate from REST API to HTTP API, which has a lower per-request price.

C. Implement response caching in the Lambda function itself using a global variable cache.

D. Deploy CloudFront in front of API Gateway with a 5-minute cache TTL.

**Correct Answer: D**

**Explanation:** CloudFront in front of API Gateway caches responses at edge locations globally, serving cached responses without hitting API Gateway at all. CloudFront pricing ($0.0085/10,000 requests for North America) is significantly lower than API Gateway pricing ($3.50/million requests for REST API). For mostly identical read requests with a 5-minute window, the cache hit ratio would be very high, potentially reducing API Gateway calls by 80-90%. This saves on both API Gateway and Lambda costs. Option A (API Gateway caching) adds hourly cache costs ($0.02-$3.80/hour) and still charges per API Gateway request. Option B (HTTP API) reduces per-request price but not as dramatically as caching. Option C doesn't reduce API Gateway costs.

---

### Question 69

A company runs an EKS cluster that auto-scales using Cluster Autoscaler. During scale-up events, new nodes take 5-7 minutes to become ready, including EC2 launch, AMI boot, kubelet registration, and node readiness. The team wants to reduce this to under 2 minutes.

Which approach achieves faster node scaling?

A. Switch to Karpenter with fast-launch AMIs built using EC2 Image Builder. Configure the AMI with pre-pulled container images for frequently used workloads. Use instance types with NVMe storage for faster boot.

B. Pre-warm a pool of EC2 instances in a stopped state and start them when scaling is needed.

C. Use Fargate profiles for the pods that need fast scaling, eliminating node provisioning entirely.

D. Increase the Cluster Autoscaler's buffer capacity by setting --scale-up-from-zero=false and maintaining minimum node count.

**Correct Answer: A**

**Explanation:** Karpenter provisions nodes faster than Cluster Autoscaler because it bypasses Auto Scaling groups and uses direct EC2 fleet API calls. Fast-launch AMIs with pre-pulled images eliminate the largest component of startup time (image pulling). NVMe instance storage provides faster boot performance. Combined, these reduce node readiness to under 2 minutes. Option B (stopped instances) still requires boot time and kubelet registration. Option C (Fargate) may not support all workload requirements and has its own cold start. Option D maintains idle capacity, which wastes resources when not needed.

---

### Question 70

A company's ECS service costs $8,000/month. The service runs 40 Fargate tasks (1 vCPU, 4GB memory) 24/7 with consistent utilization at 60-70% CPU. They have no existing commitment discounts.

Which purchasing strategy provides the OPTIMAL cost reduction?

A. Purchase a 1-year Compute Savings Plan that covers 70% of the steady-state compute usage (28 tasks worth of vCPU-hours and GB-hours). The remaining 30% runs at on-demand pricing to accommodate minor fluctuations.

B. Purchase a 3-year All Upfront Compute Savings Plan covering 100% of current usage.

C. Switch all tasks to Fargate Spot for the maximum discount.

D. Move from Fargate to EC2 launch type with Reserved Instances.

**Correct Answer: A**

**Explanation:** A 1-year Compute Savings Plan covering 70% of usage provides approximately 20% savings on the committed portion while maintaining flexibility. Covering 70% (not 100%) accounts for minor traffic variations without overspending on commitments. Savings Plans apply to both Fargate and Lambda, providing flexibility if the architecture changes. At $8,000/month, covering 70% saves ~$1,120/month. Option B (3-year 100% coverage) is risky—the architecture may change, and over-commitment at 100% wastes money if usage decreases. Option C (Spot) risks interruptions for a 24/7 production service. Option D adds operational overhead managing EC2 instances.

---

### Question 71

A company deploys a containerized application on EKS with Horizontal Pod Autoscaler (HPA) configured to scale on CPU utilization. During traffic spikes, the HPA takes 3-4 minutes to scale pods, causing request queuing and latency spikes. The application handles HTTP requests.

Which approach reduces the scaling response time?

A. Implement KEDA (Kubernetes Event Driven Autoscaling) with an HTTP add-on that scales based on the number of pending HTTP requests rather than CPU. KEDA can scale pods from 0 to N in seconds based on request queue depth.

B. Use a custom metric (request latency or queue depth) in the HPA instead of CPU. Configure the HPA with a shorter stabilization window and faster scaling behavior.

C. Increase the minimum replica count to handle expected peak traffic without autoscaling.

D. Deploy a second EKS cluster as a standby that activates during traffic spikes using Route 53 failover.

**Correct Answer: B**

**Explanation:** Using request-based metrics (latency or queue depth) in HPA instead of CPU enables faster scaling response because request metrics react immediately to traffic increases, while CPU lags behind. Configuring a shorter stabilization window (--horizontal-pod-autoscaler-downscale-stabilization) and faster scaling behavior (behavior.scaleUp with stabilizationWindowSeconds: 0 and policies for rapid scaling) reduces the 3-4 minute delay. Option A (KEDA) is also valid but adds another component. Option C over-provisions and wastes resources. Option D is overly complex for traffic spike handling.

---

### Question 72

A company runs 200 Lambda functions with an average duration of 500ms and 256MB memory. Monthly Lambda costs are $8,000. AWS Compute Optimizer shows that 60% of functions are over-provisioned on memory and 20% are under-provisioned.

What is the estimated cost savings from right-sizing all functions based on Compute Optimizer recommendations?

A. Approximately 25-35% savings ($2,000-$2,800/month) by reducing memory for over-provisioned functions (which reduces their per-ms cost) and increasing memory for under-provisioned functions (which reduces their duration due to more CPU, often resulting in net savings despite higher per-ms cost).

B. Less than 5% savings because Lambda pricing is primarily based on invocation count, not memory.

C. Approximately 50% savings by cutting all memory allocations in half.

D. No savings because Lambda functions with lower memory allocations run slower, consuming more total compute time.

**Correct Answer: A**

**Explanation:** Lambda pricing is based on GB-seconds (memory × duration). For over-provisioned functions (60% of the fleet), reducing memory directly reduces cost per invocation. For under-provisioned functions (20%), increasing memory provides proportionally more CPU, which often reduces execution duration enough that the total GB-seconds decrease. The remaining 20% are correctly provisioned. Typical right-sizing across a fleet of 200 functions yields 25-35% total savings. Option B is wrong—Lambda pricing is primarily GB-seconds based. Option C is wrong—halving memory can increase duration. Option D is partially true for some functions but not for the over-provisioned majority.

---

### Question 73

A company operates a multi-tenant SaaS platform on ECS. Each tenant's workload varies significantly—some use 10% of their allocated resources while others use 90%. The company allocates fixed resources per tenant, resulting in $50,000/month in Fargate costs.

Which approach reduces costs while maintaining tenant isolation?

A. Implement a resource management layer that dynamically adjusts each tenant's task resource allocation and count based on their actual usage patterns. Use CloudWatch metrics per tenant (custom metrics tagged by tenant ID) to drive ECS Service Auto Scaling policies. Set minimum guarantees per tenant with the ability to burst.

B. Move all tenants to a shared pool of tasks with application-level tenant routing.

C. Use a fixed resource allocation with Savings Plans to reduce per-unit cost.

D. Move small-usage tenants to Lambda-based processing and keep large tenants on Fargate.

**Correct Answer: A**

**Explanation:** Dynamic resource management based on actual usage eliminates the waste from fixed allocation. Tenants using 10% of their allocation can have their task count reduced or task size optimized, while 90% utilization tenants maintain appropriate resources. Per-tenant CloudWatch metrics enable tenant-specific scaling policies. Minimum guarantees ensure SLA compliance while burst capability handles spikes. This can reduce costs by 40-60% depending on utilization distribution. Option B loses tenant isolation. Option C reduces per-unit cost but doesn't address the fundamental over-provisioning. Option D splits the architecture, adding complexity.

---

### Question 74

A company uses CodeBuild for CI/CD across 20 teams. Each team's CodeBuild project uses a different Docker image for their build environment. Image pull times add 1-2 minutes to every build. With 500 builds per day, this results in significant wasted time.

Which approach reduces image pull overhead?

A. Use CodeBuild's custom image caching with a local cache source type of LOCAL_DOCKER_LAYER_CACHE. Additionally, create an ECR pull-through cache for frequently used public images to reduce pull times from public registries.

B. Create a single universal build image that includes all tools needed by all 20 teams.

C. Use CodeBuild compute fleets with warm pools. Images are pre-cached on fleet instances, eliminating pull time for subsequent builds.

D. Store build images as AMIs and use custom CodeBuild environments that boot from these AMIs.

**Correct Answer: C**

**Explanation:** CodeBuild compute fleets maintain warm instances with cached Docker images from previous builds. When a build starts on a fleet instance that previously used the same image, the image is already present—eliminating the pull entirely. For 500 daily builds, this saves 500-1,000 minutes of image pull time. Fleet instances maintain their cache across builds. Option A (local cache) helps with layer caching during a single build but doesn't persist across different builds. Option B (universal image) is bloated and slow to pull initially. Option D—CodeBuild doesn't support custom AMIs for build environments.

---

### Question 75

A company operates an EKS cluster with 30 nodes for a production application. They have identified that 40% of pod CPU requests are never used (pods request 1 CPU but only use 0.6 CPU on average). This over-requesting results in 12 nodes being underutilized but not removable because of resource requests.

Which strategy recovers the wasted capacity?

A. Deploy the Vertical Pod Autoscaler (VPA) in recommendation mode to identify optimal resource requests for each pod. Apply the recommendations to reduce CPU requests to match actual usage (with a safety margin). This allows the scheduler to pack more pods per node, enabling Karpenter/Cluster Autoscaler to remove excess nodes.

B. Remove all resource requests from pods so the scheduler can pack them freely on any node.

C. Increase node sizes to absorb the over-requested resources without adding more nodes.

D. Configure the Kubernetes scheduler to ignore resource requests when scheduling pods.

**Correct Answer: A**

**Explanation:** VPA in recommendation mode analyzes actual resource consumption and suggests optimal requests. Applying these recommendations (e.g., reducing from 1 CPU to 0.7 CPU request) frees up allocated capacity on nodes. With more free capacity per node, the scheduler can fit more pods, and the autoscaler can remove the now-unnecessary 12 underutilized nodes. A safety margin above actual usage (e.g., 15%) prevents OOMKills during spikes. Option B (no requests) removes scheduling guarantees and can cause noisy neighbor problems. Option C (larger nodes) increases cost. Option D is not a valid Kubernetes configuration.

---

## Answer Key

| Question | Answer | Domain |
|----------|--------|--------|
| 1 | A | D1 |
| 2 | A | D1 |
| 3 | A | D1 |
| 4 | A | D1 |
| 5 | A | D1 |
| 6 | A | D1 |
| 7 | A | D1 |
| 8 | A | D1 |
| 9 | A, B | D1 |
| 10 | B | D1 |
| 11 | A | D1 |
| 12 | A | D1 |
| 13 | A, B | D1 |
| 14 | B, C | D1 |
| 15 | B | D1 |
| 16 | A | D1 |
| 17 | A | D1 |
| 18 | A, B | D1 |
| 19 | A | D1 |
| 20 | A | D1 |
| 21 | B | D2 |
| 22 | A | D2 |
| 23 | A, B, C | D2 |
| 24 | B | D2 |
| 25 | B | D2 |
| 26 | A | D2 |
| 27 | A | D2 |
| 28 | A | D2 |
| 29 | A | D2 |
| 30 | A | D2 |
| 31 | A | D2 |
| 32 | B | D2 |
| 33 | A | D2 |
| 34 | A | D2 |
| 35 | A | D2 |
| 36 | A | D2 |
| 37 | A | D2 |
| 38 | A | D2 |
| 39 | A | D2 |
| 40 | A | D2 |
| 41 | B | D2 |
| 42 | B | D2 |
| 43 | A, B | D3 |
| 44 | A | D3 |
| 45 | A, C | D3 |
| 46 | A | D3 |
| 47 | A | D3 |
| 48 | A | D3 |
| 49 | A | D3 |
| 50 | D | D3 |
| 51 | A | D3 |
| 52 | A | D3 |
| 53 | A | D3 |
| 54 | A | D4 |
| 55 | A | D4 |
| 56 | A | D4 |
| 57 | A | D4 |
| 58 | A | D4 |
| 59 | A, B | D4 |
| 60 | A | D4 |
| 61 | A | D4 |
| 62 | A | D4 |
| 63 | A | D5 |
| 64 | A | D5 |
| 65 | A | D5 |
| 66 | A | D5 |
| 67 | A | D5 |
| 68 | D | D5 |
| 69 | A | D5 |
| 70 | A | D5 |
| 71 | B | D5 |
| 72 | A | D5 |
| 73 | A | D5 |
| 74 | C | D5 |
| 75 | A | D5 |

# AWS Certified DevOps Engineer – Professional (DOP-C02) Study Guide

## Exam Overview

| Detail | Info |
|---|---|
| **Exam Code** | DOP-C02 |
| **Format** | 75 questions — multiple choice (single answer) and multiple response (2+ correct answers) |
| **Duration** | 180 minutes (3 hours) |
| **Passing Score** | ~750 / 1000 (scaled scoring; exact threshold is not published) |
| **Cost** | $300 USD |
| **Delivery** | Pearson VUE testing center or online proctored |
| **Validity** | 3 years |
| **Recommended Experience** | 2+ years in provisioning, operating, and managing AWS environments; strong background in CI/CD, IaC, monitoring, security automation, and incident response |

> **Note:** The exam uses scaled scoring across all domains. There is no per-domain minimum — you can compensate a weaker domain with strong performance elsewhere, but you should aim for solid coverage of every domain because question distribution is weighted.

---

## Exam Domains and Weights

| Domain | Weight | Key Services |
|---|---|---|
| **1 – SDLC Automation** | **22%** | CodePipeline, CodeBuild, CodeDeploy, CodeCommit, CodeArtifact, ECR, Elastic Beanstalk, AppConfig |
| **2 – Configuration Management and IaC** | **17%** | CloudFormation, CDK, Systems Manager, OpsWorks, Service Catalog, Terraform on AWS |
| **3 – Monitoring and Logging** | **15%** | CloudWatch (Metrics, Logs, Alarms, Dashboards, Synthetics, RUM, Evidently), X-Ray, CloudTrail, OpenSearch, Kinesis Data Firehose, EventBridge |
| **4 – Policies and Standards Automation** | **10%** | AWS Config, Service Control Policies, IAM, Organizations, Control Tower, GuardDuty, Security Hub, Inspector, Macie |
| **5 – Incident and Event Response** | **18%** | EventBridge, Lambda, SNS, SQS, Systems Manager Incident Manager, Auto Scaling lifecycle hooks, GuardDuty, Health API |
| **6 – High Availability, Fault Tolerance, and DR** | **18%** | Route 53, ELB, Auto Scaling, RDS Multi-AZ/Read Replicas, Aurora Global, DynamoDB Global Tables, S3 Cross-Region Replication, Backup, Elastic Disaster Recovery |

---

## Complete Table of Contents

### Foundation

| # | Topic | Path |
|---|---|---|
| 00 | [8-Week Study Plan](./00-Study-Plan/study-plan.md) | `00-Study-Plan/study-plan.md` |

### Domain 1 – SDLC Automation (22%)

| # | Topic | Path |
|---|---|---|
| 01 | [SDLC Automation – Deep Dive Article](./01-SDLC-Automation/article.md) | `01-SDLC-Automation/article.md` |
| 01-Q | [Practice Questions – SDLC Automation](./01-SDLC-Automation/questions.md) | `01-SDLC-Automation/questions.md` |
| 01-C | [Code Examples – SDLC Automation](./01-SDLC-Automation/code-examples/sdlc-examples.md) | `01-SDLC-Automation/code-examples/sdlc-examples.md` |

### Domain 2 – Configuration Management and IaC (17%)

| # | Topic | Path |
|---|---|---|
| 02 | [Configuration Management & IaC – Deep Dive Article](./02-Configuration-Management-IaC/article.md) | `02-Configuration-Management-IaC/article.md` |
| 02-Q | [Practice Questions – IaC](./02-Configuration-Management-IaC/questions.md) | `02-Configuration-Management-IaC/questions.md` |
| 02-C | [Code Examples – IaC](./02-Configuration-Management-IaC/code-examples/iac-examples.md) | `02-Configuration-Management-IaC/code-examples/iac-examples.md` |

### Domain 3 – Monitoring and Logging (15%)

| # | Topic | Path |
|---|---|---|
| 03 | [Monitoring and Logging – Deep Dive Article](./03-Monitoring-and-Logging/article.md) | `03-Monitoring-and-Logging/article.md` |
| 03-Q | [Practice Questions – Monitoring](./03-Monitoring-and-Logging/questions.md) | `03-Monitoring-and-Logging/questions.md` |
| 03-C | [Code Examples – Monitoring](./03-Monitoring-and-Logging/code-examples/monitoring-examples.md) | `03-Monitoring-and-Logging/code-examples/monitoring-examples.md` |

### Domain 4 – Policies and Standards Automation (10%)

| # | Topic | Path |
|---|---|---|
| 04 | [Policies and Standards – Deep Dive Article](./04-Policies-Standards-Automation/article.md) | `04-Policies-Standards-Automation/article.md` |
| 04-Q | [Practice Questions – Policies](./04-Policies-Standards-Automation/questions.md) | `04-Policies-Standards-Automation/questions.md` |
| 04-C | [Code Examples – Policies](./04-Policies-Standards-Automation/code-examples/policies-examples.md) | `04-Policies-Standards-Automation/code-examples/policies-examples.md` |

### Domain 5 – Incident and Event Response (18%)

| # | Topic | Path |
|---|---|---|
| 05 | [Incident and Event Response – Deep Dive Article](./05-Incident-Event-Response/article.md) | `05-Incident-Event-Response/article.md` |
| 05-Q | [Practice Questions – Incident Response](./05-Incident-Event-Response/questions.md) | `05-Incident-Event-Response/questions.md` |
| 05-C | [Code Examples – Incident Response](./05-Incident-Event-Response/code-examples/incident-examples.md) | `05-Incident-Event-Response/code-examples/incident-examples.md` |

### Domain 6 – HA, Fault Tolerance, and DR (18%)

| # | Topic | Path |
|---|---|---|
| 06 | [HA/FT/DR – Deep Dive Article](./06-HA-FT-DR/article.md) | `06-HA-FT-DR/article.md` |
| 06-Q | [Practice Questions – HA/FT/DR](./06-HA-FT-DR/questions.md) | `06-HA-FT-DR/questions.md` |
| 06-C | [Code Examples – HA/FT/DR](./06-HA-FT-DR/code-examples/ha-dr-examples.md) | `06-HA-FT-DR/code-examples/ha-dr-examples.md` |

### Service Deep Dives

| # | Topic | Path |
|---|---|---|
| 07a | [CodePipeline, CodeBuild, CodeDeploy Deep Dive](./07-Service-Deep-Dives/CodePipeline-CodeBuild-CodeDeploy.md) | `07-Service-Deep-Dives/CodePipeline-CodeBuild-CodeDeploy.md` |
| 07b | [CloudFormation & CDK Deep Dive](./07-Service-Deep-Dives/CloudFormation-CDK.md) | `07-Service-Deep-Dives/CloudFormation-CDK.md` |
| 07c | [ECS, EKS & Lambda Deep Dive](./07-Service-Deep-Dives/ECS-EKS-Lambda.md) | `07-Service-Deep-Dives/ECS-EKS-Lambda.md` |
| 07d | [Systems Manager, Config & Organizations Deep Dive](./07-Service-Deep-Dives/Systems-Manager-Config-Organizations.md) | `07-Service-Deep-Dives/Systems-Manager-Config-Organizations.md` |
| 07e | [Elastic Beanstalk, OpsWorks & AppConfig Deep Dive](./07-Service-Deep-Dives/ElasticBeanstalk-OpsWorks-AppConfig.md) | `07-Service-Deep-Dives/ElasticBeanstalk-OpsWorks-AppConfig.md` |

### Flashcards, Cheat Sheets & Practice Exams

| # | Topic | Path |
|---|---|---|
| 08 | [Flashcards (250+ Cards)](./08-Flashcards/flashcards.md) | `08-Flashcards/flashcards.md` |
| 09a | [Practice Exam 1 (75 Questions)](./09-Practice-Exams/practice-exam-1.md) | `09-Practice-Exams/practice-exam-1.md` |
| 09b | [Practice Exam 2 (75 Questions)](./09-Practice-Exams/practice-exam-2.md) | `09-Practice-Exams/practice-exam-2.md` |
| 09c | [Practice Exam 3 – HARD (75 Questions)](./09-Practice-Exams/practice-exam-3.md) | `09-Practice-Exams/practice-exam-3.md` |
| 09d | [Practice Exam 4 – Comprehensive Review (75 Questions)](./09-Practice-Exams/practice-exam-4.md) | `09-Practice-Exams/practice-exam-4.md` |
| 10 | [Cheat Sheets (12 Reference Sheets)](./10-Cheat-Sheets/cheat-sheets.md) | `10-Cheat-Sheets/cheat-sheets.md` |
| 11 | [Architecture Diagrams (14 Diagrams)](./11-Architecture-Diagrams/diagrams.md) | `11-Architecture-Diagrams/diagrams.md` |

---

## Prerequisites

Before starting this study guide you should have:

1. **AWS Solutions Architect Associate or SysOps Administrator Associate** certification (strongly recommended but not required by AWS).
2. **2+ years of hands-on DevOps experience on AWS** including:
   - Building and maintaining CI/CD pipelines.
   - Writing CloudFormation or CDK templates for production workloads.
   - Operating monitoring and logging at scale (CloudWatch, X-Ray).
   - Managing multi-account AWS environments with Organizations / Control Tower.
   - Implementing blue/green, canary, and rolling deployment strategies.
3. Comfortable reading and writing YAML/JSON, Python or Node.js Lambda functions, and shell scripts.
4. Familiarity with Docker, container orchestration (ECS/EKS), and networking fundamentals (VPC, DNS, load balancing).

---

## Exam Tips and Strategies

### Time Management

- **180 minutes ÷ 75 questions = ~2.4 minutes per question.** That feels generous until you hit the 300-word scenario questions.
- **First pass (0 – 120 min):** Answer every question you can within ~90 seconds. If you need longer, flag it and move on.
- **Second pass (120 – 160 min):** Return to flagged questions. Re-read the scenario with fresh eyes; the answer often clicks the second time.
- **Final pass (160 – 180 min):** Review any remaining flags, double-check questions where you changed your answer.
- Never leave a question unanswered — there is no penalty for guessing.

### Elimination Strategy

- Most questions have one obviously wrong answer. Eliminate it first.
- Two options often sound similar but differ by one service name or one configuration detail. Zoom in on *that* difference.
- If an option includes a service that does not exist or a parameter that is invalid, eliminate immediately.
- Watch for options that are technically correct but operationally unnecessary or overly complex — the exam rewards the *simplest* correct solution.

### Scenario-Based Question Approach

The DOP-C02 is almost entirely scenario-based. Use this framework:

1. **Identify the goal:** What outcome does the scenario want? (Reduce downtime, automate compliance, enable cross-account deployment, etc.)
2. **Identify the constraints:** Look for keywords like "minimal operational overhead," "least privilege," "cost-effective," "existing infrastructure," "no downtime."
3. **Map constraints to AWS services:** "Minimal overhead" often means managed services. "No downtime" often means blue/green or canary. "Cross-account" means IAM roles + resource policies.
4. **Evaluate options against both goal and constraints:** An option can achieve the goal but violate a constraint — that makes it wrong.

### Key Phrases to Watch For

| Phrase | Usually Points To |
|---|---|
| "minimal operational overhead" | Managed / serverless service (Fargate, Lambda, managed pipeline) |
| "least privilege" | Scoped IAM role, resource policy, SCP |
| "near-real-time" | Kinesis Data Streams, EventBridge, CloudWatch Metric Streams |
| "automated remediation" | Config Rules + SSM Automation, EventBridge → Lambda, GuardDuty → Step Functions |
| "no downtime" | Blue/green, canary, rolling with additional batch, immutable |
| "rollback automatically" | CodeDeploy auto-rollback, CloudFormation rollback triggers, Elastic Beanstalk immutable |
| "cross-account" | IAM assume-role, resource policies, Organizations delegated admin |
| "cross-region" | S3 CRR, DynamoDB Global Tables, Aurora Global Database, CodePipeline cross-region actions |
| "encrypted at rest" | KMS CMK, SSE-S3, SSE-KMS, EBS encryption |
| "centralized logging" | CloudWatch Logs cross-account subscription, S3 log archive, OpenSearch |
| "drift detection" | CloudFormation drift, AWS Config |
| "compliance" | AWS Config Rules (managed & custom), Security Hub, Audit Manager |
| "secrets" | Secrets Manager (rotation!), Parameter Store SecureString |
| "configuration changes" | AWS Config, CloudTrail, EventBridge |
| "deployment failed" | CodeDeploy rollback hooks, CloudWatch Alarms + auto-rollback |

### General Exam Tips

1. **Read the last sentence first.** The actual question is at the end; the scenario is context.
2. **"Select TWO" questions give you a pair** — both must be correct *together* to score the point.
3. **When in doubt between two services, pick the more AWS-native one.** (CodePipeline over Jenkins, CloudFormation over Terraform, etc.)
4. **Understand the distinction between similar services:** SSM Patch Manager vs. Inspector, Config Rules vs. CloudTrail, Secrets Manager vs. Parameter Store SecureString.
5. **Memorize deployment strategies and which services support which strategies.** This is the single highest-yield topic.
6. **Know EventBridge patterns cold.** Almost every domain has questions that use EventBridge as the glue.
7. **Understand Auto Scaling lifecycle hooks** — they appear in deployment, incident response, and HA domains.
8. **CloudFormation helper scripts (cfn-init, cfn-signal, cfn-hup) still appear on the exam.** Know what each one does.
9. **Multi-account questions are everywhere.** Know Organizations SCPs, cross-account IAM roles, and Control Tower guardrails.

---

## Recommended AWS Whitepapers and Documentation

### Must-Read Whitepapers

| Whitepaper | Why |
|---|---|
| [Practicing Continuous Integration and Continuous Delivery on AWS](https://docs.aws.amazon.com/whitepapers/latest/practicing-cicd/practicing-cicd.html) | Directly covers Domain 1 |
| [Infrastructure as Code](https://docs.aws.amazon.com/whitepapers/latest/introduction-devops-aws/infrastructure-as-code.html) | Domain 2 core concepts |
| [AWS Well-Architected Framework – Operational Excellence Pillar](https://docs.aws.amazon.com/wellarchitected/latest/operational-excellence-pillar/welcome.html) | Domains 3, 5, 6 |
| [AWS Well-Architected Framework – Reliability Pillar](https://docs.aws.amazon.com/wellarchitected/latest/reliability-pillar/welcome.html) | Domain 6 |
| [AWS Well-Architected Framework – Security Pillar](https://docs.aws.amazon.com/wellarchitected/latest/security-pillar/welcome.html) | Domain 4 |
| [Organizing Your AWS Environment Using Multiple Accounts](https://docs.aws.amazon.com/whitepapers/latest/organizing-your-aws-environment/organizing-your-aws-environment.html) | Cross-domain, multi-account |
| [AWS Security Best Practices](https://docs.aws.amazon.com/prescriptive-guidance/latest/security-best-practices/welcome.html) | Domain 4 |
| [Disaster Recovery of Workloads on AWS](https://docs.aws.amazon.com/whitepapers/latest/disaster-recovery-workloads-on-aws/disaster-recovery-workloads-on-aws.html) | Domain 6 |

### Essential Service Documentation

- **CodePipeline:** [User Guide](https://docs.aws.amazon.com/codepipeline/latest/userguide/welcome.html), [Pipeline Structure Reference](https://docs.aws.amazon.com/codepipeline/latest/userguide/reference-pipeline-structure.html)
- **CodeBuild:** [Build Spec Reference](https://docs.aws.amazon.com/codebuild/latest/userguide/build-spec-ref.html)
- **CodeDeploy:** [AppSpec File Reference](https://docs.aws.amazon.com/codedeploy/latest/userguide/reference-appspec-file.html), [Deployment Configurations](https://docs.aws.amazon.com/codedeploy/latest/userguide/deployment-configurations.html)
- **CloudFormation:** [Template Reference](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/template-reference.html), [Intrinsic Functions](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/intrinsic-function-reference.html), [cfn-init](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/cfn-init.html)
- **Systems Manager:** [Automation](https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-automation.html), [Patch Manager](https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-patch.html), [Parameter Store](https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-parameter-store.html)
- **AWS Config:** [Managed Rules](https://docs.aws.amazon.com/config/latest/developerguide/managed-rules-by-aws-config.html), [Custom Rules](https://docs.aws.amazon.com/config/latest/developerguide/evaluate-config_develop-rules.html), [Remediation](https://docs.aws.amazon.com/config/latest/developerguide/remediation.html)
- **CloudWatch:** [Metrics](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/working_with_metrics.html), [Alarms](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/AlarmThatSendsEmail.html), [Logs Insights](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/AnalyzingLogData.html), [Synthetics](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch_Synthetics_Canaries.html)
- **EventBridge:** [Rules](https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-rules.html), [Event Patterns](https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-event-patterns.html)
- **Route 53:** [Routing Policies](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/routing-policy.html), [Health Checks](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/dns-failover.html)
- **Elastic Beanstalk:** [Deployment Policies](https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/using-features.rolling-version-deploy.html), [.ebextensions](https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/ebextensions.html)

### Recommended re:Invent Sessions

- "CI/CD on AWS" (search for the latest year's session)
- "Deep Dive on AWS CodeDeploy"
- "Infrastructure as Code on AWS"
- "Advanced Monitoring with Amazon CloudWatch"
- "Multi-Account Strategies on AWS"
- "Disaster Recovery on AWS"
- "Security Automation on AWS"

---

## How to Use This Guide

1. **Start with the [Study Plan](./00-Study-Plan/study-plan.md)** to structure your 8-week preparation.
2. **Read each domain article** in the order prescribed by the study plan.
3. **Complete the hands-on labs** described in each week — hands-on experience is critical for this exam.
4. **Answer the practice questions** for each domain *without* looking at explanations first, then review every explanation (even for questions you got right).
5. **Review the code examples** to ensure you can read and understand buildspec, appspec, CloudFormation, and pipeline definitions.
6. **Take at least 2 full-length practice exams** in the final two weeks.
7. **Re-read the whitepapers** listed above in the final week, focusing on any weak domains.

Good luck!

# Service Deep Dive — App Engine

## Standard vs Flexible
| Aspect | Standard | Flexible |
| --- | --- | --- |
| Runtime | Sandbox (Python, Java, Go, Node, Ruby, PHP, .NET) | Docker container |
| Scale-to-zero | Yes (automatic) | No (min 1) |
| Cold start | Sub-second (some runtimes) | 30+ s (VM boot) |
| Network | Serverless VPC Connector | Runs in your VPC |
| SSH | Not possible | Yes |
| Pricing | Instance hours | vCPU + RAM hours |

## Features
- Versions + traffic splitting (random / cookie / IP).
- Services (microservices within same app).
- Cron (Cloud Scheduler replacement for App Engine).
- Task Queues (now Cloud Tasks).
- Custom domains + managed SSL.
- Datastore / Firestore integration.

## When to use
- Existing App Engine apps; rapid prototype; multi-version traffic split.
- New apps: prefer Cloud Run.

## Limits
- 1 GB per request.
- 24h max background request (Flex) / 60 min (Standard).
- One App Engine app per project (single region).

## Exam cues
- Traffic splitting by attribute.
- Flex gives full Linux; Standard gives scale-to-zero.
- Consider **modernization to Cloud Run** for new workloads.

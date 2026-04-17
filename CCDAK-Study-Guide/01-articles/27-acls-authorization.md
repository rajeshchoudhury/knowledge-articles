# Article 27: ACLs and Authorization

## Authorization Basics

Kafka's authorization model: **principals** are granted **permissions** (Allow / Deny) to perform **operations** on **resources**.

Authorization is enforced by an `Authorizer` plugin:

- `kafka.security.authorizer.AclAuthorizer` (default in 2.4+, was `SimpleAclAuthorizer` before).
- Confluent Enterprise: `io.confluent.kafka.security.authorizer.ConfluentServerAuthorizer` — adds RBAC.

Enable:
```
authorizer.class.name=kafka.security.authorizer.AclAuthorizer
super.users=User:admin;User:kafka
```

Super users bypass all ACL checks.

## Resources

| Resource | Examples |
|----------|----------|
| **Topic** | Specific topic, or `*` for all |
| **Group** | Consumer group |
| **Cluster** | Cluster-wide operations |
| **TransactionalId** | For transactional producers |
| **DelegationToken** | Token-based auth |
| **User** (Confluent RBAC) | SCRAM user management |

Resource patterns:

- `LITERAL` — exact match (e.g., topic `orders`).
- `PREFIXED` — matches any resource with that prefix (e.g., prefix `orders-` matches `orders-dev`, `orders-prod`).
- `MATCH` (literal + prefix + wildcard `*`).

## Operations

| Operation | Resource Types | What It Does |
|-----------|---------------|--------------|
| `READ` | Topic | Fetch records |
| `WRITE` | Topic | Produce records |
| `CREATE` | Cluster, Topic | Create topics |
| `DELETE` | Topic | Delete topics |
| `ALTER` | Topic, Cluster | Change configs, reassign |
| `DESCRIBE` | Topic, Group, Cluster, TransactionalId | Read metadata |
| `DESCRIBE_CONFIGS` | Topic, Cluster | Read configs |
| `ALTER_CONFIGS` | Topic, Cluster | Write configs |
| `CLUSTER_ACTION` | Cluster | Internal broker ops (inter-broker) |
| `IDEMPOTENT_WRITE` | Cluster | Use of idempotent producer (pre-2.8) — now implicit |
| `ALL` | Any | Umbrella |

## Minimum ACLs for Common Clients

### Producer to topic `orders`

```bash
kafka-acls --bootstrap-server localhost:9092 \
  --add --allow-principal User:alice \
  --operation WRITE --operation DESCRIBE \
  --topic orders
```

Plus, for idempotent/transactional producers:

```bash
kafka-acls --add --allow-principal User:alice \
  --operation WRITE --operation DESCRIBE \
  --cluster  # for IDEMPOTENT_WRITE/DESCRIBE
  
kafka-acls --add --allow-principal User:alice \
  --operation WRITE --operation DESCRIBE \
  --transactional-id orders-tx-1
```

### Consumer of `orders` in group `billing`

```bash
kafka-acls --add --allow-principal User:alice \
  --operation READ --operation DESCRIBE \
  --topic orders

kafka-acls --add --allow-principal User:alice \
  --operation READ \
  --group billing
```

### Kafka Streams app `payment-proc`

Needs:
- Input topic: READ, DESCRIBE
- Output topic: WRITE, DESCRIBE
- Internal topics (changelog, repartition): ALL (prefix-based)
- Consumer group `payment-proc`: READ, DESCRIBE
- Cluster: for idempotent writes (`IDEMPOTENT_WRITE` — pre-2.8; implicit after)

Prefixed ACL example:
```bash
kafka-acls --add --allow-principal User:alice \
  --operation ALL \
  --topic payment-proc --resource-pattern-type PREFIXED
```

## Allow vs Deny

ACLs can be Allow or Deny. **Deny takes precedence** over Allow.

Common pattern: allow broad access, deny specific sensitive resources.

## Default Behavior

If no ACLs exist for a resource:

- `allow.everyone.if.no.acl.found=false` (default, recommended) → access denied.
- `allow.everyone.if.no.acl.found=true` → allowed (insecure, convenience).

**Exam alert:** knowing this default (false) is commonly tested.

## Listing ACLs

```bash
kafka-acls --bootstrap-server localhost:9092 --list
kafka-acls --bootstrap-server localhost:9092 --list --topic orders
kafka-acls --bootstrap-server localhost:9092 --list --principal User:alice
```

## Removing ACLs

```bash
kafka-acls --bootstrap-server localhost:9092 \
  --remove --allow-principal User:alice \
  --operation WRITE --topic orders
```

## ACLs and Inter-Broker Authorization

Brokers authenticate to each other using `security.inter.broker.protocol`. Their principal must have `CLUSTER_ACTION` privileges on the `Cluster` resource.

When you add security to an existing cluster:
1. Define super users who are the brokers themselves.
2. Or explicitly grant `CLUSTER_ACTION` to the inter-broker principal.

Missing this causes brokers to refuse each other's requests on startup.

## RBAC (Confluent Platform)

Beyond ACLs, Confluent Platform offers **Role-Based Access Control** via Metadata Service (MDS):

- Predefined roles: `SystemAdmin`, `UserAdmin`, `DeveloperRead`, `DeveloperWrite`, `DeveloperManage`, `ResourceOwner`.
- Role bindings scope roles to specific resources (topic, connector, subject, etc.).
- Integrates with LDAP for group-based grants.

RBAC is configured via `confluent iam rbac role-binding create`:

```bash
confluent iam rbac role-binding create \
  --principal User:alice \
  --role DeveloperRead \
  --resource Topic:orders \
  --kafka-cluster-id abc123
```

**Exam relevance**: RBAC is Confluent-specific (not Apache Kafka). Know that it exists and that it layers on top of ACLs.

## Audit Logs (Confluent)

Confluent Enterprise can log every authorization decision to an audit topic. Not covered in open-source Kafka.

## Delegation Tokens

Delegation tokens allow short-lived impersonation. Useful for:
- Kafka Streams where each instance needs credentials without long-lived keytab.
- Kafka Connect tasks.

Created via:
```bash
kafka-delegation-tokens --bootstrap-server localhost:9092 \
  --create --max-life-time-period -1 --command-config admin.properties --renewer-principal User:admin
```

Client uses token as SASL/SCRAM credentials.

## Schema Registry Authorization

Schema Registry itself supports auth (Basic, mTLS) but subject-level authorization is only in Confluent Enterprise (via RBAC or Schema Registry's security plugins). In OSS, you rely on broker ACLs on the `_schemas` topic.

## Exam Pointers

- `allow.everyone.if.no.acl.found=false` by default — no ACL = no access.
- Super users bypass ACLs.
- `DESCRIBE` is often required in addition to READ/WRITE (for metadata lookups).
- Consumer groups require a **group** ACL (READ for the group resource) in addition to the topic ACL.
- Transactional producers need a `transactional-id` ACL.
- Prefixed ACLs simplify Streams/Connect permissioning.
- RBAC and audit logs are Confluent Platform features, not core Apache Kafka.
- `Deny` overrides `Allow`.

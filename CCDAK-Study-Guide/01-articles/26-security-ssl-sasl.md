# Article 26: Security — SSL/TLS and SASL

## The Three Pillars

Kafka security has three orthogonal concerns:

1. **Encryption** (in transit, via TLS).
2. **Authentication** (who is the client?) — via SSL mutual auth or SASL.
3. **Authorization** (what can they do?) — via ACLs or RBAC.

This article covers #1 and #2.

## Listeners and Security Protocols

A Kafka broker listens on one or more **listeners**, each with a name and a security protocol:

```
listeners=PLAINTEXT://:9092,SSL://:9093,SASL_SSL://:9094
advertised.listeners=PLAINTEXT://broker1:9092,SSL://broker1:9093,SASL_SSL://broker1:9094
listener.security.protocol.map=PLAINTEXT:PLAINTEXT,SSL:SSL,SASL_SSL:SASL_SSL
inter.broker.listener.name=SSL
```

Four built-in security protocols:

| Protocol | Encrypted | Authenticated |
|----------|:---------:|:-------------:|
| PLAINTEXT | ❌ | ❌ |
| SSL | ✅ | Optional (mutual TLS) |
| SASL_PLAINTEXT | ❌ | ✅ (SASL) |
| SASL_SSL | ✅ | ✅ (SASL) |

## SSL/TLS

Kafka uses JVM SSL via Java keystore (`.jks`) files.

### Broker-side configs

```
listeners=SSL://:9093
ssl.keystore.location=/etc/kafka/broker.keystore.jks
ssl.keystore.password=changeme
ssl.key.password=changeme
ssl.truststore.location=/etc/kafka/kafka.truststore.jks
ssl.truststore.password=changeme
ssl.client.auth=required          # (none/requested/required) — mutual auth
ssl.enabled.protocols=TLSv1.2,TLSv1.3
ssl.keystore.type=JKS
ssl.endpoint.identification.algorithm=https   # hostname verification
```

### Client-side configs

```
security.protocol=SSL
ssl.truststore.location=/etc/kafka/client.truststore.jks
ssl.truststore.password=changeme

# Only if mutual auth is enabled
ssl.keystore.location=/etc/kafka/client.keystore.jks
ssl.keystore.password=changeme
ssl.key.password=changeme
```

### Mutual TLS (mTLS)

When `ssl.client.auth=required`, the client must present a certificate signed by a CA in the broker's truststore. The broker extracts the certificate's DN as the **principal**:

```
CN=alice,OU=platform,O=acme,L=SF,ST=CA,C=US
```

By default, the full DN is the principal. Simplify via `ssl.principal.mapping.rules`:

```
ssl.principal.mapping.rules=RULE:^.*[Cc][Nn]=([^,]+),.*$/$1/L
                            DEFAULT
```

This extracts CN only and lowercases it.

## SASL Mechanisms

SASL is a framework that plugs in authentication mechanisms:

| Mechanism | Purpose |
|-----------|---------|
| `PLAIN` | Username/password — not secure unless over TLS |
| `SCRAM-SHA-256` / `SCRAM-SHA-512` | Salted challenge-response; passwords hashed in ZK/KRaft |
| `GSSAPI` | Kerberos (enterprise AD integration) |
| `OAUTHBEARER` | OAuth 2.0 bearer tokens |

Broker enables via:

```
listeners=SASL_SSL://:9094
sasl.enabled.mechanisms=PLAIN,SCRAM-SHA-512
sasl.mechanism.inter.broker.protocol=PLAIN
```

### SASL/PLAIN

Broker:
```
listener.name.sasl_ssl.plain.sasl.jaas.config=org.apache.kafka.common.security.plain.PlainLoginModule required \
    username="admin" password="admin-secret" \
    user_admin="admin-secret" \
    user_alice="alice-secret";
```

Client:
```
security.protocol=SASL_SSL
sasl.mechanism=PLAIN
sasl.jaas.config=org.apache.kafka.common.security.plain.PlainLoginModule required \
    username="alice" password="alice-secret";
```

**Always pair with SSL** — PLAIN sends the password in the clear otherwise.

### SASL/SCRAM

Credentials stored in ZooKeeper (or KRaft) as salted hashes. Created via:

```bash
kafka-configs --bootstrap-server localhost:9092 \
  --entity-type users --entity-name alice \
  --alter --add-config 'SCRAM-SHA-512=[password=alice-secret]'
```

Client:
```
security.protocol=SASL_SSL
sasl.mechanism=SCRAM-SHA-512
sasl.jaas.config=org.apache.kafka.common.security.scram.ScramLoginModule required \
    username="alice" password="alice-secret";
```

Preferred over PLAIN because:
- Passwords are never transmitted, only hashes.
- Can be rotated without restarts.

### SASL/GSSAPI (Kerberos)

Uses a keytab file to authenticate with a KDC.

Client:
```
security.protocol=SASL_SSL
sasl.mechanism=GSSAPI
sasl.kerberos.service.name=kafka
sasl.jaas.config=com.sun.security.auth.module.Krb5LoginModule required \
    useKeyTab=true \
    storeKey=true \
    keyTab="/etc/security/keytabs/alice.keytab" \
    principal="alice@EXAMPLE.COM";
```

### SASL/OAUTHBEARER

Uses OAuth 2.0 bearer tokens.

Client:
```
security.protocol=SASL_SSL
sasl.mechanism=OAUTHBEARER
sasl.login.callback.handler.class=org.example.OAuthCallbackHandler
sasl.jaas.config=org.apache.kafka.common.security.oauthbearer.OAuthBearerLoginModule required;
```

Used for integration with external OAuth providers (Keycloak, Okta, AWS IAM via STS token).

## Principal Extraction

After authentication, the broker maps the authenticated identity to a **KafkaPrincipal**. This principal is used for authorization.

| Auth | Principal Format |
|------|------------------|
| PLAINTEXT | `User:ANONYMOUS` (no real auth) |
| SSL (mTLS) | `User:CN=alice,OU=...` or mapped via rules |
| SASL/PLAIN | `User:alice` (username) |
| SASL/SCRAM | `User:alice` |
| SASL/GSSAPI | `User:alice@REALM` or mapped |

## ZooKeeper Security

Don't forget ZK! In non-KRaft clusters, ZK holds metadata, including SCRAM credentials. Secure ZK via `zookeeper.set.acl=true` and authenticate via Kerberos (SASL) or Digest.

In KRaft, ZK is gone; the KRaft controllers themselves need to be secured as regular brokers.

## Schema Registry Security

Schema Registry has its own HTTP security:

- TLS: `ssl.keystore.*`, `ssl.truststore.*` on client and server.
- Authentication: Basic Auth (`basic.auth.credentials.source`), mTLS, SASL via Confluent JAAS.
- ACLs: Schema Registry supports RBAC in Confluent Enterprise (Confluent Cloud). Open-source depends on broker-level ACLs on `_schemas`.

Client configs:
```
schema.registry.url=https://sr:8081
schema.registry.ssl.truststore.location=...
basic.auth.credentials.source=USER_INFO
basic.auth.user.info=user:password
```

## Confluent REST Proxy Security

Similar options — the proxy authenticates the HTTP client and forwards to Kafka with its own principal (impersonation).

## Configuration Recipes

### Full SASL_SSL with SCRAM

```properties
# Broker
listeners=SASL_SSL://:9093
advertised.listeners=SASL_SSL://broker1:9093
security.inter.broker.protocol=SASL_SSL
sasl.mechanism.inter.broker.protocol=SCRAM-SHA-512
sasl.enabled.mechanisms=SCRAM-SHA-512
ssl.keystore.location=/etc/kafka/broker.keystore.jks
ssl.keystore.password=changeme
ssl.truststore.location=/etc/kafka/broker.truststore.jks
ssl.truststore.password=changeme
ssl.client.auth=none           # SCRAM handles auth; SSL just for encryption
listener.name.sasl_ssl.scram-sha-512.sasl.jaas.config=org.apache.kafka.common.security.scram.ScramLoginModule required \
    username="admin" password="admin-secret";
```

Client:
```properties
security.protocol=SASL_SSL
sasl.mechanism=SCRAM-SHA-512
ssl.truststore.location=/etc/kafka/client.truststore.jks
ssl.truststore.password=changeme
sasl.jaas.config=org.apache.kafka.common.security.scram.ScramLoginModule required \
    username="alice" password="alice-secret";
```

## Exam Pointers

- 4 protocols: PLAINTEXT, SSL, SASL_PLAINTEXT, SASL_SSL.
- SASL mechanisms: **PLAIN, SCRAM-SHA-256/512, GSSAPI, OAUTHBEARER**.
- `ssl.client.auth`: `none`, `requested`, `required` — required = mTLS.
- The broker's principal after mTLS is the certificate's DN (configurable with mapping rules).
- SCRAM credentials live in ZK/KRaft; created via `kafka-configs --alter --add-config 'SCRAM-SHA-512=[password=...]'`.
- Inter-broker traffic uses the listener named in `inter.broker.listener.name`.
- Always pair PLAIN with SSL; never use PLAIN over PLAINTEXT.
- `ssl.endpoint.identification.algorithm=https` enables hostname verification (important!).

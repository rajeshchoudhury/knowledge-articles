# 6.4 Incident Response and On-Call

Proven patterns for handling incidents on Google Cloud.

---

## 1. Pre-incident foundations

- **On-call rotation** tooling (PagerDuty, Opsgenie, Splunk On-Call).
- **Runbooks** published in Git, referenced in alert descriptions.
- **Break-glass accounts** with separate credentials, MFA, audited; kept out of normal IAM binding.
- **Access Approval** for sensitive support flows.
- **Status page** (public) + internal comms channel.
- **Dashboards** pre-built: service golden signals, dependencies, infra.
- **Chatops** bots for common tasks (rollback, scale, isolate).

---

## 2. Incident severity

| Sev | Impact | Response |
| --- | --- | --- |
| SEV1 | Full outage or data loss | All hands; exec notification |
| SEV2 | Major degradation; many users | Primary + secondary on-call |
| SEV3 | Minor degradation | Single engineer |
| SEV4 | Cosmetic or internal | Ticket, no page |

---

## 3. Incident process

1. **Detect** — alert, user report, monitoring.
2. **Declare** — open incident in tool; assign IC.
3. **Triage** — identify scope, collect data (logs, metrics, traces).
4. **Mitigate** — rollback, failover, isolate, scale, throttle.
5. **Resolve** — restore full service.
6. **Review** — blameless postmortem; action items.

Roles:

- **Incident Commander** — orchestrates.
- **Ops lead** — executes fixes.
- **Comms lead** — updates stakeholders.
- **Scribe** — timeline capture.

---

## 4. Containment patterns

- **IAM**: remove offending binding, disable SA, deny policy.
- **Network**: add firewall deny rule, remove LB backend, isolate VM in quarantine tag.
- **Compute**: stop VM (snapshot first), scale down compromised MIG, drain GKE node.
- **Storage**: make bucket private, rotate key, restore from retention snapshot.
- **Secrets**: rotate Secret Manager version; restart workloads.
- **Tokens**: revoke OAuth tokens; force re-auth.

---

## 5. Forensics

- Snapshot disks + memory dump (if confidential VM, reboot will lose memory).
- Preserve logs (export to isolated bucket).
- Use **Chronicle** for retrospective hunt.
- Maintain **chain of custody** documentation.

---

## 6. Playbooks (examples)

### Credential leak
1. Rotate affected key / secret.
2. Revoke OAuth tokens.
3. Disable SA / user.
4. Scan Git history; remediate repo.
5. Rotate downstream credentials that may have been exposed.
6. Postmortem: prevent via pre-commit scans, secret manager.

### Public GCS bucket
1. Set `publicAccessPrevention = enforced` on bucket.
2. Remove `allUsers` / `allAuthenticatedUsers` roles.
3. Check access logs for exfiltration.
4. Rotate sensitive data.
5. Enable org policy `storage.publicAccessPrevention`.

### Suspected compromised VM
1. Snapshot boot + data disks.
2. Stop VM.
3. Isolate via firewall + VPC move.
4. Analyze snapshot in sandbox.
5. Rebuild from golden image; rotate secrets.

### Database outage
1. Check Cloud SQL / Spanner status dashboard.
2. If HA: primary failed over; verify read/write.
3. Increase DB tier / nodes if saturated.
4. Shift traffic to DR region if regional failure.
5. Postmortem: capacity, quotas, queries.

---

## 7. Postmortem template

```
Title: [Service] [Date] Outage
Author: ...
Status: Draft/Final

Summary:
  1-paragraph summary.

Impact:
  - Users affected: ...
  - Revenue/SLA: ...
  - Duration: ...

Root cause:
  - Proximal cause: ...
  - Underlying cause: ...

Timeline (UTC):
  HH:MM - Alert fired
  HH:MM - IC declared
  ...

Actions taken:
  - Rollback
  - Scaling up

Detection:
  - Monitoring alert (fast/slow burn)

Action items:
  1. [P0] Add canary verification
  2. [P1] Improve runbook
  3. [P2] Auto-rollback

Lessons learned:
  What went well / what didn't / where we got lucky.
```

---

## 8. Support tiers from Google

- **Basic** (free) — billing + account.
- **Standard** — general tech support.
- **Enhanced** — 1h P1, 24/7.
- **Premium** — 15min P1, 24/7, TAM, architecture reviews.

Recommend **Enhanced** for prod; **Premium** for regulated / mission-critical.

---

## 9. Drills

- **Failover drills** quarterly: promote replica, shift LB, verify.
- **Disaster simulation**: entire region offline.
- **Security red team**: simulate breach; test detection & response.
- Document results; fix gaps.

---

## 10. Incident response exam patterns

| Scenario | Answer |
| --- | --- |
| "Public bucket discovered" | Disable public access + public access prevention |
| "SA key leaked on GitHub" | Rotate/disable SA, revoke tokens, audit use |
| "Massive DDoS" | Cloud Armor + Managed Protection Plus |
| "Unresponsive Cloud SQL primary" | HA failover automatically; verify; alert on RPO/RTO |
| "Need tamper-proof audit after incident" | GCS retention lock bucket with sink |
| "Detect anomalous API calls" | Event Threat Detection (SCC Premium) |

Next: `05-dr-and-ha.md`.

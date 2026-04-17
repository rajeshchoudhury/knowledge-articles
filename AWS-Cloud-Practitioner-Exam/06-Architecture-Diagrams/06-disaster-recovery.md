# Disaster Recovery Strategies

```
              Cost ─────────────────────────────────────────────────▶
 RTO/RPO ◀────────────────────────────────────────────────

   Backup & Restore    Pilot Light       Warm Standby      Multi-site Active-Active
   [hours]             [10s of min]      [minutes]         [seconds / zero]

   ┌────────────┐      ┌────────────┐     ┌──────────────┐  ┌─────────────────┐
   │ Snapshots +│      │ Always-on  │     │ Scaled-down  │  │ Full stack in   │
   │ AMIs in    │      │ core + DB  │     │ full stack   │  │ each Region;    │
   │ another    │      │ replicated │     │ in DR Region │  │ Route 53 / GA   │
   │ Region     │      │ in DR      │     │ ready to     │  │ / Aurora Global │
   │ Rebuild    │      │ Region;    │     │ scale out    │  │ DB or DDB GT    │
   │ on demand  │      │ front-end  │     │ on failover  │  │ for data        │
   │            │      │ off        │     │              │  │                 │
   └────────────┘      └────────────┘     └──────────────┘  └─────────────────┘
```

Mapping by tech:
| Strategy | Data replication | Compute | Traffic routing |
|---|---|---|---|
| Backup & Restore | AWS Backup / snapshots cross-Region | Off | Manual or script |
| Pilot Light | RDS read replica / Aurora Global DB (1-min RPO), DynamoDB Global Tables | Minimal | Route 53 health-check failover |
| Warm Standby | Same as Pilot Light but fully running at low capacity | Scaled-down but serving | Route 53 weighted/failover |
| Multi-site | Aurora Global DB or DDB Global Tables | Fully active | Route 53 latency / Global Accelerator |

Exam rule: **The faster the RTO/RPO, the more $ you spend.**

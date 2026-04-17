# Lab 8 — Billing & Cost Guardrails

## 1. Activate Cost Explorer

Console → Billing → Cost Management → **Cost Explorer** → Launch.
It takes ~24 h for data to appear.

## 2. Create a $10 monthly budget

```bash
cat > budget.json <<'JSON'
{
  "BudgetName": "ccp-monthly",
  "BudgetLimit": { "Amount": "10", "Unit": "USD" },
  "TimeUnit": "MONTHLY",
  "BudgetType": "COST",
  "CostTypes": {
    "IncludeCredit": false,
    "IncludeDiscount": true,
    "IncludeOtherSubscription": true,
    "IncludeRecurring": true,
    "IncludeRefund": false,
    "IncludeSubscription": true,
    "IncludeSupport": true,
    "IncludeTax": true,
    "IncludeUpfront": true,
    "UseAmortized": false,
    "UseBlended": false
  }
}
JSON

cat > notify.json <<'JSON'
[
  {
    "Notification": {
      "NotificationType": "FORECASTED",
      "ComparisonOperator": "GREATER_THAN",
      "Threshold": 80,
      "ThresholdType": "PERCENTAGE",
      "NotificationState": "ALARM"
    },
    "Subscribers": [
      { "SubscriptionType": "EMAIL", "Address": "you@example.com" }
    ]
  }
]
JSON

aws budgets create-budget \
  --account-id $(aws sts get-caller-identity --query Account --output text) \
  --budget file://budget.json \
  --notifications-with-subscribers file://notify.json
```

## 3. Enable Cost Anomaly Detection

In Console → Billing → Cost Management → **Cost Anomaly Detection** →
Create a **monitor** (Services type) with daily alerts. Free.

## 4. Configure a CUR (Cost and Usage Report)

Console → Billing → **Data Exports** → Create export → Standard data
export → daily, CSV or Parquet → choose an S3 bucket. Wait ~24 h.

## 5. Organization SCP guardrails (if you have Organizations)

Deny SSH/RDP from anywhere (sample):

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DenyPublicSSHRDP",
      "Effect": "Deny",
      "Action": [
        "ec2:AuthorizeSecurityGroupIngress"
      ],
      "Resource": "*",
      "Condition": {
        "StringEquals": { "ec2:SourceInstanceIPv4": "0.0.0.0/0" }
      }
    }
  ]
}
```

Apply to a Sandbox OU to block new SGs with `0.0.0.0/0 22` etc.
(Simpler practical SCPs: deny regions outside approved list, deny
disabling CloudTrail, deny leaving Organizations.)

## 6. Clean-up

Delete the Budget and CUR if unwanted. Free Tier covers everything above
if you stay under thresholds.

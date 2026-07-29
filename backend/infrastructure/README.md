# `backend/infrastructure/` — CDK for the CRUD plane

Infrastructure as code for the deterministic path: API Gateway, Lambdas, tables, buckets, auth,
eventing, monitoring.

> The **agent plane is a separate CDK app** under `../runtime/agentcore/`. Two planes, two apps,
> deployed independently — so a prompt change never risks the CRUD stack and vice versa.

## Layout

```
infrastructure/
├── bin/infrastructure.ts     # the authoritative stack list
└── lib/
    ├── api-stack.ts          # API Gateway + CRUD lambdas
    ├── auth-stack.ts         # Cognito user pool + identity pool
    └── data-stack.ts         # tables + KMS
```

## Rules

- **Keep account-bound identifiers in CDK context, never as scattered literals.** Runtime ARNs,
  table names, KMS keys, distribution IDs. A fresh-account migration must re-point them in lockstep,
  and hunting literals across 20 files is how that goes wrong.
- **Add a synth guard** that refuses to synthesize against the wrong account, rather than trusting a
  profile name. Verify the account id (`aws sts get-caller-identity`), because profile names lie.
- **Watch the 500-resource-per-stack CloudFormation ceiling.** Add a synth-time budget check well
  below it; hitting the limit mid-deploy is an outage-shaped problem.
- Validate before deploying: `npx cdk synth`, and `cdk diff --method=template` to see real churn.

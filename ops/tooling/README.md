# Ops Tooling

Operational helper scripts live here so they are versioned alongside the platform, but outside the runtime services.

## Seed Demo Data

```bash
node ops/tooling/seed-demo-data.mjs
```

Environment variables:

- `SEED_GATEWAY_URL` (default `http://localhost:4000`)
- `SEED_HRMS_URL` (default `SEED_GATEWAY_URL`)

Each helper handles its own connectivity errors so the script can keep running even if one service is offline.


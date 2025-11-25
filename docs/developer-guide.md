---
title: Developer Guide
---

# Developer Guide

## 1. Repository Map

| Path | Purpose |
| --- | --- |
| `backend/services/*` | NestJS microservices (FBMS, HRMS, SCM, Inventory, CRM, Support, Compliance, Analytics, EMS, Billing, etc.). |
| `backend/libs/service-core/` | Shared Nest bootstrap: validation, auth guard, health endpoints, graceful shutdown helpers. **All services must import this module.** |
| `frontend/*` | Next.js micro-frontends, one per business domain. |
| `frontend/marketing/` | Marketing site + shared login/launcher for `www.keephy.com`. |
| `frontend/packages/ui-core` | Shared shadcn/Tailwind design system for theming, layout, reusable components, auth helpers. |
| `ops/tooling/` | Operational scripts (e.g. `seed-demo-data.mjs`). Run with `node ops/tooling/<script>.mjs`. |
| `backend/api-postgres/` | Legacy monolith (only touched when retiring remaining modules). No new features here. |

## 2. Backend Feature Lifecycle

1. **Plan**: Decide which service owns the feature. If a new domain, create a new service under `backend/services`.
2. **Scaffold Module**:
   - `src/modules/<feature>/<feature>.module.ts`
   - `dto/` folder with `Create`/`Update` DTOs (`class-validator` based).
   - `entities/` folder with TypeORM entities.
   - `controller` + `service` pair using dependency injection.
3. **Wire Module**: Register the module in the service’s `AppModule`.
4. **Security & Validation**:
   - Controllers rely on `TenantGuard` (headers injected by API Gateway).
   - Validation pipes already configured globally through `bootstrapService`.
5. **Testing**:
   - Add Jest specs (`*.spec.ts`) that validate service logic + guard behavior.
   - Run `npm test`.
6. **Document API** (optional swagger). Provide README updates if environment variables change.

## 3. Service Bootstrap Standards

Every service **must**:

- Use `bootstrapService(AppModule, { serviceName: '<name>' })` in `main.ts`.
- Import `ServiceCoreModule` in `AppModule`.
- Enable TypeORM migrations with:
  ```ts
  TypeOrmModule.forRootAsync({
    useFactory: (config: ConfigService) => ({
      type: 'postgres',
      url: config.get<string>('database.url'),
      autoLoadEntities: true,
      synchronize: false,
      migrationsRun: true,
      migrations: [join(__dirname, 'migrations/*.{ts,js}')],
    }),
  });
  ```
- Provide `/health/live` and `/health/ready` (inherited from service-core).
- Seed demo data via a bootstrapper implementing `OnModuleInit` (never define schema SQL there; migrations own schema).
- Enforce auth/tenancy via `TenantGuard`.

## 4. Database Changes

1. **Create migration** (inside `src/migrations/`):
   ```bash
   npx typeorm migration:create -n <Name> -d src/migrations
   ```
2. Implement `up`/`down`.
3. Run locally:
   ```bash
   DATABASE_URL=postgres://... npm run typeorm migration:run
   ```
4. Bootstrappers only seed data (no DDL).

## 5. Operational Scripts

- All scripts live in `ops/tooling/`.
- Add helpers using `safeRun('label', fn)` so one failure does not stop the entire run.
- Example command:
  ```bash
  node ops/tooling/seed-demo-data.mjs
  ```
- Update `ops/tooling/README.md` when new environment variables or usage instructions are introduced.

## 6. Frontend Development Flow

1. **Structure**:
   - Components under `src/components`.
   - API utilities under `src/lib/api.ts` (Axios + gateway URL).
   - Pages under `src/pages` (prefer tabbed dashboards for multi-widget screens).
2. **UI System (`@keephy/ui-core`)**:
   - Shared shadcn-based package lives in `frontend/packages/ui-core`.
   - Exported pieces: Tailwind theme tokens, `ThemeProvider`, layout primitives, buttons, cards, tables, lists, role guards.
   - Built-in `ThemeSelector` lets users switch among curated shadcn palettes (default, blue, green, orange, red, rose, violet, yellow). Keep `ThemeProvider` as the app wrapper and drop the selector wherever you want user control.
   - Apps import the CSS once via `import '@keephy/ui-core/styles.css';` (done inside `src/styles/globals.css`).
   - Tailwind setup per app (`tailwind.config.js`, `postcss.config.js`, `globals.css`). `content` must include `node_modules/@keephy/ui-core`.
   - Update `next.config.js` → `transpilePackages: ['@keephy/ui-core']`.
   - Remove Chakra from new screens; use UI-core components (AppShell, AppHeader, AppFooter, AuthLayout, tables, alerts, etc.) instead.
3. **Marketing & Auth**
   - `frontend/marketing` hosts the `www.keephy.com` experience: hero page, pricing, about, testimonials, contact, privacy/terms/cookie pages.
   - The same app exposes `/login` (shared auth) and `/modules` (launcher linking to `hrms/billing/crm/fbms` subdomains). All micro-frontends must redirect unauthenticated users there.
   - Shared header/footer/auth components live in `@keephy/ui-core` so every MF renders identical chrome.
   - Environment variables (set via `.env.local`, see `frontend/marketing/ENVIRONMENT.md`):
     ```
     NEXT_PUBLIC_GATEWAY_URL=http://localhost:3010
     NEXT_PUBLIC_ROOT_DOMAIN=keephy.localhost
     NEXT_PUBLIC_MODULE_HRMS_URL=http://localhost:3001
     NEXT_PUBLIC_MODULE_BILLING_URL=http://localhost:3002
     NEXT_PUBLIC_MODULE_CRM_URL=http://localhost:3003
     NEXT_PUBLIC_MODULE_FBMS_URL=http://localhost:3004
     ```
   - Production example:
     - `NEXT_PUBLIC_GATEWAY_URL=https://gateway.keephy.com`
     - `NEXT_PUBLIC_ROOT_DOMAIN=keephy.com`
     - `NEXT_PUBLIC_MODULE_*_URL=https://<module>.keephy.com`
4. **Data Access**:
   - Use React Query (`useQuery`, `useMutation`).
   - Never mock data; always call live gateway endpoints.
   - Set `x-tenant-id` header via Axios instance.
5. **Scripts**: `npm run dev`, `npm run build`, `npm run lint`.

## 7. API Gateway Updates

When adding a new service:

1. Add `SERVICE_URL` to `backend/docs/environment-variables.md`.
2. Append route entry in `backend/services/api-gateway/src/config/configuration.ts` and `proxy/proxy-table.ts`.
3. Propagate `.env` changes wherever services run (local/dev/prod).

## 8. Legacy Monolith Retirement

- Remove module from `backend/api-postgres/src/services/index.js`.
- Delete the service folder (e.g. `src/services/billing`).
- Ensure the API Gateway route maps to the new Nest service before removal.
- Execute opt-in data migration scripts if legacy data is required.

## 9. Health, Observability, Shutdown

- `ServiceCore` automatically exposes `/health/live` and `/health/ready`.
- Guards skip health routes; no headers required.
- `enableShutdownHooks()` is applied by `bootstrapService`, ensuring clean TypeORM disconnects.
- For deeper telemetry, add Nest interceptors/loggers inside each service (recommended future enhancement).

## 10. Testing Checklist

- **Backend**: run `npm test`. Add specs for business rules, guards, and DTO validation.
- **Frontend**: run `npm run lint` and manual verification via `npm run dev`. Add Cypress/Playwright if needed.
- **Integration**: run `node ops/tooling/seed-demo-data.mjs` with all services running to verify end‑to‑end connectivity.

## 11. Deployment Ritual

1. Stop old processes (per user requirement).
2. `npm install` inside each touched service/frontend.
3. Start services via `npm run start:dev`; frontends via `npm run dev`.
4. Seed data (`node ops/tooling/seed-demo-data.mjs`).
5. Confirm `/health/ready` and key UI paths.

Following these steps ensures consistent, secure, and observable feature delivery across the entire platform. If you introduce new domains or tooling, extend this guide accordingly.***

## 12. Domains, DNS, and Local Ports

| Environment | Marketing (www) | Login | Micro-frontend | Notes |
| --- | --- | --- | --- | --- |
| **Prod** | `www.keephy.com` | `www.keephy.com/login` (same app) | `hrms.keephy.com`, `billing.keephy.com`, `crm.keephy.com`, `fbms.keephy.com` | Issue wildcard cert for `*.keephy.com`. Marketing build deployed once; each MF deployed separately. |
| **Dev/Preview** | `https://www-dev.keephy.com` | `https://www-dev.keephy.com/login` | `https://hrms-dev.keephy.com`, etc. | Point DNS (or CloudFront/Netlify/Vercel) at the respective app deployments. |
| **Local** | `http://localhost:3100` (or map `www.keephy.localhost` to that port) | same | `http://localhost:3001` HRMS, `3002` Billing, `3003` CRM, `3004` FBMS (adjust as needed) | Add `/etc/hosts` entries: `127.0.0.1 www.keephy.localhost hrms.keephy.localhost billing.keephy.localhost crm.keephy.localhost fbms.keephy.localhost`. Use `next dev -p <port>` to avoid clashes. |

**Shared cookie/session**

- After login, the marketing app sets `keephy_session=<token>` for domain `.keephy.com` (configurable via `NEXT_PUBLIC_ROOT_DOMAIN`). Downstream micro-frontends read this cookie to perform silent auth.
- When running locally with different ports, the cookie falls back to the current host (e.g. `localhost:3100`). Each MF will still read `localStorage`/`cookie` if served under the same `*.keephy.localhost` domain (use hosts file entries). If you cannot mirror subdomains locally, pass the token via `localStorage`.

**Hosting workflow**

1. Deploy `frontend/marketing` (e.g., Vercel). Attach `www.keephy.com`.
2. Deploy each MF to its subdomain. They all import the shared shell + auth components.
3. Configure the gateway URL/environment variables per environment.
4. For ops, list all domains in the change request so CDN/SSL teams can provision certificates.


# Monolith Retirement Plan

## 1. Gateway context map

| Gateway Path | Current Target | Status | Notes |
| --- | --- | --- | --- |
| `/auth`, `/access`, `/media`, `/contacts`, `/notifications`, `/audit` | Nest services (`identity`, `access`, `media`, etc.) | ✅ | Gateway already points to the standalone Nest services. Express versions are still in the repo but can be deleted once remaining modules move. |
| `/subscriptions`, `/entitlements`, `/billing`, `/usage` | Nest (`subscriptions-service`, `billing-service`) | ✅ | Fully migrated; Express billing/payments can be removed after verification. |
| `/hrms`, `/scm`, `/inventory`, `/crm`, `/fbms`, `/support`, `/compliance`, `/analytics`, `/ems` | Nest services | ✅ | Operational and wired via the gateway. |
| `/observability` | Express (api-postgres) | **Legacy** | Observability dashboards still hit the monolith launch/production modules. |
| Everything else (e.g., `/payroll`, `/onboarding`, `/talent`, `/performance`, `/training`, `/visitor`, `/gtm`, `/launch`, `/postlaunch`, `/continuous`, `/admin`, `/ai/*`, `/mobile`, `/integration`, `/payments`) | Express (api-postgres) | **Legacy** | These routes are not explicitly listed in proxy-table and therefore fall through to the monolith’s Express server via internal routing. |

## 2. Remaining monolith domains

| Domain | Directory | Depends On |
| --- | --- | --- |
| Identity / Auth / RBAC / Tenant / Audit / Notifications / Contacts / Media | `src/modules/common/*` and `src/services/{identity,rbac,tenant,...}` | Core for every other module. |
| Admin console & tooling | `src/modules/admin`, `src/services/admin` | Requires identity + tenant. |
| SmartHR / Payroll / Onboarding / Talent / Performance / Training | `src/modules/{smarthr,payroll,onboarding,talent,performance,training}` | HR data, identity, notifications. |
| Lifecycle & GTM (GTM, launch, pilot, postlaunch, production, continuous, observability, upgrades) | `src/modules/{gtm,launch,pilot,postlaunch,production,continuous}`, `src/modules/observability`, `src/modules/upgrades` | Identity, audit, analytics. |
| AI Conversational / Pipelines | `src/modules/ai/*` | Contacts, media, analytics. |
| Facilities / Visitor / Mobile / Integration (ERP) | `src/modules/{facilities,visitor,mobile}`, `src/modules/integration/erp` | Identity, notifications, SCM/IMS data. |
| Legacy payments wrappers | `src/modules/payments`, `src/modules/billing` | Should be replaced by new billing-service. |

## 3. Migration waves

1. **Shared Core Services**
   - Build/extend Nest services for identity, access, tenant, RBAC, audit, notifications, contacts, media.
   - Update gateway `/auth`, `/access`, `/media`, `/contacts`, `/notifications`, `/audit` contexts to point to the Nest equivalents.
   - Remove Express versions and shared middleware once consumers switch.

2. **Workforce Suite**
   - Nest services for payroll (config/processing/outsourcing/validation), SmartHR, onboarding, talent, performance, training.
   - ✅ `payroll-service` now handles configuration, processing, outsourcing, and validation flows.
   - Frontend alignment: admin pages, ESS, HR workflows.
   - After cutover: delete corresponding monolith modules.

3. **Lifecycle & GTM**
   - Create `lifecycle-service` (covering GTM, launch, pilot, production, post-launch, continuous, upgrades, observability dashboards).
   - Provide metrics/milestone APIs consumed by admin frontend.

4. **Admin & Tools**
   - `admin-service` + `tools-service` for console management, ERP integrations, automation catalog.
   - Replace Express endpoints used by `/admin`, `/admin/tools`, `/integration/erp`.

5. **AI Conversational & Pipelines**
   - Either fold into existing `analytics-service`/future `ai-service` or build dedicated Nest microservices.
   - Ensure copilot UI uses these new endpoints.

6. **Facilities / Visitor / Mobile**
   - Separate Nest services for facilities & visitor (maybe combined), plus a thin API for the mobile shell.

7. **Payments Legacy Cleanup**
   - Confirm all payment flows use `billing-service`. Remove remaining Express payments routes.

Each wave concludes with:
- TypeORM migrations + seeders.
- Gateway update.
- Frontend config adjustments.
- Removal of the corresponding monolith code.

## 4. Decommission checklist

1. All gateway contexts point to Nest services (no fallbacks to Express).
2. Monolith `src/services/index.js` has no remaining `require('./...')` entries.
3. `api-postgres` removed from PM2/docker/supervisor manifests.
4. CI pipelines updated to skip monolith lint/test builds.
5. Repository cleanup: delete `backend/api-postgres` directory and Sequelize migrations/seeders; update docs.


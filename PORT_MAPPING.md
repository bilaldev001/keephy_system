# Port Mapping - Docker Compatible Configuration

All services now use the same ports as Docker configuration for consistency.

## ✅ Backend Services (Ports 3010-3072)

| Service | Port | Status |
|---------|------|--------|
| api-gateway | 3010 | ✅ Running |
| identity-service | 3012 | ✅ Running |
| access-service | 3014 | ✅ Running |
| tenant-service | 3016 | ✅ Running |
| media-service | 3018 | ✅ Running |
| fbms-service | 3020 | ✅ Running |
| contacts-service | 3022 | ✅ Running |
| notifications-service | 3024 | ✅ Running |
| audit-service | 3026 | ✅ Running |
| subscriptions-service | 3028 | ✅ Running |
| entitlements-service | 3030 | ✅ Running |
| billing-service | 3032 | ✅ Running |
| observability-service | 3034 | ✅ Running |
| hrms-service | 3036 | ✅ Running |
| scm-service | 3038 | ✅ Running |
| payroll-service | 3040 | ✅ Running |
| inventory-service | 3042 | ✅ Running |
| crm-service | 3044 | ✅ Running |
| support-service | 3046 | ✅ Running |
| compliance-service | 3048 | ✅ Running |
| analytics-service | 3050 | ✅ Running |
| ems-service | 3052 | ✅ Running |
| voucher-service | 3054 | ✅ Running |
| forms-service | 3056 | ✅ Running |
| builder-service | 3058 | ✅ Running |
| onboarding-service | 3060 | ✅ Running |
| admin-service | 3062 | ✅ Running |
| ai-service | 3064 | ✅ Running |
| lifecycle-service | 3066 | ✅ Running |
| integration-service | 3068 | ✅ Running |
| mobile-service | 3070 | ✅ Running |
| facilities-service | 3072 | ✅ Running |

## ✅ Frontend Applications (Ports 3074-3104)

| Application | Port | Status |
|-------------|------|--------|
| frontend-marketing | 3074 | ✅ Running |
| frontend-console | 3076 | ✅ Running |
| frontend-admin | 3078 | ✅ Running |
| frontend-builder | 3080 | ✅ Running |
| frontend-forms | 3082 | ✅ Running |
| frontend-hrms | 3084 | ✅ Running |
| frontend-vouchers | 3086 | ✅ Running |
| frontend-fbms | 3088 | ✅ Running |
| frontend-crm | 3090 | ✅ Running |
| frontend-billing | 3092 | ✅ Running |
| frontend-analytics | 3094 | ✅ Running |
| frontend-compliance | 3096 | ✅ Running |
| frontend-ems | 3098 | ✅ Running |
| frontend-inventory | 3100 | ✅ Running |
| frontend-scm | 3102 | ✅ Running |
| frontend-support | 3104 | ✅ Running |

## 🔄 Changes Made

### Previous Ports (PM2 Custom)
- Backend: 4001-4032 (various)
- Frontend: 4206-4218, 5200-5210

### New Ports (Docker Compatible)
- Backend: 3010-3072 (even numbers, sequential)
- Frontend: 3074-3104 (even numbers, sequential)

## 📝 Benefits

1. **Consistency**: Same ports whether using PM2 or Docker
2. **Sequential**: Easy to remember - all in 30xx range
3. **No Conflicts**: Clear separation between backend (3010-3072) and frontend (3074-3104)
4. **Docker Compatible**: Can switch between PM2 and Docker without port conflicts

## 🌐 Quick Access URLs

### Main Services
- **API Gateway**: http://localhost:3010
- **Identity Service**: http://localhost:3012
- **Access Service**: http://localhost:3014
- **Tenant Service**: http://localhost:3016

### Main Applications
- **Marketing Website**: http://localhost:3074
- **Console Dashboard**: http://localhost:3076
- **Admin Portal**: http://localhost:3078

## 🔍 Verification

To verify all services are running on correct ports:

```bash
# Check all 30xx ports
netstat -an | grep LISTEN | grep "\.30" | sort

# Check PM2 status
pm2 status

# Test specific service
curl http://localhost:3010  # API Gateway
curl http://localhost:3078  # Admin Portal
```

## 📋 Configuration Files

- Backend: `ecosystem.backend.config.js`
- Frontend: `ecosystem.frontend.config.js`
- Docker: `docker-compose.dev.yml`

All three now use identical port mappings.

---

**Last Updated**: December 4, 2025
**Status**: ✅ All services running on Docker-compatible ports


#!/bin/bash
# Update all backend and frontend ports to match Docker configuration

echo "Updating Backend ports..."

# Backend services
sed -i '' 's/PORT: 4003,/PORT: 3018,/g' ecosystem.backend.config.js  # media-service
sed -i '' 's/PORT: 4004,/PORT: 3022,/g' ecosystem.backend.config.js  # contacts-service
sed -i '' 's/PORT: 4005,/PORT: 3024,/g' ecosystem.backend.config.js  # notifications-service
sed -i '' 's/PORT: 4006,/PORT: 3026,/g' ecosystem.backend.config.js  # audit-service
sed -i '' 's/PORT: 4007,/PORT: 3058,/g' ecosystem.backend.config.js  # builder-service
sed -i '' 's/PORT: 4008,/PORT: 3056,/g' ecosystem.backend.config.js  # forms-service
sed -i '' 's/PORT: 4009,/PORT: 3042,/g' ecosystem.backend.config.js  # inventory-service
sed -i '' 's/PORT: 4010,/PORT: 3028,/g' ecosystem.backend.config.js  # subscriptions-service
sed -i '' 's/PORT: 4011,/PORT: 3030,/g' ecosystem.backend.config.js  # entitlements-service
sed -i '' 's/PORT: 4012,/PORT: 3032,/g' ecosystem.backend.config.js  # billing-service
sed -i '' 's/PORT: 4013,/PORT: 3038,/g' ecosystem.backend.config.js  # scm-service
sed -i '' 's/PORT: 4014,/PORT: 3020,/g' ecosystem.backend.config.js  # fbms-service
sed -i '' 's/PORT: 4015,/PORT: 3036,/g' ecosystem.backend.config.js  # hrms-service
sed -i '' 's/PORT: 4016,/PORT: 3040,/g' ecosystem.backend.config.js  # payroll-service
sed -i '' 's/PORT: 4017,/PORT: 3046,/g' ecosystem.backend.config.js  # support-service
sed -i '' 's/PORT: 4018,/PORT: 3044,/g' ecosystem.backend.config.js  # crm-service
sed -i '' 's/PORT: 4019,/PORT: 3054,/g' ecosystem.backend.config.js  # voucher-service
sed -i '' 's/PORT: 4020,/PORT: 3048,/g' ecosystem.backend.config.js  # compliance-service
sed -i '' 's/PORT: 4021,/PORT: 3050,/g' ecosystem.backend.config.js  # analytics-service
sed -i '' 's/PORT: 4022,/PORT: 3052,/g' ecosystem.backend.config.js  # ems-service
sed -i '' 's/PORT: 4024,/PORT: 3072,/g' ecosystem.backend.config.js  # facilities-service
sed -i '' 's/PORT: 4027,/PORT: 3060,/g' ecosystem.backend.config.js  # onboarding-service
sed -i '' 's/PORT: 4028,/PORT: 3062,/g' ecosystem.backend.config.js  # admin-service
sed -i '' 's/PORT: 4029,/PORT: 3064,/g' ecosystem.backend.config.js  # ai-service
sed -i '' 's/PORT: 4030,/PORT: 3066,/g' ecosystem.backend.config.js  # lifecycle-service
sed -i '' 's/PORT: 4031,/PORT: 3068,/g' ecosystem.backend.config.js  # integration-service
sed -i '' 's/PORT: 4032,/PORT: 3070,/g' ecosystem.backend.config.js  # mobile-service
sed -i '' 's/PORT: 4026,/PORT: 3034,/g' ecosystem.backend.config.js  # observability-service

echo "Updating Frontend ports..."

# Frontend services - update both PORT: and -p arguments
sed -i '' 's/ -p 4206/ -p 3094/g' ecosystem.frontend.config.js  # frontend-analytics
sed -i '' 's/PORT: 4206,/PORT: 3094,/g' ecosystem.frontend.config.js
sed -i '' 's/ -p 4207/ -p 3092/g' ecosystem.frontend.config.js  # frontend-billing
sed -i '' 's/PORT: 4207,/PORT: 3092,/g' ecosystem.frontend.config.js
sed -i '' 's/ -p 4208/ -p 3080/g' ecosystem.frontend.config.js  # frontend-builder
sed -i '' 's/PORT: 4208,/PORT: 3080,/g' ecosystem.frontend.config.js
sed -i '' 's/ -p 4209/ -p 3090/g' ecosystem.frontend.config.js  # frontend-crm
sed -i '' 's/PORT: 4209,/PORT: 3090,/g' ecosystem.frontend.config.js
sed -i '' 's/ -p 4210/ -p 3096/g' ecosystem.frontend.config.js  # frontend-compliance
sed -i '' 's/PORT: 4210,/PORT: 3096,/g' ecosystem.frontend.config.js
sed -i '' 's/ -p 4211/ -p 3098/g' ecosystem.frontend.config.js  # frontend-ems
sed -i '' 's/PORT: 4211,/PORT: 3098,/g' ecosystem.frontend.config.js
sed -i '' 's/ -p 4212/ -p 3082/g' ecosystem.frontend.config.js  # frontend-forms
sed -i '' 's/PORT: 4212,/PORT: 3082,/g' ecosystem.frontend.config.js
sed -i '' 's/ -p 4213/ -p 3084/g' ecosystem.frontend.config.js  # frontend-hrms
sed -i '' 's/PORT: 4213,/PORT: 3084,/g' ecosystem.frontend.config.js
sed -i '' 's/ -p 4214/ -p 3088/g' ecosystem.frontend.config.js  # frontend-fbms
sed -i '' 's/PORT: 4214,/PORT: 3088,/g' ecosystem.frontend.config.js
sed -i '' 's/ -p 4215/ -p 3100/g' ecosystem.frontend.config.js  # frontend-inventory
sed -i '' 's/PORT: 4215,/PORT: 3100,/g' ecosystem.frontend.config.js
sed -i '' 's/ -p 4216/ -p 3102/g' ecosystem.frontend.config.js  # frontend-scm
sed -i '' 's/PORT: 4216,/PORT: 3102,/g' ecosystem.frontend.config.js
sed -i '' 's/ -p 4217/ -p 3104/g' ecosystem.frontend.config.js  # frontend-support
sed -i '' 's/PORT: 4217,/PORT: 3104,/g' ecosystem.frontend.config.js
sed -i '' 's/ -p 4218/ -p 3086/g' ecosystem.frontend.config.js  # frontend-vouchers
sed -i '' 's/PORT: 4218,/PORT: 3086,/g' ecosystem.frontend.config.js
sed -i '' 's/ -p 5200/ -p 3074/g' ecosystem.frontend.config.js  # frontend-marketing
sed -i '' 's/PORT: 5200,/PORT: 3074,/g' ecosystem.frontend.config.js
sed -i '' 's/ -p 5201/ -p 3076/g' ecosystem.frontend.config.js  # frontend-console
sed -i '' 's/PORT: 5201,/PORT: 3076,/g' ecosystem.frontend.config.js
sed -i '' 's/ -p 5210/ -p 3078/g' ecosystem.frontend.config.js  # frontend-admin
sed -i '' 's/PORT: 5210,/PORT: 3078,/g' ecosystem.frontend.config.js

echo "Done! All ports updated to match Docker configuration."

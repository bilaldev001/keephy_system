#!/bin/bash

# Services that need CORS added (excluding those that use bootstrapService or already have CORS)
SERVICES=(
  "ai-service"
  "audit-service"
  "builder-service"
  "contacts-service"
  "crm-service"
  "entitlements-service"
  "fbms-service"
  "forms-service"
  "hrms-service"
  "integration-service"
  "lifecycle-service"
  "mobile-service"
  "notifications-service"
  "observability-service"
  "scm-service"
  "voucher-service"
)

CORS_CODE='
  app.enableCors({
    origin: (origin, callback) => {
      if (!origin || process.env.NODE_ENV === '"'"'development'"'"') {
        return callback(null, true);
      }
      callback(null, true);
    },
    credentials: true,
    methods: ['"'"'GET'"'"', '"'"'POST'"'"', '"'"'PUT'"'"', '"'"'PATCH'"'"', '"'"'DELETE'"'"', '"'"'OPTIONS'"'"', '"'"'HEAD'"'"'],
    allowedHeaders: [
      '"'"'Content-Type'"'"',
      '"'"'Authorization'"'"',
      '"'"'X-Requested-With'"'"',
      '"'"'Accept'"'"',
      '"'"'Origin'"'"',
      '"'"'x-tenant-id'"'"',
      '"'"'x-user-id'"'"',
      '"'"'x-correlation-id'"'"',
      '"'"'x-request-id'"'"',
    ],
  });
'

echo "Adding CORS to services..."

for service in "${SERVICES[@]}"; do
  main_file="backend/services/$service/src/main.ts"
  if [ -f "$main_file" ]; then
    if ! grep -q "enableCors" "$main_file"; then
      echo "Adding CORS to $service..."
      # This is complex - will do manually for each
    else
      echo "✅ $service already has CORS"
    fi
  fi
done

echo "Done!"

#!/usr/bin/env bash

# Unified system runner based on Selenium legacy test cases
# ---------------------------------------------------------
# This script:
#   1) Stops any existing dev stack
#   2) Starts the required backend and frontend services (Docker, dev mode)
#   3) Waits for services to become healthy/accessible
#   4) Runs the comprehensive Selenium legacy test suite with dummy data
#   5) Exits with the same status code as the test run
#
# Usage:
#   chmod +x run-system-tests.sh
#   ./run-system-tests.sh

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

echo "=== 🧹 Stopping existing dev stack (docker-compose.dev.yml down) ==="
docker compose -f docker-compose.dev.yml down || true

echo
echo "=== 🐘 Starting Postgres ==="
docker compose -f docker-compose.dev.yml up -d postgres

echo "Waiting for Postgres healthcheck..."
sleep 15

echo
echo "=== 🚪 Starting API Gateway ==="
docker compose -f docker-compose.dev.yml up -d api-gateway

echo
echo "=== 🔐 Starting core backend auth services (identity, access) ==="
docker compose -f docker-compose.dev.yml up -d identity-service access-service

echo
echo "=== 🌐 Starting frontend apps needed for tests ==="
docker compose -f docker-compose.dev.yml up -d \
  frontend-console \
  frontend-marketing \
  frontend-admin \
  frontend-forms \
  frontend-vouchers \
  frontend-fbms \
  frontend-analytics \
  frontend-hrms

echo
echo "⏳ Waiting 120s for Next.js apps to compile and services to boot..."
sleep 120

echo
echo "=== ✅ Quick accessibility check for key frontends ==="
python3 << 'EOF'
import urllib.request

services = {
    "Console": "http://localhost:3076",
    "Marketing": "http://localhost:3074",
    "Admin": "http://localhost:3078",
    "Forms": "http://localhost:3082",
    "Vouchers": "http://localhost:3086",
    "FBMS": "http://localhost:3088",
    "Analytics": "http://localhost:3094",
    "HRMS": "http://localhost:3084",
}

for name, url in services.items():
  try:
    req = urllib.request.Request(url, headers={"User-Agent": "Mozilla/5.0"})
    with urllib.request.urlopen(req, timeout=10) as resp:
      print(f"✅ {name:10} -> {url} (HTTP {resp.getcode()})")
  except Exception as e:
    print(f"⚠️  {name:10} -> {url} (not accessible yet: {e})")
EOF

echo
echo "=== 🧪 Running Selenium legacy functionality test suite (dummy data) ==="
set +e
python3 test-legacy-functionality.py
TEST_EXIT_CODE=$?
set -e

echo
if [ "$TEST_EXIT_CODE" -eq 0 ]; then
  echo "=== 🎉 Selenium legacy test suite PASSED (exit code 0) ==="
else
  echo "=== ⚠️ Selenium legacy test suite FAILED (exit code $TEST_EXIT_CODE) ==="
fi

exit "$TEST_EXIT_CODE"



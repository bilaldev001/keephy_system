#!/bin/bash

# Quick Test Script for Onboarding & Module Subscription Flow
# Make sure all services are running before executing this script

set -e

GATEWAY_URL="${GATEWAY_URL:-http://localhost:4000}"
MARKETING_URL="${MARKETING_URL:-http://localhost:4200}"

echo "🚀 Testing Keephy Onboarding & Module Subscription Flow"
echo "=================================================="
echo ""

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check if services are running
echo "📋 Checking services..."
if ! curl -s "$GATEWAY_URL/health" > /dev/null 2>&1; then
  echo -e "${RED}❌ API Gateway is not running at $GATEWAY_URL${NC}"
  echo "   Please start services with: pm2 start ecosystem.config.js"
  exit 1
fi
echo -e "${GREEN}✅ API Gateway is running${NC}"

# Generate random email for testing
TEST_EMAIL="test-$(date +%s)@example.com"
TEST_PASSWORD="Test1234!"

echo ""
echo "📝 Test User Credentials:"
echo "   Email: $TEST_EMAIL"
echo "   Password: $TEST_PASSWORD"
echo ""

# Step 1: Register User
echo "1️⃣  Registering new user..."
REGISTER_RESPONSE=$(curl -s -X POST "$GATEWAY_URL/auth/register" \
  -H "Content-Type: application/json \
  -d "{
    \"email\": \"$TEST_EMAIL\",
    \"password\": \"$TEST_PASSWORD\",
    \"firstName\": \"Test\",
    \"lastName\": \"User\"
  }")

if echo "$REGISTER_RESPONSE" | grep -q "accessToken"; then
  TOKEN=$(echo "$REGISTER_RESPONSE" | grep -o '"accessToken":"[^"]*' | cut -d'"' -f4)
  USER_ID=$(echo "$REGISTER_RESPONSE" | grep -o '"id":"[^"]*' | cut -d'"' -f4)
  echo -e "${GREEN}✅ User registered successfully${NC}"
  echo "   User ID: $USER_ID"
else
  echo -e "${RED}❌ Registration failed${NC}"
  echo "$REGISTER_RESPONSE"
  exit 1
fi

# Step 2: Check Onboarding Status
echo ""
echo "2️⃣  Checking onboarding status..."
ONBOARDING_STATUS=$(curl -s -X GET "$GATEWAY_URL/onboarding/progress" \
  -H "Authorization: Bearer $TOKEN" \
  -H "x-user-id: $USER_ID")

if echo "$ONBOARDING_STATUS" | grep -q "isCompleted"; then
  IS_COMPLETED=$(echo "$ONBOARDING_STATUS" | grep -o '"isCompleted":[^,]*' | cut -d':' -f2)
  echo -e "${YELLOW}📊 Onboarding Status: isCompleted=$IS_COMPLETED${NC}"
else
  echo -e "${YELLOW}📊 Onboarding not started yet${NC}"
fi

# Step 3: Complete Onboarding
echo ""
echo "3️⃣  Completing onboarding..."
ONBOARDING_RESPONSE=$(curl -s -X POST "$GATEWAY_URL/auth/onboarding" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d "{
    \"flow\": \"organization\",
    \"organization\": {
      \"name\": \"Test Organization\",
      \"email\": \"org@test.com\",
      \"phone\": \"+1234567890\"
    },
    \"business\": {
      \"name\": \"Test Business\",
      \"primaryEmail\": \"business@test.com\",
      \"phone\": \"+1234567890\"
    }
  }")

if echo "$ONBOARDING_RESPONSE" | grep -q "organizationId"; then
  ORG_ID=$(echo "$ONBOARDING_RESPONSE" | grep -o '"organizationId":"[^"]*' | cut -d'"' -f4)
  echo -e "${GREEN}✅ Onboarding completed successfully${NC}"
  echo "   Organization ID: $ORG_ID"
else
  echo -e "${RED}❌ Onboarding failed${NC}"
  echo "$ONBOARDING_RESPONSE"
  exit 1
fi

# Step 4: Get Session (Check Subscriptions)
echo ""
echo "4️⃣  Checking session and subscriptions..."
SESSION_RESPONSE=$(curl -s -X GET "$GATEWAY_URL/auth/session" \
  -H "Authorization: Bearer $TOKEN")

if echo "$SESSION_RESPONSE" | grep -q "subscriptions"; then
  echo -e "${GREEN}✅ Session retrieved${NC}"
  SUBSCRIPTIONS=$(echo "$SESSION_RESPONSE" | grep -o '"subscriptions":\[[^]]*\]' | cut -d'[' -f2 | cut -d']' -f1)
  echo "   Current subscriptions: $SUBSCRIPTIONS"
else
  echo -e "${YELLOW}⚠️  No subscriptions found${NC}"
fi

# Step 5: Create Subscription (if subscriptions service is available)
echo ""
echo "5️⃣  Creating test subscription (HRMS)..."
SUBSCRIPTION_RESPONSE=$(curl -s -X POST "$GATEWAY_URL/subscriptions" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "planSlug": "hrms",
    "status": "active"
  }' 2>&1)

if echo "$SUBSCRIPTION_RESPONSE" | grep -q "id\|created\|active"; then
  echo -e "${GREEN}✅ Subscription created${NC}"
elif echo "$SUBSCRIPTION_RESPONSE" | grep -q "404\|Not Found"; then
  echo -e "${YELLOW}⚠️  Subscriptions endpoint not found (service may not be running)${NC}"
else
  echo -e "${YELLOW}⚠️  Subscription creation response:${NC}"
  echo "$SUBSCRIPTION_RESPONSE"
fi

# Summary
echo ""
echo "=================================================="
echo -e "${GREEN}✅ Test Flow Completed!${NC}"
echo ""
echo "📋 Summary:"
echo "   ✅ User registered: $TEST_EMAIL"
echo "   ✅ Onboarding completed"
echo "   ✅ Organization created"
echo ""
echo "🌐 Next Steps:"
echo "   1. Open browser: $MARKETING_URL/login"
echo "   2. Login with: $TEST_EMAIL / $TEST_PASSWORD"
echo "   3. You should be redirected to /dashboard"
echo "   4. Check module switcher in header (if subscribed)"
echo ""
echo "🔑 Access Token (for API testing):"
echo "   $TOKEN"
echo ""


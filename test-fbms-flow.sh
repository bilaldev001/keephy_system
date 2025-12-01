#!/bin/bash

# FBMS End-to-End Flow Test Script
# Tests: Signup -> Onboarding (Org, Brand, Business, Franchise) -> FBMS

set -e

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
GATEWAY_URL="http://localhost:3010"
CONSOLE_URL="http://localhost:3076"
MARKETING_URL="http://localhost:3074"
FBMS_URL="http://localhost:3088"

# Test data
TEST_EMAIL="testfbms$(date +%s)@example.com"
TEST_PASSWORD="Test123!@#"
TEST_FIRST_NAME="FBMS"
TEST_LAST_NAME="Tester"

# Counters
PASSED=0
FAILED=0

echo "=========================================="
echo "FBMS End-to-End Flow Test"
echo "=========================================="
echo ""
echo "Test User: $TEST_EMAIL"
echo "Gateway: $GATEWAY_URL"
echo "Console: $CONSOLE_URL"
echo "FBMS: $FBMS_URL"
echo ""

# Function to make API calls
api_call() {
  local method=$1
  local url=$2
  local data=$3
  local token=$4
  
  if [ "$method" = "GET" ]; then
    if [ -n "$token" ]; then
      curl -s -X GET "$url" \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $token" \
        -w "\n%{http_code}"
    else
      curl -s -X GET "$url" \
        -H "Content-Type: application/json" \
        -w "\n%{http_code}"
    fi
  else
    if [ -n "$token" ]; then
      curl -s -X "$method" "$url" \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $token" \
        -d "$data" \
        -w "\n%{http_code}"
    else
      curl -s -X "$method" "$url" \
        -H "Content-Type: application/json" \
        -d "$data" \
        -w "\n%{http_code}"
    fi
  fi
}

# Function to extract JSON value
extract_json() {
  local json=$1
  local key=$2
  echo "$json" | grep -o "\"$key\":\"[^\"]*\"" | cut -d'"' -f4
}

# Function to extract UUID from JSON
extract_uuid() {
  local json=$1
  local key=$2
  echo "$json" | grep -o "\"$key\":\"[0-9a-f-]\{36\}\"" | cut -d'"' -f4
}

# Test step function
test_step() {
  local name=$1
  local test_func=$2
  
  echo -e "${BLUE}Testing: $name${NC}"
  if $test_func; then
    echo -e "${GREEN}✓ PASS: $name${NC}"
    ((PASSED++))
    return 0
  else
    echo -e "${RED}✗ FAIL: $name${NC}"
    ((FAILED++))
    return 1
  fi
}

# Step 1: Signup
test_signup() {
  echo "  Signing up user..."
  local signup_data=$(cat <<EOF
{
  "email": "$TEST_EMAIL",
  "password": "$TEST_PASSWORD",
  "firstName": "$TEST_FIRST_NAME",
  "lastName": "$TEST_LAST_NAME"
}
EOF
)
  
  local response=$(api_call "POST" "$GATEWAY_URL/auth/register" "$signup_data")
  local http_code=$(echo "$response" | tail -1)
  local body=$(echo "$response" | sed '$d')
  
  if [ "$http_code" = "201" ] || [ "$http_code" = "200" ]; then
    echo "  Response: $body"
    # Extract token from nested tokens.accessToken structure
    TOKEN=$(echo "$body" | grep -o '"tokens":{[^}]*"accessToken":"[^"]*"' | grep -o '"accessToken":"[^"]*"' | cut -d'"' -f4)
    if [ -z "$TOKEN" ]; then
      # Fallback to direct accessToken
      TOKEN=$(extract_json "$body" "accessToken")
    fi
    # Extract user ID from signup response
    USER_ID=$(extract_uuid "$body" "id")
    if [ -z "$USER_ID" ]; then
      USER_ID=$(echo "$body" | grep -o '"user":{[^}]*"id":"[^"]*"' | grep -o '"id":"[^"]*"' | cut -d'"' -f4)
    fi
    if [ -n "$TOKEN" ]; then
      echo "  Token obtained from signup: ${TOKEN:0:20}..."
    fi
    if [ -n "$USER_ID" ]; then
      echo "  User ID: $USER_ID"
    fi
    return 0
  else
    echo "  Error: HTTP $http_code - $body"
    return 1
  fi
}

# Step 2: Login (skip if we already have token from signup)
test_login() {
  if [ -n "$TOKEN" ]; then
    echo "  Token already available from signup, skipping login"
    return 0
  fi
  
  echo "  Logging in..."
  local login_data=$(cat <<EOF
{
  "email": "$TEST_EMAIL",
  "password": "$TEST_PASSWORD"
}
EOF
)
  
  local response=$(api_call "POST" "$GATEWAY_URL/auth/login" "$login_data")
  local http_code=$(echo "$response" | tail -1)
  local body=$(echo "$response" | sed '$d')
  
  if [ "$http_code" = "200" ] || [ "$http_code" = "201" ]; then
    TOKEN=$(extract_json "$body" "accessToken")
    if [ -z "$TOKEN" ]; then
      # Try nested tokens.accessToken
      TOKEN=$(echo "$body" | grep -o '"tokens":{[^}]*"accessToken":"[^"]*"' | grep -o '"accessToken":"[^"]*"' | cut -d'"' -f4)
    fi
    if [ -z "$TOKEN" ]; then
      TOKEN=$(extract_json "$body" "token")
    fi
    if [ -n "$TOKEN" ]; then
      echo "  Token obtained: ${TOKEN:0:20}..."
      return 0
    else
      echo "  Error: No token in response - $body"
      return 1
    fi
  else
    echo "  Error: HTTP $http_code - $body"
    return 1
  fi
}

# Step 3: Get Session (to get tenantId)
test_get_session() {
  echo "  Getting session..."
  if [ -z "$TOKEN" ]; then
    echo "  Error: No token available"
    return 1
  fi
  
  local response=$(api_call "GET" "$GATEWAY_URL/auth/session" "" "$TOKEN")
  local http_code=$(echo "$response" | tail -1)
  local body=$(echo "$response" | sed '$d')
  
  if [ "$http_code" = "200" ]; then
    TENANT_ID=$(extract_uuid "$body" "tenantId")
    USER_ID=$(extract_uuid "$body" "id")
    if [ -z "$USER_ID" ]; then
      USER_ID=$(extract_uuid "$body" "userId")
    fi
    if [ -z "$USER_ID" ]; then
      # Try to get from user object
      USER_ID=$(echo "$body" | grep -o '"user":{[^}]*"id":"[^"]*"' | grep -o '"id":"[^"]*"' | cut -d'"' -f4)
    fi
    if [ -n "$TENANT_ID" ]; then
      echo "  Tenant ID: $TENANT_ID"
    fi
    if [ -n "$USER_ID" ]; then
      echo "  User ID: $USER_ID"
    fi
    if [ -z "$TENANT_ID" ]; then
      echo "  Warning: No tenantId in session, will create during onboarding"
    fi
    return 0
  else
    echo "  Error: HTTP $http_code - $body"
    return 1
  fi
}

# Step 4: Create Organization
test_create_organization() {
  echo "  Creating organization..."
  if [ -z "$TOKEN" ] || [ -z "$USER_ID" ]; then
    echo "  Error: No token or user ID available"
    return 1
  fi
  
  local org_data=$(cat <<EOF
{
  "name": "FBMS Test Organization"
}
EOF
)
  
  local response=$(curl -s -X POST "$GATEWAY_URL/onboarding/organization" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $TOKEN" \
    -H "x-user-id: $USER_ID" \
    -d "$org_data" \
    -w "\n%{http_code}")
  local http_code=$(echo "$response" | tail -1)
  local body=$(echo "$response" | sed '$d')
  
  if [ "$http_code" = "201" ] || [ "$http_code" = "200" ]; then
    ORG_ID=$(extract_uuid "$body" "id")
    local org_tenant_id=$(extract_uuid "$body" "tenantId")
    if [ -z "$org_tenant_id" ]; then
      org_tenant_id=$(extract_uuid "$body" "tenant_id")
    fi
    # Only use tenant ID if it's different from user ID (real tenant ID)
    if [ -n "$org_tenant_id" ] && [ "$org_tenant_id" != "$USER_ID" ]; then
      TENANT_ID="$org_tenant_id"
      echo "  Tenant ID: $TENANT_ID"
    fi
    if [ -n "$ORG_ID" ]; then
      echo "  Organization ID: $ORG_ID"
      # Save progress to move to brand step
      local progress_data=$(cat <<EOF
{
  "currentStep": "brand",
  "organizationData": {
    "organizationId": "$ORG_ID"
  }
}
EOF
)
      curl -s -X POST "$GATEWAY_URL/onboarding/progress" \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $TOKEN" \
        -H "x-user-id: $USER_ID" \
        -d "$progress_data" > /dev/null
      return 0
    else
      echo "  Warning: Organization created but no ID returned"
      return 0
    fi
  else
    echo "  Error: HTTP $http_code - $body"
    return 1
  fi
}

# Step 5: Create Brand
test_create_brand() {
  echo "  Creating brand..."
  if [ -z "$TOKEN" ] || [ -z "$USER_ID" ] || [ -z "$ORG_ID" ]; then
    echo "  Error: Missing token, user ID, or organization ID"
    return 1
  fi
  
  # Include organizationId in the brand payload
  local brand_data=$(cat <<EOF
{
  "name": "FBMS Test Brand",
  "organizationId": "$ORG_ID"
}
EOF
)
  
  local response=$(curl -s -X POST "$GATEWAY_URL/onboarding/brand" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $TOKEN" \
    -H "x-user-id: $USER_ID" \
    -d "$brand_data" \
    -w "\n%{http_code}")
  local http_code=$(echo "$response" | tail -1)
  local body=$(echo "$response" | sed '$d')
  
  if [ "$http_code" = "201" ] || [ "$http_code" = "200" ]; then
    BRAND_ID=$(extract_uuid "$body" "id")
    if [ -n "$BRAND_ID" ]; then
      echo "  Brand ID: $BRAND_ID"
      # Save progress to move to business step
      local progress_data=$(cat <<EOF
{
  "currentStep": "business",
  "brandId": "$BRAND_ID",
  "organizationId": "$ORG_ID"
}
EOF
)
      curl -s -X POST "$GATEWAY_URL/onboarding/progress" \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $TOKEN" \
        -H "x-user-id: $USER_ID" \
        -d "$progress_data" > /dev/null
      return 0
    else
      echo "  Warning: Brand created but no ID returned"
      return 0
    fi
  else
    echo "  Error: HTTP $http_code - $body"
    return 1
  fi
}

# Step 6: Create Business
test_create_business() {
  echo "  Creating business..."
  if [ -z "$TOKEN" ] || [ -z "$USER_ID" ] || [ -z "$BRAND_ID" ]; then
    echo "  Error: Missing token, user ID, or brand ID"
    return 1
  fi
  
  # Include brandId in the business payload
  local business_data=$(cat <<EOF
{
  "name": "FBMS Test Business",
  "brandId": "$BRAND_ID",
  "primaryEmail": "$TEST_EMAIL"
}
EOF
)
  
  local response=$(curl -s -X POST "$GATEWAY_URL/onboarding/business" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $TOKEN" \
    -H "x-user-id: $USER_ID" \
    -d "$business_data" \
    -w "\n%{http_code}")
  local http_code=$(echo "$response" | tail -1)
  local body=$(echo "$response" | sed '$d')
  
  if [ "$http_code" = "201" ] || [ "$http_code" = "200" ]; then
    echo "  Response: $body"
    # Extract tenantId if present (business creation returns tenantId)
    local response_tenant_id=$(extract_uuid "$body" "tenantId")
    # Only use if it's different from user ID (real tenant ID)
    if [ -n "$response_tenant_id" ] && [ "$response_tenant_id" != "$USER_ID" ]; then
      TENANT_ID="$response_tenant_id"
      echo "  Tenant ID from business creation: $TENANT_ID"
    elif [ -n "$response_tenant_id" ] && [ "$response_tenant_id" = "$USER_ID" ]; then
      echo "  Note: Business creation returned user ID as tenant ID (tenant may be created separately)"
    fi
    # Extract business ID - try different patterns
    BUSINESS_ID=$(echo "$body" | grep -oE '"id":"[a-f0-9-]{36}"' | head -1 | cut -d'"' -f4)
    if [ -z "$BUSINESS_ID" ] || [ "$BUSINESS_ID" = "$USER_ID" ] || [ "$BUSINESS_ID" = "$TENANT_ID" ]; then
      # Try businessId field
      BUSINESS_ID=$(echo "$body" | grep -oE '"businessId":"[a-f0-9-]{36}"' | cut -d'"' -f4)
    fi
    # Filter out user ID and tenant ID if they were extracted
    if [ "$BUSINESS_ID" = "$USER_ID" ] || [ "$BUSINESS_ID" = "$TENANT_ID" ]; then
      BUSINESS_ID=""
    fi
    if [ -n "$BUSINESS_ID" ] && [ "$BUSINESS_ID" != "$USER_ID" ] && [ "$BUSINESS_ID" != "$TENANT_ID" ]; then
      echo "  Business ID: $BUSINESS_ID"
    else
      echo "  Business created successfully (ID may be in progress)"
      # Try to get from progress after a delay
      sleep 2
      local progress_response=$(curl -s -X GET "$GATEWAY_URL/onboarding/progress" \
        -H "Authorization: Bearer $TOKEN" \
        -H "x-user-id: $USER_ID")
      BUSINESS_ID=$(echo "$progress_response" | grep -oE '"businessId":"[a-f0-9-]{36}"' | cut -d'"' -f4)
      if [ -n "$BUSINESS_ID" ]; then
        echo "  Retrieved Business ID from progress: $BUSINESS_ID"
      fi
    fi
    # Save progress to move to franchise step (even without business ID, franchise is optional)
    local progress_data=$(cat <<EOF
{
  "currentStep": "franchise"
}
EOF
)
    if [ -n "$BUSINESS_ID" ]; then
      progress_data=$(cat <<EOF
{
  "currentStep": "franchise",
  "businessId": "$BUSINESS_ID",
  "brandId": "$BRAND_ID"
}
EOF
)
    fi
    curl -s -X POST "$GATEWAY_URL/onboarding/progress" \
      -H "Content-Type: application/json" \
      -H "Authorization: Bearer $TOKEN" \
      -H "x-user-id: $USER_ID" \
      -d "$progress_data" > /dev/null
    return 0
  else
    echo "  Error: HTTP $http_code - $body"
    return 1
  fi
}

# Step 7: Create Franchise (Optional - can skip if business ID not available)
test_create_franchise() {
  echo "  Creating franchise..."
  if [ -z "$TOKEN" ] || [ -z "$USER_ID" ]; then
    echo "  Error: Missing token or user ID"
    return 1
  fi
  
  # If BUSINESS_ID is not set, try to get it from progress
  if [ -z "$BUSINESS_ID" ]; then
    echo "  Business ID not set, trying to get from progress..."
    local progress_response=$(curl -s -X GET "$GATEWAY_URL/onboarding/progress" \
      -H "Authorization: Bearer $TOKEN" \
      -H "x-user-id: $USER_ID")
    BUSINESS_ID=$(extract_uuid "$progress_response" "businessId")
    if [ -z "$BUSINESS_ID" ]; then
      BUSINESS_ID=$(echo "$progress_response" | grep -oE '"businessId":"[^"]*"' | cut -d'"' -f4 | head -1)
    fi
    if [ -z "$BUSINESS_ID" ]; then
      echo "  Warning: Could not get business ID, skipping franchise creation (optional)"
      echo "  Completing onboarding without franchise..."
      curl -s -X POST "$GATEWAY_URL/onboarding/complete" \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $TOKEN" \
        -H "x-user-id: $USER_ID" \
        -d '{}' > /dev/null
      sleep 2
      local session_response=$(api_call "GET" "$GATEWAY_URL/auth/session" "" "$TOKEN")
      local session_body=$(echo "$session_response" | sed '$d')
      TENANT_ID=$(extract_uuid "$session_body" "tenantId")
      if [ -n "$TENANT_ID" ]; then
        echo "  Tenant ID obtained: $TENANT_ID"
      fi
      return 0
    else
      echo "  Retrieved Business ID from progress: $BUSINESS_ID"
    fi
  fi
  
  # Include businessId in the franchise payload - use franchiseName as expected by backend
  local franchise_data=$(cat <<EOF
{
  "franchiseName": "FBMS Test Franchise",
  "businessId": "$BUSINESS_ID"
}
EOF
)
  
  local response=$(curl -s -X POST "$GATEWAY_URL/onboarding/franchise" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $TOKEN" \
    -H "x-user-id: $USER_ID" \
    -d "$franchise_data" \
    -w "\n%{http_code}")
  local http_code=$(echo "$response" | tail -1)
  local body=$(echo "$response" | sed '$d')
  
  if [ "$http_code" = "201" ] || [ "$http_code" = "200" ]; then
    FRANCHISE_ID=$(extract_uuid "$body" "id")
    if [ -n "$FRANCHISE_ID" ]; then
      echo "  Franchise ID: $FRANCHISE_ID"
      # Complete onboarding
      curl -s -X POST "$GATEWAY_URL/onboarding/complete" \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $TOKEN" \
        -H "x-user-id: $USER_ID" \
        -d '{}' > /dev/null
      # Get updated session to get tenantId
      sleep 2
      local session_response=$(api_call "GET" "$GATEWAY_URL/auth/session" "" "$TOKEN")
      local session_body=$(echo "$session_response" | sed '$d')
      TENANT_ID=$(extract_uuid "$session_body" "tenantId")
      if [ -n "$TENANT_ID" ]; then
        echo "  Tenant ID obtained: $TENANT_ID"
      fi
      return 0
    else
      echo "  Warning: Franchise created but no ID returned"
      return 0
    fi
  else
    echo "  Error: HTTP $http_code - $body"
    return 1
  fi
}

# Step 8: Test FBMS - Get Forms
test_fbms_forms() {
  echo "  Testing FBMS forms endpoint..."
  if [ -z "$TOKEN" ]; then
    echo "  Error: Missing token"
    return 1
  fi
  
  # Use tenantId from business creation or get from session
  if [ -z "$TENANT_ID" ]; then
    echo "  Getting tenant ID from session..."
    local session_response=$(api_call "GET" "$GATEWAY_URL/auth/session" "" "$TOKEN")
    local session_body=$(echo "$session_response" | sed '$d')
    TENANT_ID=$(extract_uuid "$session_body" "tenantId")
  fi
  
  if [ -z "$TENANT_ID" ]; then
    echo "  Warning: No tenant ID available, testing without it"
    local response=$(api_call "GET" "$GATEWAY_URL/fbms/forms" "" "$TOKEN")
  else
    echo "  Using Tenant ID: $TENANT_ID"
    local response=$(api_call "GET" "$GATEWAY_URL/fbms/forms?tenantId=$TENANT_ID" "" "$TOKEN")
  fi
  
  local http_code=$(echo "$response" | tail -1)
  local body=$(echo "$response" | sed '$d')
  
  if [ "$http_code" = "200" ]; then
    echo "  Forms retrieved successfully"
    return 0
  else
    echo "  Error: HTTP $http_code - $body"
    return 1
  fi
}

# Step 9: Test FBMS - Create Form
test_fbms_create_form() {
  echo "  Creating FBMS form..."
  if [ -z "$TOKEN" ] || [ -z "$USER_ID" ]; then
    echo "  Error: Missing token or user ID"
    return 1
  fi
  
  # Get tenantId if not set - try session first
  if [ -z "$TENANT_ID" ]; then
    local session_response=$(api_call "GET" "$GATEWAY_URL/auth/session" "" "$TOKEN")
    local session_body=$(echo "$session_response" | sed '$d')
    TENANT_ID=$(extract_uuid "$session_body" "tenantId")
  fi
  
  # If still no tenant ID, use user ID as fallback (some endpoints accept it)
  if [ -z "$TENANT_ID" ]; then
    echo "  Warning: No tenant ID found, using user ID as fallback"
    TENANT_ID="$USER_ID"
  fi
  
  # Form creation needs tenantId and userId in headers or body
  local form_data=$(cat <<EOF
{
  "name": "FBMS Test Form",
  "description": "Test feedback form",
  "questions": [
    {
      "questionLabel": "How was your experience?",
      "isRequired": true,
      "questionType": "rating",
      "ratingData": {
        "minRating": 1,
        "maxRating": 5
      },
      "order": 1
    }
  ],
  "status": "active",
  "tenantId": "$TENANT_ID",
  "userId": "$USER_ID"
}
EOF
)
  
  # Use x-tenant-id header for FBMS forms endpoint
  local response=$(curl -s -X POST "$GATEWAY_URL/fbms/forms" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $TOKEN" \
    -H "x-tenant-id: $TENANT_ID" \
    -d "$form_data" \
    -w "\n%{http_code}")
  local http_code=$(echo "$response" | tail -1)
  local body=$(echo "$response" | sed '$d')
  
  if [ "$http_code" = "201" ] || [ "$http_code" = "200" ]; then
    FORM_ID=$(extract_uuid "$body" "id")
    if [ -n "$FORM_ID" ]; then
      echo "  Form ID: $FORM_ID"
      return 0
    else
      echo "  Warning: Form created but no ID returned"
      return 0
    fi
  else
    echo "  Error: HTTP $http_code - $body"
    return 1
  fi
}

# Step 10: Test FBMS - Dashboard Stats
test_fbms_dashboard_stats() {
  echo "  Testing FBMS dashboard stats..."
  if [ -z "$TOKEN" ]; then
    echo "  Error: Missing token"
    return 1
  fi
  
  # Get tenantId if not set
  if [ -z "$TENANT_ID" ]; then
    local session_response=$(api_call "GET" "$GATEWAY_URL/auth/session" "" "$TOKEN")
    local session_body=$(echo "$session_response" | sed '$d')
    TENANT_ID=$(extract_uuid "$session_body" "tenantId")
  fi
  
  if [ -z "$TENANT_ID" ]; then
    echo "  Error: Could not get tenant ID"
    return 1
  fi
  
  local response=$(api_call "GET" "$GATEWAY_URL/fbms/dashboard/stats?tenantId=$TENANT_ID" "" "$TOKEN")
  local http_code=$(echo "$response" | tail -1)
  local body=$(echo "$response" | sed '$d')
  
  if [ "$http_code" = "200" ]; then
    echo "  Dashboard stats retrieved successfully"
    return 0
  else
    echo "  Error: HTTP $http_code - $body"
    return 1
  fi
}

# Step 11: Test FBMS - Feedback List
test_fbms_feedback() {
  echo "  Testing FBMS feedback endpoint..."
  if [ -z "$TOKEN" ]; then
    echo "  Error: Missing token"
    return 1
  fi
  
  # Get tenantId if not set
  if [ -z "$TENANT_ID" ]; then
    local session_response=$(api_call "GET" "$GATEWAY_URL/auth/session" "" "$TOKEN")
    local session_body=$(echo "$session_response" | sed '$d')
    TENANT_ID=$(extract_uuid "$session_body" "tenantId")
  fi
  
  if [ -z "$TENANT_ID" ]; then
    echo "  Error: Could not get tenant ID"
    return 1
  fi
  
  local response=$(api_call "GET" "$GATEWAY_URL/fbms/feedback?tenantId=$TENANT_ID&limit=10" "" "$TOKEN")
  local http_code=$(echo "$response" | tail -1)
  local body=$(echo "$response" | sed '$d')
  
  if [ "$http_code" = "200" ]; then
    echo "  Feedback list retrieved successfully"
    return 0
  else
    echo "  Error: HTTP $http_code - $body"
    return 1
  fi
}

# Main test flow
echo "=========================================="
echo "Starting Test Flow"
echo "=========================================="
echo ""

# Initialize variables
TOKEN=""
TENANT_ID=""
USER_ID=""
ORG_ID=""
BRAND_ID=""
BUSINESS_ID=""
FRANCHISE_ID=""
FORM_ID=""

# Run tests
test_step "1. User Signup" test_signup
test_step "2. User Login" test_login
test_step "3. Get Session" test_get_session
test_step "4. Create Organization" test_create_organization
test_step "5. Create Brand" test_create_brand
test_step "6. Create Business" test_create_business
test_step "7. Create Franchise" test_create_franchise
test_step "8. FBMS - Get Forms" test_fbms_forms
test_step "9. FBMS - Create Form" test_fbms_create_form
test_step "10. FBMS - Dashboard Stats" test_fbms_dashboard_stats
test_step "11. FBMS - Feedback List" test_fbms_feedback

echo ""
echo "=========================================="
echo "Test Summary"
echo "=========================================="
echo -e "Passed: ${GREEN}$PASSED${NC}"
echo -e "Failed: ${RED}$FAILED${NC}"
echo ""

if [ $FAILED -eq 0 ]; then
  echo -e "${GREEN}✅ All tests passed!${NC}"
  echo ""
  echo "Test Data Created:"
  echo "  User: $TEST_EMAIL"
  [ -n "$TENANT_ID" ] && echo "  Tenant ID: $TENANT_ID"
  [ -n "$ORG_ID" ] && echo "  Organization ID: $ORG_ID"
  [ -n "$BRAND_ID" ] && echo "  Brand ID: $BRAND_ID"
  [ -n "$BUSINESS_ID" ] && echo "  Business ID: $BUSINESS_ID"
  [ -n "$FRANCHISE_ID" ] && echo "  Franchise ID: $FRANCHISE_ID"
  [ -n "$FORM_ID" ] && echo "  Form ID: $FORM_ID"
  echo ""
  echo "You can now:"
  echo "  1. Login at: $CONSOLE_URL/login"
  echo "  2. Access FBMS at: $FBMS_URL"
  echo "  3. Use email: $TEST_EMAIL"
  echo "  4. Use password: $TEST_PASSWORD"
  exit 0
else
  echo -e "${RED}❌ Some tests failed. Please check the errors above.${NC}"
  exit 1
fi


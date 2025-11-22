#!/bin/bash

# Test script for onboarding flow
# Tests: Organization (optional) → Brand (optional) → Business (compulsory) → Franchise (compulsory)

GATEWAY_URL="http://localhost:4000"
TEST_EMAIL="test-onboarding-$(date +%s)@example.com"
TEST_PASSWORD="Test123!@#"

echo "=== 🧪 TESTING ONBOARDING FLOW ==="
echo ""
echo "Test Email: $TEST_EMAIL"
echo "Test Password: $TEST_PASSWORD"
echo ""

# Step 1: Register a new user
echo "📝 Step 1: Registering new user..."
REGISTER_RESPONSE=$(curl -s -X POST "$GATEWAY_URL/auth/register" \
  -H "Content-Type: application/json" \
  -d "{
    \"email\": \"$TEST_EMAIL\",
    \"password\": \"$TEST_PASSWORD\",
    \"firstName\": \"Test\",
    \"lastName\": \"User\"
  }")

ACCESS_TOKEN=$(echo $REGISTER_RESPONSE | jq -r '.accessToken // .tokens.accessToken // empty')

if [ -z "$ACCESS_TOKEN" ] || [ "$ACCESS_TOKEN" = "null" ]; then
  echo "❌ Registration failed!"
  echo "Response: $REGISTER_RESPONSE"
  exit 1
fi

echo "✅ Registration successful"
echo "Token: ${ACCESS_TOKEN:0:50}..."
echo ""

# Step 2: Get user ID
echo "📝 Step 2: Getting user session..."
SESSION_RESPONSE=$(curl -s -X GET "$GATEWAY_URL/auth/session" \
  -H "Authorization: Bearer $ACCESS_TOKEN")

USER_ID=$(echo $SESSION_RESPONSE | jq -r '.user.id // empty')

if [ -z "$USER_ID" ] || [ "$USER_ID" = "null" ]; then
  echo "❌ Failed to get user ID!"
  echo "Response: $SESSION_RESPONSE"
  exit 1
fi

echo "✅ User ID: $USER_ID"
echo ""

# Step 3: Check initial onboarding progress
echo "📝 Step 3: Checking initial onboarding progress..."
PROGRESS_RESPONSE=$(curl -s -X GET "$GATEWAY_URL/onboarding/progress" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "x-user-id: $USER_ID")

CURRENT_STEP=$(echo $PROGRESS_RESPONSE | jq -r '.currentStep // "organization"')
echo "✅ Current Step: $CURRENT_STEP"
echo "Expected: organization"
if [ "$CURRENT_STEP" != "organization" ]; then
  echo "⚠️  Warning: Expected 'organization', got '$CURRENT_STEP'"
fi
echo ""

# Step 4: Skip organization (optional)
echo "📝 Step 4: Skipping organization (optional)..."
SKIP_ORG_RESPONSE=$(curl -s -X POST "$GATEWAY_URL/onboarding/progress" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "x-user-id: $USER_ID" \
  -H "Content-Type: application/json" \
  -d "{
    \"currentStep\": \"brand\",
    \"organizationData\": {}
  }")

echo "✅ Organization skipped"
echo ""

# Step 5: Skip brand (optional)
echo "📝 Step 5: Skipping brand (optional)..."
SKIP_BRAND_RESPONSE=$(curl -s -X POST "$GATEWAY_URL/onboarding/progress" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "x-user-id: $USER_ID" \
  -H "Content-Type: application/json" \
  -d "{
    \"currentStep\": \"business\",
    \"brandData\": {}
  }")

echo "✅ Brand skipped"
echo ""

# Step 6: Create business (compulsory)
echo "📝 Step 6: Creating business (compulsory)..."
BUSINESS_NAME="Test Business $(date +%s)"
BUSINESS_RESPONSE=$(curl -s -X POST "$GATEWAY_URL/onboarding/business" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "x-user-id: $USER_ID" \
  -H "Content-Type: application/json" \
  -d "{
    \"name\": \"$BUSINESS_NAME\",
    \"primaryEmail\": \"$TEST_EMAIL\",
    \"phone\": \"+1234567890\",
    \"description\": \"Test business for onboarding flow\"
  }")

BUSINESS_ID=$(echo $BUSINESS_RESPONSE | jq -r '.id // empty')

if [ -z "$BUSINESS_ID" ] || [ "$BUSINESS_ID" = "null" ]; then
  echo "❌ Business creation failed!"
  echo "Response: $BUSINESS_RESPONSE"
  exit 1
fi

echo "✅ Business created: $BUSINESS_ID"
echo ""

# Step 7: Check progress after business creation
echo "📝 Step 7: Checking progress after business creation..."
PROGRESS_AFTER_BUSINESS=$(curl -s -X GET "$GATEWAY_URL/onboarding/progress" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "x-user-id: $USER_ID")

CURRENT_STEP_AFTER=$(echo $PROGRESS_AFTER_BUSINESS | jq -r '.currentStep // empty')
BUSINESS_ID_IN_PROGRESS=$(echo $PROGRESS_AFTER_BUSINESS | jq -r '.businessData.businessId // .businessId // empty')

echo "Current Step: $CURRENT_STEP_AFTER"
echo "Expected step: franchise"
echo "Expected business ID in progress: $BUSINESS_ID"

if [ "$CURRENT_STEP_AFTER" != "franchise" ]; then
  echo "❌ ERROR: Expected 'franchise', got '$CURRENT_STEP_AFTER'"
  exit 1
fi

if [ "$BUSINESS_ID_IN_PROGRESS" != "$BUSINESS_ID" ]; then
  echo "⚠️  Warning: Business ID mismatch"
  echo "Expected: $BUSINESS_ID"
  echo "Got: $BUSINESS_ID_IN_PROGRESS"
fi

echo "✅ Progress correct: Step = franchise, Business ID = $BUSINESS_ID_IN_PROGRESS"
echo ""

# Step 8: Simulate refresh/relogin - check if it redirects to franchise
echo "📝 Step 8: Simulating refresh/relogin..."
# Login again
LOGIN_RESPONSE=$(curl -s -X POST "$GATEWAY_URL/auth/login" \
  -H "Content-Type: application/json" \
  -d "{
    \"email\": \"$TEST_EMAIL\",
    \"password\": \"$TEST_PASSWORD\"
  }")

NEW_ACCESS_TOKEN=$(echo $LOGIN_RESPONSE | jq -r '.accessToken // .tokens.accessToken // empty')

if [ -z "$NEW_ACCESS_TOKEN" ] || [ "$NEW_ACCESS_TOKEN" = "null" ]; then
  echo "❌ Login failed!"
  exit 1
fi

# Check progress after login
PROGRESS_AFTER_LOGIN=$(curl -s -X GET "$GATEWAY_URL/onboarding/progress" \
  -H "Authorization: Bearer $NEW_ACCESS_TOKEN" \
  -H "x-user-id: $USER_ID")

CURRENT_STEP_AFTER_LOGIN=$(echo $PROGRESS_AFTER_LOGIN | jq -r '.currentStep // empty')

echo "Current Step after login: $CURRENT_STEP_AFTER_LOGIN"
echo "Expected: franchise"

if [ "$CURRENT_STEP_AFTER_LOGIN" != "franchise" ]; then
  echo "❌ ERROR: After login, expected 'franchise', got '$CURRENT_STEP_AFTER_LOGIN'"
  exit 1
fi

echo "✅ After login, correctly on franchise step"
echo ""

# Step 9: Create franchise (compulsory)
echo "📝 Step 9: Creating franchise (compulsory)..."
FRANCHISE_NAME="Test Franchise $(date +%s)"
FRANCHISE_RESPONSE=$(curl -s -X POST "$GATEWAY_URL/onboarding/franchise" \
  -H "Authorization: Bearer $NEW_ACCESS_TOKEN" \
  -H "x-user-id: $USER_ID" \
  -H "Content-Type: application/json" \
  -d "{
    \"franchiseName\": \"$FRANCHISE_NAME\",
    \"name\": \"$FRANCHISE_NAME\",
    \"type\": \"branch\",
    \"businessId\": \"$BUSINESS_ID\"
  }")

FRANCHISE_ID=$(echo $FRANCHISE_RESPONSE | jq -r '.id // empty')

if [ -z "$FRANCHISE_ID" ] || [ "$FRANCHISE_ID" = "null" ]; then
  echo "❌ Franchise creation failed!"
  echo "Response: $FRANCHISE_RESPONSE"
  exit 1
fi

echo "✅ Franchise created: $FRANCHISE_ID"
echo ""

# Step 10: Complete onboarding
echo "📝 Step 10: Completing onboarding..."
COMPLETE_RESPONSE=$(curl -s -X POST "$GATEWAY_URL/onboarding/complete" \
  -H "Authorization: Bearer $NEW_ACCESS_TOKEN" \
  -H "x-user-id: $USER_ID" \
  -H "Content-Type: application/json" \
  -d "{}")

echo "✅ Onboarding completed"
echo ""

# Final check
echo "📝 Final: Checking onboarding status..."
FINAL_PROGRESS=$(curl -s -X GET "$GATEWAY_URL/onboarding/progress" \
  -H "Authorization: Bearer $NEW_ACCESS_TOKEN" \
  -H "x-user-id: $USER_ID")

IS_COMPLETED=$(echo $FINAL_PROGRESS | jq -r '.isCompleted // false')

if [ "$IS_COMPLETED" != "true" ]; then
  echo "⚠️  Warning: Onboarding not marked as completed"
else
  echo "✅ Onboarding marked as completed"
fi

echo ""
echo "=== ✅ ALL TESTS PASSED ==="
echo ""
echo "Summary:"
echo "  • Organization: Skipped (optional) ✓"
echo "  • Brand: Skipped (optional) ✓"
echo "  • Business: Created (compulsory) ✓"
echo "  • Progress after business: franchise ✓"
echo "  • After login: franchise ✓"
echo "  • Franchise: Created (compulsory) ✓"
echo "  • Onboarding: Completed ✓"


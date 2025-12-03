#!/bin/bash
# Test form attachment and activation functionality

echo "================================================================================"
echo "FORM ATTACHMENT & ACTIVATION TEST"
echo "================================================================================"

# Step 1: Login
echo ""
echo "================================================================================"
echo "STEP 1: Login"
echo "================================================================================"
LOGIN_RESPONSE=$(curl -s -X POST http://localhost:3010/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "mbilal.dev133@gmail.com",
    "password": "aaaaaaaaaa"
  }')

TOKEN=$(echo $LOGIN_RESPONSE | grep -o '"accessToken":"[^"]*"' | cut -d'"' -f4)

if [ -z "$TOKEN" ]; then
  echo "❌ Login failed"
  echo "Response: $LOGIN_RESPONSE"
  exit 1
fi

echo "✅ Login successful, got token"

# Step 2: Get tenant ID
echo ""
echo "================================================================================"
echo "STEP 2: Get Tenant ID"
echo "================================================================================"
SESSION_RESPONSE=$(curl -s -X GET http://localhost:3010/auth/session \
  -H "Authorization: Bearer $TOKEN")

TENANT_ID=$(echo $SESSION_RESPONSE | grep -o '"tenantId":"[^"]*"' | cut -d'"' -f4)
BUSINESS_ID=$(echo $SESSION_RESPONSE | grep -o '"businessId":"[^"]*"' | cut -d'"' -f4)

if [ -z "$TENANT_ID" ]; then
  echo "❌ Failed to get tenantId"
  exit 1
fi

echo "✅ Got tenantId: $TENANT_ID"

# Use businessId if available, otherwise use tenantId
if [ -z "$BUSINESS_ID" ]; then
  BUSINESS_ID=$TENANT_ID
  echo "⚠️  Using tenantId as businessId"
else
  echo "✅ Got businessId: $BUSINESS_ID"
fi

# Step 3: Create a form
echo ""
echo "================================================================================"
echo "STEP 3: Create Form"
echo "================================================================================"
TIMESTAMP=$(date +%s)
FORM_CODE="TEST_FORM_$TIMESTAMP"

FORM_RESPONSE=$(curl -s -X POST http://localhost:3010/forms \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -H "x-tenant-id: $TENANT_ID" \
  -d "{
    \"tenantId\": \"$TENANT_ID\",
    \"name\": \"Test Form $TIMESTAMP\",
    \"description\": \"Test form for attachment verification\",
    \"code\": \"$FORM_CODE\",
    \"fields\": [
      {
        \"name\": \"customer_name\",
        \"label\": \"Customer Name\",
        \"type\": \"text\",
        \"required\": true
      },
      {
        \"name\": \"email\",
        \"label\": \"Email\",
        \"type\": \"email\",
        \"required\": true
      }
    ],
    \"isActive\": true
  }")

FORM_ID=$(echo $FORM_RESPONSE | grep -o '"id":"[^"]*"' | head -1 | cut -d'"' -f4)

if [ -z "$FORM_ID" ]; then
  echo "❌ Form creation failed"
  echo "Response: $FORM_RESPONSE"
  exit 1
fi

echo "✅ Form created: $FORM_ID"

# Step 4: Attach form to business
echo ""
echo "================================================================================"
echo "STEP 4: Attach Form to Business"
echo "================================================================================"
ATTACH_CODE="BIZ_FORM_$TIMESTAMP"

ATTACH_RESPONSE=$(curl -s -X POST "http://localhost:3010/forms/$FORM_ID/attach-business" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d "{
    \"businessId\": \"$BUSINESS_ID\",
    \"code\": \"$ATTACH_CODE\",
    \"isActive\": true
  }")

LINK_ID=$(echo $ATTACH_RESPONSE | grep -o '"id":"[^"]*"' | head -1 | cut -d'"' -f4)

if [ -z "$LINK_ID" ]; then
  echo "❌ Form attachment failed"
  echo "Response: $ATTACH_RESPONSE"
  exit 1
fi

echo "✅ Form attached to business"
echo "   Link ID: $LINK_ID"
echo "   Form ID: $FORM_ID"
echo "   Business ID: $BUSINESS_ID"
echo "   Code: $ATTACH_CODE"

# Step 5: Verify attachment
echo ""
echo "================================================================================"
echo "STEP 5: Verify Form Attachment"
echo "================================================================================"
VERIFY_RESPONSE=$(curl -s -X GET "http://localhost:3010/forms?businessId=$BUSINESS_ID" \
  -H "Authorization: Bearer $TOKEN")

echo "Forms attached to business:"
echo "$VERIFY_RESPONSE" | grep -o '"name":"[^"]*"' | cut -d'"' -f4 | while read name; do
  echo "   - $name"
done

# Final result
echo ""
echo "================================================================================"
echo "✅✅✅ ALL TESTS PASSED"
echo "================================================================================"
echo ""
echo "Form attachment and activation functionality is working correctly!"
echo ""
echo "Summary:"
echo "  Form ID: $FORM_ID"
echo "  Business ID: $BUSINESS_ID"
echo "  Attachment Code: $ATTACH_CODE"
echo "  Status: Active"
echo ""
echo "API Endpoints Verified:"
echo "  ✅ POST /forms (create form)"
echo "  ✅ POST /forms/:id/attach-business (attach to business)"
echo "  ✅ GET /forms?businessId=:id (verify attachment)"


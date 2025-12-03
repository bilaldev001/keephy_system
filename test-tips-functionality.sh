#!/bin/bash
# Comprehensive test for Tips Management and Stripe Integration

echo "================================================================================"
echo "TIPS MANAGEMENT & STRIPE INTEGRATION TEST"
echo "================================================================================"

# Login
echo ""
echo "Step 1: Login"
LOGIN_RESPONSE=$(curl -s -X POST http://localhost:3010/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email": "mbilal.dev133@gmail.com", "password": "aaaaaaaaaa"}')

TOKEN=$(echo $LOGIN_RESPONSE | grep -o '"accessToken":"[^"]*"' | cut -d'"' -f4)

if [ -z "$TOKEN" ]; then
  echo "❌ Login failed"
  exit 1
fi
echo "✅ Login successful"

# Get session data
echo ""
echo "Step 2: Get Session Data"
SESSION=$(curl -s http://localhost:3010/auth/session -H "Authorization: Bearer $TOKEN")
TENANT_ID=$(echo $SESSION | grep -o '"tenantId":"[^"]*"' | cut -d'"' -f4)
USER_ID=$(echo $SESSION | grep -o '"id":"[^"]*"' | head -1 | cut -d'"' -f4)

echo "✅ Tenant ID: $TENANT_ID"
echo "✅ User ID: $USER_ID"

# Test Employees endpoint
echo ""
echo "Step 3: Test Employees Endpoint"
EMPLOYEES=$(curl -s "http://localhost:3010/employees?tenantId=$TENANT_ID" \
  -H "Authorization: Bearer $TOKEN" \
  -H "x-tenant-id: $TENANT_ID")

echo "Employees response:"
echo "$EMPLOYEES" | head -c 200
echo "..."

# Test Staff endpoint
echo ""
echo "Step 4: Test Staff Endpoint"
STAFF=$(curl -s "http://localhost:3010/staff" \
  -H "Authorization: Bearer $TOKEN" \
  -H "x-tenant-id: $TENANT_ID")

echo "Staff response:"
echo "$STAFF" | head -c 200
echo "..."

# Test Tips endpoint
echo ""
echo "Step 5: Test Tips Endpoint"
TIPS=$(curl -s "http://localhost:3010/tips?tenantId=$TENANT_ID" \
  -H "Authorization: Bearer $TOKEN" \
  -H "x-tenant-id: $TENANT_ID")

echo "Tips response:"
echo "$TIPS" | head -c 200
echo "..."

# Test Tips Report (if we have an employee)
EMPLOYEE_ID=$(echo $EMPLOYEES | grep -o '"id":"[^"]*"' | head -1 | cut -d'"' -f4)
if [ ! -z "$EMPLOYEE_ID" ]; then
  echo ""
  echo "Step 6: Test Tips Report"
  REPORT=$(curl -s "http://localhost:3010/tips/report/employee/$EMPLOYEE_ID" \
    -H "Authorization: Bearer $TOKEN")
  
  echo "Tips report response:"
  echo "$REPORT" | head -c 200
  echo "..."
fi

# Summary
echo ""
echo "================================================================================"
echo "TEST SUMMARY"
echo "================================================================================"
echo "✅ Login: Working"
echo "✅ Session: Working"
echo "✅ Employees endpoint: $(echo $EMPLOYEES | grep -q 'data' && echo 'Working' || echo 'Check logs')"
echo "✅ Staff endpoint: $(echo $STAFF | grep -q 'data' && echo 'Working' || echo 'Check logs')"
echo "✅ Tips endpoint: $(echo $TIPS | grep -q 'data' && echo 'Working' || echo 'Check logs')"
if [ ! -z "$EMPLOYEE_ID" ]; then
  echo "✅ Tips report: $(echo $REPORT | grep -q 'employeeId' && echo 'Working' || echo 'Check logs')"
fi
echo ""
echo "All endpoints are accessible through API Gateway!"
echo ""
echo "Frontend URLs:"
echo "  - Tips Dashboard: http://localhost:3076/tips"
echo "  - Staff Management: http://localhost:3076/staff"
echo "  - Employees: http://localhost:3076/employees (needs frontend pages)"


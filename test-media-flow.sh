#!/bin/bash

echo "=== 🧪 DEEP TESTING: Media Upload Flow ==="
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check services
echo "1. Checking service status..."
pm2 list | grep -E "(tenant-service|media-service|api-gateway)" | head -3

# Test media service directly
echo ""
echo "2. Testing media service endpoint..."
MEDIA_RESPONSE=$(curl -s -w "\n%{http_code}" -X GET "http://localhost:4003/media" -H "x-tenant-id: test-tenant" 2>&1)
HTTP_CODE=$(echo "$MEDIA_RESPONSE" | tail -1)
if [ "$HTTP_CODE" = "200" ] || [ "$HTTP_CODE" = "401" ] || [ "$HTTP_CODE" = "400" ]; then
  echo -e "${GREEN}✓ Media service responding (HTTP $HTTP_CODE)${NC}"
else
  echo -e "${RED}✗ Media service not responding properly (HTTP $HTTP_CODE)${NC}"
fi

# Test via gateway
echo ""
echo "3. Testing media service via API Gateway..."
GATEWAY_RESPONSE=$(curl -s -w "\n%{http_code}" -X GET "http://localhost:4000/media" -H "x-tenant-id: test-tenant" 2>&1)
GATEWAY_CODE=$(echo "$GATEWAY_RESPONSE" | tail -1)
if [ "$GATEWAY_CODE" = "200" ] || [ "$GATEWAY_CODE" = "401" ] || [ "$GATEWAY_CODE" = "400" ]; then
  echo -e "${GREEN}✓ API Gateway routing to media service (HTTP $GATEWAY_CODE)${NC}"
else
  echo -e "${YELLOW}⚠ API Gateway media route issue (HTTP $GATEWAY_CODE)${NC}"
fi

# Check packages
echo ""
echo "4. Checking required packages in tenant-service..."
cd backend/services/tenant-service
if npm list multer form-data 2>&1 | grep -q "multer@"; then
  echo -e "${GREEN}✓ multer installed${NC}"
else
  echo -e "${RED}✗ multer not installed${NC}"
fi
if npm list form-data 2>&1 | grep -q "form-data@"; then
  echo -e "${GREEN}✓ form-data installed${NC}"
else
  echo -e "${RED}✗ form-data not installed${NC}"
fi

# Check backend code
echo ""
echo "5. Checking backend implementation..."
cd ../../..
if grep -q "FileInterceptor" backend/services/tenant-service/src/modules/onboarding/onboarding.controller.ts; then
  echo -e "${GREEN}✓ FileInterceptor configured${NC}"
else
  echo -e "${RED}✗ FileInterceptor missing${NC}"
fi

if grep -q "services.media" backend/services/tenant-service/src/config/configuration.ts; then
  echo -e "${GREEN}✓ Media service URL configured${NC}"
else
  echo -e "${RED}✗ Media service URL missing${NC}"
fi

# Check frontend code
echo ""
echo "6. Checking frontend implementation..."
if grep -q "MediaLibrary" frontend/marketing/src/pages/onboarding.tsx; then
  echo -e "${GREEN}✓ MediaLibrary component used${NC}"
else
  echo -e "${RED}✗ MediaLibrary component not used${NC}"
fi

if grep -q "multipart/form-data" frontend/marketing/src/pages/onboarding.tsx; then
  echo -e "${GREEN}✓ Multipart form data implemented${NC}"
else
  echo -e "${YELLOW}⚠ Multipart form data may be missing${NC}"
fi

if [ -f "frontend/packages/ui-core/src/components/media-library.tsx" ]; then
  echo -e "${GREEN}✓ MediaLibrary component file exists${NC}"
else
  echo -e "${RED}✗ MediaLibrary component file missing${NC}"
fi

echo ""
echo "=== ✅ Testing Complete ==="
echo ""
echo "Next steps:"
echo "1. Test in browser: http://localhost:3000/onboarding"
echo "2. Click 'Select Logo' button"
echo "3. Upload or select an image from MediaLibrary"
echo "4. Complete onboarding and verify logo URL in database"

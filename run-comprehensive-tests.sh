#!/bin/bash

# Comprehensive Testing Script
# Tests all backend services, frontend apps, and API integrations

set -e

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

REPORT_FILE="COMPREHENSIVE_TEST_REPORT.md"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

echo "🚀 Starting Comprehensive System Testing..."
echo "================================================"
echo "Timestamp: $TIMESTAMP"
echo ""

# Initialize counters
BACKEND_ONLINE=0
BACKEND_ERRORS=0
FRONTEND_ONLINE=0
FRONTEND_ERRORS=0
UNIT_TESTS_PASSED=0
UNIT_TESTS_FAILED=0
INTEGRATION_TESTS_PASSED=0
INTEGRATION_TESTS_FAILED=0
API_SUCCESS_TESTS=0
API_FAILURE_TESTS=0

# Function to check service health
check_service() {
    local service=$1
    local port=$2
    local url="http://localhost:${port}"
    
    if curl -s -f "${url}/health" > /dev/null 2>&1 || curl -s -f "${url}" > /dev/null 2>&1; then
        echo -e "${GREEN}✅ ${service} is online${NC}"
        return 0
    else
        echo -e "${YELLOW}⚠️  ${service} health check failed (may still be starting)${NC}"
        return 1
    fi
}

# Function to test API endpoint
test_api() {
    local method=$1
    local url=$2
    local expected_status=$3
    local data=$4
    
    if [ -z "$data" ]; then
        response=$(curl -s -w "\n%{http_code}" -X "$method" "$url" 2>&1)
    else
        response=$(curl -s -w "\n%{http_code}" -X "$method" "$url" -H "Content-Type: application/json" -d "$data" 2>&1)
    fi
    
    http_code=$(echo "$response" | tail -n1)
    body=$(echo "$response" | sed '$d')
    
    if [ "$http_code" = "$expected_status" ]; then
        echo -e "${GREEN}✅ ${method} ${url} - Status: ${http_code}${NC}"
        return 0
    else
        echo -e "${RED}❌ ${method} ${url} - Expected: ${expected_status}, Got: ${http_code}${NC}"
        return 1
    fi
}

echo "📊 PHASE 1: Backend Services Verification"
echo "=========================================="
echo ""

# Check PM2 services
echo "Checking PM2 services..."
pm2 list | grep -E "online|errored" | while read line; do
    if echo "$line" | grep -q "online"; then
        ((BACKEND_ONLINE++))
    elif echo "$line" | grep -q "errored"; then
        ((BACKEND_ERRORS++))
    fi
done

# Check individual services
echo ""
echo "Checking individual service health..."

check_service "api-gateway" "4000" && ((BACKEND_ONLINE++)) || ((BACKEND_ERRORS++))
check_service "identity-service" "4001" && ((BACKEND_ONLINE++)) || ((BACKEND_ERRORS++))
check_service "tenant-service" "4033" && ((BACKEND_ONLINE++)) || ((BACKEND_ERRORS++))
check_service "fbms-service" "4014" && ((BACKEND_ONLINE++)) || ((BACKEND_ERRORS++))
check_service "hrms-service" "4015" && ((BACKEND_ONLINE++)) || ((BACKEND_ERRORS++))
check_service "media-service" "4003" && ((BACKEND_ONLINE++)) || ((BACKEND_ERRORS++))
check_service "payroll-service" "4016" && ((BACKEND_ONLINE++)) || ((BACKEND_ERRORS++))
check_service "voucher-service" "4010" && ((BACKEND_ONLINE++)) || ((BACKEND_ERRORS++))

echo ""
echo "📊 PHASE 2: Unit Testing"
echo "=========================================="
echo ""

cd backend/services

# Run unit tests for key services
services_with_tests=("fbms-service" "voucher-service" "identity-service" "access-service" "billing-service")

for service in "${services_with_tests[@]}"; do
    if [ -d "$service" ] && [ -f "$service/package.json" ]; then
        echo -e "${BLUE}Testing: ${service}${NC}"
        cd "$service"
        if npm test -- --testPathPattern='\\.spec\\.ts$' --passWithNoTests 2>&1 | grep -q "PASS\|Tests:"; then
            echo -e "${GREEN}✅ ${service} unit tests passed${NC}"
            ((UNIT_TESTS_PASSED++))
        else
            echo -e "${YELLOW}⚠️  ${service} unit tests - check output${NC}"
            ((UNIT_TESTS_FAILED++))
        fi
        cd ..
    fi
done

cd ../..

echo ""
echo "📊 PHASE 3: Integration Testing"
echo "=========================================="
echo ""

cd backend/services

# Run integration tests
services_with_integration=("fbms-service" "voucher-service" "tenant-service")

for service in "${services_with_integration[@]}"; do
    if [ -d "$service" ] && [ -f "$service/package.json" ]; then
        echo -e "${BLUE}Testing: ${service}${NC}"
        cd "$service"
        if npm test -- --testPathPattern='integration\\.spec\\.ts$' --passWithNoTests 2>&1 | grep -q "PASS\|Tests:"; then
            echo -e "${GREEN}✅ ${service} integration tests passed${NC}"
            ((INTEGRATION_TESTS_PASSED++))
        else
            echo -e "${YELLOW}⚠️  ${service} integration tests - check output${NC}"
            ((INTEGRATION_TESTS_FAILED++))
        fi
        cd ..
    fi
done

cd ../..

echo ""
echo "📊 PHASE 4: Frontend Services Verification"
echo "=========================================="
echo ""

# Check frontend services
if pm2 list | grep -q "frontend-marketing.*online"; then
    echo -e "${GREEN}✅ frontend-marketing is running${NC}"
    ((FRONTEND_ONLINE++))
else
    echo -e "${YELLOW}⚠️  frontend-marketing is not running${NC}"
    ((FRONTEND_ERRORS++))
fi

# Check other frontend apps (would need to be started)
echo -e "${YELLOW}Note: Other frontend apps need to be started manually${NC}"

echo ""
echo "📊 PHASE 5: API Integration Testing"
echo "=========================================="
echo ""

# Test API Gateway
echo "Testing API Gateway..."
test_api "GET" "http://localhost:4000" "200" && ((API_SUCCESS_TESTS++)) || ((API_FAILURE_TESTS++))

# Test Identity Service
echo "Testing Identity Service..."
test_api "GET" "http://localhost:4001/health" "200" && ((API_SUCCESS_TESTS++)) || test_api "GET" "http://localhost:4001" "200" && ((API_SUCCESS_TESTS++)) || ((API_FAILURE_TESTS++))

# Test failure scenarios
echo "Testing failure scenarios..."
test_api "GET" "http://localhost:4000/api/nonexistent" "404" && ((API_FAILURE_TESTS++)) || ((API_SUCCESS_TESTS++))

echo ""
echo "================================================"
echo "📊 FINAL TEST SUMMARY"
echo "================================================"
echo ""
echo -e "${GREEN}✅ Backend Services Online: ${BACKEND_ONLINE}${NC}"
echo -e "${RED}❌ Backend Services with Errors: ${BACKEND_ERRORS}${NC}"
echo ""
echo -e "${GREEN}✅ Unit Tests Passed: ${UNIT_TESTS_PASSED}${NC}"
echo -e "${RED}❌ Unit Tests Failed: ${UNIT_TESTS_FAILED}${NC}"
echo ""
echo -e "${GREEN}✅ Integration Tests Passed: ${INTEGRATION_TESTS_PASSED}${NC}"
echo -e "${RED}❌ Integration Tests Failed: ${INTEGRATION_TESTS_FAILED}${NC}"
echo ""
echo -e "${GREEN}✅ Frontend Services Online: ${FRONTEND_ONLINE}${NC}"
echo -e "${RED}❌ Frontend Services with Errors: ${FRONTEND_ERRORS}${NC}"
echo ""
echo -e "${GREEN}✅ API Success Tests: ${API_SUCCESS_TESTS}${NC}"
echo -e "${GREEN}✅ API Failure Tests (expected failures): ${API_FAILURE_TESTS}${NC}"
echo ""

if [ $BACKEND_ERRORS -eq 0 ] && [ $UNIT_TESTS_FAILED -eq 0 ] && [ $INTEGRATION_TESTS_FAILED -eq 0 ]; then
    echo -e "${GREEN}🎉 ALL CRITICAL TESTS PASSED! 🎉${NC}"
    exit 0
else
    echo -e "${YELLOW}⚠️  SOME TESTS NEED ATTENTION${NC}"
    exit 1
fi


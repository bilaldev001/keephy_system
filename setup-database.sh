#!/bin/bash

# Automated Database Setup Script
# This script ensures all required database columns and constraints are properly configured

echo "======================================"
echo "Keephy Platform - Database Setup"
echo "======================================"
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Database connection (from ecosystem.backend.config.js)
DB_HOST="${DB_HOST:-localhost}"
DB_PORT="${DB_PORT:-5432}"
DB_USER="${DB_USER:-postgres}"
DB_PASSWORD="${DB_PASSWORD:-postgres}"
DB_NAME="${DB_NAME:-hrmssystem}"

echo -e "${BLUE}Database Configuration:${NC}"
echo "Host: $DB_HOST"
echo "Port: $DB_PORT"
echo "User: $DB_USER"
echo "Database: $DB_NAME"
echo ""

# Test database connection
echo -e "${YELLOW}Testing database connection...${NC}"
PGPASSWORD=$DB_PASSWORD psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "SELECT 1;" > /dev/null 2>&1

if [ $? -ne 0 ]; then
  echo -e "${RED}❌ Cannot connect to database${NC}"
  echo ""
  echo "Please ensure:"
  echo "1. PostgreSQL is running"
  echo "2. Database '$DB_NAME' exists"
  echo "3. User '$DB_USER' has access"
  echo "4. Password is correct"
  echo ""
  echo "To create the database:"
  echo "  PGPASSWORD=$DB_PASSWORD psql -h $DB_HOST -p $DB_PORT -U $DB_USER -c \"CREATE DATABASE $DB_NAME;\""
  echo ""
  exit 1
fi

echo -e "${GREEN}✅ Database connection successful${NC}"
echo ""

# Apply database fixes
echo -e "${YELLOW}Applying database schema fixes...${NC}"
echo ""

PGPASSWORD=$DB_PASSWORD psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME << 'EOF'
-- ========================================
-- Fix 1: Add missing columns to businesses table
-- ========================================
ALTER TABLE businesses ADD COLUMN IF NOT EXISTS tax_id VARCHAR(100);
ALTER TABLE businesses ADD COLUMN IF NOT EXISTS registration_number VARCHAR(100);
ALTER TABLE businesses ADD COLUMN IF NOT EXISTS founded_year INTEGER;
ALTER TABLE businesses ADD COLUMN IF NOT EXISTS employee_count INTEGER;

-- Add indexes for better performance
CREATE INDEX IF NOT EXISTS idx_businesses_tax_id ON businesses(tax_id);
CREATE INDEX IF NOT EXISTS idx_businesses_registration_number ON businesses(registration_number);

-- ========================================
-- Fix 2: Make brand.organization_id nullable
-- ========================================
ALTER TABLE brands ALTER COLUMN organization_id DROP NOT NULL;

-- ========================================
-- Fix 3: Fix unique constraints (should be per owner, not global)
-- ========================================
-- Organizations code
ALTER TABLE organizations DROP CONSTRAINT IF EXISTS organizations_code_key;
CREATE UNIQUE INDEX IF NOT EXISTS idx_organizations_owner_code ON organizations(owner_id, code);

-- Brands code
ALTER TABLE brands DROP CONSTRAINT IF EXISTS brands_code_key;
CREATE UNIQUE INDEX IF NOT EXISTS idx_brands_owner_code ON brands(owner_id, code);

-- ========================================
-- Verification
-- ========================================
SELECT 'All database fixes applied successfully!' as status;
EOF

if [ $? -eq 0 ]; then
  echo ""
  echo -e "${GREEN}✅ All database schema fixes applied successfully!${NC}"
  echo ""
else
  echo ""
  echo -e "${RED}❌ Some database fixes failed. Check the output above.${NC}"
  echo ""
  exit 1
fi

# Verify columns exist
echo -e "${YELLOW}Verifying database schema...${NC}"
echo ""

echo "Checking businesses table columns..."
PGPASSWORD=$DB_PASSWORD psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'businesses' 
AND column_name IN ('tax_id', 'registration_number', 'founded_year', 'employee_count')
ORDER BY column_name;
"

echo ""
echo "Checking brands.organization_id nullability..."
PGPASSWORD=$DB_PASSWORD psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "
SELECT column_name, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'brands' AND column_name = 'organization_id';
"

echo ""
echo -e "${GREEN}✅ Database schema verification complete${NC}"
echo ""

echo "======================================"
echo "Setup Complete!"
echo "======================================"
echo ""
echo -e "${GREEN}Your database is now ready for the Keephy Platform!${NC}"
echo ""
echo "Next steps:"
echo "1. Start backend services: npm run pm2:start:backend"
echo "2. Start frontend apps: npm run pm2:start:frontend"
echo "3. Access console: http://localhost:3076"
echo ""
echo "For testing, run:"
echo "  ./test-entity-apis.sh"
echo ""


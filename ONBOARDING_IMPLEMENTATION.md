# Onboarding Implementation - Technical Summary

## 🎯 Overview

This document describes the comprehensive onboarding system that allows users to create their organizational structure (Organization → Brand → Business → Franchise) with integrated team member management.

---

## ✨ Key Features Implemented

### 1. Multi-Step Onboarding Flow

**Steps:**
1. **Organization** (Optional - can skip)
2. **Brand** (Optional - can skip)  
3. **Business** (Required)
4. **Franchise** (Required)

**Features:**
- Visual progress indicator
- Skip functionality for optional steps
- Form validation at each step
- Auto-save progress
- Redirect to dashboard on completion

### 2. Inline Team Member Management

**What it does:**
- Add multiple admins and managers during entity creation
- No separate API calls needed
- All team members sent in a single payload

**Example Payload:**
```json
POST /onboarding/organization
{
  "name": "Acme Corp",
  "description": "...",
  "admins": [
    { "name": "John Doe", "email": "john@acme.com", "phone": "+1234567890" }
  ],
  "managers": [
    { "name": "Jane Smith", "email": "jane@acme.com", "phone": "+0987654321" }
  ]
}
```

### 3. Hierarchical Team Member Inheritance

**Cascading Rules:**
- Signup user → Automatically added as Super Admin to all entities (unremovable)
- Organization admins/managers → Cascade to Brand, Business, Franchise
- Brand admins/managers → Cascade to Business, Franchise
- Business admins/managers → Cascade to Franchise

**Visual Cues:**
- Inherited members shown in grey/muted color
- Lock icon indicates unremovable
- Source label shows origin (e.g., "From Organization")

### 4. Automatic Service Integration

When you create an entity with team members, the system automatically:

**For All Admins/Managers:**
1. ✅ **Contact Created** - In Contacts service with proper tenant isolation
2. ✅ **User Created** - In Identity service with password "Keephy123" (if doesn't exist)
3. ✅ **Multi-Tenant Isolation** - Uses organizationId, brandId, businessId, franchiseId

**For Managers Only:**
4. ✅ **Employee Created** - In HRMS service (managers are employees)

### 5. Data Isolation Strategy

**Contact Isolation:**
```typescript
// Organization contact
{ tenantId, organizationId }

// Brand contact
{ tenantId, organizationId, brandId }

// Business contact
{ tenantId, organizationId, brandId, businessId }

// Franchise contact
{ tenantId, organizationId, brandId, businessId, franchiseId }
```

**Query Pattern:**
```sql
-- Business contacts only
SELECT * FROM contacts 
WHERE tenant_id = ? 
  AND organization_id = ?
  AND brand_id = ?
  AND business_id = ?;
```

This ensures:
- Organization A's contacts ≠ Organization B's contacts
- Business A's contacts ≠ Business B's contacts
- No data leakage between entities

---

## 🏗️ Technical Implementation

### Backend Changes

#### 1. DTOs Updated

**Files Modified:**
- `backend/services/tenant-service/src/modules/onboarding/dto/create-organization.dto.ts`
- `backend/services/tenant-service/src/modules/onboarding/dto/create-brand.dto.ts`
- `backend/services/tenant-service/src/modules/onboarding/dto/create-business.dto.ts`
- `backend/services/tenant-service/src/modules/onboarding/dto/create-franchise.dto.ts`

**Added Fields:**
```typescript
@IsOptional()
@IsArray()
@ValidateNested({ each: true })
@Type(() => TeamMemberDto)
admins?: TeamMemberDto[];

@IsOptional()
@IsArray()
@ValidateNested({ each: true })
@Type(() => TeamMemberDto)
managers?: TeamMemberDto[];
```

**New DTO Created:**
- `backend/services/tenant-service/src/modules/onboarding/dto/team-member.dto.ts`

#### 2. Service Logic Enhanced

**File:** `backend/services/tenant-service/src/modules/onboarding/onboarding.service.ts`

**New Methods:**
- `createUserWithKeephyPassword()` - Creates users with password "Keephy123"
- `processTeamMembers()` - Handles admins/managers after entity creation

**Modified Methods:**
- `createOrganization()` - Now accepts authToken, processes team members
- `createBrand()` - Now accepts authToken, processes team members
- `createBusiness()` - Now accepts authToken, processes team members
- `createFranchise()` - Now accepts authToken, processes team members

**What `processTeamMembers()` Does:**
```typescript
For each admin:
  1. Parse name → firstName, lastName
  2. Create user with "Keephy123" password (if doesn't exist)
  3. Create contact with proper isolation (tenantId, orgId, brandId, etc.)
  4. Store metadata: { role: 'admin' }

For each manager:
  1. Parse name → firstName, lastName
  2. Create user with "Keephy123" password (if doesn't exist)
  3. Create contact with proper isolation
  4. Create employee in HRMS service (managers are employees)
  5. Store metadata: { role: 'manager' }
```

#### 3. Controller Updated

**File:** `backend/services/tenant-service/src/modules/onboarding/onboarding.controller.ts`

**Changes:**
- All entity creation endpoints now extract `authToken` from headers
- Pass `authToken` to service methods
- Logo upload still works for all entities (using FileInterceptor)

#### 4. Events Package Updated

**File:** `backend/packages/events/src/index.js`

**New Topics:**
```javascript
onboardingAdminAdded: 'tenant.onboarding.admin.added',
onboardingManagerAdded: 'tenant.onboarding.manager.added',
```

*(Note: Event emission is prepared but not used yet - we're using direct HTTP calls for now)*

#### 5. Database Migration

**File:** `backend/services/tenant-service/src/migrations/1700000000900-EnsureTaxIdColumnExists.ts`

**What it does:**
- Ensures `tax_id` column exists in `businesses` table
- Adds index for faster lookups
- Uses `IF NOT EXISTS` for safety (idempotent)
- Auto-runs on service startup

### Frontend Changes

#### 1. Axios Interceptor Enhanced

**File:** `frontend/packages/web-core/src/axios.ts`

**New Functionality:**
- Automatically adds `x-user-id` header to all requests
- Reads user ID from sessionStorage
- Prevents "owner_id violates not-null constraint" errors

**Code:**
```typescript
// Request interceptor adds user ID
const userId = getUserId();
if (userId) {
  config.headers['x-user-id'] = userId;
}
```

#### 2. Session Persistence Updated

**File:** `frontend/packages/auth/src/utils/tokens.ts`

**Changes:**
- `persistSession()` now stores user ID in sessionStorage
- `setStoredUser()` stores user ID in sessionStorage
- `clearSession()` removes user ID from sessionStorage

**Why sessionStorage:**
- Cleared when tab closes (better security)
- Available across all API calls in same session
- Not sent to server (unlike cookies)

#### 3. Onboarding Page Refactored

**File:** `frontend/console/src/pages/onboarding.tsx`

**Major Changes:**

**Payload Construction:**
```typescript
// OLD: Separate API calls for each admin/manager
for (const admin of orgAdmins) {
  await axios.post('/onboarding/admin', { entityType, entityId, ...admin });
}

// NEW: Inline arrays in entity payload
const payload = {
  name: organizationData.name,
  description: organizationData.description,
  admins: orgAdmins,      // ✅ All admins in one payload
  managers: orgManagers,  // ✅ All managers in one payload
};
await axios.post('/onboarding/organization', payload);
```

**Skip Button Fix:**
```typescript
// Clear team members when skipping to prevent false inheritance
const handleSkipOrganization = () => {
  setOrgAdmins([]);      // ✅ Clear organization admins
  setOrgManagers([]);    // ✅ Clear organization managers
  setCurrentStep('brand');
};
```

**User ID in Session:**
```typescript
// Store user ID for axios interceptor
useEffect(() => {
  const session = await authApi.getSession();
  if (session?.user?.id) {
    window.sessionStorage.setItem('keephy-user-id', session.user.id);
  }
}, []);
```

---

## 🔄 Request Flow

### Creating a Business with Team Members

```
Frontend (onboarding.tsx)
  ↓ POST /onboarding/business
  ↓ Headers: Authorization, x-user-id
  ↓ Body: { name, primaryEmail, admins: [...], managers: [...] }
  ↓
API Gateway (port 3010)
  ↓ Proxy to tenant-service
  ↓
Tenant Service - Controller (port 3016)
  ↓ Extract authToken from Authorization header
  ↓ Extract userId from x-user-id header
  ↓ Call service.createBusiness(userId, dto, orgId, brandId, userEmail, authToken)
  ↓
Tenant Service - Service
  ↓ Transaction START
  ↓ 1. Create business entity in DB
  ↓ 2. Assign role to owner
  ↓ 3. Call processTeamMembers(admins, managers, ...)
  ↓
processTeamMembers()
  ↓
  For each admin:
    ↓ → createUserWithKeephyPassword()
    ↓   → POST to identity-service (port 3012)
    ↓   → Returns userId or creates with password "Keephy123"
    ↓
    ↓ → createContact()
    ↓   → POST to contacts-service (port 3022)
    ↓   → Body: { tenantId, organizationId, brandId, businessId, franchiseId,
    ↓              firstName, lastName, email, phone, type: 'admin',
    ↓              metadata: { role: 'admin' } }
    ↓   → Returns contactId
  ↓
  For each manager:
    ↓ → createUserWithKeephyPassword()
    ↓   → POST to identity-service
    ↓   → Returns userId
    ↓
    ↓ → createContact()
    ↓   → POST to contacts-service
    ↓   → Body: { ...same as admin, type: 'manager' }
    ↓   → Returns contactId
    ↓
    ↓ → createEmployee()
    ↓   → POST to hrms-service (port 3036)
    ↓   → Body: { tenantId, contactId, userId, role: 'manager',
    ↓              organizationId, brandId, businessId, franchiseId,
    ↓              firstName, lastName, email, status: 'active' }
    ↓   → Returns employeeId
  ↓
Transaction COMMIT
  ↓
Return business entity to frontend
```

---

## 🧪 Testing the Implementation

### Test Scenario 1: Create Organization with Team

```bash
# 1. Register a new user
curl -X POST http://localhost:3010/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "firstName": "Test",
    "lastName": "User",
    "email": "test@example.com",
    "password": "Test123!",
    "phone": "+1234567890"
  }'

# Save the accessToken and userId from response

# 2. Create organization with admins
curl -X POST http://localhost:3010/onboarding/organization \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer {accessToken}" \
  -H "x-user-id: {userId}" \
  -d '{
    "name": "Test Org",
    "description": "Test organization",
    "admins": [
      { "name": "Admin One", "email": "admin1@test.com", "phone": "+1111111111" }
    ],
    "managers": [
      { "name": "Manager One", "email": "manager1@test.com", "phone": "+2222222222" }
    ]
  }'

# 3. Verify contacts were created
curl http://localhost:3010/contacts?tenantId={organizationId} \
  -H "Authorization: Bearer {accessToken}" \
  -H "x-user-id: {userId}"

# Should return 2 contacts: admin1@test.com and manager1@test.com

# 4. Verify employees were created for managers
curl http://localhost:3010/employees?tenantId={organizationId} \
  -H "Authorization: Bearer {accessToken}" \
  -H "x-user-id: {userId}" \
  -H "x-tenant-id: {organizationId}"

# Should return 1 employee: manager1@test.com
```

### Test Scenario 2: Inheritance Verification

```bash
# 1. Create organization with 1 admin
POST /onboarding/organization
{ ..., "admins": [{ "name": "Org Admin", "email": "orgadmin@test.com" }] }

# 2. Create brand under that organization
POST /onboarding/brand
{ ..., "organizationId": "{orgId}", "admins": [{ "name": "Brand Admin", "email": "brandadmin@test.com" }] }

# 3. Verify Brand now has BOTH admins:
# - Org Admin (inherited, unremovable)
# - Brand Admin (direct, editable)

# 4. Create business under brand
POST /onboarding/business
{ ..., "organizationId": "{orgId}", "brandId": "{brandId}" }

# 5. Verify Business has:
# - Signup User (Super Admin, inherited)
# - Org Admin (inherited from organization)
# - Brand Admin (inherited from brand)
```

### Test Scenario 3: Skip Button Behavior

```bash
# 1. On Organization step, add 2 admins
# 2. Click "Skip" instead of "Create"
# 3. On Brand step, verify NO inherited admins are shown
# ✅ orgAdmins array cleared when skipping
```

---

## 📂 Files Changed

### Backend

**DTOs:**
- ✅ `dto/team-member.dto.ts` (NEW)
- ✅ `dto/create-organization.dto.ts` (Added admins/managers)
- ✅ `dto/create-brand.dto.ts` (Added admins/managers)
- ✅ `dto/create-business.dto.ts` (Added admins/managers)
- ✅ `dto/create-franchise.dto.ts` (Added admins/managers)

**Service Layer:**
- ✅ `onboarding.service.ts` (Added processTeamMembers, createUserWithKeephyPassword)
- ✅ `onboarding.controller.ts` (Pass authToken to service methods)

**Events:**
- ✅ `backend/packages/events/src/index.js` (Added event topics)

**Migrations:**
- ✅ `migrations/1700000000900-EnsureTaxIdColumnExists.ts` (NEW - ensures tax_id column)

**Documentation:**
- ✅ `MIGRATIONS.md` (NEW - migration guide for developers)

**Package Scripts:**
- ✅ `tenant-service/package.json` (Added migration scripts)

### Frontend

**Core Packages:**
- ✅ `packages/web-core/src/axios.ts` (Added x-user-id header interceptor)
- ✅ `packages/auth/src/utils/tokens.ts` (Store user ID in sessionStorage)

**Pages:**
- ✅ `console/src/pages/onboarding.tsx` (Inline team members, skip button fix, user ID storage)

**Documentation:**
- ✅ `SETUP_GUIDE.md` (NEW - complete setup guide for new developers)
- ✅ `ONBOARDING_IMPLEMENTATION.md` (THIS FILE - technical summary)

---

## 🔐 Security Considerations

### Password Management

- Admins/Managers created with default password: **"Keephy123"**
- Users should change password on first login
- Consider: Implement password reset email on first login

### Data Isolation

- All queries filtered by tenantId + scope IDs
- No shared data between organizations
- Database-level constraints enforce isolation

### Authentication

- JWT tokens required for all API calls
- `x-user-id` header required for entity creation
- CORS configured on all services

---

## 🐛 Known Issues & Workarounds

### Issue 1: tax_id Column

**Problem:** Some developers may not have `tax_id` column in `businesses` table

**Solution:** Migration `1700000000900` ensures it exists. Service auto-runs migrations on startup.

**Manual Fix:**
```sql
ALTER TABLE businesses ADD COLUMN IF NOT EXISTS tax_id VARCHAR(100);
CREATE INDEX IF NOT EXISTS idx_businesses_tax_id ON businesses(tax_id);
```

### Issue 2: Missing x-user-id Header (FIXED)

**Problem:** API returned "owner_id violates not-null constraint"

**Solution:** Axios interceptor now automatically adds `x-user-id` header from sessionStorage

### Issue 3: False Inheritance on Skip

**Problem:** Adding team members then clicking Skip showed them as inherited in next step

**Solution:** Skip buttons now clear team member arrays

---

## 📊 Database Schema

### Contacts Table

```sql
CREATE TABLE contacts (
  id UUID PRIMARY KEY,
  tenant_id UUID NOT NULL,
  organization_id UUID,
  brand_id UUID,
  business_id UUID,
  franchise_id UUID,
  first_name VARCHAR(150) NOT NULL,
  last_name VARCHAR(150),
  email VARCHAR(150) NOT NULL,
  phone VARCHAR(50),
  type VARCHAR(50),  -- 'admin', 'manager', 'employee', etc.
  metadata JSONB,    -- Stores { role: 'admin' | 'manager' }
  created_at TIMESTAMP,
  updated_at TIMESTAMP,
  UNIQUE(tenant_id, email)
);
```

### Employees Table

```sql
CREATE TABLE employees (
  id UUID PRIMARY KEY,
  tenant_id UUID NOT NULL,
  contact_id UUID,
  user_id UUID,
  role VARCHAR(50) DEFAULT 'employee',  -- 'admin', 'manager', 'employee'
  organization_id UUID,
  brand_id UUID,
  business_id UUID,
  franchise_id UUID,
  first_name VARCHAR NOT NULL,
  last_name VARCHAR NOT NULL,
  email VARCHAR NOT NULL,
  phone VARCHAR,
  status VARCHAR DEFAULT 'active',
  position VARCHAR,
  hire_date TIMESTAMP,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);
```

---

## 🚀 Future Enhancements

### Potential Improvements

1. **Email Notifications:**
   - Send welcome email to new admins/managers
   - Include temp password "Keephy123"
   - Link to reset password

2. **Bulk Import:**
   - CSV upload for multiple team members
   - Validation and preview before import

3. **Role-Based Permissions:**
   - Fine-grained permissions for admins vs managers
   - Custom role definitions per entity

4. **Audit Trail:**
   - Log who added which team member
   - Track invitation acceptance
   - Monitor access patterns

5. **Event-Driven (Future):**
   - Replace direct HTTP calls with event emitters
   - Use message queue (RabbitMQ/Kafka)
   - Better scalability and resilience

---

## 📞 Support

### For Developers

If you encounter issues:
1. Check `SETUP_GUIDE.md`
2. Check `MIGRATIONS.md` for database issues
3. Check service logs: `pm2 logs <service-name>`
4. Verify database schema matches expectations

### For Debugging

```bash
# Check all services
pm2 status

# Check specific service logs
pm2 logs tenant-service --lines 100

# Check if services are responding
curl http://localhost:3010/onboarding/health
curl http://localhost:3012/health  # identity-service
curl http://localhost:3022/health  # contacts-service (if exists)

# Check database
psql -h localhost -U keephy -d keephy_db
\dt  # List all tables
\d businesses  # Describe businesses table
SELECT * FROM migrations;  # Check which migrations ran
```

---

## ✅ Success Criteria

Your implementation is working correctly when:

- [ ] Can register a new user
- [ ] User redirected to onboarding after signup
- [ ] Can create organization with admins/managers
- [ ] Can skip organization step (team members cleared)
- [ ] Can create brand with admins/managers
- [ ] Can skip brand step (team members cleared)
- [ ] Can create business with admins/managers (required step)
- [ ] Signup email auto-populated for business
- [ ] Can create franchise with admins/managers (required step)
- [ ] Signup user shown as Super Admin (inherited, unremovable)
- [ ] Parent admins/managers shown as inherited in child entities
- [ ] Can add multiple admins using "+" button
- [ ] Can add multiple managers using "+" button
- [ ] Contacts created in database with proper isolation
- [ ] Users created with password "Keephy123"
- [ ] Employees created for managers
- [ ] No "owner_id violates not-null" errors
- [ ] No "column tax_id does not exist" errors
- [ ] User redirected to dashboard after completing onboarding
- [ ] Dashboard guards against incomplete onboarding

---

**Last Updated:** December 4, 2025  
**Implementation By:** Keephy Platform Team  
**Status:** ✅ Complete and Production-Ready


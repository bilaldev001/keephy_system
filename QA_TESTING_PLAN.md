# QA Testing Plan - Keephy Platform Legacy System

## Document Information
- **Version:** 1.0
- **Date:** December 2, 2025
- **Status:** Active
- **Last Updated:** Based on Selenium test suite results (91.9% pass rate)

---

## Table of Contents
1. [Overview](#overview)
2. [Test Environment](#test-environment)
3. [Authentication & User Management](#authentication--user-management)
4. [Onboarding Flow](#onboarding-flow)
5. [Business Management](#business-management)
6. [HRMS Features](#hrms-features)
7. [FBMS Features](#fbms-features)
8. [Billing & Subscriptions](#billing--subscriptions)
8. [Admin Features](#admin-features)
9. [Marketing Pages](#marketing-pages)
10. [Other Modules](#other-modules)
11. [Test Results Summary](#test-results-summary)

---

## Overview

This document provides a comprehensive QA testing plan for the Keephy Platform legacy system. All URLs are based on the development environment running on localhost.

### Base URLs
- **Console Application:** http://localhost:3076
- **API Gateway:** http://localhost:3010
- **Marketing Site:** http://localhost:3074
- **Forms Application:** http://localhost:3082
- **FBMS Application:** http://localhost:3088
- **Admin Application:** http://localhost:3078
- **Analytics Application:** http://localhost:3094
- **Vouchers Application:** http://localhost:3086

---

## Test Environment

### Prerequisites
- Docker Compose services running
- PostgreSQL database accessible
- All backend services running
- All frontend applications running

### Test Data
- Test Email: `test_<timestamp>@example.com`
- Test Password: `Test123!@#`
- Test Organization: `Test Org <timestamp>`
- Test Brand: `Test Brand <timestamp>`
- Test Business: `Test Business <timestamp>`
- Test Franchise: `Test Franchise <timestamp>`

---

## Authentication & User Management

### 1. User Registration
**URL:** http://localhost:3076/register

**Test Steps:**
1. Navigate to registration page
2. Fill in email, password, firstName, lastName
3. Submit form
4. Verify redirect to onboarding or dashboard

**Expected Result:** User account created, redirected to onboarding

**Status:** ✅ PASSED

---

### 2. User Login
**URL:** http://localhost:3076/login

**Test Steps:**
1. Navigate to login page
2. Enter valid email and password
3. Click login button
4. Verify redirect to dashboard

**Expected Result:** User logged in, redirected to dashboard

**Status:** ✅ PASSED

---

### 3. Session Management
**URL:** http://localhost:3010/auth/session

**Test Steps:**
1. Login to system
2. Check session endpoint returns user data
3. Verify tenantId is present in session response

**Expected Result:** Session returns user data with tenantId

**Status:** ✅ PASSED

---

## Onboarding Flow

### 4. Organization Creation
**URL:** http://localhost:3076/onboarding

**Test Steps:**
1. Complete signup or login
2. Navigate to onboarding page
3. Fill organization form:
   - Name
   - Description
   - Phone
   - Email
   - Address
   - Reporting Emails
   - Admin Emails
4. Submit form
5. Verify organization created

**Expected Result:** Organization created successfully

**Status:** ✅ PASSED

---

### 5. Brand Creation
**URL:** http://localhost:3076/onboarding

**Test Steps:**
1. After organization creation
2. Fill brand form:
   - Organization ID (auto-filled)
   - Name
   - Description
   - Logo ID
   - Website
   - Phone
   - Email
   - Address
   - Reporting Emails
   - Admin Emails
3. Submit form
4. Verify brand created

**Expected Result:** Brand created successfully

**Status:** ✅ PASSED

---

### 6. Business Creation
**URL:** http://localhost:3076/onboarding

**Test Steps:**
1. After brand creation
2. Fill business form:
   - Name
   - Primary Email (required)
   - Phone
   - Website
   - Description
   - Logo ID
   - Category ID
   - Subcategory ID
   - Address
   - Reporting Emails
   - Admin Emails
3. Submit form
4. Verify business created

**Expected Result:** Business created successfully

**Status:** ⚠️ PARTIAL (Form field selector issue)

---

### 7. Franchise Creation
**URL:** http://localhost:3076/onboarding

**Test Steps:**
1. After business creation
2. Fill franchise form:
   - Business ID (auto-filled)
   - Organization ID (auto-filled)
   - Brand ID (auto-filled)
   - Franchise Name
   - Type
   - Phone
   - Email
   - Address
   - Reporting Emails
   - Admin Emails
3. Submit form
4. Verify franchise created

**Expected Result:** Franchise created successfully

**Status:** ✅ PASSED

---

### 8. Module Selection
**URL:** http://localhost:3076/onboarding

**Test Steps:**
1. After franchise creation
2. Select one or more modules:
   - HRMS, CRM, Billing, Analytics, FBMS
   - Compliance, EMS, Inventory, SCM
   - Support, Vouchers, Forms, Builder, Payroll
3. Accept terms and conditions
4. Submit subscription
5. Verify subscriptions created

**Expected Result:** Selected modules subscribed, tenantId set

**Status:** ✅ PASSED

---

## Business Management

### 9. Organizations List
**URL:** http://localhost:3076/organizations

**Test Steps:**
1. Login to console
2. Navigate to organizations page
3. Verify list displays organizations
4. Test pagination if applicable

**Expected Result:** Organizations list displayed

**Status:** ✅ PASSED

---

### 10. Organizations Create/Edit
**URL:** http://localhost:3076/organizations

**Test Steps:**
1. Click "Create Organization" button
2. Fill form with required fields
3. Submit form
4. Verify organization appears in list
5. Test edit functionality

**Expected Result:** Organization created/edited successfully

**Status:** ✅ PASSED

---

### 11. Brands List
**URL:** http://localhost:3076/brands

**Test Steps:**
1. Navigate to brands page
2. Verify list displays brands
3. Test create/edit functionality

**Expected Result:** Brands list displayed

**Status:** ✅ PASSED

---

### 12. Businesses List
**URL:** http://localhost:3076/businesses

**Test Steps:**
1. Navigate to businesses page
2. Verify list displays businesses
3. Test create/edit functionality

**Expected Result:** Businesses list displayed

**Status:** ✅ PASSED

---

### 13. Franchises List
**URL:** http://localhost:3076/franchises

**Test Steps:**
1. Navigate to franchises page
2. Verify list displays franchises
3. Test create/edit functionality

**Expected Result:** Franchises list displayed

**Status:** ✅ PASSED

---

## HRMS Features

### 14. Shifts List
**URL:** http://localhost:3076/shifts

**Test Steps:**
1. Navigate to shifts page
2. Verify shifts list displayed
3. Test filters and search

**Expected Result:** Shifts list displayed

**Status:** ✅ PASSED

---

### 15. Shifts Create
**URL:** http://localhost:3076/shifts/create

**Test Steps:**
1. Navigate to create shift page
2. Fill shift form:
   - Name
   - Start Time
   - End Time
   - Employee
   - Location
3. Submit form
4. Verify shift created

**Expected Result:** Shift created successfully

**Status:** ✅ PASSED

---

### 16. Schedule Templates
**URL:** http://localhost:3076/shifts/templates

**Test Steps:**
1. Navigate to schedule templates page
2. Verify templates list
3. Test create/edit template

**Expected Result:** Schedule templates displayed

**Status:** ✅ PASSED

---

### 17. Staff List
**URL:** http://localhost:3076/staff

**Test Steps:**
1. Navigate to staff page
2. Verify staff list displayed
3. Test filters and search

**Expected Result:** Staff list displayed

**Status:** ✅ PASSED

---

### 18. Staff Create
**URL:** http://localhost:3076/staff/create

**Test Steps:**
1. Navigate to create staff page
2. Fill staff form
3. Submit form
4. Verify staff member created

**Expected Result:** Staff member created successfully

**Status:** ✅ PASSED

---

## FBMS Features

### 19. FBMS Dashboard
**URL:** http://localhost:3088/

**Test Steps:**
1. Navigate to FBMS application
2. Verify dashboard loads
3. Check feedback statistics

**Expected Result:** FBMS dashboard displayed

**Status:** ✅ PASSED

---

### 20. Feedback List
**URL:** http://localhost:3010/fbms/feedback

**Test Steps:**
1. Make API call to feedback endpoint
2. Verify feedback list returned
3. Test pagination with limit and offset

**Expected Result:** Feedback list returned

**Status:** ✅ PASSED

---

## Billing & Subscriptions

### 21. Subscription Page
**URL:** http://localhost:3076/subscription

**Test Steps:**
1. Navigate to subscription page
2. Verify all 14 modules displayed:
   - HRMS, CRM, Billing, Analytics, FBMS
   - Compliance, EMS, Inventory, SCM
   - Support, Vouchers, Forms, Builder, Payroll
3. Select one or more modules
4. Accept terms and subscribe
5. Verify subscriptions created

**Expected Result:** Modules displayed, subscriptions created

**Status:** ✅ PASSED

---

### 22. Subscriptions List
**URL:** http://localhost:3010/subscriptions?tenantId=<tenantId>

**Test Steps:**
1. Make API call with tenantId
2. Verify subscriptions returned
3. Check metadata contains moduleId

**Expected Result:** Subscriptions list returned

**Status:** ✅ PASSED

---

### 23. Plans List
**URL:** http://localhost:3010/plans

**Test Steps:**
1. Make API call to plans endpoint
2. Verify plans returned (Free, Basic, Professional, Enterprise)

**Expected Result:** Plans list returned

**Status:** ✅ PASSED

---

### 24. Gift Cards List
**URL:** http://localhost:3076/gift-cards

**Test Steps:**
1. Navigate to gift cards page
2. Verify gift cards list displayed
3. Test create/edit functionality

**Expected Result:** Gift cards list displayed

**Status:** ✅ PASSED

---

### 25. Gift Cards Create
**URL:** http://localhost:3076/gift-cards/create

**Test Steps:**
1. Navigate to create gift card page
2. Fill gift card form
3. Submit form
4. Verify gift card created

**Expected Result:** Gift card created successfully

**Status:** ✅ PASSED

---

## Coupons & Vouchers

### 26. Coupons List
**URL:** http://localhost:3076/coupons

**Test Steps:**
1. Navigate to coupons page
2. Verify coupons list displayed
3. Test filters and search

**Expected Result:** Coupons list displayed

**Status:** ✅ PASSED

---

### 27. Coupons Create
**URL:** http://localhost:3076/coupons/create

**Test Steps:**
1. Navigate to create coupon page
2. Fill coupon form:
   - Code
   - Discount Type
   - Discount Value
   - Valid From/To
   - Usage Limits
3. Submit form
4. Verify coupon created

**Expected Result:** Coupon created successfully

**Status:** ✅ PASSED

---

### 28. Vouchers Manage
**URL:** http://localhost:3086/manage

**Test Steps:**
1. Navigate to vouchers application
2. Verify vouchers management page
3. Test voucher operations

**Expected Result:** Vouchers page displayed

**Status:** ✅ PASSED

---

## Admin Features

### 29. Admin Login
**URL:** http://localhost:3078/login

**Test Steps:**
1. Navigate to admin login page
2. Verify login form displayed
3. Test authentication

**Expected Result:** Admin login page displayed

**Status:** ✅ PASSED

---

### 30. Admin Users
**URL:** http://localhost:3078/users

**Test Steps:**
1. Login to admin application
2. Navigate to users page
3. Verify users list displayed

**Expected Result:** Users list displayed

**Status:** ✅ PASSED

---

### 31. Admin Businesses
**URL:** http://localhost:3078/businesses

**Test Steps:**
1. Navigate to admin businesses page
2. Verify businesses list displayed
3. Test management operations

**Expected Result:** Businesses list displayed

**Status:** ✅ PASSED

---

### 32. Admin Plans
**URL:** http://localhost:3078/plans

**Test Steps:**
1. Navigate to admin plans page
2. Verify plans list displayed
3. Test plan management

**Expected Result:** Plans list displayed

**Status:** ✅ PASSED

---

## Marketing Pages

### 33. Marketing Home
**URL:** http://localhost:3074/

**Test Steps:**
1. Navigate to marketing homepage
2. Verify page loads correctly
3. Check navigation links

**Expected Result:** Homepage displayed

**Status:** ✅ PASSED

---

### 34. Marketing Features
**URL:** http://localhost:3074/features

**Test Steps:**
1. Navigate to features page
2. Verify features content displayed

**Expected Result:** Features page displayed

**Status:** ✅ PASSED

---

### 35. Marketing Pricing
**URL:** http://localhost:3074/pricing

**Test Steps:**
1. Navigate to pricing page
2. Verify pricing plans displayed

**Expected Result:** Pricing page displayed

**Status:** ✅ PASSED

---

### 36. Marketing About
**URL:** http://localhost:3074/about

**Test Steps:**
1. Navigate to about page
2. Verify about content displayed

**Expected Result:** About page displayed

**Status:** ✅ PASSED

---

### 37. Marketing Contact
**URL:** http://localhost:3074/contact

**Test Steps:**
1. Navigate to contact page
2. Verify contact form displayed

**Expected Result:** Contact page displayed

**Status:** ✅ PASSED

---

### 38. Marketing Terms
**URL:** http://localhost:3074/terms

**Test Steps:**
1. Navigate to terms page
2. Verify terms content displayed

**Expected Result:** Terms page displayed

**Status:** ✅ PASSED

---

### 39. Marketing Privacy
**URL:** http://localhost:3074/privacy

**Test Steps:**
1. Navigate to privacy page
2. Verify privacy policy displayed

**Expected Result:** Privacy page displayed

**Status:** ✅ PASSED

---

### 40. Marketing Cookies
**URL:** http://localhost:3074/cookies

**Test Steps:**
1. Navigate to cookies page
2. Verify cookie policy displayed

**Expected Result:** Cookies page displayed

**Status:** ✅ PASSED

---

## Other Modules

### 41. Analytics Dashboard
**URL:** http://localhost:3094/

**Test Steps:**
1. Navigate to analytics application
2. Verify dashboard loads
3. Check analytics data

**Expected Result:** Analytics dashboard displayed

**Status:** ✅ PASSED

---

### 42. Forms List
**URL:** http://localhost:3082/

**Test Steps:**
1. Navigate to forms application
2. Verify forms list displayed
3. Test authentication if required

**Expected Result:** Forms list displayed

**Status:** ⚠️ PARTIAL (May require authentication)

---

### 43. Forms Create
**URL:** http://localhost:3082/create

**Test Steps:**
1. Navigate to create form page
2. Verify form builder displayed
3. Test form creation

**Expected Result:** Form create page displayed

**Status:** ⚠️ PARTIAL (May require authentication)

---

## API Endpoints Testing

### 44. API Gateway Health
**URL:** http://localhost:3010/health

**Test Steps:**
1. Make GET request to health endpoint
2. Verify status: ok

**Expected Result:** Health check returns ok

**Status:** ✅ PASSED

---

### 45. Auth Session
**URL:** http://localhost:3010/auth/session

**Test Steps:**
1. Login to system
2. Make GET request with Bearer token
3. Verify session data returned with tenantId

**Expected Result:** Session data with tenantId returned

**Status:** ✅ PASSED

---

### 46. Onboarding Organizations
**URL:** http://localhost:3010/onboarding/organizations

**Test Steps:**
1. Make POST request with organization data
2. Include x-user-id header
3. Verify organization created

**Expected Result:** Organization created

**Status:** ✅ PASSED

---

### 47. Onboarding Brands
**URL:** http://localhost:3010/onboarding/brands

**Test Steps:**
1. Make POST request with brand data
2. Include x-user-id header
3. Verify brand created

**Expected Result:** Brand created

**Status:** ✅ PASSED

---

### 48. Onboarding Businesses
**URL:** http://localhost:3010/onboarding/businesses

**Test Steps:**
1. Make POST request with business data
2. Include x-user-id header
3. Verify business created

**Expected Result:** Business created

**Status:** ✅ PASSED

---

### 49. Onboarding Franchises
**URL:** http://localhost:3010/onboarding/franchises

**Test Steps:**
1. Make POST request with franchise data
2. Include x-user-id header
3. Verify franchise created

**Expected Result:** Franchise created

**Status:** ✅ PASSED

---

### 50. Create Subscription
**URL:** http://localhost:3010/subscriptions

**Test Steps:**
1. Make POST request with subscription data:
   ```json
   {
     "tenantId": "<tenantId>",
     "planId": "<planId>",
     "status": "active",
     "startDate": "<ISO date>",
     "metadata": {
       "moduleId": "hrms",
       "moduleName": "HRMS"
     }
   }
   ```
2. Include Bearer token
3. Verify subscription created

**Expected Result:** Subscription created with moduleId in metadata

**Status:** ✅ PASSED

---

## Test Results Summary

### Overall Statistics
- **Total Tests:** 50
- **Passed:** 47 (94%)
- **Partial/Failed:** 3 (6%)

### Test Coverage by Category

| Category | Tests | Passed | Status |
|----------|-------|--------|--------|
| Authentication | 3 | 3 | ✅ 100% |
| Onboarding | 5 | 4 | ⚠️ 80% |
| Business Management | 5 | 5 | ✅ 100% |
| HRMS Features | 5 | 5 | ✅ 100% |
| FBMS Features | 2 | 2 | ✅ 100% |
| Billing & Subscriptions | 4 | 4 | ✅ 100% |
| Coupons & Vouchers | 3 | 3 | ✅ 100% |
| Admin Features | 4 | 4 | ✅ 100% |
| Marketing Pages | 8 | 8 | ✅ 100% |
| Other Modules | 3 | 2 | ⚠️ 67% |
| API Endpoints | 7 | 7 | ✅ 100% |

### Known Issues

1. **Business Creation (Onboarding)**
   - Issue: Form field selector may not find business name input
   - Impact: Low - Manual testing works
   - Priority: Medium

2. **Forms List/Create**
   - Issue: Forms application may require authentication
   - Impact: Low - Application accessible but needs auth
   - Priority: Low

---

## Test Execution Guidelines

### Manual Testing
1. Use Chrome/Edge browser
2. Clear browser cache before testing
3. Use test credentials provided
4. Document any deviations from expected results

### Automated Testing
1. Run Selenium test suite: `python3 test-legacy-functionality.py`
2. Review test results log: `test-results.log`
3. Fix any failing tests
4. Re-run until 100% pass rate

### Regression Testing
1. Run full test suite after each deployment
2. Focus on critical paths:
   - Authentication & Onboarding
   - Subscription Management
   - Business Management
3. Verify API endpoints respond correctly

---

## Test Data Requirements

### Test Users
- **Admin User:** admin@keephy.com / Admin123!@#
- **Test User:** test_<timestamp>@example.com / Test123!@#

### Test Organizations
- Use unique names with timestamps
- Include all required fields

### Test Subscriptions
- Use valid tenantId
- Use base plan (e.g., "basic")
- Include moduleId in metadata

---

## Sign-off

**QA Lead:** _________________ Date: _________

**Development Lead:** _________________ Date: _________

**Product Owner:** _________________ Date: _________

---

## Revision History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2025-12-02 | QA Team | Initial testing plan based on Selenium test results |


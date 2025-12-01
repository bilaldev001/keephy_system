# Gap Analysis & Implementation Plan

## Executive Summary
This document identifies missing functionality from the old system and provides an implementation plan to ensure feature parity while maintaining backward compatibility.

---

## 1. EXISTING FUNCTIONALITY (Already Implemented)

### ✅ Authentication & User Management
- User registration, login, password reset
- Google OAuth (needs verification)
- Email verification, OTP
- User profile management
- Payment card management (needs verification)

### ✅ Business & Franchise Management
- CRUD operations for businesses
- CRUD operations for franchises
- Business/franchise forms attachment

### ✅ Forms & Feedback
- Form builder with multiple question types
- Form submissions
- QR code generation
- Form management (CRUD)

### ✅ Employees
- Employee CRUD (HRMS service)
- Employee management

### ✅ Tips
- Tip payment creation (Payroll service)
- Employee tips retrieval
- Location tips retrieval
- Stripe Connect integration

### ✅ Menu Items
- Menu item CRUD (FBMS service)
- Menu item listing

### ✅ Vouchers
- Voucher service exists (needs verification)

### ✅ Subscriptions & Billing
- Subscription management
- Billing service exists

### ✅ Analytics
- Analytics service exists
- Reporting endpoints

---

## 2. MISSING FUNCTIONALITY (To Be Implemented)

### 🔴 HIGH PRIORITY - Core Features

#### 2.1 Gift Cards System
**Status**: ❌ Missing
**Service**: New service or add to `billing-service`
**Endpoints Needed**:
- `POST /gift-cards/template` - Create template
- `GET /gift-cards/templates/organization/:organizationId` - List templates
- `GET /gift-cards/template/:id` - Get template
- `GET /gift-cards/public/:publicLink` - Public template
- `PUT /gift-cards/template/:templateId` - Update template
- `DELETE /gift-cards/template/:templateId` - Delete template
- `POST /gift-cards/create-payment-intent` - Payment intent
- `POST /gift-cards/complete-purchase` - Complete purchase
- `GET /gift-cards/business/:businessId` - Business gift cards
- `GET /gift-cards/verify/:code` - Verify code
- `POST /gift-cards/redeem` - Redeem gift card
- `GET /gift-cards/stats/:businessId` - Statistics

**Frontend Pages Needed**:
- `/gift-cards` - List gift cards
- `/gift-cards/create` - Create gift card
- `/gift-cards/[id]` - Gift card details
- `/gift-cards/[id]/edit` - Edit gift card
- `/purchase-gift-card/[publicLink]` - Public purchase page
- `/thankyou-purchase` - Purchase confirmation

**Database Models**:
- `gift_card_templates` - Template definitions
- `gift_card_purchases` - Purchase records

#### 2.2 Staff Management (Without User Accounts)
**Status**: ❌ Missing
**Service**: Add to `hrms-service` or create `staff-service`
**Endpoints Needed**:
- `GET /staff` - List staff
- `POST /staff` - Create staff
- `PUT /staff/:staffId` - Update staff
- `DELETE /staff/:staffId` - Delete staff

**Frontend Pages Needed**:
- `/staff` - Staff listing
- `/staff/create` - Create staff
- `/staff/[id]` - Staff details
- `/staff/[id]/edit` - Edit staff

**Database Models**:
- `staff` - Staff records (no user account link)

#### 2.3 Shifts & Scheduling
**Status**: ❌ Missing
**Service**: Add to `hrms-service` or `ems-service`
**Endpoints Needed**:
- `GET /shifts` - List shifts
- `POST /shifts` - Create shift
- `PUT /shifts/:id` - Update shift
- `DELETE /shifts/:id` - Delete shift
- `GET /shifts/employee/:employeeId` - Employee shifts
- `GET /shifts/location/:franchiseId` - Location shifts
- `GET /shifts/schedule` - Schedule view

**Frontend Pages Needed**:
- `/shifts-schedule` - Schedule view
- `/shifts` - Shift listing
- `/shifts/create` - Create shift

**Database Models**:
- `shifts` - Shift records
- `shift_assignments` - Employee-shift assignments

#### 2.4 Coupon System
**Status**: ❌ Missing
**Service**: Add to `billing-service` or `voucher-service`
**Endpoints Needed**:
- `POST /coupons` - Create coupon (admin)
- `GET /coupons` - List coupons (admin)
- `DELETE /coupons/:id` - Delete coupon (admin)
- `POST /subscriptions/apply-coupon` - Apply coupon (user)

**Frontend Pages Needed**:
- Admin coupon management (in admin app)

**Database Models**:
- `coupons` - Coupon definitions

#### 2.5 Stripe Express Account Management
**Status**: ⚠️ Partial (tips exist, but onboarding missing)
**Service**: Add to `hrms-service` or `payroll-service`
**Endpoints Needed**:
- `PUT /employees/:id/create-stripe-account` - Create Stripe account
- `PUT /employees/:id/update-onboarding` - Update onboarding
- `GET /employees/:id/regenerate-stripe-link` - Regenerate link
- `POST /employees/:id/stripe-login-link` - Generate login link

**Frontend Pages Needed**:
- `/employee/regenerate-stripe-link/[id]` - Regenerate link

---

### 🟡 MEDIUM PRIORITY - Enhanced Features

#### 2.6 Business Reviews
**Status**: ❌ Missing
**Service**: Add to `fbms-service` or create `reviews-service`
**Endpoints Needed**:
- `POST /businesses/:id/reviews` - Create review
- `GET /businesses/:id/reviews` - List reviews
- `PUT /reviews/:id` - Update review
- `DELETE /reviews/:id` - Delete review

**Frontend Pages Needed**:
- Review display in business details

**Database Models**:
- `reviews` - Review records

#### 2.7 Category & Subcategory Management
**Status**: ❌ Missing
**Service**: Add to `tenant-service` or create `catalog-service`
**Endpoints Needed**:
- `GET /categories` - List categories
- `POST /categories` - Create category
- `GET /categories/:id/subcategories` - Get subcategories
- `POST /categories/:id/subcategories` - Create subcategory

**Frontend Pages Needed**:
- Category selection in business creation

**Database Models**:
- `categories` - Category definitions
- `subcategories` - Subcategory definitions

#### 2.8 Activity Logs
**Status**: ❌ Missing
**Service**: Add to `audit-service`
**Endpoints Needed**:
- `GET /activity-logs` - List activity logs (admin)
- `GET /activity-logs/user/:userId` - User activity
- `GET /activity-logs/business/:businessId` - Business activity

**Frontend Pages Needed**:
- Admin activity log viewer

**Database Models**:
- `activity_logs` - Activity records (may already exist in audit-service)

#### 2.9 Device Analytics
**Status**: ❌ Missing
**Service**: Add to `analytics-service` or `observability-service`
**Endpoints Needed**:
- `GET /analytics/device/:userId` - User device analytics
- `POST /analytics/device` - Track device

**Frontend Pages Needed**:
- Device analytics in admin/user dashboard

**Database Models**:
- `device_analytics` - Device tracking records

#### 2.10 Business Health Check
**Status**: ❌ Missing
**Service**: Add to `analytics-service` or `observability-service`
**Endpoints Needed**:
- `GET /businesses/:id/health` - Business health check
- `GET /businesses/health/summary` - Health summary (admin)

**Frontend Pages Needed**:
- Health check display in business details

---

### 🟢 LOW PRIORITY - Nice to Have

#### 2.11 Refund Requests
**Status**: ❌ Missing
**Service**: Add to `billing-service`
**Endpoints Needed**:
- `POST /refunds` - Create refund request
- `GET /refunds` - List refund requests
- `PUT /refunds/:id/approve` - Approve refund
- `PUT /refunds/:id/reject` - Reject refund

**Database Models**:
- `refund_requests` - Refund request records

#### 2.12 Login History
**Status**: ❌ Missing
**Service**: Add to `identity-service` or `audit-service`
**Endpoints Needed**:
- `GET /login-history` - User login history
- `GET /login-history/user/:userId` - Specific user history

**Database Models**:
- `login_history` - Login records

#### 2.13 API Logging
**Status**: ⚠️ May exist in observability-service
**Service**: Verify in `observability-service`
**Endpoints Needed**:
- `GET /api-logs` - List API logs (admin)
- `GET /api-logs/errors` - Error logs

#### 2.14 User Types
**Status**: ❌ Missing
**Service**: Add to `access-service`
**Endpoints Needed**:
- `POST /user-types` - Create user type (admin)
- `GET /user-types` - List user types
- `PUT /user-types/:id` - Update user type
- `DELETE /user-types/:id` - Delete user type

**Database Models**:
- `user_types` - User type definitions

#### 2.15 Contact Form Submission
**Status**: ❌ Missing
**Service**: Add to `contacts-service` or `support-service`
**Endpoints Needed**:
- `POST /contact` - Submit contact form (public)

**Frontend Pages Needed**:
- Contact form on marketing page

#### 2.16 Form Recommendations
**Status**: ❌ Missing
**Service**: Add to `forms-service`
**Endpoints Needed**:
- `POST /forms/recommend` - Recommend form

---

## 3. IMPLEMENTATION PLAN

### Phase 1: High Priority Features (Week 1-2)

1. **Gift Cards System**
   - Create gift card module in `billing-service` or new service
   - Implement all endpoints
   - Create frontend pages in console app
   - Add database migrations
   - Test with Selenium

2. **Staff Management**
   - Add staff module to `hrms-service`
   - Implement CRUD endpoints
   - Create frontend pages
   - Add database migrations
   - Test with Selenium

3. **Shifts & Scheduling**
   - Add shifts module to `hrms-service` or `ems-service`
   - Implement endpoints
   - Create frontend pages
   - Add database migrations
   - Test with Selenium

4. **Coupon System**
   - Add coupon module to `billing-service`
   - Implement admin endpoints
   - Integrate with subscription service
   - Add database migrations
   - Test with Selenium

5. **Stripe Express Account**
   - Add endpoints to `hrms-service` or `payroll-service`
   - Implement onboarding flow
   - Create frontend pages
   - Test with Selenium

### Phase 2: Medium Priority Features (Week 3-4)

6. **Business Reviews**
7. **Category Management**
8. **Activity Logs**
9. **Device Analytics**
10. **Business Health Check**

### Phase 3: Low Priority Features (Week 5+)

11. **Refund Requests**
12. **Login History**
13. **API Logging** (verify existing)
14. **User Types**
15. **Contact Form**
16. **Form Recommendations**

---

## 4. TESTING STRATEGY

### Selenium Test Coverage

Create comprehensive Selenium tests for:

1. **Authentication Flow**
   - Sign up
   - Login
   - Password reset
   - OTP verification

2. **Business Management**
   - Create business
   - Edit business
   - Delete business
   - View business details

3. **Franchise Management**
   - Create franchise
   - Edit franchise
   - Delete franchise
   - View franchise details

4. **Form Management**
   - Create form
   - Edit form
   - Clone form
   - Delete form
   - Submit form (public)
   - View submissions

5. **Employee Management**
   - Create employee
   - Edit employee
   - Delete employee
   - View employee details

6. **Staff Management** (new)
   - Create staff
   - Edit staff
   - Delete staff
   - View staff list

7. **Tips Management**
   - Create tip payment
   - View employee tips
   - View location tips

8. **Gift Cards** (new)
   - Create gift card template
   - Edit template
   - Delete template
   - Public purchase flow
   - Verify gift card
   - Redeem gift card

9. **Vouchers**
   - Create voucher
   - Edit voucher
   - Delete voucher
   - Verify voucher
   - Redeem voucher

10. **Subscriptions**
    - Subscribe to plan
    - Update subscription
    - Cancel subscription
    - Apply coupon

11. **Shifts** (new)
    - Create shift
    - Assign employee
    - View schedule

12. **Menu Items**
    - Create menu item
    - Edit menu item
    - Delete menu item
    - List menu items

13. **Analytics**
    - View business reports
    - View branch reports
    - View employee tips report

---

## 5. BACKWARD COMPATIBILITY

### Ensuring Existing Users Are Not Affected

1. **Database Migrations**
   - All new tables use new names (no conflicts)
   - Existing tables remain unchanged
   - Additive changes only

2. **API Endpoints**
   - New endpoints use new paths
   - Existing endpoints remain functional
   - Version API if needed (`/api/v1/`, `/api/v2/`)

3. **Frontend**
   - New pages don't replace existing ones
   - Existing routes remain functional
   - Feature flags for gradual rollout

4. **Testing**
   - Run existing test suite
   - Verify all existing endpoints work
   - Test user flows end-to-end

---

## 6. FILE STRUCTURE

### Backend Services
```
backend/services/
├── billing-service/
│   └── src/modules/
│       ├── gift-cards/        # NEW
│       └── coupons/           # NEW
├── hrms-service/
│   └── src/modules/
│       ├── staff/             # NEW
│       └── shifts/            # NEW
├── payroll-service/
│   └── src/modules/
│       └── stripe-express/    # NEW
└── fbms-service/
    └── src/modules/
        └── reviews/           # NEW
```

### Frontend Apps
```
frontend/
├── console/
│   └── src/pages/
│       ├── gift-cards/       # NEW
│       ├── staff/            # NEW
│       └── shifts/           # NEW
└── admin/
    └── src/pages/
        └── coupons/          # NEW
```

---

## 7. NEXT STEPS

1. ✅ Create gap analysis (this document)
2. ⏳ Implement Gift Cards system
3. ⏳ Implement Staff management
4. ⏳ Implement Shifts & Scheduling
5. ⏳ Implement Coupon system
6. ⏳ Implement Stripe Express onboarding
7. ⏳ Create Selenium test suite
8. ⏳ Run comprehensive tests
9. ⏳ Fix any issues
10. ⏳ Deploy and verify

---

## 8. NOTES

- All implementations must maintain backward compatibility
- Use existing patterns and conventions
- Follow ACID, SOLID, DRY principles
- Add proper error handling and validation
- Include i18n support
- Support dark/light mode
- Use existing UI components from `@keephy/ui-core`
- Follow existing authentication/authorization patterns


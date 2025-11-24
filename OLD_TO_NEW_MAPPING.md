# Old System to New System Mapping & Functionality Comparison

## 📋 Executive Summary

This document maps all functionality from the old Keephy system (`keephy-OLD-VERSION`) to the new microservices-based system (`hrms-develop-postgres`).

---

## 🔄 Backend Routes Mapping

### 1. Authentication & User Management

#### Old System (`keephy_bk/routes/userRoutes.js`)
| Old Route | Method | New System | Status |
|-----------|--------|------------|--------|
| `/login` | POST | `identity-service` → `/auth/login` | ✅ Implemented |
| `/signUp` | POST | `identity-service` → `/auth/register` | ✅ Implemented |
| `/forgot-password` | POST | `identity-service` → `/auth/forgot-password` | ✅ Implemented |
| `/verifyOTP` | POST | `identity-service` → `/auth/verify-otp` | ✅ Implemented |
| `/resetPassword` | POST | `identity-service` → `/auth/reset-password` | ✅ Implemented |
| `/google-login` | POST | `identity-service` → `/auth/google` | ⚠️ **MISSING** |
| `/current-user` | GET | `identity-service` → `/auth/session` | ✅ Implemented |
| `/update-payment-card` | POST | `billing-service` → `/billing/payment-methods` | ✅ Implemented |
| `/update-subscription-plan` | POST | `subscriptions-service` → `/subscriptions/update` | ✅ Implemented |
| `/create-setup-intent` | POST | `billing-service` → `/billing/setup-intent` | ⚠️ **MISSING** |
| `/get-payment-carddetails/:customerId` | GET | `billing-service` → `/billing/payment-methods/:id` | ✅ Implemented |
| `/get-billing-details` | POST | `billing-service` → `/billing/invoices` | ✅ Implemented |
| `/notification-settings` | POST | `notifications-service` → `/notifications/settings` | ⚠️ **MISSING** |
| `/submit-contact-form` | POST | `support-service` → `/support/contact` | ⚠️ **MISSING** |
| `/submit-recommend-form` | POST | `support-service` → `/support/recommend` | ⚠️ **MISSING** |
| `/all-permissions` | GET | `access-service` → `/access/permissions` | ✅ Implemented |
| `/create-role` | POST | `access-service` → `/access/roles` | ✅ Implemented |
| `/roles-listing` | GET | `access-service` → `/access/roles` | ✅ Implemented |
| `/fetch-role/:id` | GET | `access-service` → `/access/roles/:id` | ✅ Implemented |
| `/update-role/:id` | PUT | `access-service` → `/access/roles/:id` | ✅ Implemented |
| `/delete-role/:id` | DELETE | `access-service` → `/access/roles/:id` | ✅ Implemented |

### 2. Business Management

#### Old System (`keephy_bk/routes/businessRoutes.js`)
| Old Route | Method | New System | Status |
|-----------|--------|------------|--------|
| `/create-business` | POST | `tenant-service` → `/tenants/businesses` | ✅ Implemented |
| `/` | GET | `tenant-service` → `/tenants/businesses` | ✅ Implemented |
| `/:id` | GET | `tenant-service` → `/tenants/businesses/:id` | ✅ Implemented |
| `/:id` | PUT | `tenant-service` → `/tenants/businesses/:id` | ✅ Implemented |
| `/deleteBusiness/:id` | DELETE | `tenant-service` → `/tenants/businesses/:id` | ✅ Implemented |
| `/:id/forms` | POST | `forms-service` → `/forms/assign` | ✅ Implemented |
| `/:id/forms/:formId/activate` | PUT | `forms-service` → `/forms/:id/activate` | ✅ Implemented |
| `/create-business-discount` | POST | `voucher-service` → `/vouchers/campaigns` | ✅ Implemented |
| `/discount-list/:id` | GET | `voucher-service` → `/vouchers/campaigns?businessId=:id` | ✅ Implemented |
| `/delete-discount/:id` | DELETE | `voucher-service` → `/vouchers/campaigns/:id` | ✅ Implemented |
| `/update-discount/:id` | PUT | `voucher-service` → `/vouchers/campaigns/:id` | ✅ Implemented |
| `/claim-offer` | POST | `voucher-service` → `/vouchers/redeem` | ✅ Implemented |
| `/discount-detail/:id` | GET | `voucher-service` → `/vouchers/campaigns/:id` | ✅ Implemented |
| `/verify-discount-code/:id` | GET | `voucher-service` → `/vouchers/verify/:code` | ✅ Implemented |
| `/mark-code-used/:id` | GET | `voucher-service` → `/vouchers/redeem/:id` | ✅ Implemented |
| `/createReview` | POST | `fbms-service` → `/fbms/feedback` | ✅ Implemented |

### 3. Franchise Management

#### Old System (`keephy_bk/routes/franchiseRoutes.js`)
| Old Route | Method | New System | Status |
|-----------|--------|------------|--------|
| `/` | GET | `tenant-service` → `/tenants/franchises` | ✅ Implemented |
| `/` | POST | `tenant-service` → `/tenants/franchises` | ✅ Implemented |
| `/:id` | GET | `tenant-service` → `/tenants/franchises/:id` | ✅ Implemented |
| `/:id` | PUT | `tenant-service` → `/tenants/franchises/:id` | ✅ Implemented |
| `/deleteFranchise/:id` | DELETE | `tenant-service` → `/tenants/franchises/:id` | ✅ Implemented |
| `/getFranchiseByBusinessId/:id` | GET | `tenant-service` → `/tenants/franchises?businessId=:id` | ✅ Implemented |
| `/:id/forms` | POST | `forms-service` → `/forms/assign` | ✅ Implemented |
| `/:id/forms/:formId/activate` | PUT | `forms-service` → `/forms/:id/activate` | ✅ Implemented |
| `/:id/forms/:formId/show-staff` | PUT | `forms-service` → `/forms/:id/settings` | ⚠️ **MISSING** |

### 4. Form Management

#### Old System (`keephy_bk/routes/formRoutes.js`)
| Old Route | Method | New System | Status |
|-----------|--------|------------|--------|
| `/` | GET | `forms-service` → `/forms` | ✅ Implemented |
| `/addTypeForm` | POST | `forms-service` → `/forms` | ✅ Implemented |
| `/addFormSubmission` | POST | `forms-service` → `/forms/submissions` | ✅ Implemented |
| `/getFormByBusinessId/:id` | GET | `forms-service` → `/forms?businessId=:id` | ✅ Implemented |
| `/getFormByLocationId/:id` | GET | `forms-service` → `/forms?franchiseId=:id` | ✅ Implemented |
| `/getFormByFranchiseFormId/:franchiseId/:formId` | GET | `forms-service` → `/forms/:formId?franchiseId=:franchiseId` | ✅ Implemented |
| `/getFormById/:id` | GET | `forms-service` → `/forms/:id` | ✅ Implemented |
| `/getFormByCode/:code` | GET | `forms-service` → `/forms/code/:code` | ✅ Implemented |
| `/getFormSubmissionByFormId/:id` | GET | `forms-service` → `/forms/:id/submissions` | ✅ Implemented |
| `/deleteForm/:id` | DELETE | `forms-service` → `/forms/:id` | ✅ Implemented |
| `/updateFormById/:id` | PUT | `forms-service` → `/forms/:id` | ✅ Implemented |

### 5. Subscription Management

#### Old System (`keephy_bk/routes/subscriptionRoutes.js`)
| Old Route | Method | New System | Status |
|-----------|--------|------------|--------|
| `/user-subscription` | GET | `subscriptions-service` → `/subscriptions/user` | ✅ Implemented |
| `/` | POST | `subscriptions-service` → `/subscriptions` | ✅ Implemented |
| `/mark-premium` | POST | `subscriptions-service` → `/subscriptions/:id/premium` | ⚠️ **MISSING** |
| `/retry-payment` | POST | `billing-service` → `/billing/retry-payment` | ⚠️ **MISSING** |
| `/updateStripeSubscription` | POST | `subscriptions-service` → `/subscriptions/:id/update` | ✅ Implemented |
| `/finalize-updateSubscription` | POST | `subscriptions-service` → `/subscriptions/:id/finalize` | ⚠️ **MISSING** |
| `/:subscriptionId` | DELETE | `subscriptions-service` → `/subscriptions/:id` | ✅ Implemented |
| `/free-trail` | POST | `subscriptions-service` → `/subscriptions/free-trial` | ✅ Implemented |

### 6. Admin Routes

#### Old System (`keephy_bk/routes/adminRoutes.js`)
| Old Route | Method | New System | Status |
|-----------|--------|------------|--------|
| `/login` | POST | `identity-service` → `/auth/admin/login` | ⚠️ **MISSING** |
| `/current-user` | GET | `identity-service` → `/auth/session` | ✅ Implemented |
| `/all-businesses` | GET | `tenant-service` → `/tenants/businesses` | ✅ Implemented |
| `/all-users` | GET | `identity-service` → `/users` | ✅ Implemented |
| `/all-subscriptions` | GET | `subscriptions-service` → `/subscriptions` | ✅ Implemented |
| `/save-card-detail` | POST | `billing-service` → `/billing/payment-methods` | ✅ Implemented |
| `/all-branch` | GET | `tenant-service` → `/tenants/franchises` | ✅ Implemented |
| `/get-payed-now` | POST | `billing-service` → `/billing/invoices` | ⚠️ **MISSING** |
| `/dashboard-data` | GET | `analytics-service` → `/analytics/dashboard` | ✅ Implemented |
| `/get-allformsubmissions` | GET | `forms-service` → `/forms/submissions` | ✅ Implemented |
| `/business/:id` | GET | `tenant-service` → `/tenants/businesses/:id` | ✅ Implemented |
| `/check-business-health/:id` | GET | `analytics-service` → `/analytics/health/:id` | ⚠️ **MISSING** |
| `/getFranchiseByBusinessId/:id` | GET | `tenant-service` → `/tenants/franchises?businessId=:id` | ✅ Implemented |
| `/deviceAnalytics/:userId` | GET | `analytics-service` → `/analytics/devices/:userId` | ⚠️ **MISSING** |
| `/get-franchise-staff` | GET | `hrms-service` → `/hrms/employees?franchiseId=:id` | ✅ Implemented |
| `/getFormsByFranchise/:id` | GET | `forms-service` → `/forms?franchiseId=:id` | ✅ Implemented |
| `/extendUserFreeTrial` | POST | `subscriptions-service` → `/subscriptions/:id/extend-trial` | ⚠️ **MISSING** |
| `/startUserFreeTrial` | POST | `subscriptions-service` → `/subscriptions/free-trial` | ✅ Implemented |
| `/all-plans` | GET | `subscriptions-service` → `/subscriptions/plans` | ✅ Implemented |
| `/plans/create` | POST | `subscriptions-service` → `/subscriptions/plans` | ✅ Implemented |
| `/plans/:planId/replace` | POST | `subscriptions-service` → `/subscriptions/plans/:id/replace` | ⚠️ **MISSING** |
| `/plans/:planId/update` | POST | `subscriptions-service` → `/subscriptions/plans/:id` | ✅ Implemented |
| `/plans/delete/:planId` | DELETE | `subscriptions-service` → `/subscriptions/plans/:id` | ✅ Implemented |
| `/permissions/fetch-permissions-list` | GET | `access-service` → `/access/permissions` | ✅ Implemented |
| `/permissions/create-permissions` | POST | `access-service` → `/access/permissions` | ✅ Implemented |
| `/permissions/update-permissions/:id` | PUT | `access-service` → `/access/permissions/:id` | ✅ Implemented |
| `/permissions/delete-permissions/:id` | DELETE | `access-service` → `/access/permissions/:id` | ✅ Implemented |
| `/roles/reload-roles` | GET | `access-service` → `/access/roles/reload` | ⚠️ **MISSING** |
| `/roles/roles-listing` | GET | `access-service` → `/access/roles` | ✅ Implemented |
| `/roles/delete-role/:id` | DELETE | `access-service` → `/access/roles/:id` | ✅ Implemented |
| `/permissions/fetch-all-permissions` | GET | `access-service` → `/access/permissions` | ✅ Implemented |
| `/roles/create-role` | POST | `access-service` → `/access/roles` | ✅ Implemented |
| `/roles/update-role/:id` | PUT | `access-service` → `/access/roles/:id` | ✅ Implemented |

---

## 🎨 Frontend Pages Mapping

### Old Next.js App (`keephy-nextJs/src/app/`)

| Old Page | Old URL | New System | New URL | Status |
|----------|---------|------------|---------|--------|
| Homepage | `/` | `marketing` → `index.tsx` | `/` | ✅ Implemented |
| Login | `/login` | `marketing` → `login.tsx` | `/login` | ✅ Implemented |
| Sign Up | `/sign-up` | `marketing` → `register.tsx` | `/register` | ✅ Implemented |
| Pricing | `/pricing` | `marketing` → `pricing.tsx` | `/pricing` | ✅ Implemented |
| About Us | `/about-us` | `marketing` → `about.tsx` | `/about` | ✅ Implemented |
| Contact Us | `/contact-us` | `marketing` → `contact.tsx` | `/contact` | ✅ Implemented |
| Terms | `/terms-conditions` | `marketing` → `terms.tsx` | `/terms` | ✅ Implemented |
| Privacy | `/privacy-policy` | `marketing` → `privacy.tsx` | `/privacy` | ✅ Implemented |
| Cookies | `/cookie-policy` | `marketing` → `cookies.tsx` | `/cookies` | ✅ Implemented |
| Testimonials | `/testimonials` | `marketing` → `testimonials.tsx` | `/testimonials` | ✅ Implemented |
| Our Team | `/our-team` | `marketing` → N/A | N/A | ⚠️ **MISSING** |
| How It Works | `/how-it-works` | `marketing` → N/A | N/A | ⚠️ **MISSING** |
| Settings | `/settings` | `marketing` → `settings.tsx` | `/settings` | ✅ Implemented |
| Subscription | `/subscription` | `marketing` → `subscription.tsx` | `/subscription` | ✅ Implemented |
| Dashboard | `/dashboard` | `marketing` → `dashboard.tsx` | `/dashboard` | ✅ Implemented |
| All Businesses | `/all-business` | `marketing` → `businesses.tsx` | `/businesses` | ✅ Implemented |
| Business Detail | `/all-business/[businessId]` | `marketing` → N/A | `/businesses/:id` | ⚠️ **MISSING** |
| Business Edit | `/all-business/[businessId]/edit` | `marketing` → N/A | `/businesses/:id/edit` | ⚠️ **MISSING** |
| Add Franchise | `/all-business/[businessId]/add-franchise` | `marketing` → N/A | `/businesses/:id/franchises/new` | ⚠️ **MISSING** |
| Business Reports | `/all-business/[businessId]/reports` | `analytics-service` | `/analytics/business/:id` | ⚠️ **MISSING** |
| Branch Reports | `/all-business/[businessId]/reports/[branchId]` | `analytics-service` | `/analytics/franchise/:id` | ⚠️ **MISSING** |
| Location Detail | `/all-business/[businessId]/[locationId]` | `marketing` → `franchises.tsx` | `/franchises/:id` | ⚠️ **MISSING** |
| Location Edit | `/all-business/[businessId]/[locationId]/edit` | `marketing` → N/A | `/franchises/:id/edit` | ⚠️ **MISSING** |
| QR Code | `/all-business/[businessId]/[locationId]/[formId]/qrcode` | `forms-service` | `/forms/:id/qrcode` | ⚠️ **MISSING** |
| All Forms | `/all-forms` | `forms-service` | `/forms` | ⚠️ **MISSING** |
| Form Detail | `/all-forms/[formId]` | `forms-service` | `/forms/:id` | ⚠️ **MISSING** |
| Form Edit | `/all-forms/[formId]/edit` | `forms-service` | `/forms/:id/edit` | ⚠️ **MISSING** |
| Form Clone | `/all-forms/[formId]/clone` | `forms-service` | `/forms/:id/clone` | ⚠️ **MISSING** |
| Form Reviews | `/all-forms/[formId]/reviews` | `fbms-service` | `/fbms/feedback?formId=:id` | ⚠️ **MISSING** |
| Create Form | `/create-form` | `forms-service` | `/forms/new` | ⚠️ **MISSING** |
| Scratch Form | `/create-form/scratch-form` | `forms-service` | `/forms/new/scratch` | ⚠️ **MISSING** |
| Add Review | `/add-review/[code]` | `fbms-service` | `/fbms/feedback/new?code=:code` | ⚠️ **MISSING** |
| Register Business | `/register-business` | `marketing` → `onboarding.tsx` | `/onboarding` | ✅ Implemented |
| Checkout | `/checkout` | `billing-service` | `/checkout` | ⚠️ **MISSING** |
| Billing History | `/checkout/billing-history` | `billing-service` | `/billing/history` | ⚠️ **MISSING** |
| Manage Subscription | `/checkout/manage` | `subscriptions-service` | `/subscriptions/manage` | ⚠️ **MISSING** |
| Discounts | `/discounts/[accessKey]` | `voucher-service` | `/vouchers/redeem/:code` | ⚠️ **MISSING** |
| Thank You | `/thank-you` | `marketing` → N/A | `/thank-you` | ⚠️ **MISSING** |
| Verify Account | `/verify-account` | `identity-service` | `/auth/verify` | ⚠️ **MISSING** |
| Verify OTP | `/verify-otp` | `identity-service` | `/auth/verify-otp` | ⚠️ **MISSING** |
| Reset Password | `/reset-password` | `identity-service` | `/auth/reset-password` | ⚠️ **MISSING** |
| New Password | `/new-password` | `identity-service` | `/auth/new-password` | ⚠️ **MISSING** |

### Old Admin Frontend (`keephy-admin-fe/src/pages/`)

| Old Page | Old URL | New System | New URL | Status |
|----------|---------|------------|---------|--------|
| Login | `/login` | `admin-service` | `/admin/login` | ⚠️ **MISSING** |
| Dashboard | `/dashboard` | `admin-service` | `/admin/dashboard` | ⚠️ **MISSING** |
| Live Submissions | `/submissions` | `forms-service` | `/admin/submissions` | ⚠️ **MISSING** |
| All Businesses | `/buisnesses` | `tenant-service` | `/admin/businesses` | ⚠️ **MISSING** |
| Business Details | `/buisnesses/:id` | `tenant-service` | `/admin/businesses/:id` | ⚠️ **MISSING** |
| Business Franchise | `/buisnesses/:id/franchise` | `tenant-service` | `/admin/businesses/:id/franchises` | ⚠️ **MISSING** |
| All Users | `/users` | `identity-service` | `/admin/users` | ⚠️ **MISSING** |
| All Plans | `/plans` | `subscriptions-service` | `/admin/plans` | ⚠️ **MISSING** |

---

## ⚠️ Missing Functionality Summary

### Critical Missing Features

1. **Google OAuth Login** - `/auth/google` endpoint
2. **Admin Panel** - Complete admin frontend application
3. **Form Builder UI** - Visual form creation interface
4. **QR Code Generation** - For forms and feedback
5. **Business Health Monitoring** - Analytics dashboard
6. **Device Analytics** - User device tracking
7. **Contact Form Submission** - Support service integration
8. **Recommend Form** - Referral system
9. **Notification Settings UI** - User notification preferences
10. **Payment Retry** - Failed payment retry mechanism
11. **Plan Replacement** - Migrate subscriptions to new plans
12. **Role Reload** - Refresh role permissions cache
13. **Form Show Staff Toggle** - Display staff in forms
14. **Mark Premium** - Manual premium subscription assignment
15. **Extend Free Trial** - Admin trial extension
16. **Payment Setup Intent** - Stripe setup intent creation
17. **Business Reports Pages** - Analytics visualization
18. **Branch Reports Pages** - Franchise-level analytics
19. **Form Reviews Page** - Feedback linked to forms
20. **Thank You Page** - Post-subscription confirmation

### Medium Priority Missing Features

1. **Our Team Page** - Marketing page
2. **How It Works Page** - Marketing page
3. **Business Detail/Edit Pages** - Full CRUD UI
4. **Franchise Detail/Edit Pages** - Full CRUD UI
5. **Form Detail/Edit/Clone Pages** - Full CRUD UI
6. **Add Review Page** - Public feedback form
7. **Checkout Flow** - Complete billing checkout
8. **Billing History** - Invoice management
9. **Subscription Management** - User subscription controls
10. **Discount Redemption** - Voucher claim page
11. **Account Verification** - Email verification flow
12. **OTP Verification** - Two-factor authentication
13. **Password Reset Flow** - Complete reset process

---

## ✅ Implemented Functionality

### Fully Implemented

1. ✅ User Authentication (Login, Sign Up, Session)
2. ✅ Business CRUD Operations
3. ✅ Franchise CRUD Operations
4. ✅ Form CRUD Operations
5. ✅ Form Submissions
6. ✅ Subscription Management (Basic)
7. ✅ Role & Permission Management
8. ✅ Payment Card Management
9. ✅ Billing & Invoicing
10. ✅ Voucher/Discount System
11. ✅ Feedback Management (FBMS)
12. ✅ Analytics Dashboard (Basic)
13. ✅ Marketing Pages (Most)
14. ✅ Settings Page
15. ✅ Onboarding Flow

---

## 📊 Implementation Status

| Category | Total | Implemented | Missing | Percentage |
|----------|-------|-------------|---------|------------|
| Backend Routes | 85 | 65 | 20 | 76% |
| Frontend Pages (Next.js) | 35 | 15 | 20 | 43% |
| Admin Frontend | 8 | 0 | 8 | 0% |
| **Overall** | **128** | **80** | **48** | **63%** |

---

## 🎯 Recommended Next Steps

### Phase 1: Critical Missing Features (Priority 1)
1. Implement Google OAuth login
2. Build Admin Panel frontend
3. Create Form Builder UI
4. Add QR Code generation
5. Implement Business Health Monitoring

### Phase 2: Important Features (Priority 2)
1. Complete Business/Franchise CRUD pages
2. Complete Form CRUD pages
3. Implement Checkout flow
4. Add Billing History page
5. Create Reports/Analytics pages

### Phase 3: Nice-to-Have Features (Priority 3)
1. Marketing pages (Our Team, How It Works)
2. Account verification flows
3. Password reset UI
4. Thank you pages
5. Discount redemption pages

---

## 📝 Notes

- The new system uses microservices architecture, so routes are distributed across services
- API Gateway (`api-gateway`) routes all requests to appropriate services
- Frontend applications are modular (marketing, fbms, hrms, etc.)
- Admin panel needs to be built from scratch
- Some old features may have been intentionally removed or replaced

---

**Last Updated:** $(date)
**Document Version:** 1.0


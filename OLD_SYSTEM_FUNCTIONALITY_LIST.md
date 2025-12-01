# Old System - Complete Functionality List

## Overview
This document lists all functionality available in the old system located at `/old_system/keephy_bk` (Backend) and `/old_system/keephy-nextJs` (Frontend).

---

## 1. AUTHENTICATION & USER MANAGEMENT

### Authentication Features
- **User Registration** (`POST /api/v1/user/signUp`)
  - Email/password signup
  - Password confirmation
  - Country selection
  - Email verification (OTP)

- **User Login** (`POST /api/v1/user/login`)
  - Email/password authentication
  - JWT token generation
  - Last login tracking

- **Google OAuth Login** (`POST /api/v1/user/google-login`)
  - Social login with Google
  - Automatic account creation

- **Password Management**
  - Forgot password (`POST /api/v1/user/forgot-password`)
  - OTP verification (`POST /api/v1/user/verifyOTP`)
  - Reset password (`POST /api/v1/user/resetPassword`)
  - New password (`/new-password`)

- **Account Verification**
  - Email verification (`/verify-account`)
  - OTP verification (`/verify-otp`)

### User Profile & Settings
- **Current User** (`GET /api/v1/user/current-user`)
  - Get user profile
  - Business/franchise counts
  - Subscription status

- **Settings Page** (`/settings`)
  - Profile management
  - Notification settings (`POST /api/v1/user/notification-settings`)
  - Payment card management

- **Payment Card Management**
  - Add payment card (`POST /api/v1/user/addCard`)
  - Update payment card (`POST /api/v1/user/update-payment-card`)
  - Get card details (`GET /api/v1/user/get-payment-carddetails/:customerId`)
  - Create setup intent (`POST /api/v1/user/create-setup-intent`)

- **Stripe Express Account**
  - Create Stripe account (`PUT /api/v1/user/create-stripe-account/:id`)
  - Update onboarding (`PUT /api/v1/user/update-onboarding/:stripeAccountId`)
  - Regenerate Stripe link (`/employee/regenerate-stripe-link/[id]`)

---

## 2. BUSINESS MANAGEMENT

### Business CRUD Operations
- **List All Businesses** (`GET /api/v1/business`)
  - View all user businesses
  - Permission: `business/listing`

- **Create Business** (`POST /api/v1/business/create-business`)
  - Business registration (`/register-business`)
  - Name, category, subcategory
  - Primary email, reporting emails
  - Logo upload
  - Address management
  - Permission: `business/create`

- **Get Business Details** (`GET /api/v1/business/:id`)
  - Single business view (`/all-business/[businessId]`)
  - Business information
  - Related franchises
  - Permission: `business/detail`

- **Update Business** (`PUT /api/v1/business/:id`)
  - Edit business (`/all-business/[businessId]/edit`)
  - Update details, logo, emails
  - Permission: `business/edit`

- **Delete Business** (`DELETE /api/v1/business/deleteBusiness/:id`)
  - Soft delete business
  - Permission: `business/delete`

### Business Features
- **Business Dashboard** (`/all-business/[businessId]`)
  - Business overview
  - Franchise list
  - Form attachments
  - Discounts management
  - Service items

- **Business Forms**
  - Attach forms to business (`POST /api/v1/business/:id/forms`)
  - Activate form (`PUT /api/v1/business/:id/forms/:formId/activate`)

- **Business Reviews**
  - Create review (`POST /api/v1/business/createReview`)
  - Rating (1-5 stars)
  - Description

---

## 3. FRANCHISE/LOCATION MANAGEMENT

### Franchise CRUD Operations
- **List Franchises** (`GET /api/v1/franchise`)
  - All franchises

- **Get Franchises by Business** (`GET /api/v1/franchise/getFranchiseByBusinessId/:id`)
  - Business-specific franchises

- **Create Franchise** (`POST /api/v1/franchise`)
  - Add franchise (`/all-business/[businessId]/add-franchise`)
  - Franchise name
  - Primary email, reporting emails
  - Opening/closing hours
  - Address
  - Permission: `franchise/create`

- **Get Franchise Details** (`GET /api/v1/franchise/:id`)
  - Single franchise view (`/all-business/[businessId]/[locationId]`)
  - Franchise information
  - Employees list
  - Forms attached

- **Update Franchise** (`PUT /api/v1/franchise/:id`)
  - Edit franchise (`/all-business/[businessId]/[locationId]/edit`)
  - Update details, hours, emails
  - Permission: `franchise/edit`

- **Delete Franchise** (`DELETE /api/v1/franchise/deleteFranchise/:id`)
  - Soft delete franchise
  - Permission: `franchise/delete`

### Franchise Features
- **Franchise Forms**
  - Attach forms (`POST /api/v1/franchise/:id/forms`)
  - Activate form (`PUT /api/v1/franchise/:id/forms/:formId/activate`)
  - Show staff toggle (`PUT /api/v1/franchise/:id/forms/:formId/show-staff`)
  - QR code generation (`/all-business/[businessId]/[locationId]/[formId]/qrcode`)

- **Franchise Employees**
  - View employees (`/all-business/[businessId]/[locationId]`)
  - Employee management

---

## 4. FORM BUILDER & MANAGEMENT

### Form CRUD Operations
- **List All Forms** (`GET /api/v1/form`)
  - All forms page (`/all-forms`)
  - Pagination support
  - Permission: `form/listing`

- **Create Form** (`POST /api/v1/form/addTypeForm`)
  - Create form (`/create-form`)
  - Create from scratch (`/create-form/scratch-form`)
  - Form name, description
  - Question types:
    - Rating (1-5 stars)
    - Dropdown
    - Multiple Choice
    - Yes/No
    - Short Text
    - Long Text
    - Rating Scale
    - NPS Scale
  - Permission: `form/create`

- **Get Form Details** (`GET /api/v1/form/getFormById/:id`)
  - Single form view (`/all-forms/[formId]`)
  - Form schema
  - Submissions count
  - Permission: `form/detail`

- **Get Form by Code** (`GET /api/v1/form/getFormByCode/:code`)
  - Public form access (`/add-review/[code]`)
  - No authentication required

- **Update Form** (`PUT /api/v1/form/updateFormById/:id`)
  - Edit form (`/all-forms/[formId]/edit`)
  - Update questions, styling
  - Permission: `form/edit`

- **Clone Form** (`/all-forms/[formId]/clone`)
  - Duplicate existing form

- **Delete Form** (`DELETE /api/v1/form/deleteForm/:id`)
  - Soft delete form
  - Permission: `form/delete`

### Form Features
- **Form Attachments**
  - Get forms by location (`GET /api/v1/form/getFormByLocationId/:id`)
  - Get forms by franchise (`GET /api/v1/form/getFormByFranchiseFormId/:franchiseId/:formId`)
  - Permission: `form/attached_listing`

- **Form Submissions**
  - Submit form (`POST /api/v1/form/addFormSubmission`)
  - View submissions (`/all-forms/[formId]/reviews`)
  - Get submissions by form (`GET /api/v1/form/getFormSubmissionByFormId/:id`)
  - Permission: `form/submissions`

- **Form QR Codes**
  - Generate QR code (`/all-business/[businessId]/[locationId]/[formId]/qrcode`)
  - Permission: `form/qr`

---

## 5. EMPLOYEE MANAGEMENT

### Employee CRUD Operations
- **List Employees** (`GET /api/v1/employee`)
  - All employees page (`/all-employees`)
  - Pagination support
  - Permission: `employee/listing`

- **Create Employee** (`POST /api/v1/employee`)
  - Create employee (`/all-employees/create`)
  - Employee details
  - Role assignment
  - Franchise assignment
  - Permission: `employee/create`

- **Get Employee Details** (`GET /api/v1/employee/:id`)
  - Single employee view (`/all-employees/[id]`)
  - Employee information
  - Tips history
  - Work schedule
  - Permission: `employee/edit`

- **Get Employee by User ID** (`GET /api/v1/employee/get-by-userId/:userId`)
  - Employee details by user

- **Update Employee** (`PUT /api/v1/employee/:id`)
  - Edit employee (`/all-employees/[id]/edit`)
  - Update details, status
  - Permission: `employee/edit`

- **Delete Employee** (`DELETE /api/v1/employee/:id`)
  - Soft delete employee
  - Permission: `employee/delete`

### Employee Features
- **Employee Franchises** (`GET /api/v1/employee/franchises/:id/:businessId`)
  - View employee's franchises

- **Franchise Employees** (`GET /api/v1/employee/get-franchise-employees`)
  - List employees by franchise
  - Permission: `employee/frenchise_listing`

- **Employee Tips**
  - Tips page (`/tips`)
  - Employee tips chart
  - Tips overview card
  - Daily/weekly/monthly filters
  - Employee tips report (`GET /api/v1/report/employee-tips-report/:employeeId`)

- **Stripe Integration**
  - Generate Stripe login link (`POST /api/v1/employee/stripe-login-link`)
  - Regenerate Stripe link (`GET /api/v1/employee/regenerate-stripe-link/:userId`)
  - Create tip payment (`POST /api/v1/employee/create-tip-payment`)

---

## 6. STAFF MANAGEMENT

### Staff CRUD Operations
- **List Staff** (`GET /api/v1/staff`)
  - View all staff
  - Permission required

- **Create Staff** (`POST /api/v1/staff`)
  - Add new staff member
  - No user account required

- **Update Staff** (`PUT /api/v1/staff/:staffId`)
  - Edit staff details

- **Delete Staff** (`DELETE /api/v1/staff/:staffId`)
  - Remove staff member

---

## 7. ROLES & PERMISSIONS (RBAC)

### Role Management
- **List Roles** (`GET /api/v1/user/roles-listing`)
  - Roles page (`/roles`)
  - All roles listing
  - Permission: `role/listing`

- **Create Role** (`POST /api/v1/user/create-role`)
  - Create role (`/create-role`)
  - Role name, description
  - Permission assignment
  - Permission: `role/create`

- **Get Role Details** (`GET /api/v1/user/fetch-role/:id`)
  - Single role view (`/roles/[roleId]`)
  - Role permissions
  - Permission: `role/edit`

- **Update Role** (`PUT /api/v1/user/update-role/:id`)
  - Edit role permissions
  - Permission: `role/edit`

- **Delete Role** (`DELETE /api/v1/user/delete-role/:id`)
  - Remove role
  - Permission: `role/delete`

- **Reload Roles** (`GET /api/v1/admin/roles/reload-roles`)
  - Admin only

### Permission Management
- **List All Permissions** (`GET /api/v1/user/all-permissions`)
  - Get all available permissions

- **Admin Permission Management**
  - Fetch permissions (`GET /api/v1/admin/permissions/fetch-permissions-list`)
  - Create permission (`POST /api/v1/admin/permissions/create-permissions`)
  - Update permission (`PUT /api/v1/admin/permissions/update-permissions/:id`)
  - Delete permission (`DELETE /api/v1/admin/permissions/delete-permissions/:id`)
  - Get all permissions (`GET /api/v1/admin/permissions/fetch-all-permissions`)

---

## 8. SUBSCRIPTION & BILLING

### Subscription Management
- **User Subscription** (`GET /api/v1/subscription/user-subscription`)
  - Subscription page (`/subscription`)
  - Current subscription details
  - Plan information

- **Create Subscription** (`POST /api/v1/subscription`)
  - Subscribe to plan
  - Stripe payment processing

- **Update Subscription** (`POST /api/v1/subscription/updateStripeSubscription`)
  - Upgrade/downgrade plan
  - Finalize update (`POST /api/v1/subscription/finalize-updateSubscription`)

- **Cancel Subscription** (`DELETE /api/v1/subscription/:subscriptionId`)
  - Cancel subscription modal
  - Subscription cancellation

- **Free Trial**
  - Start free trial (`POST /api/v1/subscription/free-trail`)
  - 14-day free trial
  - Extend free trial (admin)

- **Mark Premium** (`POST /api/v1/subscription/mark-premium`)
  - Admin function

### Billing & Payments
- **Checkout** (`/checkout`)
  - Payment form
  - Plan selection
  - Stripe integration

- **Billing History** (`/checkout/billing-history`)
  - Invoice list
  - Payment history

- **Manage Payment** (`/checkout/manage`)
  - Payment method management
  - Update card details

- **Retry Payment** (`POST /api/v1/subscription/retry-payment`)
  - Retry failed payment
  - Payment retry modal

- **Apply Coupon** (`POST /api/v1/subscription/apply-coupon`)
  - Apply discount coupon

### Plans Management
- **Get Active Plans** (`GET /api/v1/plan`)
  - Pricing page (`/pricing`)
  - All available plans

- **Admin Plan Management**
  - Get all plans (`GET /api/v1/admin/all-plans`)
  - Create plan (`POST /api/v1/admin/plans/create`)
  - Update plan (`POST /api/v1/admin/plans/:planId/update`)
  - Replace plan (`POST /api/v1/admin/plans/:planId/replace`)
  - Delete plan (`DELETE /api/v1/admin/plans/delete/:planId`)

---

## 9. VOUCHERS & DISCOUNTS

### Voucher Management
- **List Vouchers** (`GET /api/v1/voucher`)
  - View all vouchers
  - Voucher history (`/voucher-history`)
  - Recent redeemed vouchers (`GET /api/v1/voucher/recent-redeemed-vouchers`)

- **Create Voucher** (`POST /api/v1/voucher/create`)
  - Create promotional voucher
  - Menu item selection
  - Discount type (percentage/fixed)
  - Expiry date

- **Get Voucher Details** (`GET /api/v1/voucher/:voucherId`)
  - Single voucher view
  - Voucher information

- **Update Voucher** (`PUT /api/v1/voucher/:voucherId`)
  - Edit voucher (`/all-business/[businessId]/edit-promotional-voucher/[voucherId]`)
  - Update details

- **Delete Voucher** (`DELETE /api/v1/voucher/:voucherId`)
  - Remove voucher

- **Redeem Voucher** (`POST /api/v1/voucher/redeem`)
  - Voucher code redemption
  - Verification

- **Verify Voucher** (`GET /api/v1/voucher/verification/:code`)
  - Voucher verification page (`/voucher-verifications`)
  - Code validation

- **Voucher Logs** (`GET /api/v1/voucher/logs/:id`)
  - Redemption history

### Discount Management
- **Create Business Discount** (`POST /api/v1/voucher/create-business-discount`)
  - Create discount offer
  - QR code generation

- **Get Discount List** (`GET /api/v1/business/discount-list/:id`)
  - Business discounts
  - Permission: `discount/detail`

- **Get Discount Detail** (`GET /api/v1/business/discount-detail/:id`)
  - Single discount view

- **Update Discount** (`PUT /api/v1/voucher/update-discount/:id`)
  - Edit discount

- **Delete Discount** (`DELETE /api/v1/voucher/delete-discount/:id`)
  - Remove discount

- **Claim Discount** (`POST /api/v1/business/claim-offer`)
  - Claim discount page (`/discounts/[accessKey]`)
  - Customer claim flow

- **Verify Discount Code** (`GET /api/v1/business/verify-discount-code/:id`)
  - QR code verification

- **Mark Code Used** (`GET /api/v1/business/mark-code-used/:id`)
  - Mark discount as used

---

## 10. GIFT CARDS

### Gift Card Template Management
- **Create Template** (`POST /api/v1/gift-card/template`)
  - Create gift card (`/gift-cards/create`)
  - Template title, amount
  - Business association

- **List Templates** (`GET /api/v1/gift-card/templates/organization/:organizationId`)
  - Gift cards page (`/gift-cards`)
  - All templates

- **Get Template** (`GET /api/v1/gift-card/template/:id`)
  - Single template view (`/gift-cards/[id]`)

- **Get Public Template** (`GET /api/v1/gift-card/public/:publicLink`)
  - Public purchase page (`/purchase-gift-card/[publicLink]`)

- **Update Template** (`PUT /api/v1/gift-card/template/:templateId`)
  - Edit template (`/gift-cards/[id]/edit`)

- **Delete Template** (`DELETE /api/v1/gift-card/template/:templateId`)
  - Remove template

### Gift Card Purchase & Redemption
- **Create Payment Intent** (`POST /api/v1/gift-card/create-payment-intent`)
  - Stripe payment setup
  - Public access

- **Complete Purchase** (`POST /api/v1/gift-card/complete-purchase`)
  - Finalize purchase
  - Thank you page (`/thankyou-purchase`)

- **Get Gift Cards by Business** (`GET /api/v1/gift-card/business/:businessId`)
  - Business gift cards

- **Verify Gift Card** (`GET /api/v1/gift-card/verify/:code`)
  - Code verification

- **Redeem Gift Card** (`POST /api/v1/gift-card/redeem`)
  - Full redemption only
  - Staff/business owner access

- **Gift Card Stats** (`GET /api/v1/gift-card/stats/:businessId`)
  - Business statistics

---

## 11. MENU ITEMS

### Menu Item Management
- **Create Menu Item** (`POST /api/v1/menu-item/create`)
  - Add single menu item
  - Item details, pricing

- **Bulk Create** (`POST /api/v1/menu-item/create-bulk`)
  - Add multiple items
  - CSV import support

- **List Menu Items** (`GET /api/v1/menu-item/listing`)
  - All menu items
  - Business/franchise filter

- **Get by IDs** (`POST /api/v1/menu-item/get-by-ids`)
  - Get specific items

- **Update Menu Item** (`PUT /api/v1/menu-item/update/:id`)
  - Edit item details

- **Delete Menu Item** (`DELETE /api/v1/menu-item/delete/:id`)
  - Remove item

---

## 12. ANALYTICS & REPORTING

### Business Reports
- **All Franchises** (`GET /api/v1/report/all-franchises/:id`)
  - Franchise list for business

- **Performance Table** (`GET /api/v1/report/performance-table/:id`)
  - Business performance metrics

- **Feedback Volume Chart** (`GET /api/v1/report/feedback-volume-chart/:id`)
  - Feedback volume over time

- **Performance Map Chart** (`GET /api/v1/report/performance-map-chart/:id`)
  - Geographic performance

- **Distribution Pie Chart** (`GET /api/v1/report/distribution-pie-chart/:id`)
  - Rating distribution

- **Category Comparison Radar** (`GET /api/v1/report/category-comparison-radar/:id`)
  - Multi-category comparison

- **Rating Over Time** (`GET /api/v1/report/rating-over-time-line/:id`)
  - Rating trends

- **Current Distribution** (`GET /api/v1/report/current-distribution-chart/:id`)
  - Current rating distribution

- **Distribution Trend** (`GET /api/v1/report/distribution-trend-chart/:id`)
  - Distribution trends

- **Branch Location Performance** (`GET /api/v1/report/branch-location-performance/:id`)
  - Location comparison

- **Work Schedule Table** (`GET /api/v1/report/work-schedule-table/:id`)
  - Employee schedules

- **Time Analysis Heatmap** (`GET /api/v1/report/time-analysis-heatmap/:id`)
  - Time-based analysis

- **Insights Summary** (`GET /api/v1/report/insights-summary/:id`)
  - Business insights

- **Live Reports** (`GET /api/v1/report/live-reports/:id`)
  - Real-time data

- **Live Comments** (`GET /api/v1/report/live-comments/:id`)
  - Recent feedback comments

- **NPS Pie Chart** (`GET /api/v1/report/nps-pie-chart/:id`)
  - NPS distribution

### Branch Reports
- **Branch Performance Summary** (`GET /api/v1/report/branch-performance-summary/:id`)
  - Single branch overview

- **Branch Heat Performance** (`GET /api/v1/report/branch-heat-performance/:id`)
  - Branch heatmap

- **Branch Rating Trend** (`GET /api/v1/report/branch-rating-trend/:branchId`)
  - Branch trends

- **Single Branch Reports** (`GET /api/v1/report/single-branch-reports/:id`)
  - Complete branch analytics
  - Reports page (`/all-business/[businessId]/reports`)
  - Branch reports (`/all-business/[businessId]/reports/[branchId]`)

### Tips Reports
- **Tips Report Chart** (`GET /api/v1/report/tips-report-chart/:businessId`)
  - Tips visualization

- **Tips Report Table** (`GET /api/v1/report/tips-report-table/:businessId`)
  - Tips data table

- **Employee Tips Report** (`GET /api/v1/report/employee-tips-report/:employeeId`)
  - Individual employee tips

### Voucher Reports
- **Voucher Reporting** (`GET /api/v1/report/voucher-reports/:businessId`)
  - Voucher analytics

---

## 13. ADMIN PORTAL

### Admin Authentication
- **Admin Login** (`POST /api/v1/admin/login`)
  - Admin authentication

- **Current Admin User** (`GET /api/v1/admin/current-user`)
  - Admin profile

### Admin Dashboard
- **Dashboard Data** (`GET /api/v1/admin/dashboard-data`)
  - Business count
  - Submissions today
  - Trials ending soon
  - Active subscriptions
  - Recent submissions
  - Business summary

### Business Management (Admin)
- **All Businesses** (`GET /api/v1/admin/all-businesses`)
  - View all businesses

- **Business Details** (`GET /api/v1/admin/business/:id`)
  - Single business admin view

- **Check Business Health** (`GET /api/v1/admin/check-business-health/:id`)
  - Business health check

- **Franchises by Business** (`GET /api/v1/admin/getFranchiseByBusinessId/:id`)
  - Business franchises

- **Forms by Franchise** (`GET /api/v1/admin/getFormsByFranchise/:id`)
  - Franchise forms

### User Management (Admin)
- **All Users** (`GET /api/v1/admin/all-users`)
  - User listing

- **All Business Owners** (`GET /api/v1/admin/all-business-owners`)
  - Business owner list

- **User Device Analytics** (`GET /api/v1/admin/deviceAnalytics/:userId`)
  - Device tracking

### Subscription Management (Admin)
- **All Subscriptions** (`GET /api/v1/admin/all-subscriptions`)
  - Subscription listing

- **Extend Free Trial** (`POST /api/v1/admin/extendUserFreeTrial`)
  - Trial extension

- **Start Free Trial** (`POST /api/v1/admin/startUserFreeTrial`)
  - Trial activation

### Form Management (Admin)
- **All Form Submissions** (`GET /api/v1/admin/get-allformsubmissions`)
  - All submissions

- **Franchise Employees** (`GET /api/v1/admin/get-franchise-employees`)
  - Employee list

### Payment Management (Admin)
- **Save Payment Card** (`POST /api/v1/admin/save-card-detail`)
  - Card management

- **Get Paid Now** (`POST /api/v1/admin/get-payed-now`)
  - Payment processing

- **All Branch** (`GET /api/v1/admin/all-branch`)
  - Branch listing

### Coupon Management (Admin)
- **Create Coupon** (`POST /api/v1/admin/coupon/create-coupon`)
  - Discount coupons

- **List Coupons** (`GET /api/v1/admin/coupon/coupons-list`)
  - All coupons

- **Delete Coupon** (`DELETE /api/v1/admin/coupon/delete-coupon/:id`)
  - Remove coupon

### User Type Management (Admin)
- **Create User Type** (`POST /api/v1/admin/user-type/create`)
  - User type creation

- **List User Types** (`GET /api/v1/admin/user-type/fetch-listing`)
  - All user types

- **Update User Type** (`PUT /api/v1/admin/user-type/update/:id`)
  - Edit user type

- **Delete User Type** (`DELETE /api/v1/admin/user-type/delete/:id`)
  - Remove user type

### Activity Logs (Admin)
- **Activity Listing** (`GET /api/v1/admin/activity-logs-listing`)
  - System activity logs
  - User actions tracking

---

## 14. CATEGORIES

### Category Management
- **List Categories** (`GET /api/v1/category`)
  - All categories
  - Business categories

- **Get Subcategories** (`GET /api/v1/category/:id/subcategories`)
  - Category subcategories

- **Create Category** (`POST /api/v1/category`)
  - Add new category

---

## 15. SHIFTS & SCHEDULING

### Shift Management
- **Shifts Schedule** (`/shifts-schedule`)
  - Employee shift scheduling
  - Work schedule table
  - Time management

---

## 16. MARKETING & PUBLIC PAGES

### Public Pages
- **Homepage** (`/`)
  - Hero section
  - Feature carousel
  - Interactive flow
  - Real-time insights
  - Smart alerts
  - Outcome features
  - Advanced grid
  - Google social proof
  - CTA band
  - FAQ section
  - Global impact

- **About Us** (`/about-us`)
  - Company information

- **Our Team** (`/our-team`)
  - Team members

- **How It Works** (`/how-it-works`)
  - Platform explanation

- **Testimonials** (`/testimonials`)
  - Customer testimonials

- **Pricing** (`/pricing`)
  - Plan comparison
  - Pricing plans page

- **Contact Us** (`/contact-us`)
  - Contact form
  - Submit contact form (`POST /api/v1/user/submit-contact-form`)

- **Terms & Conditions** (`/terms-conditions`)
  - Legal terms

- **Privacy Policy** (`/privacy-policy`)
  - Privacy information

- **Cookie Policy** (`/cookie-policy`)
  - Cookie usage

- **Thank You** (`/thank-you`)
  - Post-action confirmation

---

## 17. CRON JOBS & SCHEDULED TASKS

### Automated Tasks
- **Check Free Trials** (`start/cron/checkFreeTrials.js`)
  - Monitor trial expiration
  - Auto-convert to paid

- **Update Subscription Status** (`start/cron/UpdateSubscriptionStatus.js`)
  - Subscription status updates
  - Payment failures

- **Reset Subscription Change Permission** (`start/cron/resetSubscriptionChangePermission.js`)
  - Monthly permission reset

- **Send Form Submission Emails** (`start/cron/sendFormsubmissionEmails.js`)
  - Email notifications
  - Form submission alerts

---

## 18. EMAIL SERVICES

### Email Templates
- **Signup Email** (English/Arabic)
  - Welcome emails
  - Account verification

- **Form Submission Email** (English/Arabic)
  - Submission notifications

- **Claim Discount Email** (English/Arabic)
  - Discount claim confirmations

- **Voucher Creation Email**
  - Voucher notifications
  - Customer notifications

- **Coupon Creation Email**
  - Coupon alerts

- **Employee Onboarding Email**
  - Welcome emails
  - Setup instructions

- **Employment Update Email**
  - Status change notifications

- **Gift Card Purchase Email**
  - Purchase confirmations

---

## 19. INTEGRATIONS

### Stripe Integration
- **Payment Processing**
  - Subscription payments
  - One-time payments
  - Payment intents

- **Stripe Connect**
  - Employee tip processing
  - Express accounts
  - Onboarding links

- **Stripe Webhooks** (`/api/v1/stripe-webhook`)
  - Payment events
  - Tip payment status
  - Subscription updates

### Google Integration
- **Google OAuth**
  - Social login
  - Account creation

- **Google Maps API**
  - Location services
  - Address autocomplete

### Cloud Storage
- **AWS S3 / DigitalOcean Spaces**
  - File uploads
  - Logo storage
  - Form images
  - Pre-signed URLs

---

## 20. NOTIFICATIONS

### Notification Features
- **Email Notifications**
  - Form submissions
  - Voucher redemptions
  - Discount claims
  - Employee updates
  - Subscription changes

- **Notification Settings** (`POST /api/v1/user/notification-settings`)
  - User preferences
  - Email preferences

---

## 21. PERMISSIONS SYSTEM

### Permission-Based Access Control
- **Permission Checks**
  - `business/listing`
  - `business/create`
  - `business/edit`
  - `business/delete`
  - `business/detail`
  - `business/reports`
  - `franchise/create`
  - `franchise/edit`
  - `franchise/delete`
  - `form/listing`
  - `form/create`
  - `form/edit`
  - `form/delete`
  - `form/detail`
  - `form/submissions`
  - `form/attach`
  - `form/qr`
  - `form/attached_listing`
  - `employee/listing`
  - `employee/create`
  - `employee/edit`
  - `employee/delete`
  - `employee/frenchise_listing`
  - `role/create`
  - `role/edit`
  - `role/delete`
  - `role/listing`
  - `discount/detail`
  - And more...

---

## 22. MULTI-LANGUAGE SUPPORT

### Internationalization
- **Languages Supported**
  - English (`en.json`)
  - Arabic (`ar.json`)

- **Language Switcher**
  - UI language toggle
  - RTL support for Arabic

---

## 23. DATA MODELS

### Database Collections
1. **User** - User accounts, authentication
2. **Business** - Business entities
3. **Franchise** - Business locations
4. **Form** - Feedback form templates
5. **FormSubmission** - Customer feedback
6. **Employment** - Employees with accounts
7. **Staff** - Employees without accounts
8. **Plan** - Subscription plans
9. **Subscription** - User subscriptions
10. **Role** - RBAC roles
11. **Permission** - RBAC permissions
12. **Discount** - Promotional offers
13. **ClaimDiscount** - Claimed discounts
14. **Voucher** - Vouchers
15. **VoucherRedemption** - Voucher redemptions
16. **GiftCardTemplate** - Gift card templates
17. **GiftCardPurchase** - Gift card purchases
18. **MenuItem** - Menu items
19. **Tip** - Employee tips
20. **Review** - Business reviews
21. **Invoice** - Payment invoices
22. **RefundRequest** - Refund requests
23. **LoginHistory** - Login tracking
24. **Category** - Business categories
25. **Coupon** - Discount coupons
26. **UserType** - User type definitions
27. **ApiLog** - API request logging

---

## 24. FRONTEND PAGES SUMMARY

### Authentication Pages
- `/login` - User login
- `/sign-up` - User registration
- `/verify-account` - Email verification
- `/verify-otp` - OTP verification
- `/reset-password` - Password reset
- `/new-password` - New password setup

### Dashboard Pages
- `/all-business` - Business listing
- `/all-business/[businessId]` - Business details
- `/all-business/[businessId]/edit` - Edit business
- `/all-business/[businessId]/add-franchise` - Add franchise
- `/all-business/[businessId]/[locationId]` - Franchise details
- `/all-business/[businessId]/[locationId]/edit` - Edit franchise
- `/all-business/[businessId]/reports` - Business reports
- `/all-business/[businessId]/reports/[branchId]` - Branch reports
- `/all-business/[businessId]/create-promotional-voucher` - Create voucher
- `/all-business/[businessId]/edit-promotional-voucher/[voucherId]` - Edit voucher
- `/all-business/[businessId]/[locationId]/[formId]/qrcode` - Form QR code

### Form Pages
- `/all-forms` - Form listing
- `/all-forms/[formId]` - Form details
- `/all-forms/[formId]/edit` - Edit form
- `/all-forms/[formId]/clone` - Clone form
- `/all-forms/[formId]/reviews` - Form submissions
- `/create-form` - Create form
- `/create-form/scratch-form` - Create from scratch
- `/add-review/[code]` - Public form submission

### Employee Pages
- `/all-employees` - Employee listing
- `/all-employees/create` - Create employee
- `/all-employees/[id]` - Employee details
- `/all-employees/[id]/edit` - Edit employee
- `/tips` - Employee tips
- `/employee/regenerate-stripe-link/[id]` - Regenerate Stripe link

### Role & Permission Pages
- `/roles` - Role listing
- `/roles/[roleId]` - Role details
- `/create-role` - Create role

### Subscription Pages
- `/subscription` - Subscription management
- `/checkout` - Payment checkout
- `/checkout/billing-history` - Billing history
- `/checkout/manage` - Payment management

### Voucher Pages
- `/voucher-history` - Voucher history
- `/voucher-verifications` - Voucher verification
- `/discounts/[accessKey]` - Claim discount

### Gift Card Pages
- `/gift-cards` - Gift card listing
- `/gift-cards/create` - Create gift card
- `/gift-cards/[id]` - Gift card details
- `/gift-cards/[id]/edit` - Edit gift card
- `/purchase-gift-card/[publicLink]` - Public purchase

### Settings & Other
- `/settings` - User settings
- `/shifts-schedule` - Shift scheduling

### Marketing Pages
- `/` - Homepage
- `/about-us` - About us
- `/our-team` - Our team
- `/how-it-works` - How it works
- `/testimonials` - Testimonials
- `/pricing` - Pricing
- `/contact-us` - Contact us
- `/terms-conditions` - Terms
- `/privacy-policy` - Privacy
- `/cookie-policy` - Cookies
- `/thank-you` - Thank you

---

## 25. API ENDPOINTS SUMMARY

### Total Endpoints: 100+

**By Category:**
- **Authentication**: 13 endpoints
- **Business**: 13 endpoints
- **Franchise**: 9 endpoints
- **Forms**: 9 endpoints
- **Employees**: 7 endpoints
- **Staff**: 4 endpoints
- **Subscriptions**: 6 endpoints
- **Vouchers**: 10 endpoints
- **Gift Cards**: 9 endpoints
- **Menu Items**: 6 endpoints
- **Categories**: 3 endpoints
- **Plans**: 1 endpoint
- **Analytics/Reporting**: 15 endpoints
- **Admin**: 30+ endpoints
- **Roles/Permissions**: 10+ endpoints
- **Webhooks**: 1 endpoint

---

## 26. KEY FEATURES HIGHLIGHTS

### Form Builder
- 8 question types (rating, dropdown, multiple choice, yes/no, short text, long text, rating scale, NPS scale)
- Custom styling (colors, background images)
- QR code generation
- Multi-language support
- Staff rating for franchise forms

### Employee Management
- Employee accounts with roles
- Shift scheduling
- Employment status tracking (Active, Inactive, Terminated, On Leave)
- Salary management (hourly/monthly)
- Stripe Connect for tips

### Subscription System
- Multiple plans
- Free trial (14 days)
- Multi-currency (GBP, USD)
- Stripe payments
- Upgrade/downgrade
- Coupon codes

### Analytics & Reporting
- 15+ report types
- Performance metrics
- NPS tracking
- Category comparison
- Time-based analysis
- Geographic performance
- Employee tips reports
- Voucher analytics

### Voucher System
- Promotional vouchers
- Menu item vouchers
- QR code generation
- Code verification
- Redemption tracking

### Gift Cards
- Template creation
- Public purchase links
- Stripe payment integration
- Code verification
- Full redemption only

---

## 27. TECHNOLOGY STACK

### Backend
- Node.js v18+
- Express.js v4.19.2
- MongoDB v8.3.4 (Mongoose ORM)

### Frontend
- Next.js (App Router)
- React
- TypeScript
- Redux (State Management)
- Tailwind CSS
- next-intl (i18n)

### Integrations
- Stripe (Payments, Connect)
- Google OAuth 2.0
- Google Maps API
- AWS S3 / DigitalOcean Spaces
- Nodemailer (Email)
- Sentry (Error Tracking)

### Scheduled Tasks
- node-cron v4.2.1

---

## 28. SECURITY FEATURES

### Authentication
- JWT tokens
- bcrypt password hashing
- Google OAuth
- Email verification
- OTP verification

### Authorization
- Role-Based Access Control (RBAC)
- Permission-based access
- Admin authentication
- API logging

---

## 29. DATA FLOWS

### User Registration Flow
1. Sign up → Email verification → Account creation → Business registration

### Business Creation Flow
2. Create business → Add franchises → Attach forms → Configure settings

### Form Submission Flow
3. Customer scans QR → Fills form → Submits → Email notification → Analytics update

### Subscription Flow
4. Select plan → Payment → Subscription activation → Feature access

### Employee Tip Flow
5. Customer pays tip → Stripe Connect → Employee receives payment → Tip tracking

---

## 30. MISSING FUNCTIONALITY (Not in New System)

Based on comparison, the following features exist in old system but may need verification in new system:

1. **Gift Cards** - Complete gift card system
2. **Menu Items** - Menu item management
3. **Tips Management** - Employee tip processing with Stripe Connect
4. **Shifts Schedule** - Employee shift scheduling
5. **Staff Management** - Staff without user accounts
6. **Coupon System** - Admin coupon management
7. **User Types** - User type definitions
8. **Activity Logs** - System activity tracking
9. **Device Analytics** - User device tracking
10. **Business Health Check** - Health monitoring
11. **Refund Requests** - Refund management
12. **Login History** - Login tracking
13. **API Logging** - Request logging
14. **Stripe Express Accounts** - Employee Stripe onboarding
15. **Recommend Form** - Form recommendations
16. **Contact Form Submission** - Public contact form
17. **Business Reviews** - Review creation system
18. **Category/Subcategory** - Business categorization
19. **Multi-currency Support** - GBP, USD
20. **Free Trial Management** - Trial extensions (admin)

---

## Summary

**Total Functionality Count:**
- **Frontend Pages**: 60+ pages
- **Backend API Endpoints**: 100+ endpoints
- **Database Models**: 27 models
- **Features**: 30+ major feature sets
- **Integrations**: 5+ third-party services
- **Cron Jobs**: 4 scheduled tasks

This comprehensive list covers all functionality available in the old system for migration and feature parity verification.


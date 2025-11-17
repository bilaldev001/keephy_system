# 🏗️ Frontend Architecture Documentation

## **Overview**

This document describes the complete architecture of the HRMS Enterprise Next.js frontend application.

---

## **1. 🎨 UI/UX Architecture**

### **Navigation Hierarchy**

```
┌─────────────────────────────────────────────┐
│ Level 1: Module Selector Dashboard          │
│ - Shows all subscribed modules              │
│ - Module cards with stats                   │
│ - Quick insights across modules             │
└─────────────────────────────────────────────┘
                    ↓ Click Module
┌─────────────────────────────────────────────┐
│ Level 2: Module Dashboard (e.g., HRMS)      │
│ - Module-specific sidebar navigation        │
│ - Module stats and quick actions            │
│ - Pending approvals                         │
└─────────────────────────────────────────────┘
                    ↓ Click Sidebar Item
┌─────────────────────────────────────────────┐
│ Level 3: Feature Page (e.g., Employees)     │
│ - Data table with filters                   │
│ - Search functionality                       │
│ - Bulk actions                        
      │
└─────────────────────────────────────────────┘
                    ↓ Click Row
┌─────────────────────────────────────────────┐
│ Level 4: Detail Page (e.g., Employee)       │
│ - Tabbed interface                          │
│ - Related data                              │
│ - Actions                                   │
└─────────────────────────────────────────────┘
```

---

## **2. 📦 Module Structure**

### **All 18 Modules**

| # | Module | Route | Category | Priority |
|---|--------|-------|----------|----------|
| 1 | HRMS | `/hrms` | People | ✅ MVP |
| 2 | FBMS | `/fbms` | Customer | ✅ MVP |
| 3 | CRM | `/crm` | Customer | ✅ MVP |
| 4 | Finance | `/finance` | Finance | 🔄 Phase 2 |
| 5 | Inventory | `/inventory` | Operations | 🔄 Phase 2 |
| 6 | Projects | `/projects` | Operations | 🔄 Phase 2 |
| 7 | EMS | `/ems` | People | 🔄 Phase 2 |
| 8 | FMS | `/fms` | Customer | 🔄 Phase 2 |
| 9 | E-Commerce | `/ecommerce` | Customer | 🔄 Phase 3 |
| 10 | Manufacturing | `/manufacturing` | Operations | 🔄 Phase 3 |
| 11 | Loyalty | `/loyalty` | Customer | 🔄 Phase 3 |
| 12 | Service | `/service` | Customer | 🔄 Phase 3 |
| 13 | Assets | `/assets` | Operations | 🔄 Phase 4 |
| 14 | Compliance | `/compliance` | Finance | 🔄 Phase 4 |
| 15 | Procurement | `/procurement` | Operations | 🔄 Phase 4 |
| 16 | SCM | `/scm` | Operations | 🔄 Phase 4 |
| 17 | Analytics | `/analytics` | System | 🔄 Phase 5 |
| 18 | Admin | `/settings` | System | ✅ MVP |

---

## **3. 🔄 Inter-Module Integrations**

### **Integration Map**

```
HRMS
├→ Finance (Payroll data)
├→ EMS (Expense claims)
├→ Projects (Employee assignments)
├→ Assets (Asset allocation)
└← Core Admin (User auth, RBAC)

FBMS
├→ Inventory (Menu items sync)
├→ Finance (Revenue accounting)
├→ CRM (Customer data)
├→ FMS (Feedback collection)
└→ HRMS (Staff management, tips)

CRM
├→ Finance (Invoice generation)
├→ Projects (Customer projects)
├→ Service (Support tickets)
├→ FBMS (Franchise customers)
└→ E-Commerce (Online customers)

Finance
├← HRMS (Payroll)
├← FBMS (Revenue)
├← CRM (Sales invoices)
├← Inventory (Purchase orders)
└← E-Commerce (Order payments)

Inventory
├→ Finance (Stock valuation)
├→ Manufacturing (Production materials)
├→ FBMS (Menu items)
└→ E-Commerce (Product catalog)
```

---

## **4. 🔒 Role-Based Access Matrix**

### **User Roles**

```
Super Admin
├─ Full access to all modules
├─ Module configuration
├─ User management
└─ Subscription management

Organization Admin
├─ Access to subscribed modules
├─ User management within org
├─ Role assignment
└─ Reports

Module Admin (per module)
├─ Full access to specific module
├─ Module configuration
└─ Module reports

Manager
├─ View access to modules
├─ Approval workflows
├─ Team management
└─ Reports

Employee
├─ Self-service features
├─ View own data
├─ Submit requests
└─ Limited reports

Viewer
├─ Read-only access
└─ Dashboard viewing
```

### **Permission Matrix Example (HRMS)**

| Feature | Super Admin | Org Admin | HRMS Admin | Manager | Employee | Viewer |
|---------|------------|-----------|------------|---------|----------|--------|
| View Employees | ✅ | ✅ | ✅ | ✅ (Team) | ✅ (Self) | ✅ |
| Add Employee | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Edit Employee | ✅ | ✅ | ✅ | ✅ (Team) | ✅ (Self) | ❌ |
| Delete Employee | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Mark Attendance | ✅ | ✅ | ✅ | ✅ | ✅ (Self) | ❌ |
| Approve Leave | ✅ | ✅ | ✅ | ✅ (Team) | ❌ | ❌ |
| Process Payroll | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| View Payroll | ✅ | ✅ | ✅ | ✅ (Team) | ✅ (Self) | ❌ |

---

## **5. 🛍️ Module Marketplace Design**

### **Marketplace Page** (`/settings/modules`)

```
┌────────────────────────────────────────────────────┐
│ Module Marketplace                                 │
├────────────────────────────────────────────────────┤
│                                                    │
│ [Search] [All ▼] [Category ▼] [Sort: Popular ▼]  │
│                                                    │
│ FEATURED MODULES                                   │
│ ┌──────────┐  ┌──────────┐  ┌──────────┐         │
│ │🏭 Manufct│  │🛒 E-Comm │  │🎁 Loyalty│         │
│ │$199/mo   │  │$89/mo    │  │$49/mo    │         │
│ │★★★★★    │  │★★★★☆    │  │★★★★★    │         │
│ │[Try Free]│  │[Try Free]│  │[Try Free]│         │
│ └──────────┘  └──────────┘  └──────────┘         │
│                                                    │
│ ALL MODULES                                        │
│ [Cards with pricing, features, reviews]           │
│                                                    │
│ BUNDLE OFFERS                                      │
│ 💡 HR Suite (HRMS + EMS + Assets) - Save 25%     │
│ 💡 Sales Suite (CRM + Finance + Analytics) - 20% │
└────────────────────────────────────────────────────┘
```

### **Module Detail Page** (`/settings/modules/[id]`)

```
┌────────────────────────────────────────────────────┐
│ 🛒 E-Commerce Module                              │
├────────────────────────────────────────────────────┤
│ [Hero Image/Video]                                │
│                                                    │
│ Manage your online store with powerful tools      │
│ [Start 14-Day Free Trial] [Schedule Demo]        │
│                                                    │
│ [Overview] [Features] [Pricing] [Reviews] [FAQ]  │
│ ═══════════════════════════════════════════════   │
│                                                    │
│ KEY FEATURES                                       │
│ ✅ Shopping Cart & Checkout                       │
│ ✅ Product Management                             │
│ ✅ Order Processing                               │
│ ✅ Payment Gateway Integration                    │
│                                                    │
│ PRICING PLANS                                      │
│ ┌──────────┬──────────┬──────────┐               │
│ │ Starter  │ Business │ Enterprise│               │
│ │ $89/mo   │ $199/mo  │ Custom    │               │
│ └──────────┴──────────┴──────────┘               │
│                                                    │
│ CUSTOMER REVIEWS (4.8/5)                          │
│ "Game changer for our business..." - John D.     │
│                                                    │
│ INTEGRATIONS                                       │
│ • Works with: Inventory, Finance, CRM            │
│                                                    │
│ [Start Free Trial]                                │
└────────────────────────────────────────────────────┘
```

### **Subscription Checkout Flow**

```
Step 1: Choose Plan
┌────────────────────────────────┐
│ ○ Starter - $89/mo            │
│ ● Business - $199/mo  ⭐      │
│ ○ Enterprise - Custom         │
│                                │
│ Billing: ○ Monthly ● Annual   │
│ (Save 20% - $1,910/year)      │
│                                │
│ [Continue →]                  │
└────────────────────────────────┘

Step 2: Review
┌────────────────────────────────┐
│ E-Commerce - Business Plan     │
│ Annual Billing                 │
│                                │
│ Subtotal:      $2,388/year    │
│ Discount (20%):  -$478         │
│ Total:         $1,910/year    │
│                                │
│ 💡 14-day free trial          │
│ Charged on: Jan 15, 2026      │
│                                │
│ [Confirm & Activate]          │
└────────────────────────────────┘

Step 3: Success
┌────────────────────────────────┐
│ ✅ Module Activated!          │
│                                │
│ Your trial has started         │
│                                │
│ NEXT STEPS:                    │
│ 1. Complete setup wizard       │
│ 2. Configure settings          │
│ 3. Invite team members         │
│                                │
│ [Go to Module] [Setup Wizard] │
└────────────────────────────────┘
```

---

## **6. 📱 Responsive Design**

### **Breakpoints (Tailwind)**
- `sm`: 640px - Mobile landscape
- `md`: 768px - Tablet
- `lg`: 1024px - Desktop
- `xl`: 1280px - Large desktop
- `2xl`: 1536px - Extra large

### **Mobile Optimizations**
- Bottom navigation for key actions
- Swipe gestures
- Touch-optimized buttons
- Collapsed sidebar
- Stacked cards

---

## **7. 🎯 Performance Optimizations**

- ✅ **Code Splitting** - Automatic per route
- ✅ **Image Optimization** - Next.js Image component
- ✅ **Bundle Analysis** - Track bundle size
- ✅ **Lazy Loading** - Components on demand
- ✅ **Caching** - React Query cache
- ✅ **SSR** - Server-side rendering
- ✅ **Prefetching** - Link prefetching

---

## **8. 🔧 Configuration Files**

### **next.config.js**
- API rewrites for CORS
- Image domains
- Environment variables

### **tailwind.config.ts**
- Custom colors per module
- Extended theme
- Plugin configurations

### **components.json**
- shadcn/ui configuration
- Component styles
- Import aliases

### **tsconfig.json**
- Path aliases (@/*)
- Strict mode
- Module resolution

---

## **9. 🚀 Deployment Strategy**

### **Vercel Deployment**
```bash
# Install Vercel CLI
npm i -g vercel

# Deploy
vercel
```

### **Docker Deployment**
```dockerfile
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .
RUN npm run build
CMD ["npm", "start"]
```

### **Environment Variables**
- Production API URL
- Authentication secrets
- Feature flags

---

## **10. 📊 Module Implementation Status**

### **✅ Completed (Phase 1)**
- Authentication system
- Module selector dashboard
- HRMS module (full)
  - Dashboard
  - Employee directory
  - Employee detail
  - Attendance tracking
  - Leave management
- Core layouts
- Shared components
- API integration layer

### **🔄 In Progress (Phase 2)**
- FBMS module
- CRM module
- Finance module
- Inventory module
- Projects module

### **📋 Planned (Phases 3-5)**
- E-Commerce, Manufacturing, Loyalty, Service
- Assets, Compliance, Procurement, SCM
- Analytics with AI insights
- Mobile application

---

## **11. 🎨 Design System**

### **Color Palette**

```typescript
Module Colors:
- HRMS:          #3B82F6 (Blue)
- FBMS:          #10B981 (Green)
- CRM:           #8B5CF6 (Purple)
- Finance:       #F59E0B (Orange)
- Inventory:     #84CC16 (Lime)
- Projects:      #06B6D4 (Cyan)
```

### **Component Patterns**

All components follow shadcn/ui patterns:
- Composable components
- Accessible by default
- Variant-based styling
- Responsive design

---

## **12. 🔐 Security**

- ✅ JWT authentication
- ✅ HTTP-only cookies (optional)
- ✅ RBAC enforcement
- ✅ XSS protection
- ✅ CSRF tokens
- ✅ Secure headers
- ✅ Input validation

---

## **13. 🧪 Testing Strategy**

### **Unit Tests**
```bash
npm test
```

### **E2E Tests**
```bash
npm run test:e2e
```

### **Type Checking**
```bash
npm run type-check
```

---

## **14. 📈 Analytics Integration**

- Module usage tracking
- User behavior analytics
- Performance monitoring
- Error tracking (Sentry)
- Custom events

---

## **15. 🌐 Internationalization (i18n)**

Future support for:
- English (default)
- Arabic
- Spanish
- French

---

**This architecture supports:**
- ✅ 18 independent modules
- ✅ Unlimited scalability
- ✅ Multi-tenant SaaS
- ✅ White-label customization
- ✅ Mobile-first design
- ✅ Enterprise-grade security

---

**Version:** 1.0.0  
**Last Updated:** November 4, 2025  
**Architecture by:** CTO with 20 years experience


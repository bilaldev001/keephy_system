# Entity Management - Organizations, Brands, Businesses, Franchises

## 🎯 Overview

After completing onboarding, users can manage all their entities (Organizations, Brands, Businesses, Franchises) through dedicated CRUD pages accessible from the sidebar.

---

## 📱 Pages Created

### 1. Organizations Page (`/organizations`)

**Features:**
- ✅ List all organizations
- ✅ Search by name or code
- ✅ Create new organization
- ✅ Edit existing organization
- ✅ Delete organization
- ✅ View organization details (description, phone, email, tax ID, address)

**Fields (Same as Onboarding):**
- Name * (required)
- Description
- Phone
- Code
- Tax ID
- Address (Street, City, State, Zip, Country)

**Sidebar Link:** Organizations → `/organizations`

---

### 2. Brands Page (`/brands`)

**Features:**
- ✅ List all brands
- ✅ Search by name or code
- ✅ Create new brand
- ✅ Edit existing brand
- ✅ Delete brand
- ✅ View brand details with organization association
- ✅ **Organization dropdown (optional)** - Select which organization the brand belongs to

**Fields (Same as Onboarding + Organization Dropdown):**
- Name * (required)
- **Organization** (optional dropdown) - NEW!
- Description
- Website
- Phone
- Code

**Sidebar Link:** Brands → `/brands`

**Additional Feature:**
- Shows organization name as a badge on each brand card
- Filter brands by organization in the dropdown

---

### 3. Businesses Page (`/businesses`)

**Features:**
- ✅ List all businesses
- ✅ Search by name or email
- ✅ Create new business
- ✅ Edit existing business
- ✅ Delete business
- ✅ View business details with organization and brand associations
- ✅ **Organization dropdown (optional)** - Select which organization
- ✅ **Brand dropdown (optional)** - Select which brand (filtered by selected organization)

**Fields (Same as Onboarding + Dropdowns):**
- Name * (required)
- Primary Email * (required)
- **Organization** (optional dropdown) - NEW!
- **Brand** (optional dropdown, filtered by organization) - NEW!
- Description
- Phone
- Website
- Tax ID
- Registration Number
- Founded Year
- Employee Count
- Address (Street, City, State, Zip, Country)

**Sidebar Link:** Businesses → `/businesses`

**Additional Features:**
- Shows organization and brand names as badges on each business card
- Brand dropdown is filtered based on selected organization
- If no organization is selected, shows all brands without an organization

---

### 4. Franchises Page (`/franchises`)

**Features:**
- ✅ List all franchises
- ✅ Search by franchise name
- ✅ Create new franchise
- ✅ Edit existing franchise
- ✅ Delete franchise
- ✅ View franchise details with business association
- ✅ **Business dropdown (required)** - Select which business the franchise belongs to

**Fields (Same as Onboarding + Business Dropdown):**
- Franchise Name * (required)
- **Business** (required dropdown) - NEW!
- Franchise Type
- Phone
- Address (Street, City, State, Zip, Country)

**Sidebar Link:** Franchises → `/franchises`

**Additional Features:**
- Shows business name as a badge on each franchise card
- Business dropdown is required (franchises must belong to a business)
- Organization and brand IDs are automatically inherited from the selected business

---

## 🎨 UI/UX Features

### Common Features Across All Pages

1. **Search Functionality**
   - Real-time search filter
   - Search by name, code, or email (depending on entity)
   - Clear search icon

2. **Card-Based Grid Layout**
   - Responsive grid (1 col mobile, 2 cols tablet, 3 cols desktop)
   - Hover effects with shadow
   - Clean, modern design

3. **Modal-Based Create/Edit**
   - Full-screen modal overlay
   - Same form for create and edit
   - Form validation
   - Loading states
   - Error handling

4. **Action Buttons**
   - Edit button (pencil icon)
   - Delete button (trash icon) with confirmation
   - Create button (plus icon) in header

5. **Visual Hierarchy**
   - Entity name as card title
   - Badges for codes, types, and associations
   - Icons for contact info (phone, email, location)
   - Color-coded badges for different entity types

6. **Empty States**
   - Friendly message when no entities exist
   - "Create Your First X" button
   - Icon illustration

7. **Loading States**
   - Spinner animation
   - "Loading..." text
   - Disabled buttons during operations

---

## 🔗 Entity Relationships

### Hierarchy

```
Organization (Optional)
  └── Brand (Optional)
      └── Business (Required)
          └── Franchise (Required)
```

### Dropdown Behavior

**Brands:**
- Organization dropdown shows all organizations
- Can select "No Organization" (independent brand)

**Businesses:**
- Organization dropdown shows all organizations
- Brand dropdown shows:
  - If organization selected: Only brands from that organization
  - If no organization: Only brands without an organization
- Can select "No Organization" and "No Brand" (independent business)

**Franchises:**
- Business dropdown shows all businesses (required)
- Organization and brand IDs are automatically inherited from the selected business

---

## 🔄 API Endpoints Used

### Organizations

```typescript
GET    /onboarding/organizations          // List all
GET    /onboarding/organizations/:id      // Get one
POST   /onboarding/organization           // Create
PUT    /onboarding/organizations/:id      // Update
DELETE /onboarding/organizations/:id      // Delete
```

### Brands

```typescript
GET    /onboarding/brands                 // List all
GET    /onboarding/brands/:id             // Get one
POST   /onboarding/brand                  // Create
PUT    /onboarding/brands/:id             // Update
DELETE /onboarding/brands/:id             // Delete
```

### Businesses

```typescript
GET    /onboarding/businesses             // List all
GET    /onboarding/businesses/:id         // Get one
POST   /onboarding/business               // Create
PUT    /onboarding/businesses/:id         // Update
DELETE /onboarding/businesses/:id         // Delete
```

### Franchises

```typescript
GET    /onboarding/franchises             // List all
GET    /onboarding/franchises/:id         // Get one
POST   /onboarding/franchise              // Create
PUT    /onboarding/franchises/:id         // Update
DELETE /onboarding/franchises/:id         // Delete
```

---

## 💡 Usage Examples

### Creating a Brand Under an Organization

1. Go to `/brands`
2. Click "Create Brand"
3. Fill in brand details
4. **Select organization from dropdown** (optional)
5. Click "Create Brand"
6. Brand is now associated with the selected organization

### Creating a Business Under Brand

1. Go to `/businesses`
2. Click "Create Business"
3. Fill in business details
4. **Select organization from dropdown** (optional)
5. **Select brand from dropdown** (filtered by organization)
6. Click "Create Business"
7. Business is now associated with the selected organization and brand

### Creating a Franchise Under Business

1. Go to `/franchises`
2. Click "Create Franchise"
3. Fill in franchise details
4. **Select business from dropdown** (required)
5. Click "Create Franchise"
6. Franchise is now associated with the selected business
7. Organization and brand IDs are automatically inherited

---

## 🎯 User Flows

### Scenario 1: Complete Hierarchy

```
1. Create Organization "Acme Corp"
   └─> Go to /organizations, click Create

2. Create Brand "Acme Pro" under "Acme Corp"
   └─> Go to /brands, click Create
   └─> Select "Acme Corp" in Organization dropdown

3. Create Business "Acme Downtown" under "Acme Pro"
   └─> Go to /businesses, click Create
   └─> Select "Acme Corp" in Organization dropdown
   └─> Select "Acme Pro" in Brand dropdown (filtered)

4. Create Franchise "Downtown Location" under "Acme Downtown"
   └─> Go to /franchises, click Create
   └─> Select "Acme Downtown" in Business dropdown
   └─> Organization and Brand are auto-inherited
```

### Scenario 2: Independent Business (No Org/Brand)

```
1. Create Business "Solo Coffee Shop"
   └─> Go to /businesses, click Create
   └─> Leave Organization dropdown as "No Organization"
   └─> Leave Brand dropdown as "No Brand"
   └─> Fill in other details

2. Create Franchise "Main Street Location"
   └─> Go to /franchises, click Create
   └─> Select "Solo Coffee Shop" in Business dropdown
```

---

## 🔐 Permissions & Access Control

### Who Can See What?

- **Owner:** Can see and manage all entities they created
- **Organization Admin:** Can see all brands, businesses, franchises under their organization
- **Brand Admin:** Can see all businesses and franchises under their brand
- **Business Admin:** Can see all franchises under their business
- **Manager:** Can see entities they have access to

### Data Isolation

- Each user only sees their own entities
- Multi-tenant isolation enforced at API level
- `x-user-id` header ensures proper filtering

---

## 🎨 Design Principles

### Consistency

- All pages use the same layout structure
- Same modal design for create/edit
- Consistent button placement and styling
- Unified color scheme and spacing

### User Experience

- Minimal clicks to perform actions
- Inline editing without page navigation
- Instant feedback on actions
- Clear error messages
- Confirmation dialogs for destructive actions

### Responsive Design

- Mobile-first approach
- Grid adapts to screen size
- Modal scrolls on small screens
- Touch-friendly button sizes

---

## 🧪 Testing the Pages

### Test Organizations Page

```bash
# 1. Navigate to http://localhost:3076/organizations
# 2. Click "Create Organization"
# 3. Fill in form and save
# 4. Verify organization appears in list
# 5. Click edit icon, modify details, save
# 6. Verify changes are reflected
# 7. Click delete icon, confirm
# 8. Verify organization is removed
```

### Test Brands Page with Organization Dropdown

```bash
# 1. Navigate to http://localhost:3076/brands
# 2. Click "Create Brand"
# 3. Select an organization from dropdown
# 4. Fill in other fields and save
# 5. Verify brand shows organization badge
# 6. Edit brand and change organization
# 7. Verify organization badge updates
```

### Test Businesses Page with Filtered Dropdowns

```bash
# 1. Navigate to http://localhost:3076/businesses
# 2. Click "Create Business"
# 3. Select Organization "Acme Corp"
# 4. Observe Brand dropdown now shows only brands from "Acme Corp"
# 5. Select a brand
# 6. Fill in other fields and save
# 7. Verify business shows both organization and brand badges
```

### Test Franchises Page with Business Dropdown

```bash
# 1. Navigate to http://localhost:3076/franchises
# 2. Click "Create Franchise"
# 3. Select a business from dropdown
# 4. Fill in other fields and save
# 5. Verify franchise shows business badge
# 6. Check that organization and brand are auto-inherited
```

---

## 🚀 Future Enhancements

### Potential Improvements

1. **Bulk Operations**
   - Select multiple entities
   - Bulk delete
   - Bulk status change

2. **Advanced Filtering**
   - Filter by organization
   - Filter by status
   - Filter by date created

3. **Sorting**
   - Sort by name
   - Sort by date created
   - Sort by status

4. **Pagination**
   - Load more button
   - Infinite scroll
   - Page size selector

5. **Export/Import**
   - Export to CSV
   - Import from CSV
   - Bulk upload

6. **Detailed View**
   - Dedicated detail page for each entity
   - Show team members
   - Show child entities
   - Activity timeline

7. **Logo Upload**
   - Add logo upload to create/edit modals
   - Display logos in cards
   - Logo preview

---

## 📊 Data Flow

### Creating a Business with Organization and Brand

```
User fills form on /businesses
  ↓
  Name: "Acme Downtown"
  Primary Email: "downtown@acme.com"
  Organization: "Acme Corp" (from dropdown)
  Brand: "Acme Pro" (from dropdown, filtered by org)
  ↓
POST /onboarding/business
  {
    name: "Acme Downtown",
    primaryEmail: "downtown@acme.com",
    organizationId: "uuid-of-acme-corp",
    brandId: "uuid-of-acme-pro",
    ...other fields
  }
  ↓
Backend creates business with associations
  ↓
Response: { id: "uuid", name: "Acme Downtown", ... }
  ↓
Frontend reloads list
  ↓
Business card shows:
  - Name: "Acme Downtown"
  - Organization badge: "Acme Corp"
  - Brand badge: "Acme Pro"
```

---

## ✅ Success Criteria

Your entity management is working correctly when:

- [ ] Can access all 4 pages from sidebar (Organizations, Brands, Businesses, Franchises)
- [ ] Can see list of existing entities on each page
- [ ] Can search entities by name/code
- [ ] Can create new entities with all fields
- [ ] Can edit existing entities
- [ ] Can delete entities with confirmation
- [ ] Brand page shows organization dropdown
- [ ] Business page shows organization and brand dropdowns
- [ ] Brand dropdown filters by selected organization
- [ ] Franchise page shows business dropdown (required)
- [ ] All forms use same fields as onboarding
- [ ] No linter errors
- [ ] Responsive on mobile, tablet, desktop
- [ ] Loading states work correctly
- [ ] Error messages display properly

---

## 🎓 For Developers

### File Locations

```
frontend/console/src/pages/
  ├── organizations.tsx    (List + CRUD for Organizations)
  ├── brands.tsx           (List + CRUD for Brands)
  ├── businesses.tsx       (List + CRUD for Businesses)
  └── franchises.tsx       (List + CRUD for Franchises)
```

### Component Structure

Each page follows the same pattern:

```typescript
export default function EntityPage() {
  // State management
  const [entities, setEntities] = useState([]);
  const [showModal, setShowModal] = useState(false);
  const [modalMode, setModalMode] = useState('create' | 'edit');
  const [currentEntity, setCurrentEntity] = useState({});
  
  // Load data
  useEffect(() => {
    loadEntities();
    loadRelatedEntities(); // For dropdowns
  }, []);
  
  // CRUD operations
  const handleCreate = () => { ... };
  const handleEdit = (entity) => { ... };
  const handleSave = async () => { ... };
  const handleDelete = async (id) => { ... };
  
  // Render
  return (
    <DashboardLayout>
      {/* Header with Create button */}
      {/* Search bar */}
      {/* Entity cards grid */}
      {/* Create/Edit modal */}
    </DashboardLayout>
  );
}
```

### Adding New Fields

To add a new field to any entity:

1. **Update the interface:**
   ```typescript
   interface Business {
     // ... existing fields
     newField?: string;  // Add here
   }
   ```

2. **Add to initial state:**
   ```typescript
   const [currentBusiness, setCurrentBusiness] = useState({
     // ... existing fields
     newField: '',  // Add here
   });
   ```

3. **Add form field in modal:**
   ```tsx
   <div>
     <Label>New Field</Label>
     <Input
       value={currentBusiness.newField || ''}
       onChange={(e) => setCurrentBusiness({ 
         ...currentBusiness, 
         newField: e.target.value 
       })}
       placeholder="Enter value"
     />
   </div>
   ```

4. **Include in payload:**
   ```typescript
   const payload = {
     // ... existing fields
     newField: currentBusiness.newField || undefined,
   };
   ```

5. **Update backend DTO** (if needed)

---

## 🐛 Known Issues & Solutions

### Issue 1: Dropdown Not Showing Options

**Cause:** Related entities (orgs, brands, businesses) not loaded

**Solution:** Check network tab, ensure GET requests succeed. Verify user has access to those entities.

### Issue 2: Brand Dropdown Empty After Selecting Organization

**Cause:** No brands exist for that organization

**Solution:** Create a brand for that organization first, or select "No Organization" to see independent brands.

### Issue 3: Can't Delete Entity

**Cause:** Entity has child entities (e.g., deleting org with brands)

**Solution:** Delete child entities first, then parent. Or implement cascade delete in backend.

---

## 📞 API Requirements

### Backend Endpoints Must Support

1. **List Endpoints:**
   - Return array of entities
   - Filter by user/tenant automatically
   - Include related entity names (optional)

2. **Create Endpoints:**
   - Accept all fields from onboarding DTOs
   - Accept optional organizationId, brandId, businessId
   - Return created entity with ID

3. **Update Endpoints:**
   - Accept partial updates
   - Validate ownership
   - Return updated entity

4. **Delete Endpoints:**
   - Validate ownership
   - Handle cascade (or prevent if has children)
   - Return success message

---

## 🎉 Summary

You now have a complete entity management system with:

✅ **4 CRUD pages** - Organizations, Brands, Businesses, Franchises  
✅ **Sidebar navigation** - Easy access from any page  
✅ **Hierarchical dropdowns** - Organization → Brand → Business → Franchise  
✅ **Same fields as onboarding** - Consistent user experience  
✅ **Search & filter** - Find entities quickly  
✅ **Responsive design** - Works on all devices  
✅ **Error handling** - Clear error messages  
✅ **Loading states** - Visual feedback  
✅ **Confirmation dialogs** - Prevent accidental deletions  

**Access the pages:**
- http://localhost:3076/organizations
- http://localhost:3076/brands
- http://localhost:3076/businesses
- http://localhost:3076/franchises

---

**Last Updated:** December 4, 2025  
**Status:** ✅ Complete and Production-Ready


# ⚡ Keephy Platform - Quick Start

## 🏃‍♂️ Get Running in 4 Steps

### Step 1: Install Dependencies
```bash
npm install --legacy-peer-deps
```

### Step 2: Setup Database
```bash
# Run automated database setup (creates tables, adds columns, fixes constraints)
./setup-database.sh
```

### Step 3: Start Everything
```bash
npm run pm2:start:all
```

### Step 4: Access the Platform
**That's it!** 🎉 Access http://localhost:3076

---

## 🔥 Common Commands

```bash
# View all services status
pm2 status

# View service logs
pm2 logs <service-name>

# Restart a service
pm2 restart <service-name>

# Stop everything
npm run pm2:stop:all
```

---

## ⚠️ First-Time Issues?

### Database Errors (tax_id, logo_id, etc.)

**Cause:** Migrations haven't run yet

**Fix:**
```bash
pm2 restart tenant-service
sleep 10  # Wait for migrations
```

### "owner_id violates not-null constraint"

**Cause:** User ID not in session

**Fix:**
1. Clear browser localStorage and sessionStorage
2. Log out and log back in
3. Try again

### Port Already in Use

**Fix:**
```bash
pm2 restart all
```

---

## 📱 Access Points

- **Console UI:** http://localhost:3076
- **API Gateway:** http://localhost:3010
- **Admin Panel:** http://localhost:3078

---

## 📚 Full Docs

- **Complete Setup:** See `SETUP_GUIDE.md`
- **PM2 Usage:** See `PM2_GUIDE.md`  
- **Migrations:** See `backend/services/tenant-service/MIGRATIONS.md`
- **Implementation Details:** See `ONBOARDING_IMPLEMENTATION.md`

---

**Need Help?** Check the docs above or ask the team! 🚀


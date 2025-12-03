#!/bin/bash

# Script to update all console pages to use gradient layout
# Based on home-final-2 design

echo "🎨 Updating Console Pages to Gradient Layout..."
echo ""

cd "$(dirname "$0")/frontend/console/src/pages"

# List of files to update
files=(
  "staff.tsx"
  "shifts.tsx"
  "coupons.tsx"
  "gift-cards.tsx"
  "tips/index.tsx"
  "brands.tsx"
  "businesses.tsx"
  "franchises.tsx"
  "organizations.tsx"
  "dashboard.tsx"
  "subscription.tsx"
  "onboarding.tsx"
  "staff/create.tsx"
  "staff/[id]/index.tsx"
  "staff/[id]/edit.tsx"
  "shifts/create.tsx"
  "shifts/[id]/index.tsx"
  "shifts/[id]/edit.tsx"
  "shifts/templates.tsx"
  "coupons/create.tsx"
  "coupons/[id]/index.tsx"
  "coupons/[id]/edit.tsx"
  "gift-cards/create.tsx"
  "gift-cards/[id]/index.tsx"
  "gift-cards/[id]/edit.tsx"
  "brands/[id].tsx"
  "brands/[id]/edit.tsx"
  "businesses/[id].tsx"
  "businesses/[id]/edit.tsx"
  "businesses/[id]/add-franchise.tsx"
  "franchises/[id].tsx"
  "franchises/[id]/edit.tsx"
  "organizations/[id].tsx"
  "organizations/[id]/edit.tsx"
)

updated=0
skipped=0

for file in "${files[@]}"; do
  if [ -f "$file" ]; then
    # Count how many levels deep the file is
    depth=$(echo "$file" | tr -cd '/' | wc -c)
    
    # Determine the correct relative path
    if [ $depth -eq 0 ]; then
      # Root level: ../components/
      sed -i '' "s|from '../components/DashboardLayout'|from '../components/DashboardLayoutGradient' as DashboardLayout|g" "$file"
      sed -i '' "s|import { DashboardLayout }|import { DashboardLayoutGradient as DashboardLayout }|g" "$file"
    elif [ $depth -eq 1 ]; then
      # One level deep: ../../components/
      sed -i '' "s|from '../../components/DashboardLayout'|from '../../components/DashboardLayoutGradient' as DashboardLayout|g" "$file"
      sed -i '' "s|import { DashboardLayout }|import { DashboardLayoutGradient as DashboardLayout }|g" "$file"
    elif [ $depth -eq 2 ]; then
      # Two levels deep: ../../../components/
      sed -i '' "s|from '../../../components/DashboardLayout'|from '../../../components/DashboardLayoutGradient' as DashboardLayout|g" "$file"
      sed -i '' "s|import { DashboardLayout }|import { DashboardLayoutGradient as DashboardLayout }|g" "$file"
    fi
    
    echo "  ✓ Updated: $file"
    ((updated++))
  else
    echo "  ⊘ Skipped: $file (not found)"
    ((skipped++))
  fi
done

echo ""
echo "📊 Summary:"
echo "  ✅ Updated: $updated files"
echo "  ⊘ Skipped: $skipped files"
echo ""
echo "🎉 Gradient layout applied successfully!"


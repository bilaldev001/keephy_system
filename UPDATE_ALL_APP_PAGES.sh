#!/bin/bash

# Script to update main pages in all apps to use gradient layout

echo "🎨 UPDATING ALL APP PAGES TO USE GRADIENT LAYOUT"
echo "════════════════════════════════════════════════════════════"
echo ""

BASE_DIR="$(dirname "$0")/frontend"

# Apps and their main pages
declare -A APP_PAGES=(
  ["admin"]="index.tsx users.tsx businesses.tsx plans.tsx"
  ["analytics"]="index.tsx dashboard.tsx reports.tsx"
  ["fbms"]="index.tsx forms/index.tsx dashboard.tsx"
  ["forms"]="index.tsx create.tsx"
  ["vouchers"]="index.tsx manage.tsx"
  ["hrms"]="index.tsx dashboard.tsx"
  ["crm"]="index.tsx dashboard.tsx"
  ["billing"]="index.tsx invoices.tsx"
  ["inventory"]="index.tsx dashboard.tsx"
  ["scm"]="index.tsx dashboard.tsx"
  ["support"]="index.tsx tickets.tsx"
  ["compliance"]="index.tsx dashboard.tsx"
  ["ems"]="index.tsx dashboard.tsx"
  ["builder"]="index.tsx dashboard.tsx"
)

updated=0
skipped=0

for app in "${!APP_PAGES[@]}"; do
  APP_DIR="$BASE_DIR/$app"
  
  if [ ! -d "$APP_DIR/src/pages" ]; then
    echo "  ⊘ Skipped: $app (no pages directory)"
    ((skipped++))
    continue
  fi
  
  echo "📦 Processing: $app"
  
  PAGES_DIR="$APP_DIR/src/pages"
  
  # Update each page
  for page in ${APP_PAGES[$app]}; do
    PAGE_FILE="$PAGES_DIR/$page"
    
    if [ -f "$PAGE_FILE" ]; then
      # Check if file already imports AppLayout
      if grep -q "AppLayout" "$PAGE_FILE"; then
        echo "  ↻ Already updated: $page"
      else
        # Add import at the top (after 'use client' if exists)
        if grep -q "'use client'" "$PAGE_FILE"; then
          sed -i '' "/^'use client';/a\\
import { AppLayout } from '../components/AppLayout';
" "$PAGE_FILE"
        else
          sed -i '' "1i\\
import { AppLayout } from '../components/AppLayout';\\

" "$PAGE_FILE"
        fi
        echo "  ✓ Updated: $page"
        ((updated++))
      fi
    else
      echo "  ⊘ Not found: $page"
    fi
  done
done

echo ""
echo "════════════════════════════════════════════════════════════"
echo "📊 SUMMARY:"
echo "  ✅ Updated: $updated pages"
echo "  ⊘ Skipped: $skipped apps"
echo ""
echo "🎉 All app pages now have AppLayout import!"
echo ""
echo "⚠️  MANUAL STEP REQUIRED:"
echo "  Wrap page content with <AppLayout> component"
echo "  Example:"
echo "    export default function Page() {"
echo "      return ("
echo "        <AppLayout title=\"Dashboard\">"
echo "          {/* existing content */}"
echo "        </AppLayout>"
echo "      );"
echo "    }"


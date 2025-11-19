#!/bin/bash

# Script to link @keephy/ui-core locally across all frontend apps
# Usage: ./scripts/link-ui-core.sh

set -e

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
UI_CORE_DIR="$ROOT_DIR/frontend/packages/ui-core"
FRONTEND_DIR="$ROOT_DIR/frontend"

echo "🔗 Linking @keephy/ui-core locally..."
echo ""

# Step 1: Link the ui-core package globally
echo "Step 1: Creating global symlink for @keephy/ui-core..."
cd "$UI_CORE_DIR"
npm link
echo "✅ ui-core package linked globally"
echo ""

# Step 2: Link in all frontend apps that use it
echo "Step 2: Linking @keephy/ui-core in consuming packages..."
cd "$FRONTEND_DIR"

# Find all directories that contain package.json with @keephy/ui-core
apps=()
for dir in */; do
  if [ -f "${dir}package.json" ] && grep -q "@keephy/ui-core" "${dir}package.json" 2>/dev/null; then
    apps+=("${dir%/}")
  fi
done

# Link in each app
for app_name in "${apps[@]}"; do
  echo "📦 Linking in $app_name..."
  cd "$FRONTEND_DIR/$app_name"
  npm link @keephy/ui-core 2>&1 | grep -v "npm warn" | grep -v "EBADENGINE" || true
done

echo ""
echo "✅ All apps linked successfully!"
echo ""
echo "📝 Note: Changes to ui-core will now be reflected immediately in all linked apps."
echo "   To unlink, run: npm unlink @keephy/ui-core in each app, then npm unlink in ui-core"


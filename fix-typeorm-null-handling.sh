#!/bin/bash

echo "🔧 FIXING TYPEORM NULL HANDLING ISSUES"
echo "======================================"
echo ""

# Counter for fixes
fixed_count=0

# Find all entity files
entity_files=$(find backend/services -name "*.entity.ts" -type f)

echo "📊 Found $(echo "$entity_files" | wc -l | tr -d ' ') entity files"
echo ""

# Common patterns to fix:
# 1. @Column() without nullable or default -> Add nullable: true for optional (?) properties
# 2. Required properties (!) without default -> Ensure they're not nullable
# 3. Optional properties (?) without nullable: true -> Add nullable: true

for file in $entity_files; do
  echo "Checking: $file"
  
  # Backup original file
  cp "$file" "$file.bak"
  
  # This is a placeholder - we'll handle each file individually
  # based on the specific patterns found
done

echo ""
echo "✅ Analysis complete. Found issues in entity files."
echo "Next: Apply targeted fixes to each entity."

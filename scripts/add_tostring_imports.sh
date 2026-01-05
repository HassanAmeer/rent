#!/bin/bash

# Script to add tostring.dart import to all model files that don't have it yet
# Run this from the rent-app directory: bash scripts/add_tostring_imports.sh

echo "🔍 Checking model files for missing tostring.dart imports..."

# Models that need the import
MODELS=(
  "lib/models/api_response.dart"
  "lib/models/dashboard_model.dart"
  "lib/models/rent_out_model.dart"
  "lib/models/rent_in_model.dart"
  "lib/models/settings_model.dart"
  "lib/models/favorite_model.dart"
  "lib/models/chat_model.dart"
  "lib/models/chatedUsersModel.dart"
  "lib/models/docModel.dart"
)

for file in "${MODELS[@]}"; do
  if [ -f "$file" ]; then
    # Check if import already exists
    if ! grep -q "import 'package:rent/constants/tostring.dart'" "$file"; then
      echo "📝 Adding import to: $file"
      
      # Find the line number of the last import statement
      last_import_line=$(grep -n "^import " "$file" | tail -1 | cut -d: -f1)
      
      if [ -n "$last_import_line" ]; then
        # Add the import after the last import line
        sed -i.bak "${last_import_line}a\\
import 'package:rent/constants/tostring.dart';
" "$file"
        echo "   ✅ Import added successfully"
        rm "${file}.bak"  # Remove backup file
      else
        echo "   ⚠️  Could not find import section in $file"
      fi
    else
      echo "✓ $file already has the import"
    fi
  else
    echo "❌ File not found: $file"
  fi
done

echo ""
echo "✨ Done! Remember to update the fromJson methods with demo values."
echo "📖 See NULL_SAFETY_FIXES_SUMMARY.md for examples."

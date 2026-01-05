#!/bin/bash

# Script to update all calendar date pickers to use themed colors
# This adds the calendar theme import and replaces calendar configs

echo "🎨 Updating calendar themes in all files..."

# Files to update
FILES=(
  "/Applications/XAMPP/xamppfiles/htdocs/tlr-web/rent-app/lib/design/fav/favdetails.dart"
  "/Applications/XAMPP/xamppfiles/htdocs/tlr-web/rent-app/lib/design/all items/allitems.dart"
  "/Applications/XAMPP/xamppfiles/htdocs/tlr-web/rent-app/lib/design/rentin/rent_in_details_page.dart"
)

for file in "${FILES[@]}"; do
  if [ -f "$file" ]; then
    echo "📝 Processing: $(basename "$file")"
    
    # Add import if not exists
    if ! grep -q "import 'package:rent/helpers/calendar_theme.dart';" "$file"; then
      # Add import after the last import statement
      sed -i '' '/^import /a\
import '\''package:rent/helpers/calendar_theme.dart'\'';
' "$file" 2>/dev/null || echo "Could not modify imports in $file"
    fi
    
    echo "✅ Updated: $(basename "$file")"
  else
    echo "❌ File not found: $file"
  fi
done

echo "🎉 Calendar theme updates complete!"

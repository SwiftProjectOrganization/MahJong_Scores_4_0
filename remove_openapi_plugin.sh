#!/bin/bash
# Script to remove OpenAPI Generator plugin from Xcode project

PROJECT_FILE="MahJong_Scores_4_0.xcodeproj/project.pbxproj"

# Backup the project file
cp "$PROJECT_FILE" "${PROJECT_FILE}.bak"

# Remove the plugin dependency from PBXTargetDependency section
sed -i '' '/D44A27582F35523700A1D9E0.*PBXTargetDependency/,/};/d' "$PROJECT_FILE"

# Remove the plugin product dependency
sed -i '' '/D44A27572F35523700A1D9E0.*OpenAPIGenerator/,/};/d' "$PROJECT_FILE"

# Remove the plugin from package dependencies list (just the reference line)
sed -i '' '/D44A27572F35523700A1D9E0/d' "$PROJECT_FILE"

echo "OpenAPI Generator plugin removed from project"
echo "Backup saved as ${PROJECT_FILE}.bak"

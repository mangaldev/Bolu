#!/bin/bash

# Bolu iOS App - Build and Run Script
# This script builds and runs the Bolu app on an iOS simulator

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
SCHEME_NAME="Bolu"
PROJECT_NAME="Bolu"
SIMULATOR_NAME="iPhone 14 Pro Max"
SIMULATOR_OS="iOS-16-2"  # Adjust based on available simulators

echo -e "${GREEN}🚀 Bolu iOS App - Build and Run${NC}"
echo ""

# Check if Xcode is installed
if ! command -v xcodebuild &> /dev/null; then
    echo -e "${RED}❌ Error: xcodebuild not found. Please install Xcode.${NC}"
    exit 1
fi

# Check if project exists
if [ ! -d "${PROJECT_NAME}.xcodeproj" ] && [ ! -d "${PROJECT_NAME}.xcworkspace" ]; then
    echo -e "${YELLOW}⚠️  Warning: Xcode project not found.${NC}"
    echo -e "${YELLOW}   Please create the Xcode project first by following SETUP_INSTRUCTIONS.md${NC}"
    echo ""
    echo "To create the project:"
    echo "  1. Open Xcode"
    echo "  2. Create a new iOS App project named 'Bolu'"
    echo "  3. Add all files from the Bolu/ directory"
    echo "  4. Then run this script again"
    exit 1
fi

# Find available simulators
echo -e "${GREEN}📱 Finding available simulators...${NC}"
SIMULATORS=$(xcrun simctl list devices available | grep -i "iphone" | head -5)
if [ -z "$SIMULATORS" ]; then
    echo -e "${RED}❌ No iPhone simulators found${NC}"
    exit 1
fi

echo "$SIMULATORS"
echo ""

# Get the first available iPhone simulator
DEVICE_ID=$(xcrun simctl list devices available | grep -i "iphone" | grep -i "pro max" | head -1 | sed -E 's/.*\(([^)]+)\).*/\1/')

if [ -z "$DEVICE_ID" ]; then
    # Fallback to any iPhone
    DEVICE_ID=$(xcrun simctl list devices available | grep -i "iphone" | head -1 | sed -E 's/.*\(([^)]+)\).*/\1/')
fi

if [ -z "$DEVICE_ID" ]; then
    echo -e "${RED}❌ Could not find a suitable simulator${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Using simulator: ${DEVICE_ID}${NC}"
echo ""

# Boot the simulator if not already running
echo -e "${GREEN}🔌 Booting simulator...${NC}"
xcrun simctl boot "$DEVICE_ID" 2>/dev/null || echo "Simulator already booted"
open -a Simulator

# Wait for simulator to be ready
echo -e "${GREEN}⏳ Waiting for simulator to be ready...${NC}"
sleep 5

# Determine project type
if [ -d "${PROJECT_NAME}.xcworkspace" ]; then
    PROJECT_PATH="${PROJECT_NAME}.xcworkspace"
    PROJECT_TYPE="workspace"
else
    PROJECT_PATH="${PROJECT_NAME}.xcodeproj"
    PROJECT_TYPE="project"
fi

# Build the project
echo -e "${GREEN}🔨 Building project...${NC}"
xcodebuild \
    -${PROJECT_TYPE} "$PROJECT_PATH" \
    -scheme "$SCHEME_NAME" \
    -destination "id=$DEVICE_ID" \
    -configuration Debug \
    clean build \
    CODE_SIGN_IDENTITY="" \
    CODE_SIGNING_REQUIRED=NO \
    CODE_SIGNING_ALLOWED=NO

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Build failed${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Build successful!${NC}"
echo ""

# Install and run the app
echo -e "${GREEN}📲 Installing app on simulator...${NC}"
APP_PATH=$(find ~/Library/Developer/Xcode/DerivedData -name "Bolu.app" -type d | head -1)

if [ -z "$APP_PATH" ]; then
    echo -e "${RED}❌ Could not find built app${NC}"
    echo "   Try building from Xcode first to ensure the project is configured correctly"
    exit 1
fi

xcrun simctl install "$DEVICE_ID" "$APP_PATH"

echo -e "${GREEN}🚀 Launching app...${NC}"
xcrun simctl launch "$DEVICE_ID" "$(xcodebuild -showBuildSettings -${PROJECT_TYPE} "$PROJECT_PATH" -scheme "$SCHEME_NAME" | grep PRODUCT_BUNDLE_IDENTIFIER | head -1 | awk '{print $3}')"

echo ""
echo -e "${GREEN}✅ App launched successfully!${NC}"
echo -e "${GREEN}   The app should now be running on the simulator${NC}"


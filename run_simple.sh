#!/bin/bash

# Simple script to build and run Bolu app
# Usage: ./run_simple.sh

set -e

SCHEME="Bolu"
PROJECT="Bolu.xcodeproj"

# Check if project exists
if [ ! -d "$PROJECT" ]; then
    echo "❌ Error: $PROJECT not found"
    echo "Please create the Xcode project first (see SETUP_INSTRUCTIONS.md)"
    exit 1
fi

# Get first available iPhone simulator
DEVICE=$(xcrun simctl list devices available | grep -i "iphone" | head -1 | sed -E 's/.*\(([^)]+)\).*/\1/')

if [ -z "$DEVICE" ]; then
    echo "❌ No iPhone simulator found"
    exit 1
fi

echo "📱 Using simulator: $DEVICE"
echo "🔨 Building..."

# Build and run
xcodebuild \
    -project "$PROJECT" \
    -scheme "$SCHEME" \
    -destination "id=$DEVICE" \
    build

echo "✅ Build complete!"
echo "💡 Tip: You can also run directly from Xcode (Cmd+R)"


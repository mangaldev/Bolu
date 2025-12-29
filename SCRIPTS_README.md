# Running the Bolu App - Scripts Guide

This directory contains several scripts to help you build and run the Bolu iOS app from the command line.

## Prerequisites

1. **Xcode installed** (Xcode 14.0 or later)
2. **Xcode project created** (follow `SETUP_INSTRUCTIONS.md` first)
3. **Command Line Tools** installed (`xcode-select --install`)

## Available Scripts

### 1. `run.sh` - Full Featured Script

The most comprehensive script with error checking and detailed output.

**Usage:**
```bash
./run.sh
```

**Features:**
- ✅ Checks if Xcode project exists
- ✅ Finds and boots simulator automatically
- ✅ Builds the project
- ✅ Installs and launches the app
- ✅ Color-coded output
- ✅ Error handling

### 2. `run_simple.sh` - Simple Script

A minimal script for quick builds.

**Usage:**
```bash
./run_simple.sh
```

**Features:**
- ✅ Quick build
- ✅ Minimal output
- ✅ Basic error checking

### 3. `Makefile` - Make Commands

Use traditional `make` commands for building and running.

**Available Commands:**

```bash
# Build the project
make build

# Build and run on simulator
make run

# Clean build artifacts
make clean

# Open project in Xcode
make open

# List available simulators
make list-devices

# Show help
make help
```

## Quick Start

### Option 1: Using the Shell Script (Recommended)

```bash
cd /Users/mangal.dev/Projects/Bolu
./run.sh
```

### Option 2: Using Make

```bash
cd /Users/mangal.dev/Projects/Bolu
make run
```

### Option 3: Using Xcode (Easiest)

1. Open `Bolu.xcodeproj` in Xcode
2. Select a simulator (e.g., iPhone 14 Pro Max)
3. Press `Cmd + R` or click the Play button

## Manual Commands

If you prefer to run commands manually:

### Build Only
```bash
xcodebuild -project Bolu.xcodeproj -scheme Bolu -configuration Debug build
```

### List Simulators
```bash
xcrun simctl list devices available
```

### Boot Simulator
```bash
xcrun simctl boot "iPhone 14 Pro Max"
open -a Simulator
```

### Build and Run on Specific Simulator
```bash
# Get device ID first
DEVICE_ID=$(xcrun simctl list devices available | grep "iPhone 14 Pro Max" | head -1 | sed -E 's/.*\(([^)]+)\).*/\1/')

# Build
xcodebuild -project Bolu.xcodeproj -scheme Bolu -destination "id=$DEVICE_ID" build

# Find app
APP_PATH=$(find ~/Library/Developer/Xcode/DerivedData -name "Bolu.app" -type d | head -1)

# Install
xcrun simctl install "$DEVICE_ID" "$APP_PATH"

# Launch
xcrun simctl launch "$DEVICE_ID" "com.yourcompany.Bolu"
```

## Troubleshooting

### Script Permission Denied
```bash
chmod +x run.sh run_simple.sh
```

### Project Not Found
- Make sure you've created the Xcode project first
- Follow `SETUP_INSTRUCTIONS.md`
- Verify `Bolu.xcodeproj` exists in the directory

### Simulator Not Found
```bash
# List available simulators
xcrun simctl list devices available

# Create a new simulator if needed (via Xcode)
# Xcode → Window → Devices and Simulators
```

### Build Errors
- Open the project in Xcode first
- Build once from Xcode (`Cmd + B`)
- Check that all files are added to the target
- Verify scheme is set correctly

### App Not Installing
- Check that the build succeeded
- Verify the app bundle exists:
  ```bash
  find ~/Library/Developer/Xcode/DerivedData -name "Bolu.app" -type d
  ```
- Try building from Xcode first

## Tips

1. **First Time Setup**: Always build from Xcode first to ensure everything is configured correctly
2. **Simulator Selection**: The scripts automatically find an iPhone simulator, but you can modify them to use a specific one
3. **Bundle Identifier**: Update the bundle identifier in the scripts if yours differs from `com.yourcompany.Bolu`
4. **Xcode Path**: If Xcode is in a non-standard location, you may need to set:
   ```bash
   export DEVELOPER_DIR="/Applications/Xcode.app/Contents/Developer"
   ```

## Alternative: Fastlane

For more advanced automation, consider using [Fastlane](https://fastlane.tools):

```bash
# Install Fastlane
gem install fastlane

# Initialize (optional)
fastlane init
```

Then create a `Fastfile` with build and run commands.

## Notes

- Scripts assume the project is named "Bolu" - adjust if different
- Default simulator is "iPhone 14 Pro Max" - modify scripts to change
- Build products are stored in `~/Library/Developer/Xcode/DerivedData`
- The app will launch automatically after installation


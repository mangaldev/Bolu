# Fixing Simulator Boot Error: "launchd failed to respond"

## The Error
Xcode shows: "Unable to boot the Simulator. launchd failed to respond."

## Quick Fixes (Try in Order)

### 1. Shutdown All Simulators
```bash
xcrun simctl shutdown all
```

### 2. Kill Simulator Processes
```bash
killall -9 com.apple.CoreSimulator.CoreSimulatorService
killall -9 Simulator
```

### 3. Restart Simulator Service
```bash
# Kill the service
sudo killall -9 com.apple.CoreSimulator.CoreSimulatorService

# It will restart automatically when you try to boot a simulator
```

### 4. Delete Problematic Simulator
If a specific simulator is causing issues:

```bash
# List all simulators
xcrun simctl list devices

# Delete the problematic one (replace DEVICE_ID with actual ID)
xcrun simctl delete DEVICE_ID
```

Then create a new one in Xcode: `Window → Devices and Simulators → +`

### 5. Reset Simulator Content
In Xcode:
- `Window → Devices and Simulators`
- Select the problematic simulator
- Right-click → `Erase All Content and Settings...`

### 6. Clean Derived Data
```bash
rm -rf ~/Library/Developer/Xcode/DerivedData/*
```

### 7. Restart Xcode
- Quit Xcode completely (`Cmd + Q`)
- Reopen and try again

## Alternative: Use a Different Simulator

1. In Xcode, click the device selector (next to Play button)
2. Choose a different iPhone simulator (e.g., iPhone 16 Pro Max instead of iPhone 17 Pro Max)
3. Try running again

## If Still Not Working

### Check System Resources
```bash
# Check if simulator processes are stuck
ps aux | grep -i simulator

# Check available disk space
df -h
```

### Reinstall Simulator Runtime
1. Xcode → Settings → Platforms
2. Remove the iOS Simulator runtime
3. Re-download it

### Last Resort: Restart Mac
Sometimes a full system restart resolves simulator issues.

## Quick Test Command

After trying fixes, test if simulator boots:
```bash
# Get a device ID
DEVICE_ID=$(xcrun simctl list devices available | grep "iPhone" | head -1 | sed -E 's/.*\(([^)]+)\).*/\1/')

# Try to boot it
xcrun simctl boot $DEVICE_ID

# Open Simulator app
open -a Simulator
```

If this works, the simulator should be usable from Xcode.


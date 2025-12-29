# Deploying Bolu App to Physical Device

This guide will help you install the Bolu app on your iPhone/iPad.

## Prerequisites

1. **Apple Developer Account** (Free or Paid)
   - Free: Allows development on your own devices
   - Paid ($99/year): Required for App Store distribution
   
2. **macOS computer** with Xcode installed
3. **USB cable** to connect your device
4. **iOS device** (iPhone/iPad) running iOS 14.0 or later

## Step 1: Set Up Apple Developer Account (Free)

1. Go to [developer.apple.com](https://developer.apple.com)
2. Sign in with your Apple ID
3. Accept the Apple Developer Agreement
4. Your account is now ready for free development

## Step 2: Configure Xcode Project

### 2.1 Open Project in Xcode
```bash
cd /Users/mangal.dev/Projects/Bolu
open Bolu.xcodeproj
```

### 2.2 Select Your Target
1. In Xcode, click on the **Bolu** project (blue icon) in the Project Navigator
2. Select the **Bolu** target
3. Go to the **Signing & Capabilities** tab

### 2.3 Configure Signing
1. Check **"Automatically manage signing"**
2. Select your **Team** from the dropdown
   - If you don't see your team, click "Add Account..." and sign in
3. Xcode will automatically create a provisioning profile

### 2.4 Set Bundle Identifier
- Make sure the Bundle Identifier is unique (e.g., `com.yourname.Bolu`)
- If it's already taken, change it to something unique

## Step 3: Connect Your Device

1. **Unlock your iPhone/iPad**
2. **Connect via USB** to your Mac
3. **Trust the computer** if prompted on your device
4. In Xcode, select your device from the device selector (top toolbar)
   - It should appear as "Your Name's iPhone" or similar

## Step 4: Build and Install

### Option A: Using Xcode (Recommended)

1. **Select your device** in the device selector (top toolbar)
2. **Press `Cmd + R`** or click the **Play** button
3. Xcode will:
   - Build the app
   - Install it on your device
   - Launch it automatically

### Option B: Using Command Line

```bash
cd /Users/mangal.dev/Projects/Bolu

# Get your device UDID first
xcrun xctrace list devices

# Build and install (replace DEVICE_ID with your device's UDID)
xcodebuild -project Bolu.xcodeproj \
  -scheme Bolu \
  -destination 'id=DEVICE_ID' \
  build install
```

## Step 5: Trust Developer Certificate on Device

**First time only:**

1. On your iPhone/iPad, go to **Settings → General → VPN & Device Management**
2. Tap on your developer certificate (e.g., "Apple Development: your@email.com")
3. Tap **"Trust [Your Name]"**
4. Confirm by tapping **"Trust"**

Now you can launch the app from your home screen!

## Troubleshooting

### "No devices found"
- Make sure device is unlocked
- Trust the computer on your device
- Check USB cable connection
- Try a different USB port

### "Failed to code sign"
- Make sure "Automatically manage signing" is checked
- Verify your Apple ID is signed in (Xcode → Settings → Accounts)
- Try cleaning build folder: `Cmd + Shift + K`

### "App installation failed"
- Check device has enough storage
- Make sure device is running iOS 14.0+
- Restart Xcode and try again

### "Untrusted Developer"
- Go to Settings → General → VPN & Device Management
- Trust your developer certificate

### Bundle Identifier Already Taken
- Change it in Xcode → Target → General → Bundle Identifier
- Use something unique like `com.yourname.Bolu`

## Building for Distribution (App Store)

If you want to submit to the App Store:

1. **Upgrade to Paid Developer Account** ($99/year)
2. In Xcode:
   - Select **"Any iOS Device"** as destination
   - Go to **Product → Archive**
   - Once archived, click **"Distribute App"**
   - Follow the App Store Connect process

## Alternative: TestFlight (Beta Testing)

1. Upload build to App Store Connect
2. Add testers via TestFlight
3. Testers can install via TestFlight app (no USB needed)

## Quick Reference Commands

```bash
# List connected devices
xcrun xctrace list devices

# Build for device
xcodebuild -project Bolu.xcodeproj -scheme Bolu -destination 'generic/platform=iOS' build

# Clean build
xcodebuild clean -project Bolu.xcodeproj -scheme Bolu
```

## Notes

- **Free Developer Account**: Apps expire after 7 days, need to reinstall
- **Paid Developer Account**: Apps last 1 year, can distribute via TestFlight/App Store
- **Development builds**: Only work on devices registered to your account
- **Maximum devices**: Free account allows 3 devices, Paid allows 100

## Need Help?

- Check Xcode console for specific error messages
- Verify device is in Settings → General → About → Name
- Make sure device iOS version matches minimum deployment target (iOS 14.0)


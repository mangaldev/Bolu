# Quick Start - Running Bolu App

## Easiest Way: Run from Xcode

1. **Open Xcode** (if not already open)
2. **Select a Simulator**:
   - Click the device selector at the top (next to the Play button)
   - Choose "iPhone 14 Pro Max" or any iPhone simulator
3. **Press `Cmd + R`** or click the **▶️ Play** button
4. The app will build and launch automatically!

## Alternative: Run from Terminal

If you prefer command line:

### Using the Script
```bash
cd /Users/mangal.dev/Projects/Bolu
./run.sh
```

### Using Make
```bash
cd /Users/mangal.dev/Projects/Bolu
make run
```

### Direct xcodebuild Command
```bash
cd /Users/mangal.dev/Projects/Bolu
xcodebuild -project Bolu.xcodeproj -scheme Bolu -destination 'platform=iOS Simulator,name=iPhone 14 Pro Max' build
```

## Adding Scripts to Xcode (Optional)

If you want to see the scripts in Xcode:

1. In Xcode, right-click on the **Bolu** folder (blue folder icon)
2. Select **Add Files to "Bolu"...**
3. Navigate to `/Users/mangal.dev/Projects/Bolu`
4. Select:
   - `run.sh`
   - `run_simple.sh`
   - `Makefile`
5. Make sure **"Copy items if needed"** is **UNCHECKED** (they're already in the right place)
6. Make sure **"Add to targets"** is **UNCHECKED** (scripts don't need to be compiled)
7. Click **Add**

The scripts will appear in Xcode, but you still need to run them from Terminal.

## Troubleshooting

**Build Errors?**
- Make sure all files are added to the target
- Clean build folder: `Product → Clean Build Folder` (Cmd+Shift+K)
- Try building once from Xcode first

**Simulator Not Found?**
- Open Xcode → `Window → Devices and Simulators`
- Create a new simulator if needed

**Script Permission Denied?**
```bash
chmod +x run.sh run_simple.sh
```


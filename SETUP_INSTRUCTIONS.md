# Bolu iOS App - Setup Instructions

## Prerequisites

- macOS with Xcode 14.0 or later installed
- iOS 14.0+ simulator or physical device
- Basic knowledge of Swift and SwiftUI

## Step-by-Step Setup

### 1. Create New Xcode Project

1. Open Xcode
2. Select **File → New → Project**
3. Choose **iOS → App**
4. Click **Next**
5. Configure the project:
   - **Product Name**: `Bolu`
   - **Team**: Select your development team
   - **Organization Identifier**: `com.yourcompany` (or your preferred identifier)
   - **Interface**: **SwiftUI**
   - **Language**: **Swift**
   - **Storage**: **None** (we'll add our own files)
   - **Include Tests**: ✅ (optional but recommended)
6. Choose a location to save the project
7. Click **Create**

### 2. Add Project Files

1. In Xcode, right-click on the `Bolu` folder (blue folder icon) in the Project Navigator
2. Select **Add Files to "Bolu"...**
3. Navigate to the `Bolu` directory in your file system
4. Select all the following folders/files:
   - `App/` folder
   - `Models/` folder
   - `ViewModels/` folder
   - `Views/` folder
   - `Utilities/` folder
   - `Info.plist`
5. Make sure **"Copy items if needed"** is checked
6. Make sure **"Create groups"** is selected (not "Create folder references")
7. Click **Add**

### 3. Configure Project Settings

1. Select the **Bolu** project in the Project Navigator (top item)
2. Select the **Bolu** target
3. Go to the **General** tab:
   - **Minimum Deployments**: Set to **iOS 14.0**
   - **Supported Destinations**: Ensure iPhone is selected
4. Go to the **Info** tab:
   - Verify that `Info.plist` is listed
   - If not, add it manually

### 4. Update App Entry Point

1. Open `BoluApp.swift` in the `App/` folder
2. Replace the default content with the provided `BoluApp.swift` content
3. Open `ContentView.swift` in the `App/` folder
4. Replace the default content with the provided `ContentView.swift` content

### 5. Verify File Structure

Your project should have the following structure:

```
Bolu/
├── Bolu/
│   ├── App/
│   │   ├── BoluApp.swift
│   │   └── ContentView.swift
│   ├── Models/
│   │   ├── Player.swift
│   │   ├── Game.swift
│   │   └── Round.swift
│   ├── ViewModels/
│   │   └── GameViewModel.swift
│   ├── Views/
│   │   ├── Setup/
│   │   │   └── PlayerSetupView.swift
│   │   ├── Game/
│   │   │   ├── GameView.swift
│   │   │   ├── BoliInputView.swift
│   │   │   └── HandPlayView.swift
│   │   └── Results/
│   │       ├── RoundResultsView.swift
│   │       └── FinalResultsView.swift
│   ├── Utilities/
│   │   ├── ScoreCalculator.swift
│   │   └── Constants.swift
│   └── Info.plist
├── BoluTests/ (if you included tests)
└── Bolu.xcodeproj
```

### 6. Build and Run

1. Select a simulator or device:
   - For iOS 14 Pro Max: Select **iPhone 14 Pro Max** simulator (or any iOS 14+ simulator)
   - Or connect a physical device
2. Click the **Play** button (▶️) or press `Cmd + R`
3. The app should build and launch

### 7. Test the App

1. **Setup Phase**:
   - Enter number of players (e.g., 5)
   - Enter player names
   - Optionally edit player order
   - Verify round count is calculated correctly

2. **Gameplay**:
   - Tap "Start Round"
   - Declare Boli for each player
   - Tap players to record hand winners
   - Verify scores are calculated correctly
   - Complete all rounds

3. **Results**:
   - Verify final rankings
   - Check winner declaration

## Troubleshooting

### Build Errors

1. **"Cannot find type 'X' in scope"**:
   - Make sure all files are added to the target
   - Check that file is in the correct folder
   - Clean build folder: **Product → Clean Build Folder** (`Cmd + Shift + K`)

2. **"Missing Info.plist"**:
   - Verify `Info.plist` is added to the project
   - Check Build Settings → Info.plist File path

3. **SwiftUI Preview Errors**:
   - Previews may not work immediately
   - Try building the project first
   - Restart Xcode if issues persist

### Runtime Issues

1. **App crashes on launch**:
   - Check console for error messages
   - Verify all required files are included
   - Ensure minimum iOS version is set correctly

2. **UI not updating**:
   - Verify `@Published` properties are used correctly
   - Check that `@ObservedObject` or `@StateObject` is used in views
   - Ensure `GameViewModel` is passed correctly through environment

## Next Steps

- Customize the UI colors and styling
- Add animations and transitions
- Implement game state persistence
- Add sound effects
- Test on physical devices

## Support

If you encounter issues not covered here:
1. Check the `GAME_DESIGN.md` for game logic details
2. Review the `IMPLEMENTATION_PLAN.md` for architecture details
3. Check Xcode console for specific error messages
4. Verify all files are properly added to the project target


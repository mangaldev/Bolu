# Fixing Xcode Error: "Type 'GameViewModel' does not conform to protocol 'ObservableObject'"

## The Issue

Xcode is showing an error that `GameViewModel` doesn't conform to `ObservableObject`, but the code is actually correct. This is typically an **Xcode indexing issue**, not a real compilation error.

## Verification

The command-line build succeeds:
```bash
xcodebuild -project Bolu.xcodeproj -scheme Bolu build
# Result: ** BUILD SUCCEEDED **
```

## Solutions (Try in Order)

### 1. Clean Build Folder
In Xcode:
- Press `Cmd + Shift + K` (or `Product → Clean Build Folder`)
- Then build again: `Cmd + B`

### 2. Close and Reopen Xcode
- Quit Xcode completely (`Cmd + Q`)
- Reopen the project
- Build again

### 3. Delete Derived Data
```bash
rm -rf ~/Library/Developer/Xcode/DerivedData/Bolu-*
```
Then reopen Xcode and build.

### 4. Restart Xcode Indexing
- Close Xcode
- Delete the index:
```bash
rm -rf ~/Library/Developer/Xcode/DerivedData/Bolu-*/Index
```
- Reopen Xcode (it will re-index)

### 5. Verify the Code
The code is correct - `GameViewModel` does conform to `ObservableObject`:
```swift
import Foundation
import SwiftUI
import Combine

class GameViewModel: ObservableObject {
    @Published var game: Game
    @Published var currentBoliPlayerIndex: Int = 0
    // ...
}
```

## Why This Happens

Xcode's source indexer sometimes gets out of sync, especially when:
- Files are added/modified outside Xcode
- Project structure changes
- Multiple Xcode windows are open
- Xcode crashes or is force-quit

## If Error Persists

If the error still appears after trying the above:

1. **Check the actual build**: The red error in Xcode might be stale. Try building (`Cmd + B`) - if it succeeds, the error is just a display issue.

2. **Verify file is in target**: 
   - Select `GameViewModel.swift` in Project Navigator
   - Open File Inspector (right panel)
   - Check "Target Membership" - make sure "Bolu" is checked

3. **Check for duplicate files**: Make sure there aren't two `GameViewModel.swift` files in the project.

## Quick Test

Run this to verify the build works:
```bash
cd /Users/mangal.dev/Projects/Bolu
xcodebuild -project Bolu.xcodeproj -scheme Bolu -sdk iphonesimulator build
```

If this succeeds, the error in Xcode is just a display/indexing issue and you can safely ignore it or try the solutions above.


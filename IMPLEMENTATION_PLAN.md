# Bolu iOS App - Implementation Plan

## Project Structure

```
Bolu/
├── Bolu/
│   ├── App/
│   │   ├── BoluApp.swift (Main app entry)
│   │   └── ContentView.swift (Root view)
│   ├── Models/
│   │   ├── Player.swift
│   │   ├── Game.swift
│   │   ├── Round.swift
│   │   └── Hand.swift
│   ├── Views/
│   │   ├── Setup/
│   │   │   ├── PlayerSetupView.swift
│   │   │   └── PlayerEditView.swift
│   │   ├── Game/
│   │   │   ├── GameView.swift
│   │   │   ├── RoundView.swift
│   │   │   ├── BoliInputView.swift
│   │   │   └── HandPlayView.swift
│   │   └── Results/
│   │       ├── RoundResultsView.swift
│   │       └── FinalResultsView.swift
│   ├── ViewModels/
│   │   ├── GameViewModel.swift
│   │   └── RoundViewModel.swift
│   └── Utilities/
│       ├── ScoreCalculator.swift
│       └── Constants.swift
├── BoluTests/
└── Bolu.xcodeproj
```

## Implementation Phases

### Phase 1: Core Models & Data Structure
- [x] Player model (name, totalScore, currentRoundScore)
- [x] Round model (roundNumber, cardsPerPlayer, boliDeclarations, handsWon)
- [x] Game model (players, rounds, currentRound, gameState)
- [x] ScoreCalculator utility

### Phase 2: Setup Flow
- [x] Player count input
- [x] Player name input
- [x] Player order editing
- [x] Round calculation display
- [x] Navigation to game

### Phase 3: Game Flow
- [x] Round start/display
- [x] Boli input for each player
- [x] Hand tracking (tap to assign winner)
- [x] Round completion
- [x] Score calculation

### Phase 4: Results & Ranking
- [x] Round results display
- [x] Current ranking display
- [x] Final results
- [x] Winner declaration

### Phase 5: Polish & UX
- [x] Visual feedback
- [x] Animations
- [x] Error handling
- [x] Edge cases

## Key Components

### Models

#### Player
```swift
struct Player: Identifiable, Codable {
    let id: UUID
    var name: String
    var totalScore: Int
    var currentRoundBoli: Int?
    var currentRoundWins: Int
}
```

#### Round
```swift
struct Round: Identifiable {
    let id: UUID
    let roundNumber: Int
    let cardsPerPlayer: Int
    var boliDeclarations: [UUID: Int] // Player ID -> Boli
    var handsWon: [UUID: Int] // Player ID -> Hands won
    var isComplete: Bool
}
```

#### Game
```swift
class Game: ObservableObject {
    @Published var players: [Player]
    @Published var rounds: [Round]
    @Published var currentRoundIndex: Int
    @Published var gameState: GameState
    
    enum GameState {
        case setup
        case boliInput
        case handPlay
        case roundComplete
        case gameComplete
    }
}
```

### Views

1. **PlayerSetupView**: Initial setup with player count and names
2. **GameView**: Main game container with round display
3. **BoliInputView**: Input Boli declarations for current round
4. **HandPlayView**: Tap players to assign hand winners
5. **RoundResultsView**: Show round scores
6. **FinalResultsView**: Show final scores and winner

### ViewModels

- **GameViewModel**: Manages game state, rounds, scoring
- **RoundViewModel**: Manages current round state

## Technical Decisions

1. **State Management**: SwiftUI @StateObject/@ObservedObject
2. **Navigation**: NavigationView/NavigationStack (iOS 16+)
3. **Persistence**: UserDefaults (simple) or Core Data (if needed)
4. **UI Framework**: SwiftUI with iOS 14+ features
5. **Architecture**: MVVM pattern

## Testing Strategy

- Unit tests for ScoreCalculator
- Unit tests for Game logic
- UI tests for critical flows
- Manual testing on iOS 14 Pro Max simulator


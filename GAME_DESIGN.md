# Bolu - Card Game App Design Document

## Game Overview
Bolu is a playing card game app for iOS where up to 10 players compete in multiple rounds. Players predict how many hands they'll win (Boli) and score points based on accuracy.

## Game Rules

### Setup
- **Players**: 1-10 players
- **Deck**: Standard 52-card deck
- **Rounds**: Calculated as `floor(52 / number_of_players)`
  - Example: 10 players = 5 rounds (5 cards max per player)
  - Example: 7 players = 7 rounds (7 cards max per player)

### Round Structure
1. **Card Distribution**:
   - Round 1: 1 card per player
   - Round 2: 2 cards per player
   - Round 3: 3 cards per player
   - Continue until maximum cards can be distributed
   - Remaining cards are set aside (not used in that round)

2. **Boli Declaration**:
   - After cards are distributed, players declare how many hands they'll win
   - Boli starts from the player where shuffling started
   - Boli range: 0 to maximum hands possible in that round
   - Example: Round with 3 cards = Boli can be 0, 1, 2, or 3

3. **Hand Play**:
   - Each hand: All players throw one card
   - Best card wins the hand
   - Track which player wins each hand

4. **Scoring**:
   - **Positive Points**: Only if won exactly the same number of hands as Boli
   - **Negative Points**: If won more or less than Boli
   - **Scoring Formula**: 
     - Boli 0 → Score: 10
     - Boli 1 → Score: 21
     - Boli 2 → Score: 32
     - Boli 3 → Score: 43
     - Boli 4 → Score: 54
     - Boli 5 → Score: 65
     - Pattern: `(Boli + 1) * 10 + Boli` = `11 * Boli + 10`
   - If actual wins = Boli: +score
   - If actual wins ≠ Boli: -score

### Game Flow
1. **Setup Phase**:
   - Enter number of players
   - Enter player names
   - Arrange player order (with edit option)
   - Display calculated number of rounds

2. **Round Phase**:
   - Click "Start Round" button
   - Cards are distributed (visual representation)
   - Players declare Boli (in order, starting from shuffle position)
   - Play hands: Click player who wins each hand
   - End round: Calculate and display scores

3. **End Game**:
   - After all rounds complete
   - Display final scores
   - Declare winner (highest total score)
   - Show ranking throughout the game

## Technical Requirements

### Platform
- **Target**: iOS 14 Pro Max and later
- **Language**: Swift 5+
- **Framework**: SwiftUI (latest iOS features)
- **Minimum iOS**: iOS 14.0

### Features
- Player management (add, edit, reorder)
- Round management
- Boli input system
- Hand tracking (tap to assign winner)
- Score calculation
- Real-time ranking display
- Game state persistence (optional)

### UI/UX Considerations
- Large, tap-friendly buttons for hand winners
- Clear visual feedback for current round/hand
- Score display always visible
- Player order clearly indicated
- Smooth transitions between rounds

## Clarifying Questions

1. **Card Suit/Rank**: Do we need to display actual card suits/ranks, or just track which player wins each hand? (Assuming just tracking winners for MVP)

2. **Shuffle Position**: How is the starting shuffle position determined? (Assuming first player or random)

3. **Card Display**: Should we show the cards visually, or just track hands won? (Assuming just tracking for MVP)

4. **Game Persistence**: Should the game save progress if app is closed? (Assuming not needed for MVP)

5. **Best Card Logic**: Since we're not showing actual cards, do we just let players decide who wins each hand by tapping? (Assuming yes - players decide)

6. **Round Transition**: Should there be a confirmation before moving to next round? (Assuming yes)

7. **Boli Validation**: Should we prevent players from declaring Boli that sums to total hands? (Assuming no restriction - players can all declare same Boli)


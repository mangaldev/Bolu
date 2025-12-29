//
//  GameViewModel.swift
//  Bolu
//
//  Created on [Date]
//

import Foundation
import SwiftUI
import Combine

class GameViewModel: ObservableObject {
    @Published var game: Game
    @Published var currentBoliPlayerIndex: Int = 0
    
    init(game: Game = Game()) {
        self.game = game
    }
    
    // MARK: - Setup
    
    func setPlayers(_ players: [Player]) {
        var updatedGame = game
        updatedGame.players = players
        updatedGame.shuffleStartPlayerIndex = Constants.defaultShuffleStartIndex
        game = updatedGame
        initializeRounds()
    }
    
    func updatePlayerOrder(_ players: [Player]) {
        var updatedGame = game
        updatedGame.players = players
        game = updatedGame
    }
    
    private func initializeRounds() {
        let totalRounds = game.totalRounds
        var updatedGame = game
        updatedGame.rounds = (1...totalRounds).map { roundNumber in
            Round(roundNumber: roundNumber, cardsPerPlayer: roundNumber)
        }
        game = updatedGame
    }
    
    // MARK: - Round Management
    
    func startRound() {
        guard game.currentRoundIndex < game.rounds.count else { return }
        
        var updatedGame = game
        
        // Reset player round data
        for i in 0..<updatedGame.players.count {
            updatedGame.players[i].resetRound()
        }
        
        // Reset round data
        updatedGame.rounds[game.currentRoundIndex].boliDeclarations = [:]
        updatedGame.rounds[game.currentRoundIndex].handsWon = [:]
        updatedGame.rounds[game.currentRoundIndex].currentHand = 0
        updatedGame.rounds[game.currentRoundIndex].isComplete = false
        
        updatedGame.gameState = .boliInput
        game = updatedGame
        currentBoliPlayerIndex = game.shuffleStartPlayerIndex
    }
    
    func declareBoli(playerId: UUID, boli: Int) {
        guard let round = game.currentRound else { return }
        guard boli >= 0 && boli <= round.cardsPerPlayer else { return }
        
        var updatedGame = game
        updatedGame.rounds[game.currentRoundIndex].boliDeclarations[playerId] = boli
        
        // Update player's current round Boli
        if let playerIndex = updatedGame.players.firstIndex(where: { $0.id == playerId }) {
            updatedGame.players[playerIndex].currentRoundBoli = boli
        }
        
        // Move to next player for Boli input
        currentBoliPlayerIndex = (currentBoliPlayerIndex + 1) % updatedGame.players.count
        
        // Check if all Boli declared
        if updatedGame.rounds[game.currentRoundIndex].boliDeclarations.count == updatedGame.players.count {
            updatedGame.gameState = .handPlay
            updatedGame.rounds[game.currentRoundIndex].currentHand = 1
        }
        
        game = updatedGame
    }
    
    func getCurrentBoliPlayer() -> Player? {
        guard currentBoliPlayerIndex < game.players.count else { return nil }
        return game.players[currentBoliPlayerIndex]
    }
    
    enum NavigationDirection {
        case forward
        case backward
    }
    
    func navigateBoliPlayer(direction: NavigationDirection) {
        guard game.currentRound != nil else { return }
        
        switch direction {
        case .backward:
            if currentBoliPlayerIndex > 0 {
                currentBoliPlayerIndex -= 1
            } else {
                currentBoliPlayerIndex = game.players.count - 1
            }
        case .forward:
            if currentBoliPlayerIndex < game.players.count - 1 {
                currentBoliPlayerIndex += 1
            } else {
                currentBoliPlayerIndex = 0
            }
        }
    }
    
    func canNavigateBoliPlayer(direction: NavigationDirection) -> Bool {
        // Can always navigate if there are multiple players
        return game.players.count > 1
    }
    
    // MARK: - Hand Management
    
    func recordHandWinner(playerId: UUID) {
        guard let round = game.currentRound,
              round.currentHand <= round.cardsPerPlayer else { return }
        
        var updatedGame = game
        
        // Increment hands won for this player
        let currentWins = updatedGame.rounds[game.currentRoundIndex].handsWon[playerId] ?? 0
        updatedGame.rounds[game.currentRoundIndex].handsWon[playerId] = currentWins + 1
        
        // Update player's current round wins
        if let playerIndex = updatedGame.players.firstIndex(where: { $0.id == playerId }) {
            updatedGame.players[playerIndex].currentRoundWins += 1
        }
        
        // Move to next hand
        updatedGame.rounds[game.currentRoundIndex].currentHand += 1
        
        game = updatedGame
        
        // Check if round is complete
        if game.rounds[game.currentRoundIndex].currentHand > round.cardsPerPlayer {
            completeRound()
        }
    }
    
    private func completeRound() {
        guard let round = game.currentRound else { return }
        
        var updatedGame = game
        
        // Calculate scores for all players
        for player in updatedGame.players {
            let boli = round.boliDeclarations[player.id] ?? 0
            let actualWins = round.handsWon[player.id] ?? 0
            let roundScore = ScoreCalculator.calculateScore(boli: boli, actualWins: actualWins)
            
            // Update total score
            if let playerIndex = updatedGame.players.firstIndex(where: { $0.id == player.id }) {
                updatedGame.players[playerIndex].totalScore += roundScore
            }
        }
        
        // Mark round as complete
        updatedGame.rounds[game.currentRoundIndex].isComplete = true
        updatedGame.gameState = .roundComplete
        
        // Check if game is complete
        if updatedGame.currentRoundIndex >= updatedGame.rounds.count - 1 {
            updatedGame.gameState = .gameComplete
        }
        
        game = updatedGame
    }
    
    func nextRound() {
        guard game.currentRoundIndex < game.rounds.count - 1 else {
            var updatedGame = game
            updatedGame.gameState = .gameComplete
            game = updatedGame
            return
        }
        
        var updatedGame = game
        updatedGame.currentRoundIndex += 1
        game = updatedGame
        startRound()
    }
    
    func getRoundScore(for playerId: UUID) -> Int {
        guard let round = game.currentRound else { return 0 }
        let boli = round.boliDeclarations[playerId] ?? 0
        let actualWins = round.handsWon[playerId] ?? 0
        return ScoreCalculator.calculateScore(boli: boli, actualWins: actualWins)
    }
    
    // MARK: - Game Management
    
    func startNewGame() {
        var newGame = Game()
        newGame.gameState = .setup
        game = newGame
        currentBoliPlayerIndex = 0
    }
    
    func endGameEarly() {
        // Complete current round if in progress
        if game.gameState == .handPlay || game.gameState == .boliInput {
            if let round = game.currentRound, round.currentHand > 0 {
                completeRound()
            }
        }
        
        // Mark all remaining rounds as complete (they won't affect scores)
        var updatedGame = game
        updatedGame.gameState = .gameComplete
        game = updatedGame
    }
    
    func updateHandWins(for roundIndex: Int, playerId: UUID, newWins: Int) {
        guard roundIndex < game.rounds.count else { return }
        guard newWins >= 0 else { return }
        
        var updatedGame = game
        let round = game.rounds[roundIndex]
        
        // Update hands won
        updatedGame.rounds[roundIndex].handsWon[playerId] = newWins
        
        // Recalculate scores for this round
        let boli = round.boliDeclarations[playerId] ?? 0
        let roundScore = ScoreCalculator.calculateScore(boli: boli, actualWins: newWins)
        
        // Find the original round score to adjust total
        let originalWins = round.handsWon[playerId] ?? 0
        let originalRoundScore = ScoreCalculator.calculateScore(boli: boli, actualWins: originalWins)
        let scoreDifference = roundScore - originalRoundScore
        
        // Update player's total score
        // Note: Don't update currentRoundWins here - that's only for the active round
        if let playerIndex = updatedGame.players.firstIndex(where: { $0.id == playerId }) {
            updatedGame.players[playerIndex].totalScore += scoreDifference
            // Only update currentRoundWins if this is the current round
            if roundIndex == updatedGame.currentRoundIndex {
                updatedGame.players[playerIndex].currentRoundWins = newWins
            }
        }
        
        game = updatedGame
    }
    
    func updateBoli(for roundIndex: Int, playerId: UUID, newBoli: Int) {
        guard roundIndex < game.rounds.count else { return }
        guard newBoli >= 0 else { return }
        
        var updatedGame = game
        let round = game.rounds[roundIndex]
        
        // Update Boli declaration
        updatedGame.rounds[roundIndex].boliDeclarations[playerId] = newBoli
        
        // Recalculate scores for this round with new Boli
        let actualWins = round.handsWon[playerId] ?? 0
        let roundScore = ScoreCalculator.calculateScore(boli: newBoli, actualWins: actualWins)
        
        // Find the original round score to adjust total
        let originalBoli = round.boliDeclarations[playerId] ?? 0
        let originalRoundScore = ScoreCalculator.calculateScore(boli: originalBoli, actualWins: actualWins)
        let scoreDifference = roundScore - originalRoundScore
        
        // Update player's total score
        if let playerIndex = updatedGame.players.firstIndex(where: { $0.id == playerId }) {
            updatedGame.players[playerIndex].totalScore += scoreDifference
            // Only update currentRoundBoli if this is the current round
            if roundIndex == updatedGame.currentRoundIndex {
                updatedGame.players[playerIndex].currentRoundBoli = newBoli
            }
        }
        
        game = updatedGame
    }
    
    func getCompletedRoundsCount() -> Int {
        return game.rounds.filter { $0.isComplete }.count
    }
}


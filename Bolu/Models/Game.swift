//
//  Game.swift
//  Bolu
//
//  Created on [Date]
//

import Foundation

enum GameState {
    case setup
    case boliInput
    case handPlay
    case roundComplete
    case gameComplete
}

struct Game {
    var players: [Player]
    var rounds: [Round]
    var currentRoundIndex: Int
    var gameState: GameState
    var shuffleStartPlayerIndex: Int // Index of player where shuffling starts
    
    init(players: [Player] = [], rounds: [Round] = [], currentRoundIndex: Int = 0, gameState: GameState = .setup, shuffleStartPlayerIndex: Int = 0) {
        self.players = players
        self.rounds = rounds
        self.currentRoundIndex = currentRoundIndex
        self.gameState = gameState
        self.shuffleStartPlayerIndex = shuffleStartPlayerIndex
    }
    
    var currentRound: Round? {
        guard currentRoundIndex < rounds.count else { return nil }
        return rounds[currentRoundIndex]
    }
    
    var totalRounds: Int {
        guard !players.isEmpty else { return 0 }
        return 52 / players.count
    }
    
    var isGameComplete: Bool {
        return currentRoundIndex >= rounds.count && !rounds.isEmpty
    }
    
    func getRankings() -> [Player] {
        return players.sorted { $0.totalScore > $1.totalScore }
    }
    
    func getWinner() -> Player? {
        return getRankings().first
    }
}


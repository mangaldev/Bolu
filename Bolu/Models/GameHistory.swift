//
//  GameHistory.swift
//  Bolu
//
//  Game history model for storing past games
//

import Foundation

struct GameHistory: Identifiable, Codable {
    let id: UUID
    let date: Date
    let players: [String] // Player names
    let winner: String
    let winnerScore: Int
    let totalRounds: Int
    let completedRounds: Int
    
    init(id: UUID = UUID(), date: Date = Date(), players: [String], winner: String, winnerScore: Int, totalRounds: Int, completedRounds: Int) {
        self.id = id
        self.date = date
        self.players = players
        self.winner = winner
        self.winnerScore = winnerScore
        self.totalRounds = totalRounds
        self.completedRounds = completedRounds
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}


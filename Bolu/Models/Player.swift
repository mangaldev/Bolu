//
//  Player.swift
//  Bolu
//
//  Created on [Date]
//

import Foundation

struct Player: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var totalScore: Int
    var currentRoundBoli: Int?
    var currentRoundWins: Int
    
    init(id: UUID = UUID(), name: String, totalScore: Int = 0, currentRoundBoli: Int? = nil, currentRoundWins: Int = 0) {
        self.id = id
        self.name = name
        self.totalScore = totalScore
        self.currentRoundBoli = currentRoundBoli
        self.currentRoundWins = currentRoundWins
    }
    
    mutating func resetRound() {
        currentRoundBoli = nil
        currentRoundWins = 0
    }
}


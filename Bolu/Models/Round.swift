//
//  Round.swift
//  Bolu
//
//  Created on [Date]
//

import Foundation

struct Round: Identifiable {
    let id: UUID
    let roundNumber: Int
    let cardsPerPlayer: Int
    var boliDeclarations: [UUID: Int] // Player ID -> Boli
    var handsWon: [UUID: Int] // Player ID -> Hands won
    var isComplete: Bool
    var currentHand: Int // Current hand number (1 to cardsPerPlayer)
    
    init(id: UUID = UUID(), roundNumber: Int, cardsPerPlayer: Int) {
        self.id = id
        self.roundNumber = roundNumber
        self.cardsPerPlayer = cardsPerPlayer
        self.boliDeclarations = [:]
        self.handsWon = [:]
        self.isComplete = false
        self.currentHand = 0
    }
    
    var allBoliDeclared: Bool {
        // This will be checked against player count in GameViewModel
        return false // Placeholder
    }
    
    var allHandsPlayed: Bool {
        return currentHand >= cardsPerPlayer
    }
}


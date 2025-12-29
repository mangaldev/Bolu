//
//  ScoreCalculator.swift
//  Bolu
//
//  Created on [Date]
//

import Foundation

struct ScoreCalculator {
    /// Calculate score based on Boli and actual wins
    /// - Parameters:
    ///   - boli: The declared Boli (predicted wins)
    ///   - actualWins: The actual number of hands won
    /// - Returns: Positive score if exact match, negative score otherwise
    static func calculateScore(boli: Int, actualWins: Int) -> Int {
        let baseScore = calculateBaseScore(boli: boli)
        
        if boli == actualWins {
            return baseScore // Positive score
        } else {
            return -baseScore // Negative score
        }
    }
    
    /// Calculate base score for a given Boli
    /// Formula: (Boli + 1) * 10 + Boli = 11 * Boli + 10
    /// Examples: 0 -> 10, 1 -> 21, 2 -> 32, 3 -> 43, 4 -> 54, 5 -> 65
    static func calculateBaseScore(boli: Int) -> Int {
        return (boli + 1) * 10 + boli
    }
}


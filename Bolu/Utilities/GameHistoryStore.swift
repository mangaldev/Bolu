//
//  GameHistoryStore.swift
//  Bolu
//
//  Storage service for game history
//

import Foundation
import Combine

class GameHistoryStore: ObservableObject {
    @Published var games: [GameHistory] = []
    
    private let storageKey = "BoluGameHistory"
    
    init() {
        loadGames()
    }
    
    func saveGame(_ game: GameHistory) {
        games.insert(game, at: 0) // Add to beginning (most recent first)
        saveGames()
    }
    
    func loadGames() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode([GameHistory].self, from: data) {
            games = decoded
        }
    }
    
    private func saveGames() {
        if let encoded = try? JSONEncoder().encode(games) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
        }
    }
    
    func clearHistory() {
        games = []
        UserDefaults.standard.removeObject(forKey: storageKey)
    }
}


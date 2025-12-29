//
//  BoluApp.swift
//  Bolu
//
//  Created on [Date]
//

import SwiftUI

@main
struct BoluApp: App {
    @StateObject private var gameViewModel = GameViewModel()
    @StateObject private var historyStore = GameHistoryStore()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(gameViewModel)
                .environmentObject(historyStore)
        }
    }
}


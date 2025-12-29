//
//  ContentView.swift
//  Bolu
//
//  Created on [Date]
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: GameViewModel
    @EnvironmentObject var historyStore: GameHistoryStore
    
    var body: some View {
        Group {
            if viewModel.game.players.isEmpty {
                PlayerSetupView(viewModel: viewModel)
            } else {
                NavigationView {
                    GameView(viewModel: viewModel, historyStore: historyStore)
                }
            }
        }
    }
}


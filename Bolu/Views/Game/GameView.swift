//
//  GameView.swift
//  Bolu
//
//  Created on [Date]
//

import SwiftUI

struct GameView: View {
    @ObservedObject var viewModel: GameViewModel
    @ObservedObject var historyStore: GameHistoryStore
    @State private var showingRoundResults = false
    @State private var showingMenu = false
    @State private var showingHistory = false
    @State private var showingEditRounds = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Header with round info and rankings
            GameHeaderView(viewModel: viewModel, showingMenu: $showingMenu)
            
            Divider()
            
            // Main game area
            ZStack {
                switch viewModel.game.gameState {
                case .setup:
                    Text("Press 'Start Round' to begin")
                        .foregroundColor(.secondary)
                    
                case .boliInput:
                    BoliInputView(viewModel: viewModel)
                    
                case .handPlay:
                    HandPlayView(viewModel: viewModel)
                    
                case .roundComplete:
                    RoundResultsView(viewModel: viewModel) {
                        if viewModel.game.isGameComplete {
                            viewModel.game.gameState = .gameComplete
                        } else {
                            viewModel.nextRound()
                        }
                    }
                    
                case .gameComplete:
                    WinnerAnnouncementView(viewModel: viewModel, historyStore: historyStore, onNewGame: {
                        viewModel.startNewGame()
                    })
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .navigationTitle("Bolu")
        .navigationBarTitleDisplayMode(.inline)
        .overlay(
            // Menu overlay
            Group {
                if showingMenu {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                        .onTapGesture {
                            showingMenu = false
                        }
                    
                    VStack {
                        HStack {
                            Spacer()
                            GameMenuView(
                                isPresented: $showingMenu,
                                onNewGame: {
                                    viewModel.startNewGame()
                                },
                                onEditRounds: {
                                    showingEditRounds = true
                                },
                                onEndGame: {
                                    viewModel.endGameEarly()
                                },
                                onViewHistory: {
                                    showingHistory = true
                                }
                            )
                            .padding(.top, 60)
                            .padding(.trailing, 16)
                        }
                        Spacer()
                    }
                }
            }
        )
        .sheet(isPresented: $showingHistory) {
            GameHistoryView(historyStore: historyStore)
        }
        .sheet(isPresented: $showingEditRounds) {
            EditRoundsView(viewModel: viewModel)
        }
    }
}

struct GameHeaderView: View {
    @ObservedObject var viewModel: GameViewModel
    @Binding var showingMenu: Bool
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                // Hamburger menu button
                HamburgerMenuButton(isMenuPresented: $showingMenu)
                
                if let round = viewModel.game.currentRound {
                    Text("Round \(round.roundNumber) of \(viewModel.game.rounds.count)")
                        .font(.headline)
                } else {
                    Text("Ready to Start")
                        .font(.headline)
                }
                
                Spacer()
                
                if viewModel.game.gameState == .setup || viewModel.game.gameState == .roundComplete {
                    Button("Start Round") {
                        viewModel.startRound()
                    }
                    .buttonStyle(ProminentButtonStyle())
                }
            }
            .padding(.horizontal)
            
            // Current rankings
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(viewModel.game.getRankings()) { player in
                        VStack(spacing: 4) {
                            Text(player.name)
                                .font(.caption)
                                .lineLimit(1)
                            Text("\(player.totalScore)")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(player.totalScore >= 0 ? .green : .red)
                        }
                        .padding(8)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.vertical, 8)
    }
}


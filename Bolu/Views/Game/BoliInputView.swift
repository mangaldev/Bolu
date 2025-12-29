//
//  BoliInputView.swift
//  Bolu
//
//  Created on [Date]
//

import SwiftUI

struct BoliInputView: View {
    @ObservedObject var viewModel: GameViewModel
    @State private var selectedBoli: Int = 0
    
    var body: some View {
        VStack(spacing: 30) {
            if let currentPlayer = viewModel.getCurrentBoliPlayer(),
               let round = viewModel.game.currentRound {
                
                Text("Declare Boli")
                    .font(.title)
                    .fontWeight(.bold)
                
                VStack(spacing: 15) {
                    // Player name with navigation buttons
                    HStack {
                        // Back button
                        Button(action: {
                            viewModel.navigateBoliPlayer(direction: .backward)
                            updateSelectedBoli()
                        }) {
                            Image(systemName: "chevron.left.circle.fill")
                                .font(.title2)
                                .foregroundColor(.blue)
                        }
                        .disabled(!viewModel.canNavigateBoliPlayer(direction: .backward))
                        
                        Spacer()
                        
                        Text("\(currentPlayer.name)'s turn")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        // Forward button
                        Button(action: {
                            viewModel.navigateBoliPlayer(direction: .forward)
                            updateSelectedBoli()
                        }) {
                            Image(systemName: "chevron.right.circle.fill")
                                .font(.title2)
                                .foregroundColor(.blue)
                        }
                        .disabled(!viewModel.canNavigateBoliPlayer(direction: .forward))
                    }
                    .padding(.horizontal)
                    
                    Text("Round \(round.roundNumber) - \(round.cardsPerPlayer) cards per player")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    // Combined question and counter in one line
                    HStack {
                        Text("How many hands will you win?")
                            .font(.headline)
                        
                        Text("\(selectedBoli)")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                            .frame(minWidth: 30)
                    }
                    .padding(.top)
                }
                
                // Boli selector
                VStack(spacing: 20) {
                    Picker("Boli", selection: $selectedBoli) {
                        ForEach(0...round.cardsPerPlayer, id: \.self) { value in
                            Text("\(value)").tag(value)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(height: 150)
                }
                .padding()
                
                Button("Confirm Boli") {
                    viewModel.declareBoli(playerId: currentPlayer.id, boli: selectedBoli)
                    updateSelectedBoli()
                }
                .buttonStyle(ProminentButtonStyle())
                .font(.headline)
                .padding()
            }
            
            Spacer()
        }
        .padding()
        .onAppear {
            updateSelectedBoli()
        }
    }
    
    private func updateSelectedBoli() {
        if let currentPlayer = viewModel.getCurrentBoliPlayer(),
           let round = viewModel.game.currentRound {
            // Get existing Boli if already declared, otherwise use current selection
            selectedBoli = round.boliDeclarations[currentPlayer.id] ?? selectedBoli
        }
    }
}


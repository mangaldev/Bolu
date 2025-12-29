//
//  HandPlayView.swift
//  Bolu
//
//  Created on [Date]
//

import SwiftUI

struct HandPlayView: View {
    @ObservedObject var viewModel: GameViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            if let round = viewModel.game.currentRound {
                // Round info
                VStack(spacing: 10) {
                    Text("Hand \(round.currentHand) of \(round.cardsPerPlayer)")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Tap the player who won this hand")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                .padding()
                
                // Player buttons
                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 15) {
                        ForEach(viewModel.game.players) { player in
                            PlayerHandButton(
                                player: player,
                                round: round,
                                action: {
                                    viewModel.recordHandWinner(playerId: player.id)
                                }
                            )
                        }
                    }
                    .padding()
                }
                
                // Current round stats
                VStack(spacing: 10) {
                    Text("Current Round Stats")
                        .font(.headline)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(viewModel.game.players) { player in
                                VStack(spacing: 4) {
                                    Text(player.name)
                                        .font(.caption)
                                    Text("Boli: \(player.currentRoundBoli ?? 0)")
                                        .font(.caption)
                                    Text("Wins: \(player.currentRoundWins)")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                }
                                .padding(8)
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(8)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding()
            }
        }
    }
}

struct PlayerHandButton: View {
    let player: Player
    let round: Round
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 10) {
                Text(player.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                if let boli = player.currentRoundBoli {
                    Text("Boli: \(boli)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Text("Wins: \(player.currentRoundWins)")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.blue.opacity(0.3), lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}


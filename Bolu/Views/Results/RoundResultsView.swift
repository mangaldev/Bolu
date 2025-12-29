//
//  RoundResultsView.swift
//  Bolu
//
//  Created on [Date]
//

import SwiftUI

struct RoundResultsView: View {
    @ObservedObject var viewModel: GameViewModel
    let onContinue: () -> Void
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if let round = viewModel.game.currentRound {
                    Text("Round \(round.roundNumber) Complete!")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top)
                    
                    Text("Round Scores")
                        .font(.headline)
                        .padding(.top)
                    
                    ForEach(viewModel.game.players) { player in
                        RoundScoreCard(
                            player: player,
                            roundScore: viewModel.getRoundScore(for: player.id),
                            boli: round.boliDeclarations[player.id] ?? 0,
                            actualWins: round.handsWon[player.id] ?? 0
                        )
                    }
                    .padding(.horizontal)
                    
                    Button(action: onContinue) {
                        if viewModel.game.isGameComplete {
                            Text("View Final Results")
                                .font(.headline)
                        } else {
                            Text("Next Round")
                                .font(.headline)
                        }
                    }
                    .buttonStyle(ProminentButtonStyle())
                    .padding()
                }
            }
        }
    }
}

struct RoundScoreCard: View {
    let player: Player
    let roundScore: Int
    let boli: Int
    let actualWins: Int
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(player.name)
                    .font(.headline)
                
                Text("Boli: \(boli) | Won: \(actualWins)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text("\(roundScore >= 0 ? "+" : "")\(roundScore)")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(roundScore >= 0 ? .green : .red)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}


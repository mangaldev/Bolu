//
//  FinalResultsView.swift
//  Bolu
//
//  Created on [Date]
//

import SwiftUI

struct FinalResultsView: View {
    @ObservedObject var viewModel: GameViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                Text("Game Complete!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top)
                
                if let winner = viewModel.game.getWinner() {
                    VStack(spacing: 10) {
                        Text("🏆 Winner 🏆")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text(winner.name)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.yellow)
                        
                        Text("Score: \(winner.totalScore)")
                            .font(.title2)
                            .foregroundColor(.green)
                    }
                    .padding()
                    .background(Color.yellow.opacity(0.2))
                    .cornerRadius(15)
                    .padding()
                }
                
                Text("Final Rankings")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                ForEach(Array(viewModel.game.getRankings().enumerated()), id: \.element.id) { index, player in
                    RankingCard(
                        rank: index + 1,
                        player: player,
                        isWinner: index == 0
                    )
                }
                .padding(.horizontal)
            }
        }
    }
}

struct RankingCard: View {
    let rank: Int
    let player: Player
    let isWinner: Bool
    
    var body: some View {
        HStack {
            Text("\(rank)")
                .font(.title)
                .fontWeight(.bold)
                .frame(width: 50)
                .foregroundColor(isWinner ? .yellow : .primary)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(player.name)
                    .font(.headline)
                
                Text("Total Score")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text("\(player.totalScore)")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(player.totalScore >= 0 ? .green : .red)
        }
        .padding()
        .background(isWinner ? Color.yellow.opacity(0.2) : Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}


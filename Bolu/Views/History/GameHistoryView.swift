//
//  GameHistoryView.swift
//  Bolu
//
//  View to browse game history
//

import SwiftUI

struct GameHistoryView: View {
    @ObservedObject var historyStore: GameHistoryStore
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Group {
                if historyStore.games.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "clock")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        Text("No Game History")
                            .font(.title2)
                            .foregroundColor(.secondary)
                        Text("Play some games to see history here")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                } else {
                    List {
                        ForEach(historyStore.games) { game in
                            GameHistoryRow(game: game)
                        }
                    }
                }
            }
            .navigationTitle("Game History")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: historyStore.games.isEmpty ? AnyView(EmptyView()) : AnyView(
                    Button("Clear") {
                        historyStore.clearHistory()
                    }
                )
            )
        }
    }
}

struct GameHistoryRow: View {
    let game: GameHistory
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("🏆 \(game.winner)")
                    .font(.headline)
                    .foregroundColor(.yellow)
                
                Spacer()
                
                Text("\(game.winnerScore)")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(game.winnerScore >= 0 ? .green : .red)
            }
            
            Text(game.formattedDate)
                .font(.caption)
                .foregroundColor(.secondary)
            
            HStack {
                Text("\(game.completedRounds)/\(game.totalRounds) rounds")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text("\(game.players.count) players")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            // Player list
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(game.players, id: \.self) { player in
                        Text(player)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(8)
                    }
                }
            }
        }
        .padding(.vertical, 4)
    }
}


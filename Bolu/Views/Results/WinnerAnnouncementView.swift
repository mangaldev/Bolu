//
//  WinnerAnnouncementView.swift
//  Bolu
//
//  Winner announcement with flashy animation
//

import SwiftUI

struct WinnerAnnouncementView: View {
    @ObservedObject var viewModel: GameViewModel
    @ObservedObject var historyStore: GameHistoryStore
    let onNewGame: () -> Void
    
    @State private var scale: CGFloat = 0.5
    @State private var pulseScale: CGFloat = 1.0
    @State private var rotation: Double = 0
    @State private var opacity: Double = 0
    @State private var sparkleRotation: Double = 0
    @State private var isAnimating = true
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                if let winner = viewModel.game.getWinner() {
                    // Animated Winner Section
                    VStack(spacing: 20) {
                        // Sparkle effect
                        ZStack {
                            ForEach(0..<8) { index in
                                Image(systemName: "sparkle")
                                    .font(.title)
                                    .foregroundColor(.yellow)
                                    .offset(x: cos(Double(index) * .pi / 4) * 60,
                                           y: sin(Double(index) * .pi / 4) * 60)
                                    .rotationEffect(.degrees(sparkleRotation))
                                    .opacity(isAnimating ? 0.7 : 0.3)
                            }
                            
                            // Winner name with animation
                            VStack(spacing: 15) {
                                Text("🏆")
                                    .font(.system(size: 80))
                                    .scaleEffect(scale * pulseScale)
                                    .rotationEffect(.degrees(rotation))
                                
                                Text("WINNER")
                                    .font(.system(size: 32, weight: .black))
                                    .foregroundColor(.yellow)
                                    .opacity(opacity)
                                
                                Text(winner.name)
                                    .font(.system(size: 48, weight: .bold))
                                    .foregroundColor(.yellow)
                                    .scaleEffect(scale * pulseScale)
                                    .opacity(opacity)
                                
                                Text("Score: \(winner.totalScore)")
                                    .font(.title2)
                                    .foregroundColor(.green)
                                    .opacity(opacity)
                            }
                        }
                        .frame(height: 250)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.yellow.opacity(0.3), Color.orange.opacity(0.2)]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    )
                    .padding()
                    .onAppear {
                        startAnimations()
                        saveGameToHistory(winner: winner)
                    }
                    
                    // Final Rankings
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
                    
                    // New Game Button
                    Button(action: onNewGame) {
                        Text("Start New Game")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                }
            }
            .padding(.top)
        }
    }
    
    private func startAnimations() {
        // Initial scale and opacity animation
        withAnimation(.spring(response: 0.6, dampingFraction: 0.6)) {
            scale = 1.0
            opacity = 1.0
        }
        
        // Rotation animation (delayed to avoid conflict)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                rotation = 360
            }
        }
        
        // Sparkle rotation (delayed)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.linear(duration: 3).repeatForever(autoreverses: false)) {
                sparkleRotation = 360
            }
        }
        
        // Pulsing effect (delayed and separate scale)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                pulseScale = 1.1
            }
        }
    }
    
    private func saveGameToHistory(winner: Player) {
        let gameHistory = GameHistory(
            players: viewModel.game.players.map { $0.name },
            winner: winner.name,
            winnerScore: winner.totalScore,
            totalRounds: viewModel.game.rounds.count,
            completedRounds: viewModel.getCompletedRoundsCount()
        )
        historyStore.saveGame(gameHistory)
    }
}


//
//  EditRoundsView.swift
//  Bolu
//
//  View to edit hand wins for previous rounds
//

import SwiftUI

struct EditRoundsView: View {
    @ObservedObject var viewModel: GameViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedRoundIndex: Int = 0
    
    var completedRounds: [Round] {
        viewModel.game.rounds.filter { $0.isComplete }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                if completedRounds.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "pencil.circle")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        Text("No Completed Rounds")
                            .font(.title2)
                            .foregroundColor(.secondary)
                        Text("Complete at least one round to edit")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                } else {
                    // Round selector
                    Picker("Round", selection: $selectedRoundIndex) {
                        ForEach(0..<completedRounds.count, id: \.self) { index in
                            Text("Round \(completedRounds[index].roundNumber)").tag(index)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding()
                    
                    // Round details
                    if selectedRoundIndex < completedRounds.count {
                        let round = completedRounds[selectedRoundIndex]
                        let roundIndex = round.roundNumber - 1
                        
                        ScrollView {
                            VStack(spacing: 15) {
                                Text("Round \(round.roundNumber)")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                
                                Text("\(round.cardsPerPlayer) cards per player")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                ForEach(viewModel.game.players) { player in
                                    EditPlayerCard(
                                        player: player,
                                        round: round,
                                        roundIndex: roundIndex,
                                        onUpdateWins: { newWins in
                                            viewModel.updateHandWins(
                                                for: roundIndex,
                                                playerId: player.id,
                                                newWins: newWins
                                            )
                                        },
                                        onUpdateBoli: { newBoli in
                                            viewModel.updateBoli(
                                                for: roundIndex,
                                                playerId: player.id,
                                                newBoli: newBoli
                                            )
                                        }
                                    )
                                    .id("\(player.id)-\(roundIndex)-\(round.roundNumber)") // Force recreation when round changes
                                }
                            }
                            .padding()
                        }
                        .id("round-\(roundIndex)") // Force refresh when round changes
                    }
                }
            }
            .navigationTitle("Edit Round")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

struct EditPlayerCard: View {
    let player: Player
    let round: Round
    let roundIndex: Int
    let onUpdateWins: (Int) -> Void
    let onUpdateBoli: (Int) -> Void
    
    @State private var localWins: Int
    @State private var localBoli: Int
    @State private var showingBoliEditor = false
    
    init(player: Player, round: Round, roundIndex: Int, onUpdateWins: @escaping (Int) -> Void, onUpdateBoli: @escaping (Int) -> Void) {
        self.player = player
        self.round = round
        self.roundIndex = roundIndex
        self.onUpdateWins = onUpdateWins
        self.onUpdateBoli = onUpdateBoli
        _localWins = State(initialValue: round.handsWon[player.id] ?? 0)
        _localBoli = State(initialValue: round.boliDeclarations[player.id] ?? 0)
    }
    
    // Update local values when round changes
    private var actualWins: Int {
        round.handsWon[player.id] ?? 0
    }
    
    private var actualBoli: Int {
        round.boliDeclarations[player.id] ?? 0
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Player name and Boli with edit button
            HStack {
                Text(player.name)
                    .font(.headline)
                
                Spacer()
                
                HStack(spacing: 8) {
                    Text("Boli: \(localBoli)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Button(action: {
                        showingBoliEditor = true
                    }) {
                        Image(systemName: "pencil")
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                }
            }
            
            // Hands Won section
            HStack {
                Text("Hands Won:")
                    .font(.subheadline)
                
                Spacer()
                
                // Decrease button
                Button(action: {
                    if localWins > 0 {
                        localWins -= 1
                        onUpdateWins(localWins)
                    }
                }) {
                    Image(systemName: "minus.circle.fill")
                        .foregroundColor(.red)
                        .font(.title2)
                }
                .disabled(localWins == 0)
                
                Text("\(localWins)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .frame(minWidth: 40)
                
                // Increase button
                Button(action: {
                    if localWins < round.cardsPerPlayer {
                        localWins += 1
                        onUpdateWins(localWins)
                    }
                }) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.green)
                        .font(.title2)
                }
                .disabled(localWins >= round.cardsPerPlayer)
            }
            
            // Score preview
            let score = ScoreCalculator.calculateScore(boli: localBoli, actualWins: localWins)
            Text("Score: \(score >= 0 ? "+" : "")\(score)")
                .font(.caption)
                .foregroundColor(score >= 0 ? .green : .red)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
        .onAppear {
            // Sync local values when view appears (round changes)
            localWins = actualWins
            localBoli = actualBoli
        }
        .sheet(isPresented: $showingBoliEditor) {
            EditBoliView(
                currentBoli: localBoli,
                maxBoli: round.cardsPerPlayer,
                playerName: player.name,
                onSave: { newBoli in
                    localBoli = newBoli
                    onUpdateBoli(newBoli)
                    showingBoliEditor = false
                },
                onCancel: {
                    showingBoliEditor = false
                }
            )
        }
    }
}

struct EditBoliView: View {
    let currentBoli: Int
    let maxBoli: Int
    let playerName: String
    let onSave: (Int) -> Void
    let onCancel: () -> Void
    
    @State private var selectedBoli: Int
    
    init(currentBoli: Int, maxBoli: Int, playerName: String, onSave: @escaping (Int) -> Void, onCancel: @escaping () -> Void) {
        self.currentBoli = currentBoli
        self.maxBoli = maxBoli
        self.playerName = playerName
        self.onSave = onSave
        self.onCancel = onCancel
        _selectedBoli = State(initialValue: currentBoli)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Text("Edit Boli for \(playerName)")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.top)
                
                Text("How many hands will you win?")
                    .font(.headline)
                
                Picker("Boli", selection: $selectedBoli) {
                    ForEach(0...maxBoli, id: \.self) { value in
                        Text("\(value)").tag(value)
                    }
                }
                .pickerStyle(.wheel)
                .frame(height: 150)
                
                HStack(spacing: 20) {
                    Button("Cancel") {
                        onCancel()
                    }
                    .buttonStyle(BorderedButtonStyle())
                    
                    Button("Save") {
                        onSave(selectedBoli)
                    }
                    .buttonStyle(ProminentButtonStyle())
                }
                .padding()
                
                Spacer()
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}


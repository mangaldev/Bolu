//
//  PlayerSetupView.swift
//  Bolu
//
//  Created on [Date]
//

import SwiftUI

struct PlayerSetupView: View {
    @ObservedObject var viewModel: GameViewModel
    @State private var numberOfPlayers: String = ""
    @State private var playerNames: [String] = []
    @State private var showingEditOrder = false
    @State private var isEditing = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                if playerNames.isEmpty {
                    // Initial setup
                    VStack(spacing: 20) {
                        Text("How many players?")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        TextField("Enter number (1-10)", text: $numberOfPlayers)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                            .padding(.horizontal)
                        
                        Button("Continue") {
                            setupPlayers()
                        }
                        .buttonStyle(ProminentButtonStyle())
                        .disabled(!isValidPlayerCount)
                    }
                    .padding()
                } else {
                    // Player names input
                    VStack(spacing: 20) {
                        Text("Enter Player Names")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text("Order: \(playerNames.count) players")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        ScrollView {
                            VStack(spacing: 15) {
                                ForEach(0..<playerNames.count, id: \.self) { index in
                                    HStack {
                                        Text("Player \(index + 1):")
                                            .frame(width: 80, alignment: .leading)
                                        TextField("Name", text: $playerNames[index])
                                            .textFieldStyle(RoundedBorderTextFieldStyle())
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        }
                        
                        HStack(spacing: 20) {
                            Button("Edit Order") {
                                showingEditOrder = true
                            }
                            .buttonStyle(BorderedButtonStyle())
                            
                            Button("Start Game") {
                                startGame()
                            }
                            .buttonStyle(ProminentButtonStyle())
                            .disabled(!allNamesEntered)
                        }
                    }
                    .padding()
                }
                
                // Round calculation display
                if !playerNames.isEmpty {
                    let rounds = calculateRounds(playerCount: playerNames.count)
                    Text("Total Rounds: \(rounds)")
                        .font(.headline)
                        .foregroundColor(.blue)
                        .padding()
                }
            }
            .navigationTitle("Bolu Setup")
            .sheet(isPresented: $showingEditOrder) {
                PlayerEditOrderView(playerNames: $playerNames)
            }
        }
    }
    
    private var isValidPlayerCount: Bool {
        guard let count = Int(numberOfPlayers),
              count >= Constants.minPlayers,
              count <= Constants.maxPlayers else {
            return false
        }
        return true
    }
    
    private var allNamesEntered: Bool {
        return playerNames.allSatisfy { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
    }
    
    private func setupPlayers() {
        guard let count = Int(numberOfPlayers),
              count >= Constants.minPlayers,
              count <= Constants.maxPlayers else {
            return
        }
        
        playerNames = Array(repeating: "", count: count)
    }
    
    private func calculateRounds(playerCount: Int) -> Int {
        guard playerCount > 0 else { return 0 }
        return Constants.totalCards / playerCount
    }
    
    private func startGame() {
        let players = playerNames.enumerated().map { index, name in
            Player(name: name.isEmpty ? "Player \(index + 1)" : name)
        }
        viewModel.setPlayers(players)
    }
}

struct PlayerEditOrderView: View {
    @Binding var playerNames: [String]
    @Environment(\.presentationMode) var presentationMode
    @State private var editableNames: [String]
    
    init(playerNames: Binding<[String]>) {
        self._playerNames = playerNames
        self._editableNames = State(initialValue: playerNames.wrappedValue)
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(0..<editableNames.count, id: \.self) { index in
                    HStack {
                        Text("\(index + 1).")
                            .frame(width: 30)
                        TextField("Name", text: $editableNames[index])
                    }
                }
                .onMove { source, destination in
                    editableNames.move(fromOffsets: source, toOffset: destination)
                }
            }
            .navigationTitle("Edit Order")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        playerNames = editableNames
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
            }
        }
    }
}


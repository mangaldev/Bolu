//
//  GameMenuView.swift
//  Bolu
//
//  Hamburger menu for game options
//

import SwiftUI

struct GameMenuView: View {
    @Binding var isPresented: Bool
    let onNewGame: () -> Void
    let onEditRounds: () -> Void
    let onEndGame: () -> Void
    let onViewHistory: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Menu items
            MenuButton(title: "New Game", icon: "plus.circle.fill") {
                isPresented = false
                onNewGame()
            }
            
            Divider()
            
            MenuButton(title: "Edit Round", icon: "pencil.circle.fill") {
                isPresented = false
                onEditRounds()
            }
            
            Divider()
            
            MenuButton(title: "End Game", icon: "flag.checkered.circle.fill") {
                isPresented = false
                onEndGame()
            }
            
            Divider()
            
            MenuButton(title: "Game History", icon: "clock.fill") {
                isPresented = false
                onViewHistory()
            }
        }
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 10)
        .frame(width: 250)
    }
}

struct MenuButton: View {
    let title: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                    .frame(width: 24)
                Text(title)
                    .foregroundColor(.primary)
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct HamburgerMenuButton: View {
    @Binding var isMenuPresented: Bool
    
    var body: some View {
        Button(action: {
            isMenuPresented.toggle()
        }) {
            Image(systemName: "line.3.horizontal")
                .font(.title2)
                .foregroundColor(.primary)
                .padding(8)
        }
    }
}


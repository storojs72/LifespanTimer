//
//  SettingsView.swift
//  LifespanTimer
//
//  Created by Artem Storozhuk on 24.09.2025.
//

import SwiftUI

struct SettingsView: View {
    @Binding var showInitialTimer: Bool

    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Timer")
                    .foregroundColor(.white)
                    .fontDesign(.monospaced)
                ) {
                    Button(action: {
                        showInitialTimer.toggle() // toggle visibility
                    }) {
                        Text(showInitialTimer ? "Hide Initial Timer" : "Show Initial Timer")
                    }
                }

                Section(header: Text("Support us")
                    .foregroundColor(.white)
                    .fontDesign(.monospaced)
                ) {
                    NavigationLink(destination: DonateSelectionView()) {
                        Label("Donate", systemImage: "heart.fill")
                            .foregroundColor(.red)
                    }
                }

                Section(header: Text("Information")
                    .foregroundColor(.white)
                    .fontDesign(.monospaced)
                ) {
                    Link(destination: URL(string: "https://storojs72.github.io/lifespan-timer-support/privacy.html")!) {
                        Label("Privacy Policy", systemImage: "lock.shield")
                    }

                    Link(destination: URL(string: "https://storojs72.github.io/lifespan-timer-support/index.html")!) {
                        Label("Support", systemImage: "questionmark.circle")
                    }
                }
            }
            .navigationTitle("")
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Settings")
                        .multilineTextAlignment(.center)
                        .fontDesign(.monospaced)
                        .foregroundStyle(.white)
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.black)
        }
    }
}

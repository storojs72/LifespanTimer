//
//  ContentView.swift
//  LifespanTimer
//
//  Created by Artem Storozhuk on 09.09.2025.
//

import SwiftUI
import WidgetKit

struct ContentView: View {
    @AppStorage("welcomeScreenShown", store: UserDefaults(suiteName: "group.lifespan-timer"))
    var welcomeScreenShown: Bool = false

    @AppStorage("userAlreadyLivedMoreThanAverage", store: UserDefaults(suiteName: "group.lifespan-timer"))
    var userAlreadyLivedMoreThanAverage: Bool = false

    var body: some View {
        if welcomeScreenShown {
            ZStack {
                Color.primary.ignoresSafeArea()
                if userAlreadyLivedMoreThanAverage {
                    LifetimeIsZeroFlowView().padding()
                } else {
                    RegularFlowView().padding()
                }
            }
        } else {
            InitialView()
        }
    }
}

func get_lifetime_to_display() -> Date {
    @AppStorage("welcomeScreenShown", store: UserDefaults(suiteName: "group.lifespan-timer"))
    var welcomeScreenShown: Bool = false

    @AppStorage("userAlreadyLivedMoreThanAverage", store: UserDefaults(suiteName: "group.lifespan-timer"))
    var userAlreadyLivedMoreThanAverage: Bool = false

    @AppStorage("lifetime", store: UserDefaults(suiteName: "group.lifespan-timer"))
    var lifetime: Double = 0.0

    @AppStorage("lifetimeUpdateable", store: UserDefaults(suiteName: "group.lifespan-timer"))
    var lifetimeUpdateable: Double = 0.0

    @AppStorage("deathDate", store: UserDefaults(suiteName: "group.lifespan-timer"))
    var deathDate: Double = 0.0

    if userAlreadyLivedMoreThanAverage {
        let lifetimeDate = Calendar.current.date(byAdding: .year, value: 20, to: Date())!
        lifetime = lifetimeDate.timeIntervalSince1970
        lifetimeUpdateable = lifetime
    } else {
        let now = Date().timeIntervalSince1970
        let lifetimeDate = Date().addingTimeInterval(deathDate - now)
        lifetime = lifetimeDate.timeIntervalSince1970
        lifetimeUpdateable = lifetime
    }

    return Date(timeIntervalSince1970: lifetime)
}

func get_lifetime_to_display_updateable() -> Date {
    @AppStorage("welcomeScreenShown", store: UserDefaults(suiteName: "group.lifespan-timer"))
    var welcomeScreenShown: Bool = false

    @AppStorage("userAlreadyLivedMoreThanAverage", store: UserDefaults(suiteName: "group.lifespan-timer"))
    var userAlreadyLivedMoreThanAverage: Bool = false

    @AppStorage("lifetime", store: UserDefaults(suiteName: "group.lifespan-timer"))
    var lifetime: Double = 0.0

    @AppStorage("lifetimeUpdateable", store: UserDefaults(suiteName: "group.lifespan-timer"))
    var lifetimeUpdateable: Double = 0.0

    @AppStorage("deathDateUpdateable", store: UserDefaults(suiteName: "group.lifespan-timer"))
    var deathDateUpdateable: Double = 0.0

    if userAlreadyLivedMoreThanAverage {
        let lifetimeDate = Calendar.current.date(byAdding: .year, value: 20, to: Date())!
        lifetime = lifetimeDate.timeIntervalSince1970
    } else {
        let now = Date().timeIntervalSince1970
        let lifetimeDate = Date().addingTimeInterval(deathDateUpdateable - now)
        lifetimeUpdateable = lifetimeDate.timeIntervalSince1970
    }

    return Date(timeIntervalSince1970: lifetimeUpdateable)
}

struct RegularFlowView: View {
    @State private var refreshID = UUID()
    @State private var showInitialTimer = false

    @State private var showPlusSelection = false
    @State private var showMinusSelection = false

    @State private var showDonateSelection = false


    @AppStorage("deathDateUpdateable", store: UserDefaults(suiteName: "group.lifespan-timer"))
    var deathDateUpdateable: Double = 0.0

    @AppStorage("lifetime", store: UserDefaults(suiteName: "group.lifespan-timer"))
    var lifetime: Double = 0.0

    @AppStorage("lifetimeUpdateable", store: UserDefaults(suiteName: "group.lifespan-timer"))
    var lifetimeUpdateable: Double = 0.0

    @AppStorage("targetDate", store: UserDefaults(suiteName: "group.lifespan-timer"))
    var targetDate: Date = Date()

    var body: some View {
        VStack(spacing: 20) {
            Text("")
            Text("")
            Text("")
            Text("Your lifetime available:")
                .multilineTextAlignment(.center)
                .foregroundStyle(.white)
                .font(.largeTitle)
                .fontDesign(.monospaced)
                .frame(width: 300)
            

            Text(get_lifetime_to_display_updateable(), style: .timer)
                .multilineTextAlignment(.center)
                .font(.largeTitle)
                .fontDesign(.monospaced)
                .foregroundStyle(.green)
                .id(refreshID)


            if showInitialTimer {
                Text(get_lifetime_to_display(), style: .timer)
                    .multilineTextAlignment(.center)
                    .font(.largeTitle)
                    .fontDesign(.monospaced)
                    .foregroundStyle(.green)
                    .transition(.slide) // optional animation
            } else {
                Text("")
                    .multilineTextAlignment(.center)
                    .font(.largeTitle)
                    .fontDesign(.monospaced)
                    .foregroundStyle(.green)
                    .transition(.slide) // optional animation
            }

            Button(action: {
                showInitialTimer.toggle() // toggle visibility
            }) {
                Text(showInitialTimer ? "Hide initial" : "Show initial")
                    .padding()
                    .fontDesign(.monospaced)
                    .background(Color.black)
                    .foregroundColor(.blue)
                    .cornerRadius(10)
            }

            Text("")

            HStack(spacing: 20) {
                Button(action: {
                    showMinusSelection = true
                }) {
                    Text("-")
                        .padding(20)
                        .font(.largeTitle)
                        .fontDesign(.monospaced)
                        .frame(maxWidth: .infinity) // expand equally
                        .background(Color.red)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                }

                Button(action: {
                    showPlusSelection = true
                }) {
                    Text("+")
                        .padding(20)
                        .font(.largeTitle)
                        .fontDesign(.monospaced)
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal) // optional padding around buttons

            Button(action: {
                showDonateSelection = true
            }) {
                Text("Donate")
                    .padding()
                    .fontDesign(.monospaced)
                    .background(Color.black)
                    .foregroundColor(.blue)
                    .cornerRadius(10)
            }

        }
        .animation(.default, value: showInitialTimer)
        .sheet(isPresented: $showPlusSelection) {
                PlusSelectionView(deathDateUpdateable: $deathDateUpdateable, refreshID: $refreshID)
        }
        .sheet(isPresented: $showMinusSelection) {
                MinusSelectionView(deathDateUpdateable: $deathDateUpdateable, refreshID: $refreshID)
        }
        .sheet(isPresented: $showDonateSelection) {
                DonateSelectionView()
        }
    }
}

struct LifetimeIsZeroFlowView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Congratulations! You have already lived longer than the average life expectancy in your country. Try to live next 20 years")
                .multilineTextAlignment(.center)
                .foregroundStyle(.white)
                .font(.title3)
                .fontDesign(.monospaced)
                .frame(width: 300)
            Text(get_lifetime_to_display(), style: .timer)
                .multilineTextAlignment(.center)
                .font(.largeTitle)
                .fontDesign(.monospaced)
                .foregroundStyle(.green)
        }
    }
}

#Preview {
    ContentView()
}

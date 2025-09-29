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

    var body: some View {
        if welcomeScreenShown {
            ZStack {
                Color.primary.ignoresSafeArea()
                RegularFlowView().padding()
            }
        } else {
            InitialView()
        }
    }
}

func get_lifetime_to_display() -> Date {
    @AppStorage("lifetime", store: UserDefaults(suiteName: "group.lifespan-timer"))
    var lifetime: Double = 0.0

    @AppStorage("lifetimeUpdateable", store: UserDefaults(suiteName: "group.lifespan-timer"))
    var lifetimeUpdateable: Double = 0.0

    @AppStorage("deathDate", store: UserDefaults(suiteName: "group.lifespan-timer"))
    var deathDate: Double = 0.0

    let now = Date().timeIntervalSince1970
    let lifetimeDate = Date().addingTimeInterval(deathDate - now)
    lifetime = lifetimeDate.timeIntervalSince1970
    lifetimeUpdateable = lifetime

    return Date(timeIntervalSince1970: lifetime)
}

func get_lifetime_to_display_updateable() -> Date {
    @AppStorage("lifetimeUpdateable", store: UserDefaults(suiteName: "group.lifespan-timer"))
    var lifetimeUpdateable: Double = 0.0

    @AppStorage("deathDateUpdateable", store: UserDefaults(suiteName: "group.lifespan-timer"))
    var deathDateUpdateable: Double = 0.0

    let now = Date().timeIntervalSince1970
    let lifetimeDate = Date().addingTimeInterval(deathDateUpdateable - now)
    lifetimeUpdateable = lifetimeDate.timeIntervalSince1970

    return Date(timeIntervalSince1970: lifetimeUpdateable)
}

struct RegularFlowView: View {
    @State private var refreshID = UUID()
    @State private var showInitialTimer = false

    @State private var showPlusSelection = false
    @State private var showMinusSelection = false
    @State private var showSettings = false

    @AppStorage("deathDate", store: UserDefaults(suiteName: "group.lifespan-timer"))
    var deathDate: Double = 0.0

    @AppStorage("deathDateUpdateable", store: UserDefaults(suiteName: "group.lifespan-timer"))
    var deathDateUpdateable: Double = 0.0

    @AppStorage("lifetime", store: UserDefaults(suiteName: "group.lifespan-timer"))
    var lifetime: Double = 0.0

    @AppStorage("lifetimeUpdateable", store: UserDefaults(suiteName: "group.lifespan-timer"))
    var lifetimeUpdateable: Double = 0.0

    @AppStorage("userAlreadyLivedMoreThanAverage", store: UserDefaults(suiteName: "group.lifespan-timer"))
    var userAlreadyLivedMoreThanAverage: Bool = false

    @AppStorage("updateableTimerEnded", store: UserDefaults(suiteName: "group.lifespan-timer"))
    var updateableTimerEnded: Bool = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                if userAlreadyLivedMoreThanAverage {
                    Text("🎉 Congratulations!!! 🎉")
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.green)
                        .font(.title3)
                        .fontDesign(.monospaced)
                        .frame(width: 300)

                    Text("You have already lived longer than the average life expectancy in your country. Keep up the good work!")
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.white)
                        .font(.title3)
                        .fontDesign(.monospaced)
                        .frame(width: 300)

                } else if updateableTimerEnded {
                    Text("Your lifetime has ended in theory!")
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.red)
                        .font(.title3)
                        .fontDesign(.monospaced)
                        .frame(width: 300)

                    Text("You should revisit your habits, lifestyle and try avoiding things that reduce the lifespan.")
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.white)
                        .font(.title3)
                        .fontDesign(.monospaced)
                        .frame(width: 300)
                } else {
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

                    Text("")
                        .task {
                                // this is for checking whether timer gets to the end
                                while true {
                                    let now = Date();
                                    let endDate = Date(timeIntervalSince1970: deathDate)
                                    let endDateUpdateable = Date(timeIntervalSince1970: deathDateUpdateable)

                                    if now > endDate {
                                        userAlreadyLivedMoreThanAverage = true
                                    }
                                    if now > endDateUpdateable {
                                        updateableTimerEnded = true
                                    }
                                    try? await Task.sleep(for: .seconds(1))
                                }
                            }

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
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showSettings = true
                    } label: {
                        Image(systemName: "gear")
                            .imageScale(.large)
                    }
                }
            }
            .animation(.default, value: showInitialTimer)
            .sheet(isPresented: $showPlusSelection) {
                    PlusSelectionView(deathDateUpdateable: $deathDateUpdateable, refreshID: $refreshID)
            }
            .sheet(isPresented: $showMinusSelection) {
                    MinusSelectionView(deathDateUpdateable: $deathDateUpdateable, refreshID: $refreshID)
            }
            .sheet(isPresented: $showSettings) {
                SettingsView(showInitialTimer: $showInitialTimer)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black.ignoresSafeArea())
        }
    }
}

#Preview {
    ContentView()
}

//
//  ContentView.swift
//  LifespanTimer
//
//  Created by Artem Storozhuk on 09.09.2025.
//

import SwiftUI
import WidgetKit

extension UserDefaults {
    var welcomeScreenShown: Bool {
        get {
            return (UserDefaults.standard.value(forKey: "welcomeScreenShown") as? Bool) ?? false
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "welcomeScreenShown")
        }
    }

    var userAlreadyLivedMoreThanAverage: Bool {
        get {
            return (UserDefaults.standard.value(forKey: "userAlreadyLivedMoreThanAverage") as? Bool) ?? false
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "userAlreadyLivedMoreThanAverage")
        }
    }
}

struct ContentView: View {
    var body: some View {
        if UserDefaults.standard.welcomeScreenShown {
            ZStack {
                Color.primary.ignoresSafeArea()
                if UserDefaults.standard.userAlreadyLivedMoreThanAverage {
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

// TODO: invoke this function from time to time in order to update lifetime value in UserDefaults
func get_lifetime_to_display() -> Date {
    if let userDefaults = UserDefaults(suiteName: "group.lifespan-timer") {
        if UserDefaults.standard.userAlreadyLivedMoreThanAverage {
            let lifetime = Calendar.current.date(byAdding: .year, value: 20, to: Date())!
            userDefaults.setValue(lifetime.timeIntervalSince1970, forKey: "lifetime")
            return lifetime
        } else {
            let death_date = userDefaults.double(forKey: "DeathDate")
            let now = Date().timeIntervalSince1970
            let lifetime = Date().addingTimeInterval(death_date - now)
            userDefaults.setValue(lifetime.timeIntervalSince1970, forKey: "lifetime")
            userDefaults.setValue(lifetime.timeIntervalSince1970, forKey: "lifetimeUpdateable")
            return lifetime
        }
    }
    fatalError("should never happen") // TODO: remove this in a clean way
}

func get_lifetime_to_display_updateable() -> Date {
    if let userDefaults = UserDefaults(suiteName: "group.lifespan-timer") {
        if UserDefaults.standard.userAlreadyLivedMoreThanAverage {
            let lifetime = Calendar.current.date(byAdding: .year, value: 20, to: Date())!
            userDefaults.setValue(lifetime.timeIntervalSince1970, forKey: "lifetime")
            return lifetime
        } else {
            let death_date = userDefaults.double(forKey: "DeathDateUpdateable")
            let now = Date().timeIntervalSince1970
            let lifetime = Date().addingTimeInterval(death_date - now)
            userDefaults.setValue(lifetime.timeIntervalSince1970, forKey: "lifetimeUpdateable")
            return lifetime
        }
    }
    fatalError("should never happen") // TODO: remove this in a clean way
}

struct RegularFlowView: View {
    @State private var refreshID = UUID()
    @State private var showInitialTimer = false

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
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

            Text("")


            HStack(spacing: 20) {
                Button(action: {
                    if let userDefaults = UserDefaults(suiteName: "group.lifespan-timer") {
                        let death_date = Date(timeIntervalSince1970: userDefaults.double(forKey: "DeathDateUpdateable"))
                        let updated_death_date = Calendar.current.date(byAdding: .year, value: -1, to: death_date)!
                        userDefaults.setValue(updated_death_date.timeIntervalSince1970, forKey: "DeathDateUpdateable")
                        userDefaults.synchronize()
                    } else {
                        fatalError("should never happen") // TODO: remove this in a clean way
                    }

                    refreshID = UUID()
                    WidgetCenter.shared.reloadAllTimelines()
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
                    if let userDefaults = UserDefaults(suiteName: "group.lifespan-timer") {
                        let death_date = Date(timeIntervalSince1970: userDefaults.double(forKey: "DeathDateUpdateable"))
                        let updated_death_date = Calendar.current.date(byAdding: .year, value: 1, to: death_date)!
                        userDefaults.setValue(updated_death_date.timeIntervalSince1970, forKey: "DeathDateUpdateable")
                        userDefaults.synchronize()
                    } else {
                        fatalError("should never happen") // TODO: remove this in a clean way
                    }

                    refreshID = UUID()
                    WidgetCenter.shared.reloadAllTimelines()
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

        }.animation(.default, value: showInitialTimer)
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

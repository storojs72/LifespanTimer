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
            return lifetime
        }
    }
    fatalError("should never happen") // TODO: remove this in a clean way
}

struct RegularFlowView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Your lifetime available:")
                .multilineTextAlignment(.center)
                .foregroundStyle(.white)
                .font(.largeTitle)
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

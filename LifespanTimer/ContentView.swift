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
}

struct ContentView: View {
    var body: some View {
        if UserDefaults.standard.welcomeScreenShown {
            ZStack {
                Color.primary.ignoresSafeArea()
                TestView()
                .padding()
            }
        } else {
            InitialView()
        }
    }
}

// TODO: invoke this function from time to time in order to update lifetime value in UserDefaults
func get_lifetime_to_display() -> Date {
    if let userDefaults = UserDefaults(suiteName: "group.lifespan-timer") {
        let death_date = userDefaults.double(forKey: "DeathDate")
        let initial_date = userDefaults.double(forKey: "InitialDate")
        let now = Date().timeIntervalSince1970
        let passed_since_initial_date = now - initial_date
        let lifetime = Date().addingTimeInterval(death_date - passed_since_initial_date)

        userDefaults.setValue(lifetime.timeIntervalSince1970, forKey: "lifetime")

        return lifetime
    }
    fatalError("should never happen") // TODO: remove this in a clean way
}

struct TestView: View {
    @State var showingAlert: Bool = false
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

#Preview {
    ContentView()
}

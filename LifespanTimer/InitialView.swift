//
//  InitialView.swift
//  LifespanTimer
//
//  Created by Artem Storozhuk on 09.09.2025.
//

import SwiftUI
import WidgetKit
import Combine

// This is the average life expectancy in Ukraine, Portugal, UK and USA
let MALES = [64, 79, 79, 75]
let FEMALES = [74, 85, 83, 80]

struct InitialView: View {
    
    @AppStorage("welcomeScreenShown")
    var welcomeScreenShown: Bool = false
    
    func goHome() {
        // transfer control to MainView
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = UIHostingController(rootView: ContentView())
            window.makeKeyAndVisible()
        }
    }
    
    var sexes = ["Male", "Female"]

    // Order of countries relates to MALES / FEMALES order
    var countries = ["Ukraine", "Portugal", "United Kingdom", "United States of America"]
    var ages = [
        1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
        11, 12, 13, 14, 15, 16, 17, 18, 19, 20,
        21, 22, 23, 24, 25, 26, 27, 28, 29, 30,
        31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
        41, 42, 43, 44, 45, 46, 47, 48, 49, 50,
        51, 52, 53, 54, 55, 56, 57, 58, 59, 60,
        61, 62, 63, 64, 65, 66, 67, 68, 69, 70,
        71, 72, 73, 74, 75, 76, 77, 78, 79, 80,
        81, 82, 83, 84, 85, 86, 87, 88, 89, 90,
    ]
    
    
    @State private var selectedGender = "Male"
    @State private var selectedCountry = "Ukraine"
    @State private var selectedAge = 1
    
    @State var showingAlert: Bool = false
    
    var body: some View {
            ZStack {
                Color.primary.ignoresSafeArea()
                VStack(spacing: 20) {
                    // Choosing Sex
                    Text("Choose your gender:")
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.white)
                        .font(.largeTitle)
                        .fontDesign(.monospaced)
                        .frame(width: 300)
                    Picker("Gender picker", selection: $selectedGender) {
                        ForEach(sexes, id: \.self) {
                            Text($0)
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.black)
                                .font(.headline)
                                .fontDesign(.monospaced)
                                .frame(width: 300)
                        }
                    }
                    .pickerStyle(.inline)
                    .frame(height: 100)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                    )
                    
                    // Chosing age
                    Text("Choose your age:")
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.white)
                        .font(.largeTitle)
                        .fontDesign(.monospaced)
                        .frame(width: 300)
                    Picker(selection: $selectedAge, label: /*@START_MENU_TOKEN@*/Text("Picker")/*@END_MENU_TOKEN@*/) {
                        ForEach(ages, id: \.self) {
                            Text(String($0))
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.black)
                                .font(.headline)
                                .fontDesign(.monospaced)
                                .frame(width: 300)
                        }
                    }
                    .pickerStyle(.inline)
                    .frame(height: 100)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                    )
                    
                    
                    // Chosing country
                    Text("Choose your country:")
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.white)
                        .font(.largeTitle)
                        .fontDesign(.monospaced)
                        .frame(width: 300)
                    Picker(selection: $selectedCountry, label: /*@START_MENU_TOKEN@*/Text("Picker")/*@END_MENU_TOKEN@*/) {
                        ForEach(countries, id: \.self) {
                            Text($0)
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.black)
                                .font(.headline)
                                .fontDesign(.monospaced)
                                .frame(width: 300)
                        }
                    }
                    .pickerStyle(.inline)
                    .frame(height: 100)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                    )
                    
                    
                    Button(">>>>") {
                        showingAlert = true
                    }.alert(isPresented: $showingAlert) {
                        Alert(
                            title: Text("Continue?"),
                            message: Text("Make sure that you have correctly specified your gender, age and country."),
                            primaryButton: .default(Text("Continue")){
                                
                                var index = 0;
                                for i in (0 ..< countries.count) {
                                    if (countries[i] == selectedCountry) {
                                        index = i
                                    }
                                }
                                
                                let life_expectancy = if selectedGender == "Male" {
                                    MALES[index]
                                } else {
                                    FEMALES[index]
                                }
                                
                                let years_left = life_expectancy - selectedAge
                                let seconds_left = years_left * 365 * 24 * 60 * 60 // TODO: increase accuracy

                                // Using AppGroup: group.lifespan-timer to share UserDefaults data with the Widget
                                if let userDefaults = UserDefaults(suiteName: "group.lifespan-timer") {
                                    let approximateDeathDate = Calendar.current.date(byAdding: .second, value: seconds_left, to: Date())
                                    userDefaults.setValue(approximateDeathDate?.timeIntervalSince1970, forKey: "DeathDate")
                                }
                                UserDefaults.standard.synchronize()
                                
                                // refresh our widgets
                                WidgetCenter.shared.reloadAllTimelines()
                                
                                welcomeScreenShown = true

                                goHome()
                            },
                            secondaryButton: .cancel()
                        )
                    }
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.white)
                    .font(.largeTitle)
                    .fontDesign(.monospaced)
                    .frame(width: 300)
                    .buttonStyle(.bordered)
                    .tint(.white)
                }
        }
    }
}

#Preview {
    InitialView()
}

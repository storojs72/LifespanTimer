//
//  LifespanTimerApp.swift
//  LifespanTimer
//
//  Created by Artem Storozhuk on 09.09.2025.
//

import SwiftUI
import StoreKit

@main
struct LifespanTimerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    await observeTransactions()
                }
        }
    }

    // Keep observing transactions
    func observeTransactions() async {
        for await result in Transaction.updates {
            do {
                let transaction = try checkVerified(result)
                // Handle the transaction (e.g. unlock donation badge, thank user)
                await transaction.finish()
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }

    // Helper to check verification
    func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .verified(let safe):
            return safe
        case .unverified(_, let error):
            throw error
        }
    }
}

//
//  DonateSelection.swift
//  LifespanTimer
//
//  Created by Artem Storozhuk on 19.09.2025.
//


import SwiftUI
import StoreKit

struct DonateSelectionView: View {
    func goHome() {
        // transfer control to ContentView
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = UIHostingController(rootView: ContentView())
            window.makeKeyAndVisible()
        }
    }
    
    @State private var products: [Product] = []

    var body: some View {
        ZStack {
            Color.primary.ignoresSafeArea()
            VStack(spacing: 20) {
                Text("Please, support us!")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.green)
                    .lineLimit(1)
                    .fontDesign(.monospaced)
                Text("❤️ Thank You! ❤️")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.green)
                    .lineLimit(1)
                    .fontDesign(.monospaced)

                List(products, id: \.id) { product in
                    Button(action: {
                        Task {
                            await purchase(product: product)
                        }
                    }) {
                        Text("\(product.displayName) – \(product.displayPrice)")
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.black)
            .padding()
            .task {
                await loadProducts()
            }
        }
    }

    func loadProducts() async {
        do {
            let storeProducts = try await Product.products(for: [
                "iOS.LifespanTimer.donation.donation.small",
                "iOS.LifespanTimer.donation.donation.medium",
                "iOS.LifespanTimer.donation.donation.large"
            ])

            let order: [String: Int] = [
                "iOS.LifespanTimer.donation.donation.small": 0,
                "iOS.LifespanTimer.donation.donation.medium": 1,
                "iOS.LifespanTimer.donation.donation.large": 2
            ]

            products = storeProducts.sorted {
                (order[$0.id] ?? 999) < (order[$1.id] ?? 999)
            }
        } catch {
            print("Failed to load products: \(error)")
        }
    }

    func purchase(product: Product) async {
        do {
            let result = try await product.purchase()
            switch result {
                case .success(.verified(let transaction)):
                    await transaction.finish()
                    goHome()
                case .success(.unverified(_, _)):
                    print("Transaction unverified")
                case .userCancelled:
                    print("Cancelled")
                default:
                    break
                }
        } catch {
            print("Purchase failed: \(error)")
        }
    }
}

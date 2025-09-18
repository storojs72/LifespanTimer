//
//  Minus.swift
//  LifespanTimer
//
//  Created by Artem Storozhuk on 18.09.2025.
//

import SwiftUI

struct PlusSelectionView: View {
    @Binding var deathDateUpdateable: Double
    @Binding var refreshID: UUID
    @Environment(\.dismiss) private var dismiss
    
    let items = ["(15 mins) Morning excercises: +1 hour", "(60 mins) Active walking: +6 hours"]
    
    var body: some View {
        NavigationView {
            List(items.indices, id: \.self) { index in
                Button(items[index]) {
                    let deathDateValue = Date(timeIntervalSince1970: deathDateUpdateable)
                    switch index {
                    case 0:
                        deathDateUpdateable = Calendar.current.date(byAdding: .hour, value: 1, to: deathDateValue)!.timeIntervalSince1970
                    case 1:
                        deathDateUpdateable = Calendar.current.date(byAdding: .hour, value: 6, to: deathDateValue)!.timeIntervalSince1970
                    default:
                        fatalError()
                    }

                    refreshID = UUID() // cause timer update on the main view
                    dismiss()  // close the sheet
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.black)
            .navigationTitle("")
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Please select item that increases your lifespan")
                        .multilineTextAlignment(.center)
                        .fontDesign(.monospaced)
                        .foregroundStyle(.green)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

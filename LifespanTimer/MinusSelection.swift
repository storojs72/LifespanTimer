//
//  MinusSelection.swift
//  LifespanTimer
//
//  Created by Artem Storozhuk on 18.09.2025.
//

import SwiftUI
import WidgetKit

struct MinusSelectionView: View {
    @Binding var deathDateUpdateable: Double
    @Binding var refreshID: UUID
    @Environment(\.dismiss) private var dismiss
    
    let items = ["Smoking cigarette: -20 mins", "Drinking bottle of beer: -24 hours"]
    
    var body: some View {
        NavigationView {
            List(items.indices, id: \.self) { index in
                Button(items[index]) {
                    let deathDateValue = Date(timeIntervalSince1970: deathDateUpdateable)
                    switch index {
                    case 0:
                        deathDateUpdateable = Calendar.current.date(byAdding: .minute, value: -20, to: deathDateValue)!.timeIntervalSince1970
                    case 1:
                        deathDateUpdateable = Calendar.current.date(byAdding: .hour, value: -24, to: deathDateValue)!.timeIntervalSince1970
                    default:
                        fatalError()
                    }

                    WidgetCenter.shared.reloadAllTimelines()

                    refreshID = UUID() // cause timer update on the main view
                    dismiss()  // close the sheet
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.black)
            .navigationTitle("")
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Please select item that decreases your lifespan")
                        .multilineTextAlignment(.center)
                        .fontDesign(.monospaced)
                        .foregroundStyle(.red)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

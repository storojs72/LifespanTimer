//
//  LifespanTimerWidget.swift
//  LifespanTimerWidget
//
//  Created by Artem Storozhuk on 09.09.2025.
//

import WidgetKit
import SwiftUI

struct SimpleEntry: TimelineEntry {
    let date: Date
    let lifetimeEntryItem: Double
    let configuration: ConfigurationAppIntent
}

struct Provider: AppIntentTimelineProvider {
    @AppStorage("lifetime", store: UserDefaults(suiteName: "group.lifespan-timer"))
    var lifetime: Double = 0.0
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), lifetimeEntryItem: 0.0, configuration: ConfigurationAppIntent())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        return SimpleEntry(date: Date(), lifetimeEntryItem: lifetime, configuration: configuration)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        let entry = SimpleEntry(date: Date(), lifetimeEntryItem: lifetime, configuration: configuration)

        // Reload as soon as possible
        return Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(5)))
    }
}

struct LifespanTimerWidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(Date(timeIntervalSince1970: entry.lifetimeEntryItem), style: .timer)
                .multilineTextAlignment(.center)
                .font(.callout)
                .fontDesign(.monospaced)
                .frame(width: 300)
                .foregroundStyle(.green)
                .font(.headline)
        }
        .padding()
    }
}

struct LifespanTimerWidget: Widget {
    let kind: String = "LifespanTimerWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            LifespanTimerWidgetEntryView(entry: entry)
                .containerBackground(for: .widget, content: {Color.black})
        }.supportedFamilies([
            .systemSmall,
            .systemMedium,
            .systemLarge,
            .accessoryInline,
        ])
    }
}

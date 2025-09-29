//
//  LifespanTimerWidget.swift
//  LifespanTimerWidget
//
//  Created by Artem Storozhuk on 09.09.2025.
//

import WidgetKit
import SwiftUI

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

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
}

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        return SimpleEntry(date: Date(), configuration: configuration)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        // Generate a timeline with 5 entries, one per hour
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            if let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate) {
                let entry = SimpleEntry(date: entryDate, configuration: configuration)
                entries.append(entry)
            }
        }

        return Timeline(entries: entries, policy: .atEnd)
    }
}

struct LifespanTimerWidgetEntryView : View {
    @Environment(\.widgetFamily) var family

    var entry: Provider.Entry

    @AppStorage("userAlreadyLivedMoreThanAverage", store: UserDefaults(suiteName: "group.lifespan-timer"))
    var userAlreadyLivedMoreThanAverage: Bool = false

    @AppStorage("updateableTimerEnded", store: UserDefaults(suiteName: "group.lifespan-timer"))
    var updateableTimerEnded: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if userAlreadyLivedMoreThanAverage {
                Text("Congratulations!")
                    .multilineTextAlignment(.center)
                    .font(fontForFamily(family))
                    .fontDesign(.monospaced)
                    .foregroundStyle(.green)
                    .lineLimit(1)
                    .frame(width: 300)
            } else if updateableTimerEnded {
                Text("Your lifetime ended!")
                    .multilineTextAlignment(.center)
                    .font(fontForFamily(family))
                    .fontDesign(.monospaced)
                    .foregroundStyle(.red)
                    .lineLimit(1)
                    .frame(width: 300)
            } else {
                Text(get_lifetime_to_display_updateable(), style: .timer)
                    .multilineTextAlignment(.center)
                    .font(.callout)
                    .fontDesign(.monospaced)
                    .frame(width: 300)
                    .foregroundStyle(.green)
                    .font(.headline)
            }
        }
        .padding()
    }

    private func fontForFamily(_ family: WidgetFamily) -> Font {
            switch family {
            case .systemSmall:
                return .caption
            case .systemMedium:
                return .body
            case .systemLarge:
                return .title
            default:
                return .body
            }
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

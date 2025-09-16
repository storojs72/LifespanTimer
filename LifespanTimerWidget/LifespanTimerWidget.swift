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
    let title: String
    let subtitle: String
}

struct Provider: AppIntentTimelineProvider {
    let sharedDefaults = UserDefaults(suiteName: "group.lifespan-timer")
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), title: "Title", subtitle: "Subtitle")
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        let title = sharedDefaults?.string(forKey: "title") ?? "Title"
        let subtitle = sharedDefaults?.string(forKey: "subtitle") ?? "Subtitle"
        return SimpleEntry(date: Date(), title: title, subtitle: subtitle)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        let title = sharedDefaults?.string(forKey: "title") ?? "Title"
        let subtitle = sharedDefaults?.string(forKey: "subtitle") ?? "Subtitle"
        
        let entry = SimpleEntry(date: Date(), title: title, subtitle: subtitle)

        return Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(5)))
    }
}

struct LifespanTimerWidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
//            Color.primary.frame(width: 500, height: 500)
            Text(entry.title)
                .multilineTextAlignment(.center)
                .font(.callout)
                .fontDesign(.monospaced)
                .frame(width: 300)
                .foregroundStyle(.green)
                .font(.headline)
            Text(entry.subtitle)
                .multilineTextAlignment(.center)
                .font(.callout)
                .fontDesign(.monospaced)
                .frame(width: 300)
                .foregroundStyle(.green)
                .font(.subheadline)
        }
        .padding()
    }
}

struct LifespanTimerWidget: Widget {
    let kind: String = "LifespanTimerWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            LifespanTimerWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }.supportedFamilies([
            .systemSmall,
            .systemMedium,
            .systemLarge,
            .accessoryInline,
        ])
    }
}

/*
struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
}


let backgroundGradient = LinearGradient(
    colors: [Color.black, Color.black],
    startPoint: .top, endPoint: .bottom)


extension Date {
    init(_ dateString:String) {
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd"
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        let date = dateStringFormatter.date(from: dateString)!
        self.init(timeInterval:0, since:date)
    }
}

struct LifespanTimerWidgetEntryView : View {
    var entry: Provider.Entry
    
    // Obtain the widget family value
    @Environment(\.widgetFamily)
    var family
    
    var body: some View {
        switch family {
            default:
            VStack {
                ZStack {
                    Color.primary.frame(width: 500, height: 500)
                    if let userDefaults = UserDefaults(suiteName: "group.lifespan-timer") {
                        let raw_date = userDefaults.double(forKey: "lifetime")
                        if raw_date == Double.zero {
                            Text("")
                        } else {
                            let date_parsed = Date(timeIntervalSince1970: raw_date)
                            Text(date_parsed, style: .timer)
                                .multilineTextAlignment(.center)
                                .font(.callout)
                                .fontDesign(.monospaced)
                                .frame(width: 300)
                                .foregroundStyle(.green)
                        }
                    }
                }.cornerRadius(10)
            }
        }
    }
}

struct LifespanTimerWidget: Widget {
    let kind: String = "LifespanTimerWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            LifespanTimerWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }.supportedFamilies([
            .systemSmall,
            .systemMedium,
            .systemLarge,
            .accessoryInline,
        ])
    }
}*/

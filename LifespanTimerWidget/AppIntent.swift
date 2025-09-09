// TODO: this is generated source. Probably it needs to be removed

//
//  AppIntent.swift
//  LifespanTimerWidget
//
//  Created by Artem Storozhuk on 09.09.2025.
//

import WidgetKit
import AppIntents

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource { "Configuration" }
    static var description: IntentDescription { "This is an example widget." }

    // An example configurable parameter.
    @Parameter(title: "Favorite Emoji", default: "😃")
    var favoriteEmoji: String
}

//
//  ScrumdingerWidget.swift
//  ScrumdingerWidget
//
//  Created by 이태호 on 10/1/24.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> ScrumEntry {
        ScrumEntry(date: Date(), scrums: DailyScrum.sampleData)
    }

    func getSnapshot(in context: Context, completion: @escaping (Entry) -> ()) {
        let entry = ScrumEntry(date: Date(), scrums: DailyScrum.sampleData)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<ScrumEntry>) -> ()) {
        var entries: [ScrumEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = ScrumEntry(date: entryDate, scrums: DailyScrum.sampleData)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }

//    func relevances() async -> WidgetRelevances<Void> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct ScrumEntry: TimelineEntry {
    let date: Date
    let scrums: [DailyScrum]
}

struct ScrumdingerWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
//            Text("Time:")
//            Text(entry.date, style: .time)
            ForEach(entry.scrums) { scrum in
                HStack {
                    Text(scrum.title)
                    Spacer()
                    Text(String(scrum.lengthInMinutes))
                }
                .padding(2)
                .foregroundColor(scrum.theme.mainColor)
            }
        }
    }
}

struct ScrumdingerWidget: Widget {
    let kind: String = "ScrumdingerWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                ScrumdingerWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                ScrumdingerWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

#Preview(as: .systemSmall) {
    ScrumdingerWidget()
} timeline: {
    ScrumEntry(date: .now, scrums: DailyScrum.sampleData)
}

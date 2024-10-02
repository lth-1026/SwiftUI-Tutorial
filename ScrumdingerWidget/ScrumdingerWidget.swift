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
        
        var scrums: [DailyScrum]
        
        do {
            let fileURL = try Self.fileURL()
            guard let data = try? Data(contentsOf: fileURL!) else {
                scrums = [DailyScrum(title: "Nil", attendees: [""], lengthInMinutes: 5, theme: .bubblegum)]
                return
            }
            scrums = try JSONDecoder().decode([DailyScrum].self, from: data)
        } catch {
            scrums = [DailyScrum(title: "Nil", attendees: [""], lengthInMinutes: 5, theme: .bubblegum)]
        }
        
        // 타임라인 생성
        let currentDate = Date()
        for minuteOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .minute, value: minuteOffset, to: currentDate)!
            let entry = ScrumEntry(date: entryDate, scrums: scrums)
            entries.append(entry)
        }
        
        // 타임라인을 반환
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
    
    private static func fileURL() throws -> URL? {
//        try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
//            .appendingPathComponent("scrums.data")
        // App Group 식별자 설정
        let appGroupIdentifier = "group.com.example.Scrumdinger"
        
        // FileManager를 통해 App Group 디렉토리 경로를 가져옴
        guard let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupIdentifier) else {
            fatalError("Unable to access App Group container. Make sure the App Group is correctly configured.")
        }
            
        let fileURL = containerURL.appendingPathComponent("scrums.json")
            
        // 파일이 존재하지 않는다면 생성
        if !FileManager.default.fileExists(atPath: fileURL.path) {
            FileManager.default.createFile(atPath: fileURL.path, contents: nil, attributes: nil)
        }

        return fileURL
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

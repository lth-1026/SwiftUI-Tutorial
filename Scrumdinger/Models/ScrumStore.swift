//
//  ScrumStore.swift
//  Scrumdinger
//
//  Created by 이태호 on 9/27/24.
//

import Foundation

@MainActor
class ScrumStore: ObservableObject {
    @Published var scrums: [DailyScrum] = []
    
    
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
    
    func load() async throws {
        let task = Task<[DailyScrum], Error> {
            let fileURL = try Self.fileURL()
            guard let data = try? Data(contentsOf: fileURL!) else {
                return []
            }
            let dailyScrums = try JSONDecoder().decode([DailyScrum].self, from: data)
            return dailyScrums
        }
        let scrums = try await task.value
        self.scrums = scrums
    }
    
    func save(scrums: [DailyScrum]) async throws {
        let task = Task {
            let data = try JSONEncoder().encode(scrums)
            let outfile = try Self.fileURL()
            try data.write(to: outfile!)
        }
        _ = try await task.value
    }
}

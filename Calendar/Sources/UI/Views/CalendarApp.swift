//
//  CalendarApp.swift
//  Calendar
//
//  Created by Sora Oya on 2025/03/21.
//

import SwiftUI
import SwiftData

@main
struct CalendarApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Todo.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            CalendarView()
        }
        .modelContainer(sharedModelContainer)
    }
}

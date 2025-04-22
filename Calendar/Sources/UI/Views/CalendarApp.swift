//
//  CalendarApp.swift
//  Calendar
//
//  Created by Sora Oya on 2025/03/21.
//

import SwiftData
import SwiftUI

@main
struct CalendarApp: App {
    var body: some Scene {
        WindowGroup {
            CalendarView()
        }
        .modelContainer(ModelContainerManager.shared.modelContainer)
    }
}

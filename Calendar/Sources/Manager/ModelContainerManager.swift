//
//  ModelContainerManager.swift
//  Calendar
//
//  Created by Sora Oya on 2025/03/23.
//

import SwiftData

struct ModelContainerManager {
    static let shared = ModelContainerManager()
    let modelContainer: ModelContainer

    private init() {
        let schema = Schema([Todo.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        modelContainer = try! ModelContainer(for: schema, configurations: modelConfiguration)
    }
}

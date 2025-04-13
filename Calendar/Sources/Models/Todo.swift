//
//  Todo.swift
//  Calendar
//
//  Created by Sora Oya on 2025/03/21.
//

import Foundation
import SwiftData

@Model
final class Todo {
    @Attribute(.unique) var id: UUID
    var title: String
    var detail: String
    var createdDate: Date
    var startDate: Date
    var endDate: Date

    init(
        id: UUID,
        title: String,
        detail: String,
        createdDate: Date,
        startDate: Date,
        endDate: Date
    ) {
        self.id = id
        self.title = title
        self.detail = detail
        self.createdDate = createdDate
        self.startDate = startDate
        self.endDate = endDate
    }
}

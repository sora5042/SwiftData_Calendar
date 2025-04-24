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
    @Attribute(.unique) var id: String
    var title: String
    var detail: String
    var startDate: Date
    var endDate: Date

    init(
        id: String,
        title: String,
        detail: String,
        startDate: Date,
        endDate: Date
    ) {
        self.id = id
        self.title = title
        self.detail = detail
        self.startDate = startDate
        self.endDate = endDate
    }
}

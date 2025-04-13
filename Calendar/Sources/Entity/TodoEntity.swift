//
//  TodoEntity.swift
//  Calendar
//
//  Created by Sora Oya on 2025/03/23.
//

import Foundation

struct TodoEntity: Sendable, Hashable {
    var id: UUID
    var title: String
    var detail: String
    var createdDate: Date
    var startDate: Date
    var endDate: Date
}

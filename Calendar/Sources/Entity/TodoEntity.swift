//
//  TodoEntity.swift
//  Calendar
//
//  Created by Sora Oya on 2025/03/23.
//

import Foundation

struct TodoEntity: Sendable, Hashable {
    var id: String
    var title: String
    var detail: String
    var startDate: Date
    var endDate: Date
}

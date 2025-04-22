//
//  CalendarViewModel.swift
//  Calendar
//
//  Created by Sora Oya on 2025/04/07.
//

import Foundation
import SwiftData

@MainActor
final class CalendarViewModel: ObservableObject {
    private let todoRepository: TodoRepository

    @Published
    var selectedDates: Set<DateComponents> = [Calendar.current.dateComponents([.calendar, .era, .year, .month, .day], from: Date())]

    var date: Date {
        guard let selectedDate = selectedDates.first else { return .now }
        return Calendar.current.date(from: selectedDate) ?? .now
    }

    private var todos: [Todo] = []

    @Published
    var displayTodos: [Todo] = []

    @Published
    var sheet: Sheet?

    init(
        todoRepository: TodoRepository = .init(context: .init(ModelContainerManager.shared.modelContainer))
    ) {
        self.todoRepository = todoRepository
    }

    func fetchTodos() async {
        let todos = await todoRepository.fetchTodos()
        self.todos = todos.map(Todo.init)
        filteredTodos()
    }

    func filteredTodos() {
        let (startOfDay, endOfDay) = calculateDateRange(for: date)
        let filteredTodos = todos.filter { todo in
            (todo.startDate >= startOfDay && todo.startDate <= endOfDay) ||
                (todo.endDate >= startOfDay && todo.endDate <= endOfDay)
        }
        displayTodos = filteredTodos
    }

    private func calculateDateRange(for date: Date) -> (startOfDay: Date, endOfDay: Date) {
        let startOfDay = Calendar.current.startOfDay(for: date)
        let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)?.addingTimeInterval(-1) ?? startOfDay
        return (startOfDay, endOfDay)
    }

    func sheetTodoForm(_ todo: Todo?) {
        if let todo = todo {
            let todoEntity = TodoEntity(
                id: UUID(uuidString: todo.id) ?? .init(),
                title: todo.title,
                detail: todo.detail,
                createdDate: Date.now,
                startDate: todo.startDate,
                endDate: todo.endDate
            )
            sheet = .todoForm(date, todoEntity)
        } else {
            sheet = .todoForm(date, nil)
        }
    }
}

extension CalendarViewModel {
    struct Todo: Hashable {
        var id: String
        var title: String
        var detail: String
        var startDate: Date
        var endDate: Date
        var displayDate: String
    }

    enum Sheet: Identifiable, Hashable {
        var id: Int { hashValue }
        case todoForm(Date, TodoEntity?)
    }
}

extension CalendarViewModel.Todo {
    init(todo: TodoEntity) {
        self.init(
            id: todo.id.uuidString,
            title: todo.title,
            detail: todo.detail,
            startDate: todo.startDate,
            endDate: todo.endDate,
            displayDate: "開始: \(todo.startDate.formatted("MM/dd HH:mm"))\n終了: \(todo.endDate.formatted("MM/dd HH:mm"))"
        )
    }
}

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

    @Published
    var alert: Alert = .init()

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

    func confirmDeleteTodo(_ todo: Todo?) {
        alert.confirmDelete = todo
    }

    func deleteTodo(_ todo: Todo?) async {
        guard let todo else { return }
        let todoEntity = TodoEntity(
            id: todo.id,
            title: todo.title,
            detail: todo.detail,
            startDate: todo.startDate,
            endDate: todo.endDate
        )

        await todoRepository.deleteTodo(todoEntity: todoEntity)
        await fetchTodos()
    }

    func sheetTodoForm(_ todo: Todo?) {
        if let todo = todo {
            let todoEntity = TodoEntity(
                id: todo.id,
                title: todo.title,
                detail: todo.detail,
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
    }

    enum Sheet: Identifiable, Hashable {
        var id: Int { hashValue }
        case todoForm(Date, TodoEntity?)
    }

    struct Alert: Hashable {
        var confirmDelete: Todo?
    }
}

extension CalendarViewModel.Todo {
    init(todo: TodoEntity) {
        self.init(
            id: todo.id,
            title: todo.title,
            detail: todo.detail,
            startDate: todo.startDate,
            endDate: todo.endDate
        )
    }
}

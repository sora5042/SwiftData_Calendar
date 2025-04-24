//
//  ToDoFormViewModel.swift
//  Calendar
//
//  Created by Sora Oya on 2025/04/07.
//

import Foundation

@MainActor
final class TodoFormViewModel: ObservableObject {
    private let todoRepository: TodoRepository

    var mode: Mode

    var selectedDate: Date

    @Published
    var todo: Todo

    @Published
    private(set) var isDismissed: Bool = false

    @Published
    var alert: Alert = .init()

    init(
        todoRepository: TodoRepository = .init(context: .init(ModelContainerManager.shared.modelContainer)),
        mode: Mode,
        selectedDate: Date
    ) {
        self.todoRepository = todoRepository
        self.mode = mode
        self.selectedDate = selectedDate
        switch mode {
        case let .update(todo):
            self.todo = .init(todo: todo)
        default:
            todo = .init(
                id: "",
                title: "",
                detail: "",
                startDate: selectedDate,
                endDate: selectedDate.addingTimeInterval(3600)
            )
        }
    }

    func saveContents() async {
        let todoEntity = TodoEntity(
            id: todo.id,
            title: todo.title,
            detail: todo.detail,
            startDate: todo.startDate,
            endDate: todo.endDate
        )

        switch mode {
        case .update:
            await todoRepository.updateTodo(todoEntity: todoEntity)
        case .insert:
            await todoRepository.insertTodo(todoEntity: todoEntity)
        }
        isDismissed = true
    }

    func confirmInsert(_ todo: Todo) {
        self.todo = todo
        alert.confirmInsert = todo
    }
}

extension TodoFormViewModel {
    struct Todo: Hashable {
        var id: String
        var title: String
        var detail: String
        var startDate: Date
        var endDate: Date
    }

    enum Mode {
        case insert
        case update(TodoEntity)
    }

    struct Alert: Hashable {
        var confirmInsert: Todo?
    }
}

extension TodoFormViewModel.Todo {
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

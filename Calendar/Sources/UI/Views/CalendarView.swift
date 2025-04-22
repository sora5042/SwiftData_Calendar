//
//  CalendarView.swift
//  Calendar
//
//  Created by Sora Oya on 2025/04/07.
//

import SwiftUI

struct CalendarView: View {
    @StateObject
    var viewModel: CalendarViewModel = .init()

    var body: some View {
        VStack(spacing: .zero) {
            UICalendarWrapper(selectedDates: $viewModel.selectedDates) { _ in
                viewModel.filteredTodos()
            }
            TodoList(
                todos: viewModel.displayTodos,
                selectedDate: viewModel.date
            ) { todo in
                viewModel.sheetTodoForm(todo)
            }
        }
        .task {
            await viewModel.fetchTodos()
        }
        ._sheet(item: $viewModel.sheet, onDismiss: {
            Task {
                await viewModel.fetchTodos()
            }
        }) { sheet in
            switch sheet {
            case let .todoForm(selectedDate, todo):
                if let todo = todo {
                    TodoFormView(viewModel: .init(mode: .update(todo), selectedDate: selectedDate))
                } else {
                    TodoFormView(viewModel: .init(mode: .insert, selectedDate: selectedDate))
                }
            }
        }
    }
}

private struct TodoList: View {
    var todos: [CalendarViewModel.Todo]
    var selectedDate: Date
    var saveTodoAction: @MainActor (CalendarViewModel.Todo?) async -> Void

    var body: some View {
        VStack {
            List {
                Button {
                    Task {
                        await saveTodoAction(nil)
                    }
                } label: {
                    Text("タスクを追加する")
                }
                ForEach(todos, id: \.id) { todo in
                    Row(
                        title: todo.title,
                        detail: todo.detail,
                        displayDate: todo.displayDate
                    ) {
                        await saveTodoAction(todo)
                    }
                }
            }
        }
    }
}

private struct Row: View {
    var title: String
    var detail: String
    var displayDate: String
    var action: @MainActor () async -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title)
                Text(detail)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text(displayDate)
                    .font(.caption)
            }
        }
    }
}

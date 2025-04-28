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
            UICalendarWrapper(
                selectedDates: $viewModel.selectedDates,
            ) { _ in
                viewModel.filteredTodos()
            }
            TodoList(
                todos: viewModel.displayTodos,
                selectedDate: viewModel.date
            ) { todo in
                viewModel.sheetTodoForm(todo)
            } deleteTodoAction: { todo in
                viewModel.confirmDeleteTodo(todo)
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
        .alert(
            "本当に削除しますか？",
            isPresented: .init(value: $viewModel.alert.confirmDelete)
        ) {
            Button("いいえ") {}
            Button("はい") {
                let todo = viewModel.alert.confirmDelete
                Task {
                    await viewModel.deleteTodo(todo)
                }
            }
        }
    }
}

private struct TodoList: View {
    var todos: [CalendarViewModel.Todo]
    var selectedDate: Date
    var saveTodoAction: @MainActor (CalendarViewModel.Todo?) async -> Void
    var deleteTodoAction: @MainActor (CalendarViewModel.Todo) async -> Void

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            List {
                ForEach(todos, id: \.id) { todo in
                    Row(
                        title: todo.title,
                        detail: todo.detail,
                        startDate: todo.startDate,
                        endDate: todo.endDate
                    ) {
                        await saveTodoAction(todo)
                    }
                    .transition(.move(edge: .trailing).combined(with: .opacity))
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            Task {
                                await deleteTodoAction(todo)
                            }
                        } label: {
                            Image(systemName: "trash")
                        }
                    }
                }
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
            }
            .listStyle(.plain)
            .padding(.horizontal)
            // フローティング追加ボタン
            Button {
                Task {
                    await saveTodoAction(nil)
                }
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .padding()
                    .background(Circle().fill(Color.accentColor))
                    .shadow(radius: 5)
            }
            .padding()
        }
    }
}

private struct Row: View {
    var title: String
    var detail: String
    var startDate: Date
    var endDate: Date
    var action: @MainActor () async -> Void

    var body: some View {
        Button {
            Task {
                await action()
            }
        } label: {
            HStack(alignment: .center, spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                    Text(detail)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Spacer()
                VStack {
                    Text(startDate.formatted("HH:mm"))
                        .font(.callout)
                    Text("〜")
                        .font(.callout)
                    Text(endDate.formatted("HH:mm"))
                        .font(.callout)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemBackground))
                    .shadow(color: .black.opacity(0.05), radius: 4, x: 1, y: 2)
            )
        }
        .buttonStyle(.plain)
        .padding(4)
    }
}

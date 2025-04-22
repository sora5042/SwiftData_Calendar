//
//  ToDoFormView.swift
//  Calendar
//
//  Created by Sora Oya on 2025/04/07.
//

import SwiftUI

struct TodoFormView: View {
    @StateObject
    var viewModel: TodoFormViewModel

    @Environment(\.dismiss)
    private var dismiss

    var body: some View {
        VStack {
            FormContent(
                todo: $viewModel.todo,
                selectedDate: viewModel.selectedDate.format("yyyy/MM/dd")
            ) { todo in
                viewModel.confirmInsert(todo)
            }
        }
        .onChange(of: viewModel.isDismissed) {
            dismiss()
        }
        .alert(
            "保存しますか？",
            isPresented: .init(value: $viewModel.alert.confirmInsert)
        ) {
            Button("いいえ") {}
            Button("はい") {
                Task {
                    await viewModel.saveContents()
                }
            }
        }
    }
}

private struct FormContent: View {
    @Binding
    var todo: TodoFormViewModel.Todo
    var selectedDate: String
    var saveAction: @MainActor (TodoFormViewModel.Todo) -> Void

    var body: some View {
        Form {
            Section(header: Text("タスク情報")) {
                HStack {
                    Text("日付")
                    Spacer()
                    Text(selectedDate)
                }
                TextField("タスク名", text: $todo.title)
                TextField("詳細", text: $todo.detail)
                DatePicker("開始時間", selection: $todo.startDate, displayedComponents: .hourAndMinute)
                DatePicker("終了時間", selection: $todo.endDate, displayedComponents: .hourAndMinute)
            }
            Section {
                Button {
                    saveAction(todo)
                } label: {
                    Text("保存")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
        }
    }
}

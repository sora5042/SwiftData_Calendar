//
//  TodoRepository.swift
//  Calendar
//
//  Created by Sora Oya on 2025/03/23.
//

import Foundation
import SwiftData

@globalActor actor DataActor {
    static let shared = DataActor()
}

@DataActor
struct TodoRepository {
    let context: ModelContext

    func fetchTodos() async -> [TodoEntity] {
        let fetchDescriptor = FetchDescriptor<Todo>()
        let models = try? context.fetch(fetchDescriptor)

        guard let models else { return [] }
        return models.map {
            TodoEntity(
                id: $0.id,
                title: $0.title,
                detail: $0.detail,
                startDate: $0.startDate,
                endDate: $0.endDate
            )
        }
    }

    func insertTodo(todoEntity: TodoEntity) async {
        let model = Todo(
            id: UUID().uuidString,
            title: todoEntity.title,
            detail: todoEntity.detail,
            startDate: todoEntity.startDate,
            endDate: todoEntity.endDate
        )
        context.insert(model)

        guard context.hasChanges else { return }
        try? context.save()
    }

    func updateTodo(todoEntity: TodoEntity) async {
        let todoId = todoEntity.id
        let fetchDescriptor = FetchDescriptor<Todo>(
            predicate: #Predicate { $0.id == todoId }
        )

        do {
            if let existingModel = try context.fetch(fetchDescriptor).first {
                existingModel.title = todoEntity.title
                existingModel.detail = todoEntity.detail
                existingModel.startDate = todoEntity.startDate
                existingModel.endDate = todoEntity.endDate

                guard context.hasChanges else { return }
                try context.save()
            } else {
                print("指定されたIDのTodoが見つかりませんでした。")
            }
        } catch {
            print("更新中にエラーが発生しました: \(error)")
        }
    }

    func deleteTodo(todoEntity: TodoEntity) async {
        let todoId = todoEntity.id
        let fetchDescriptor = FetchDescriptor<Todo>(
            predicate: #Predicate { $0.id == todoId }
        )

        do {
            if let existingModel = try context.fetch(fetchDescriptor).first {
                context.delete(existingModel)
                guard context.hasChanges else { return }
                try context.save()
            } else {
                print("指定されたIDのTodoが見つかりませんでした。")
            }
        } catch {
            print("削除中にエラーが発生しました: \(error)")
        }
    }
}

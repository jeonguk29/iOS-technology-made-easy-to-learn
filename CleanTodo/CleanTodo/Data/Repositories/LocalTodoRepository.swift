//
//  InMemoryTodoRepository.swift
//  TodoListApp
//
//  Created by 정정욱 on 2/24/25.
//

import Foundation
import CoreData

/*
 단계 2: Data 계층 구현
 1. Repositories (구현체 작성):
 InMemoryTodoRepository를 생성하여 TodoRepository 프로토콜을 구현합니다.
 추상화 개념임 Domain 계층과 직접적으로 의존성을 낮춤
 여기서는 메모리 상에서 데이터를 저장하지만, 추후 Core Data나 네트워크 기반 구현으로 쉽게 변경할 수 있습니다.
 */

class LocalTodoRepository: TodoRepository {

    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = TodoPersistence.shared.context) {
        self.context = context
        insertMockData()
    }
    
    // ✅ CoreData에 Mock 데이터를 삽입
    func insertMockData() {
        let mockTodos = [
            Todo(id: 1, title: "할 일 1", isDone: false, createdAt: "2024-03-01", updatedAt: "2024-03-02"),
            Todo(id: 2, title: "할 일 2", isDone: true, createdAt: "2024-03-02", updatedAt: "2024-03-03"),
            Todo(id: 3, title: "할 일 3", isDone: false, createdAt: "2024-03-03", updatedAt: "2024-03-04")
        ]
        
        for todo in mockTodos {
            let newTodo = TodoEntity(context: context)
            newTodo.id = Int64(todo.id ?? 0)
            newTodo.title = todo.title
            newTodo.isDone = todo.isDone ?? false
            newTodo.createdAt = todo.createdAt
            newTodo.updatedAt = todo.updatedAt
        }
        
        saveContext()
    }
    
    // ✅ CoreData에서 Todo 목록을 가져옴
    func fetchTodos(page: Int) async throws -> [Todo] {
        let fetchRequest: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest() as! NSFetchRequest<TodoEntity> // ✅ 타입 명확히 지정
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \TodoEntity.createdAt, ascending: false)]
        
        do {
            let todoEntities = try context.fetch(fetchRequest)
            return todoEntities.map {
                Todo(
                    id: Int($0.id), // ✅ Int64 → Int 변환
                    title: $0.title,
                    isDone: $0.isDone,
                    createdAt: $0.createdAt,
                    updatedAt: $0.updatedAt
                )
            }
        } catch {
            throw NSError(domain: "CoreDataFetchError", code: 100, userInfo: nil)
        }
    }
    
    func createTodo(request: TodoAPIRequest) async throws -> Todo {
        
        return Todo(id: 1, title: "test", isDone: false, createdAt: "", updatedAt: "")
    }
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("❌ CoreData 저장 실패: \(error)")
        }
    }
    
}


/*
 class InMemoryTodoRepository: TodoRepository {
 private(set) var todos: [Todo] = []
 
 private let networkRepository = NetworkTodoRepository() // ✅ 네트워크 저장소 추가
 
 func fetchTodos(page: Int) async throws -> [Todo] {
 let fetchedTodos = try await networkRepository.fetchTodos(page: 1)
 
 // ✅ 이제 비동기적으로 `todos`를 업데이트하는 것이 아니라 즉시 적용
 self.todos = fetchedTodos
 print("✅ Repository에서 업데이트된 todos: \(self.todos)")
 
 return self.todos // ✅ 최신 데이터를 반환
 }
 /*
  func fetchTodos(page: Int) async throws -> [Todo] {
  let fetchedTodos = try await networkRepository.fetchTodos(page: 1)
  DispatchQueue.main.async {
  self.todos = fetchedTodos
  print("todos \(self.todos)")
  }
  return todos // ❌ 여전히 기존 값 반환
  }
  🚨 문제점
  
  todos는 DispatchQueue.main.async에서 업데이트되지만, 비동기 작업이므로 즉시 적용되지 않음.
  return todos는 self.todos를 반환하지만, UI가 업데이트되기 전에 실행되므로 최신 데이터를 반영하지 않음.
  즉, ViewModel에서 fetchTodos()를 호출하면 여전히 빈 배열을 받을 가능성이 있음.
  */
 }
 */

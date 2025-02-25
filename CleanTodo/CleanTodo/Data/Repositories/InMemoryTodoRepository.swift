//
//  InMemoryTodoRepository.swift
//  TodoListApp
//
//  Created by 정정욱 on 2/24/25.
//

import Foundation
import Combine


/*
 단계 2: Data 계층 구현
 1. Repositories (구현체 작성):
 InMemoryTodoRepository를 생성하여 TodoRepository 프로토콜을 구현합니다.
 여기서는 메모리 상에서 데이터를 저장하지만, 추후 Core Data나 네트워크 기반 구현으로 쉽게 변경할 수 있습니다.
 */
class InMemoryTodoRepository: TodoRepository, ObservableObject {
    @Published private(set) var todos: [Todo] = []
    
    func fetchTodos() -> [Todo] {
        todos
    }
    
    func addTodo(_ todo: Todo) {
        todos.append(todo)
    }
    
    func updateTodo(_ todo: Todo) {
        if let index = todos.firstIndex(where: { $0.id == todo.id }) {
            todos[index] = todo
        }
    }
    
    func deleteTodo(_ todo: Todo) {
        todos.removeAll(where: { $0.id == todo.id })
    }
}

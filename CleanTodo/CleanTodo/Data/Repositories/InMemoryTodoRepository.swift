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

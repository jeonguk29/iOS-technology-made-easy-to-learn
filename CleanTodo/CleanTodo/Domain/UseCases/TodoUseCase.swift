//
//  TodoUseCase.swift
//  TodoListApp
//
//  Created by 정정욱 on 2/24/25.
//

import Foundation

/*
 단계 1: Domain 계층 구성
 3. UseCase 작성(비즈니스 로직):
 TodoUseCase.swift는 Todo와 관련된 구체적인 동작(예: 추가, 조회 등)을 담당합니다.
 UseCase는 도메인에 집중하여 “어떻게” 해야 하는지를 결정하며, 외부 구현에 의존하지 않습니다.
 */

struct TodoUseCase {
    private let repository: TodoRepository

    init(repository: TodoRepository) {
        self.repository = repository
    }
    
    func getTodos() async throws -> [Todo] {
        return try await repository.fetchTodos(page: 1)
    }
    
    func postTodo(request: TodoAPIRequest) async throws -> Todo {
        return try await repository.createTodo(request: request)
    }
}

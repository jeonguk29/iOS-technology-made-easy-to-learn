//
//  MockTodoRepository.swift
//  CleanTodoTests
//
//  Created by 정정욱 on 3/10/25.
//

import Foundation
@testable import CleanTodo

class MockTodoRepository: TodoRepository {
    var shouldFail: Bool = false
    var mockTodos: [Todo] = [
        Todo(id: 1, title: "할 일 1", isDone: false, createdAt: "2024-03-01", updatedAt: "2024-03-02"),
        Todo(id: 2, title: "할 일 2", isDone: true, createdAt: "2024-03-02", updatedAt: "2024-03-03")
    ]
    
    func fetchTodos(page: Int) async throws -> [Todo] {
        if shouldFail {
            throw ApiError.badStatus(code: 500)
        }
        return mockTodos
    }
    
    func createTodo(request: TodoAPIRequest) async throws -> Todo {
        if shouldFail {
            throw ApiError.badStatus(code: 422) // 요청이 잘못되었을 경우 예외 발생
        }
        
        let newTodo = Todo(
            id: mockTodos.count + 1,
            title: request.title,
            isDone: request.is_done,
            createdAt: "2024-03-07",
            updatedAt: "2024-03-07"
        )
        
        mockTodos.append(newTodo)
        return newTodo
    }
}

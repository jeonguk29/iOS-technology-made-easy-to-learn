//
//  TodoRepository.swift
//  TodoListApp
//
//  Created by 정정욱 on 2/24/25.
//

import Foundation
/*
 단계 1: Domain 계층 구성
 2.인터페이스(Protocol) 정의:
 TodoRepository 프로토콜을 정의하여, 데이터 접근 방식(읽기, 쓰기 등)을 추상화합니다.
 여기서는 실제 데이터 저장 방식(메모리, 데이터베이스 등)에 상관없이 도메인 로직이 사용할 수 있도록 추상화합니다.
 */
protocol TodoRepository {
    func fetchTodos(page:Int) async throws -> [Todo]
    func createTodo(request: TodoAPIRequest) async throws -> Todo
}

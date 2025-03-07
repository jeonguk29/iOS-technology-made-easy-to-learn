//
//  NetworkTodoRepository.swift
//  CleanTodo
//
//  Created by 정정욱 on 2/25/25.
//

import Foundation
import Combine

// 커스텀 에러타입 정의
/*
 struct Config {
 static let version = "v2"
 static let baseURL = "https://phplaravel-574671-2962113.cloudwaysapps.com/api/" + version
 }
 */
enum ApiError : Error {
    case parsingError
    case noContent
    case decodingError
    case badStatus(code: Int)
}

class NetworkTodoRepository: TodoRepository {
    private let apiClient: APIClientProtocol
    
    init(apiClient: APIClientProtocol = APIClient()) {
        self.apiClient = apiClient
    }
    
    func fetchTodos(page: Int) async throws -> [Todo] {
        let response: TodosResponse = try await apiClient.sendRequest(
            endpoint: "/todos?page=\(page)", method: "GET", body: nil
        )
        return response.data ?? []
    }
    
    func createTodo(request: TodoAPIRequest) async throws -> Todo {
        let response: TodoAPIResponse = try await apiClient.sendRequest(
            endpoint: "/todos", method: "POST", body: request
        )
        return response.data!
    }
}

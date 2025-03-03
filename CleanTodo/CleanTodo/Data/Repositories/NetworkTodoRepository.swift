//
//  NetworkTodoRepository.swift
//  CleanTodo
//
//  Created by 정정욱 on 2/25/25.
//

import Foundation
import Combine

// 커스텀 에러타입 정의

struct Config {
    static let version = "v2"
    static let baseURL = "https://phplaravel-574671-2962113.cloudwaysapps.com/api/" + version
}

enum ApiError : Error {
    case parsingError
    case noContent
    case decodingError
    case badStatus(code: Int)
}

class NetworkTodoRepository: TodoRepository {
    
    func fetchTodos(page: Int) async throws -> [Todo] {
        // ✅ 1. URLRequest 생성
        let urlString = Config.baseURL + "/todos?page=\(page)"
        guard let url = URL(string: urlString) else {
            throw ApiError.parsingError // 유효하지 않은 URL일 경우 예외 발생
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept") // 헤더 설정
        
        // ✅ 2. URLSession을 통해 API 호출 (HTTP 상태 코드 검증 없이 바로 데이터 사용)
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        
        // ✅ 3. JSON 데이터를 Swift 모델(`TodosResponse`)로 디코딩
        do {
            let todosResponse = try JSONDecoder().decode(TodosResponse.self, from: data)
            return todosResponse.data ?? [] // `data`가 nil일 경우 빈 배열 반환
        } catch {
            throw ApiError.decodingError // 디코딩 오류 발생 시 예외 던지기
        }
    }
    
}

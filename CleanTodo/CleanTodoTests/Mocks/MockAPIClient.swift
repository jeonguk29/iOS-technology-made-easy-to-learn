//
//  MockAPIClient.swift
//  CleanTodoTests
//
//  Created by 정정욱 on 3/7/25.
//

import Foundation

class MockAPIClient: APIClientProtocol {
    var mockResponse: Any?
    var shouldFail: Bool = false
    var errorCode: Int? // ✅ 원하는 에러 코드를 설정 가능

    func sendRequest<T: Decodable>(endpoint: String, method: String, body: Encodable?) async throws -> T {
        if shouldFail {
            throw ApiError.badStatus(code: errorCode ?? 500) // ✅ 기본적으로 500을 반환함
        }
        guard let response = mockResponse as? T else {
            throw ApiError.decodingError
        }
        return response
    }
}


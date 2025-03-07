//
//  APIClient.swift
//  CleanTodo
//
//  Created by 정정욱 on 3/6/25.
//

import Foundation

protocol APIClientProtocol {
    func sendRequest<T: Decodable>(endpoint: String, method: String, body: Encodable?) async throws -> T
}

class APIClient: APIClientProtocol {
    private let baseURL = "https://phplaravel-574671-2962113.cloudwaysapps.com/api/v2"
    
    func sendRequest<T: Decodable>(
        endpoint: String,
        method: String,
        body: Encodable?
    ) async throws -> T {
        
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            throw ApiError.parsingError
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("9J9ysNjaRd1I68vYjRxg2DncqBKBslEi5nP9ZpDc", forHTTPHeaderField: "X-CSRF-TOKEN")

        if let body = body {
            if body.isMultipartRequired { // ✅ 자동 감지 (Request 모델에 따라 JSON 또는 FormData로 전송)
                let boundary = UUID().uuidString
                request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
                request.httpBody = createMultipartBody(parameters: body, boundary: boundary)
            } else {
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpBody = try? JSONEncoder().encode(body)
            }
        }

        let (data, response) = try await URLSession.shared.data(for: request)

        let responseData = String(data: data, encoding: .utf8) ?? "응답 없음"
        print("📡 서버 응답: \(responseData)")

        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw ApiError.badStatus(code: (response as? HTTPURLResponse)?.statusCode ?? 0)
        }

        return try JSONDecoder().decode(T.self, from: data)
    }
    
    /// ✅ Multipart FormData Body 생성 함수
    private func createMultipartBody(parameters: Encodable, boundary: String) -> Data {
        var body = Data()
        
        if let dictionary = parameters.dictionary {
            for (key, value) in dictionary {
                body.append("--\(boundary)\r\n".data(using: .utf8)!)
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
                body.append("\(value)\r\n".data(using: .utf8)!)
            }
        }
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        return body
    }
}

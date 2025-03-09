//
//  RealServerAPIClient.swift
//  CleanTodoTests
//
//  Created by 정정욱 on 3/9/25.
//

import Foundation

class RealServerAPIClient: APIClientProtocol {
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

        if let body = body {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try? JSONEncoder().encode(body)
        }

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw ApiError.badStatus(code: (response as? HTTPURLResponse)?.statusCode ?? 0)
        }

        return try JSONDecoder().decode(T.self, from: data)
    }
}

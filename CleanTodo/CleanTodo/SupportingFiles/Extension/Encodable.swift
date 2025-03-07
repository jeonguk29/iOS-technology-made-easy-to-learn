//
//  Encodable.swift
//  CleanTodo
//
//  Created by 정정욱 on 3/6/25.
//

import Foundation

/// ✅ FormData를 사용하는 API Request는 이 프로토콜을 채택하도록 설정
protocol MultipartRequest {}

extension Encodable {
    var dictionary: [String: String]? {
        guard let data = try? JSONEncoder().encode(self),
              let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
              let dictionary = jsonObject as? [String: Any] else { return nil }
        
        var stringDict: [String: String] = [:]
        for (key, value) in dictionary {
            if let boolValue = value as? Bool {
                stringDict[key] = boolValue ? "true" : "false"
            } else {
                stringDict[key] = "\(value)"
            }
        }
        return stringDict
    }
    
    /// ✅ Request 모델이 multipart/form-data가 필요한지 자동 감지
    var isMultipartRequired: Bool {
        self is MultipartRequest
    }
}

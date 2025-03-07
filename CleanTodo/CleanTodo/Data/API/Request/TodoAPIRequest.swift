//
//  TodoAPIRequest.swift
//  CleanTodo
//
//  Created by 정정욱 on 3/6/25.
//

import Foundation

struct TodoAPIRequest: Encodable, MultipartRequest{
    let title: String
    let is_done: Bool
    
    enum CodingKeys: String, CodingKey {
        case title
        case is_done = "is_done"
    }
}

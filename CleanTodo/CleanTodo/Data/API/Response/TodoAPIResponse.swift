//
//  TodoAPIResponse.swift
//  CleanTodo
//
//  Created by 정정욱 on 3/6/25.
//

import Foundation

struct TodoAPIResponse: Decodable {
    let data: Todo?
    let message: String?
}

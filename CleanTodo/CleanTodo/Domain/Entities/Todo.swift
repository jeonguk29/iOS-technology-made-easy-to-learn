//
//  Todo.swift
//  TodoListApp
//
//  Created by 정정욱 on 2/24/25.
//

import Foundation

/*
 단계 1: Domain 계층 구성
 1.모델(Entity) 생성:
 Todo.swift 파일은 앱의 핵심 데이터 모델인 Todo 객체를 정의합니다.
 이 모델은 앱 전반에 걸쳐 사용되며, 비즈니스 로직의 기본 단위입니다.
 */

// MARK: - TodosResponse
// JSON -> struct, class : 디코딩한다
struct TodosResponse: Decodable {
    let data: [Todo]?
    let meta: Meta?
    let message: String?
}

struct Todo: Codable {
    let id: Int?
    let title: String?
    let isDone: Bool?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey { // CodingKeys 서버에서 주는 이름이랑 다르게 사용하고 싶을때 사용
        case id, title
        case isDone = "is_done"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct Meta: Codable {
    let currentPage, from, lastPage, perPage: Int?
    let to, total: Int?

    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case from
        case lastPage = "last_page"
        case perPage = "per_page"
        case to, total
    }
}

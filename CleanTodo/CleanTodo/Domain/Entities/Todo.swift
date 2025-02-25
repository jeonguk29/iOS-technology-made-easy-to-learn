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
struct Todo: Identifiable {
    let id: UUID
    var title: String
    var isCompleted: Bool
}


//
//  CleanTodoApp.swift
//  CleanTodo
//
//  Created by 정정욱 on 2/24/25.
//

import SwiftUI

/*
 단계 4: 앱 구성 및 의존성 주입
 의존성 주입 구현: 앱 시작 시 NetworkTodoRepository 인스턴스를 생성합니다.
 이를 이용해 TodoListViewModel을 초기화하고, 최종적으로 TodoListView에 주입하여 앱 전체에서 동일한 데이터 소스를 사용하도록 설정합니다.
 */

@main
struct CleanTodoApp: App {
    var body: some Scene {
        // 네트워크 Repository 인스턴스를 생성
        let repository = NetworkTodoRepository()
        // LocalTodoRepository
        // UseCase를 생성하고 Repository 주입
        let todoUseCase = TodoUseCase(repository: repository)
        
        // ViewModel을 생성하고 UseCase 주입
        let viewModel = TodoListViewModel(todoUseCase: todoUseCase)
        
        WindowGroup {
            TodoListView(viewModel: viewModel)
        }
    }
}

/*
@main
struct CleanTodoApp: App {
    var body: some Scene {
        let repository = InMemoryTodoRepository()
        let viewModel = TodoListViewModel(repository: repository)
        
        WindowGroup {
            TodoListView(viewModel: viewModel)
        }
    }
}
*/

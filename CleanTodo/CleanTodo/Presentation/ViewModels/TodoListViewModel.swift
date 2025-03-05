//
//  TodoListViewModel.swift
//  TodoListApp
//
//  Created by 정정욱 on 2/24/25.
//

import Foundation
import Combine

/*
 단계 3: Presentation 계층 구현
 1. ViewModels (UI 상태 관리):
 
 TodoListViewModel.swift는 뷰와 도메인 계층(UseCase)을 연결해주는 역할을 합니다.
 UI에서 발생하는 이벤트를 받아 도메인 로직에 전달하고, 그 결과를 다시 UI에 반영하는 중개자 역할을 합니다.
 TodoListViewModel을 만들어, Domain 계층의 UseCase를 통해 데이터를 처리하고 UI에 필요한 상태를 관리합니다.

 TodoUseCase가 데이터 처리 즉 TodoRepository를 통해 알아서 하기 때문에 TodoUseCase만 이용하면 됨 알 필요가 없는 것
 ViewModel은
 */

class TodoListViewModel: ObservableObject {
    @Published var todos: [Todo] = []
    
    private let todoUseCase: TodoUseCase
    
    init(todoUseCase: TodoUseCase) {
        self.todoUseCase = todoUseCase
    }
    
    func fetchTodos() {
        Task {
            do {
                let fetchedTodos = try await todoUseCase.getTodos()
                DispatchQueue.main.async {
                    self.todos = fetchedTodos
                    print("ViewModel\(self.todos)")
                }
            } catch {
                print("❌ 오류 발생: \(error)")
            }
        }
    }
}

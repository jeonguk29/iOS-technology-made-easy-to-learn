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
 이때, 의존성 주입을 사용하여 외부에서 InMemoryTodoRepository를 주입받습니다.
 의존성 주입을 통해 테스트가 용이해지고, 나중에 다른 데이터 저장소로의 변경이 쉬워집니다.
 */
class TodoListViewModel: ObservableObject {
    @Published var todos: [Todo] = []
    
    private let todoUseCase: TodoUseCase
    private var repository: NetworkTodoRepository
    
    init(repository: NetworkTodoRepository) {
        self.repository = repository
        self.todoUseCase = TodoUseCase(repository: repository)
        self.todos = repository.fetchTodos()
    }
    
    func addTodo(title: String) {
        todoUseCase.addTodo(title: title)
        self.todos = repository.fetchTodos()
    }
    
    func deleteTodo(at offsets: IndexSet) {
        offsets.forEach { index in
            let todo = todos[index]
            repository.deleteTodo(todo)
        }
        self.todos = repository.fetchTodos()
    }
}

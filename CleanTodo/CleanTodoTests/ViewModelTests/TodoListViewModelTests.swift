//
//  TodoListViewModelTests.swift
//  CleanTodoTests
//
//  Created by 정정욱 on 3/10/25.
//

//
//  TodoListViewModelTests.swift
//  CleanTodoTests
//

import XCTest
@testable import CleanTodo

class TodoListViewModelTests: XCTestCase {
    var viewModel: TodoListViewModel!
    var mockRepository: MockTodoRepository!
    var useCase: TodoUseCase!

    override func setUp() {
        super.setUp()
        mockRepository = MockTodoRepository()
        useCase = TodoUseCase(repository: mockRepository) // ✅ 멤버 변수로 유지
        viewModel = TodoListViewModel(todoUseCase: useCase)
    }
    
    func test_ViewModel초기화_할일목록이_비어있어야함() {
        XCTAssertEqual(viewModel.todos.count, 0, "초기화 시 todos는 비어 있어야 함")
    }
    
    func test_fetchTodos실행시_할일목록이_업데이트됨() async {
        // Given: Mock 데이터를 설정
        let expectedTodos = mockRepository.mockTodos
        let expectation = expectation(description: "fetchTodos 완료 대기") // ✅ 비동기 실행 대기

        // When: fetchTodos() 실행
        Task {
            await viewModel.fetchTodos()
            expectation.fulfill() // ✅ 실행 완료 후 expectation 완료
        }

        await fulfillment(of: [expectation], timeout: 2.0) // ✅ 최대 2초 동안 대기

        // Then: ViewModel의 todos 배열이 업데이트되었는지 확인
        XCTAssertEqual(viewModel.todos.count, expectedTodos.count, "fetchTodos 실행 후 todos가 업데이트되어야 함")
        XCTAssertEqual(viewModel.todos.first?.title, expectedTodos.first?.title, "첫 번째 할 일의 제목이 일치해야 함")
    }

    
    func test_fetchTodos_서버에러시_할일목록이_변경되지않음() async {
        // Given: 서버 오류를 발생시키도록 설정
        mockRepository.shouldFail = true
        
        // When: `fetchTodos()` 실행
        await viewModel.fetchTodos()
        
        // Then: ViewModel의 `todos` 배열이 그대로 비어 있어야 함
        XCTAssertEqual(viewModel.todos.count, 0, "서버 오류 시 todos는 변경되지 않아야 함")
    }
}

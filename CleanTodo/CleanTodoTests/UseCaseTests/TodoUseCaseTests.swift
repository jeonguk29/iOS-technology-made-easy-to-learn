//
//  TodoUseCaseTests.swift
//  CleanTodoTests
//

import XCTest
@testable import CleanTodo

class TodoUseCaseTests: XCTestCase {
    var useCase: TodoUseCase!
    var mockRepository: MockTodoRepository!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockTodoRepository()
        useCase = TodoUseCase(repository: mockRepository)
    }
    
    /// ✅ 정상적으로 할 일 목록을 불러오는지 확인
    func test_할일목록을_정상적으로_불러온다() async throws {
        // Given: Mock 데이터를 설정
        let expectedTodos = mockRepository.mockTodos
        
        // When: fetchTodos() 실행
        let todos = try await useCase.getTodos()

        // Then: 목록이 올바르게 반환되었는지 확인
        XCTAssertEqual(todos.count, expectedTodos.count, "불러온 할 일 개수가 일치해야 함")
        XCTAssertEqual(todos.first?.title, expectedTodos.first?.title, "첫 번째 할 일의 제목이 일치해야 함")
    }
    
    /// ✅ 서버에서 500 오류가 발생하면 예외를 던지는지 확인
    func test_할일목록불러오기_서버에러발생시_예외반환() async throws {
        // Given: 서버 오류를 발생시키도록 설정
        mockRepository.shouldFail = true

        // When & Then: 예외가 발생해야 함
        do {
            _ = try await useCase.getTodos()
            XCTFail("서버 오류가 발생해야 하지만 정상적으로 실행됨")
        } catch let error as ApiError {
            XCTAssertEqual(error, .badStatus(code: 500), "500 오류가 발생해야 함")
        }
    }

    /// ✅ 정상적으로 할 일을 추가하는지 확인
    func test_할일을_정상적으로_추가한다() async throws {
        // Given
        let request = TodoAPIRequest(title: "새 할일", is_done: false)

        // When
        let newTodo = try await useCase.postTodo(request: request)

        // Then
        XCTAssertEqual(newTodo.title, "새 할일")
        XCTAssertEqual(mockRepository.mockTodos.count, 3, "새로운 할 일이 추가되어야 함")
    }
    
    /// ✅ 글자 수 제한으로 인해 추가 실패 시 예외를 반환하는지 확인
    func test_할일추가시_글자수가_적다면_예외반환() async throws {
        // Given
        mockRepository.shouldFail = true
        let request = TodoAPIRequest(title: "새 할일", is_done: false)

        // When & Then
        do {
            _ = try await useCase.postTodo(request: request)
            XCTFail("서버 오류가 발생해야 하지만 정상적으로 실행됨")
        } catch let error as ApiError {
            XCTAssertEqual(error, .badStatus(code: 422), "422 오류가 발생해야 함")
        }
    }
}

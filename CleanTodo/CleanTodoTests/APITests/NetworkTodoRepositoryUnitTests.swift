//
//  NetworkTodoRepositoryUnitTests.swift
//  CleanTodoTests
//
//  Created by 정정욱 on 3/7/25.
//

import XCTest
@testable import CleanTodo

class NetworkTodoRepositoryUnitTests: XCTestCase {
    var repository: NetworkTodoRepository!
    var mockAPIClient: MockAPIClient!
    
    override func setUp() {
        super.setUp()
        mockAPIClient = MockAPIClient()
        repository = NetworkTodoRepository(apiClient: mockAPIClient)
    }
    
    func test_FetchTodos_ShouldReturnMockData() async throws {
        // Given: Mock 데이터를 설정
        let mockTodos = [Todo(id: 1, title: "Mock 할일", isDone: false, createdAt: "2024-03-01", updatedAt: "2024-03-02")]
        let mockResponse = TodosResponse(data: mockTodos, meta: nil, message: "성공")
        
        mockAPIClient.mockResponse = mockResponse
        
        // When: `fetchTodos()` 실행
        let todos = try await repository.fetchTodos(page: 1)
        
        // Then: 예상한 결과와 비교
        XCTAssertEqual(todos.count, 1)
        XCTAssertEqual(todos.first?.title, "Mock 할일", "todo 패치 실패")
        
        // ✅ 성공 메시지 출력
        print("✅ test_FetchTodos_ShouldReturnMockData 성공: todo 불러오기 완료!")
    }
    
    func test_CreateTodo_ShouldReturnNewTodo() async throws {
        // Given
        let request = TodoAPIRequest(title: "새 할일", is_done: false)
        let mockResponse = TodoAPIResponse(data: Todo(id: 99, title: "새 할일", isDone: false, createdAt: "2024-03-06", updatedAt: "2024-03-06"), message: "성공")
        mockAPIClient.mockResponse = mockResponse

        // When
        let newTodo = try await repository.createTodo(request: request)

        // Then
        XCTAssertEqual(newTodo.id, 99)
        XCTAssertEqual(newTodo.title, "새 할일", "todo 생성 실패")
        
        // ✅ 성공 메시지 출력
        print("✅ test_CreateTodo_ShouldReturnNewTodo 성공: todo 생성 완료!")
    }
    
    func test_CreateTodo_ShouldReturnError_WhenTitleIsEmpty() async throws {
        // Given: 최소 글자 미만 요청 데이터 (서버에서 422 반환 기대)
        let request = TodoAPIRequest(title: "3글자", is_done: false)
        mockAPIClient.shouldFail = true // ✅ API 요청 실패 시뮬레이션
        mockAPIClient.errorCode = 422 // ✅ 422를 반환하도록 설정

        // When & Then: 예외가 발생해야 함
        do {
            _ = try await repository.createTodo(request: request)
            XCTFail("적은 글자로 실행했지만 실패 하지 않았음!") // ✅ 실패 시 테스트 실패 처리
        } catch let error as ApiError {
            XCTAssertEqual(error, .badStatus(code: 422)) // ✅ 422 에러 반환 확인
        }
    }

    
    func test_FetchTodos_ShouldHandleServerError() async throws {
        // Given: 서버에서 500 오류 발생
        mockAPIClient.shouldFail = true // ✅ 서버 장애 시뮬레이션

        // When & Then: API 호출 시 에러가 발생해야 함
        do {
            _ = try await repository.fetchTodos(page: 1)
            XCTFail("서버 오류가 발생해야 하는데 정상적으로 실행됨!") // ✅ 실패 시 테스트 실패
        } catch {
            XCTAssertEqual(error as? ApiError, .badStatus(code: 500)) // ✅ 500 에러 확인
        }
    }
    
}

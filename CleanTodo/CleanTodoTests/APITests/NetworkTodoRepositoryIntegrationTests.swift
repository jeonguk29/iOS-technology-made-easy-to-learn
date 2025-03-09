//
//  NetworkTodoRepositoryIntegrationTests.swift
//  CleanTodoTests
//
//  Created by 정정욱 on 3/9/25.
//

import XCTest

class NetworkTodoRepositoryIntegrationTests: XCTestCase {
    var repository: NetworkTodoRepository!

    override func setUp() {
        super.setUp()
        let realAPIClient = RealServerAPIClient() // ✅ 실제 서버와 통신
        repository = NetworkTodoRepository(apiClient: realAPIClient)
    }

    func test_FetchTodos_ShouldReturnValidData_FromServer() async throws {
        // When: 실제 서버에서 todo 목록을 가져옴
        let todos = try await repository.fetchTodos(page: 1)

        // Then: 정상적으로 데이터를 가져왔는지 확인
        XCTAssertGreaterThan(todos.count, 0, "서버에서 최소 1개 이상의 할 일이 반환되어야 함")
        print("✅ 실서버 테스트 성공: \(todos.count)개의 할 일 로드 완료!")
    }

    func test_CreateTodo_ShouldCreateTodo_OnServer() async throws {
        // Given
        let request = TodoAPIRequest(title: "테스트 할 일", is_done: false)

        // When
        let newTodo = try await repository.createTodo(request: request)

        // Then
        XCTAssertNotNil(newTodo.id, "생성된 할 일의 ID가 존재해야 함")
        XCTAssertEqual(newTodo.title, "테스트 할 일", "서버에서 응답한 제목이 요청과 동일해야 함")
        print("✅ 실서버 테스트 성공: 할 일 생성 완료 (ID: \(newTodo.id!))")
    }
    
    func test_CreateTodo_ShouldReturnError_WhenTitleIsEmpty() async throws {
        // Given: 최소 글자 미만 요청 데이터 (서버에서 422 반환 기대)
        let request = TodoAPIRequest(title: "3글자", is_done: false)
        // When & Then: 예외가 발생해야 함
        do {
            _ = try await repository.createTodo(request: request)
            XCTFail("적은 글자로 실행했지만 실패 하지 않았음!") // ✅ 실패 시 테스트 실패 처리
        } catch let error as ApiError {
            XCTAssertEqual(error, .badStatus(code: 422)) // ✅ 422 에러 반환 확인
        }
    }
}

//
//  NetworkTodoRepository.swift
//  CleanTodo
//
//  Created by 정정욱 on 2/25/25.
//

import Foundation
import Combine

class NetworkTodoRepository: TodoRepository, ObservableObject {
    @Published var todos: [Todo] = []
    
    // 예시용 API 엔드포인트 (실제 주소로 교체)
    private let baseURL = URL(string: "https://example.com/api/todos")!
    
    // HTTP 통신은 기본적으로 비동기입니다.
    // 아래는 async/await를 활용한 예시입니다. (iOS 15 이상)
    func fetchTodos() -> [Todo] {
        // 기존 프로토콜 메서드 시그니처는 동기 형태이지만,
        // 실제로는 비동기 통신을 통해 데이터를 받아와야 합니다.
        var fetchedTodos: [Todo] = []

        URLSession.shared.dataTask(with: baseURL) { data, response, error in
            if let error = error {
                print("네트워크 오류: \(error)")
                return
            }
            guard let data = data else { return }
            do {
                fetchedTodos = try JSONDecoder().decode([Todo].self, from: data)
            } catch {
                print("디코딩 오류: \(error)")
            }
        }.resume()
  
        return fetchedTodos
    }
    
    func addTodo(_ todo: Todo) {
        // POST 요청을 보내 서버에 Todo를 추가하는 로직 구현
        var request = URLRequest(url: baseURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            request.httpBody = try JSONEncoder().encode(todo)
        } catch {
            print("인코딩 오류: \(error)")
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("POST 요청 오류: \(error)")
            }
        }.resume()
    }
    
    func updateTodo(_ todo: Todo) {
        // PUT 요청을 보내 서버에 Todo 업데이트 요청
        let updateURL = baseURL.appendingPathComponent(todo.id.uuidString)
        var request = URLRequest(url: updateURL)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            request.httpBody = try JSONEncoder().encode(todo)
        } catch {
            print("인코딩 오류: \(error)")
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("PUT 요청 오류: \(error)")
            }
        }.resume()
    }
    
    func deleteTodo(_ todo: Todo) {
        // DELETE 요청을 보내 서버에서 Todo 삭제
        let deleteURL = baseURL.appendingPathComponent(todo.id.uuidString)
        var request = URLRequest(url: deleteURL)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("DELETE 요청 오류: \(error)")
            }
        }.resume()
    }
}

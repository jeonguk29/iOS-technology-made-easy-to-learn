//
//  TodoListView.swift
//  TodoListApp
//
//  Created by 정정욱 on 2/24/25.
//


import SwiftUI
/*
 단계 3: Presentation 계층 구현
 2. ViewModels (UI 상태 관리):
 뷰에서는 ViewModel의 데이터를 바인딩하여 화면에 표시하고, 사용자 입력(예: Todo 추가, 삭제)을 처리합니다.
 */

struct TodoListView: View {
    @StateObject var viewModel: TodoListViewModel
    @State private var newTodoTitle: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("새로운 할 일을 입력하세요", text: $newTodoTitle)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button(action: {
                    viewModel.addTodo(title: newTodoTitle)
                    newTodoTitle = "" // 입력창 초기화
                }) {
                    Text("할 일 추가")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                List(viewModel.todos, id: \.id) { todo in
                    HStack {
                        Image(systemName: todo.isDone == true ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(todo.isDone == true ? .green : .gray)
                        Text(todo.title ?? "제목 없음")
                    }
                }
                .navigationTitle("Todo List")
            }
            .onAppear {
                viewModel.fetchTodos()
            }
            //            .refreshable { // ✅ Pull to Refresh 추가
            //                await viewModel.fetchTodos()
            //            }
        }
    }
    
    // ✅ 날짜 포맷 함수 (ISO8601 -> 사용자 친화적 날짜 변환)
    private func formatDate(_ dateString: String) -> String {
        let inputFormatter = ISO8601DateFormatter()
        if let date = inputFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateStyle = .medium
            outputFormatter.timeStyle = .none
            return outputFormatter.string(from: date)
        }
        return "날짜 없음"
    }
}

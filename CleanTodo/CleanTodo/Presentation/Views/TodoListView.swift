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
                List(viewModel.todos, id: \.id) { todo in
                    HStack {
                        // ✅ 완료 여부에 따라 체크 아이콘 표시
                        Image(systemName: todo.isDone == true ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(todo.isDone == true ? .green : .gray)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            // ✅ 할 일 제목
                            Text(todo.title ?? "제목 없음")
                                .font(.headline)
                                .foregroundColor(todo.isDone == true ? .gray : .primary) // ✅ 완료된 항목 흐리게 표시
                            
                            // ✅ 생성 날짜 표시
                            if let createdAt = todo.createdAt {
                                Text(formatDate(createdAt))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        Spacer() // ✅ 자동 정렬
                    }
                    .padding(.vertical, 8) // ✅ 간격 조정
                }
                .navigationTitle("Todo List") // ✅ 네비게이션 제목
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

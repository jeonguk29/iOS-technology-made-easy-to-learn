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
                HStack {
                    TextField("새 Todo 입력", text: $newTodoTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button(action: {
                        guard !newTodoTitle.isEmpty else { return }
                        viewModel.addTodo(title: newTodoTitle)
                        newTodoTitle = ""
                    }) {
                        Text("추가")
                    }
                }
                .padding()
                
                List {
                    ForEach(viewModel.todos) { todo in
                        HStack {
                            Text(todo.title)
                            Spacer()
                            if todo.isCompleted {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                    .onDelete(perform: viewModel.deleteTodo)
                }
            }
            .navigationTitle("Todo List")
        }
    }
}

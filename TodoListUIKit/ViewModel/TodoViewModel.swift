//
//  TodoViewModel.swift
//  TodoListUIKit
//
//  Created by John Yun on 5/26/24.
//

import Foundation

// saveTodo(), sortTodoDate() 를 매 함 수마다 사용하지 말고 UserDefaults를 확장시켜서  didSet{ saveTodo() or sortTodoDate() or loadTodo()} 하면 코드가 짧아지지 않았을까 생각듭니당

class TodoViewModel {
    private(set) var todo: [Todo] = []
    
    var numberOfTodo: Int {
        return todo.count
    }
    
    init() {
        loadTodo()
    }
    
    func todo(at index: Int) -> Todo {
        return todo[index]
    }
    
    // Todo 추가
    func addTodo(title: String, date: Date) {
        let newTodo = Todo(title: title, isComplete: false, date: date)
        todo.append(newTodo)
        saveTodo()
        sortTodoDate()
    }
    
    func toggleComplete(at index: Int) {
        todo[index].isComplete.toggle()
        saveTodo()
        sortTodoDate()
    }
    
    func deleteTodo(at index: Int) {
        todo.remove(at: index)
        saveTodo()
    }
    
    // Todo 업데이트
    func updateTodo(at index: Int, with title: String, date: Date) {
        todo[index].title = title
        todo[index].date = date
        saveTodo()
        sortTodoDate()
    }
    
    // UserDefaults에 저장
    private func saveTodo() {
        // saveTodo() 이후에 sortTodoDate()가 반복되는거 같아서
        // 여기에 sortTodoDate()를 넣으면 어떨까 싶음
        if let encoded = try? JSONEncoder().encode(todo) {
            UserDefaults.standard.set(encoded, forKey: "todo")
        }
    }
    
    // UserDefaults에서 불러오기
    private func loadTodo() {
        if let saveTodo = UserDefaults.standard.object(forKey: "todo") as? Data {
            if let decodedTodo = try? JSONDecoder().decode([Todo].self, from: saveTodo) {
                todo = decodedTodo
                sortTodoDate()
            }
        }
    }
    
    private func sortTodoDate() {
        todo.sort { ($0.date > $1.date) }
    }
    
//    isComplete로 sort하는 함수 구현해야함
//    private func sortTodoIsComplete() {
//        todo.sort { ($0.isComplete == true) }
//    }
}

//
//  TodoViewModel.swift
//  TodoListUIKit
//
//  Created by John Yun on 5/26/24.
//

import Foundation

class TodoViewModel {
    private(set) var todo: [Todo] = []
    
    var numberOfTodo: Int {
        return todo.count
    }
    
    init() {
        loadTodo()
    }
    
    //Ruel: 함수명 명확하게 수정 필요 ex) getTodo(at index:)
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
        if let encoded = try? JSONEncoder().encode(todo) {
            UserDefaults.standard.set(encoded, forKey: "todo")
        }
    }
    
    // UserDefaults에서 불러오기
    private func loadTodo() {
        if let saveTodo = UserDefaults.standard.object(forKey: "todo") as? Data {
            if let decodedTodo = try? JSONDecoder().decode([Todo].self, from: saveTodo) {
                todo = decodedTodo
                /*
                 Ruel: loadTodo시 sort를 하게 된다면 sortTodoDate 메서드 불필요해짐
                 todo = decodedTodo.sorted(by: { $0.date > $1.date })
                 */
                sortTodoDate()
            }
        }
    }
    
    /*
    Ruel: loadTodo시 sort를 하게 된다면 해당 메서드 불필요해짐
     */
    private func sortTodoDate() {
        todo.sort { ($0.date > $1.date) }
    }
    
//    isComplete로 sort하는 함수 구현해야함
//    private func sortTodoIsComplete() {
//        todo.sort { ($0.isComplete == true) }
//    }
}

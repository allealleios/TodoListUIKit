//
//  TodoViewModel.swift
//  TodoListUIKit
//
//  Created by John Yun on 5/26/24.
//

import Foundation
import Combine


class TodoViewModel: ObservableObject {
    @Published var todo: [Todo] = []
    
    private var cancellable = Set<AnyCancellable>()
    
    var numberOfTodo: Int {
        return todo.count
    }
    
    init() {
        loadTodo()
    }
    
    func getTodo(at index: Int) -> Todo {
        return todo[index]
    }
    
    func addTodo(title: String, date: Date) {
        let newTodo = Todo(title: title, isComplete: false, date: date)
        todo.append(newTodo)
        saveTodo()
    }
    
    func toggleComplete(at index: Int) {
        todo[index].isComplete.toggle()
        saveTodo()
    }
    
    func deleteTodo(at index: Int) {
        todo.remove(at: index)
        saveTodo()
    }
    
    func updateTodo(at index: Int, with updateTodo: Todo) {
        todo[index] = updateTodo
        saveTodo()
    }
    
    private func saveTodo() {
        if let encoded = try? JSONEncoder().encode(todo) {
            UserDefaults.standard.set(encoded, forKey: "todo")
        }
        todo.sort { ($0.date > $1.date) }
    }
    
    private func loadTodo() {
        if let saveTodo = UserDefaults.standard.object(forKey: "todo") as? Data {
            if let decodedTodo = try? JSONDecoder().decode([Todo].self, from: saveTodo) {
                todo = decodedTodo.sorted(by: { $0.date > $1.date })
            }
        }
    }
}

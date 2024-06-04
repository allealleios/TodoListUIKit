//
//  Todo.swift
//  TodoListUIKit
//
//  Created by John Yun on 5/26/24.
//

import Foundation

struct Todo: Codable, Identifiable {
    
    var id = UUID()
    var title: String
    var isComplete: Bool
    var date: Date
    
    init(id: UUID = UUID(), title: String, isComplete: Bool, date: Date) {
        self.id = id
        self.title = title
        self.isComplete = isComplete
        self.date = date
    }
}

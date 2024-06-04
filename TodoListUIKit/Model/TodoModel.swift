//
//  Todo.swift
//  TodoListUIKit
//
//  Created by John Yun on 5/26/24.
//

import Foundation

struct Todo: Codable, Identifiable {
    
    let id = UUID()
    var title: String
    var isComplete: Bool
    var date: Date
    
}

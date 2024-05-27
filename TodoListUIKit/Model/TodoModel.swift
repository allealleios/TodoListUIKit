//
//  Todo.swift
//  TodoListUIKit
//
//  Created by John Yun on 5/26/24.
//

import Foundation

// Todo 모델
struct Todo: Codable {
    
    var title: String
    var isComplete: Bool
    var date: Date
    
}

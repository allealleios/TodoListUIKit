//
//  EditTodoViewController.swift
//  TodoListUIKit
//
//  Created by John Yun on 5/27/24.
//

import UIKit

protocol EditTodoDelegate: AnyObject {
    func editTodo(_ todo: Todo, at index: Int)
}

class EditTodoViewController: UIViewController {
    
    weak var delegate: EditTodoDelegate?
    var todo: Todo?
    var index: Int?
    
    private let textField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupNavigationBar()
        loadTodo()
    }
    
    private func setupUI() {
        view.addSubview(textField)
        view.addSubview(datePicker)
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            textField.heightAnchor.constraint(equalToConstant: 40),
            
            datePicker.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 20),
            datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButtonTapped))
    }
    
    private func loadTodo() {
        guard let todo = todo else { return }
        textField.text = todo.title
        datePicker.date = todo.date
    }
    
    @objc private func saveButtonTapped() {
        guard let title = textField.text, !title.isEmpty else { return }
        guard let index = index else { return }
        let date = datePicker.date
        todo?.title = title
        todo?.date = date
        if let todo = todo {
            delegate?.editTodo(todo, at: index)
            navigationController?.popViewController(animated: true)
        }
    }
}

//
//  TodoDetailView.swift
//  TodoListUIKit
//
//  Created by John Yun on 5/26/24.
//

import UIKit

protocol AddTodoDelegate: AnyObject {
    func addTodo(_ todo: Todo)
}

class AddTodoViewController: UIViewController {
    
    weak var delegate: AddTodoDelegate?
    
    private let textField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Todo를 입력하세요"
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
    
    @objc private func saveButtonTapped() {
        guard let title = textField.text, !title.isEmpty else { return }
        let date = datePicker.date
        let newTodo = Todo(title: title, isComplete: false, date: date)
        delegate?.addTodo(newTodo)
        navigationController?.popViewController(animated: true)
    }
}

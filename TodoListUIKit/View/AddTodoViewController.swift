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
        
        /*
         Ruel: Backgroundcolor 설정은 setupUI 메서드 안에 작성해주는게 UI Setting한다는것을 
                명확하게 알 수 있을것 같음
         */
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
        //Ruel: 해당부분을 ViewModel을 생성해서 분리할 수 있을 듯, 명확한 비지니스 로직 분리
        guard let title = textField.text, !title.isEmpty else { return }
        let date = datePicker.date
        let newTodo = Todo(title: title, isComplete: false, date: date)
        delegate?.addTodo(newTodo)
        navigationController?.popViewController(animated: true)
    }
}

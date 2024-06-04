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
    
    var delegate: EditTodoDelegate?
    var todo: Todo?
    var index: Int?
    
    /*
     Ruel: TodoViewController에 주석을 남긴부분 예시 코드
     init(todo: Todo? = nil, index: Int? = nil) {
     self.todo = todo
     self.index = index
     super.init(nibName: nil, bundle: nil)
     }
     
     
     func setup(todo: Todo, index: Int) {
     self.todo = todo
     self.index = index
     }
     
     ->> 위와 같다면 todo, index를 private로 바꿔줄 수 있고
     외부에서 데이터를 변경 할 수 없게 만들기 때문에 안정성 확보 가능
     */
    // ㄴ 반영완료
    
    init(todo: Todo, index: Int) {
        self.todo = todo
        self.index = index
        super .init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        //Ruel: 해당 부분은 ViewModel을 생성해서 분리할 수 있을 듯, 명확한 비지니스 로직 분리
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

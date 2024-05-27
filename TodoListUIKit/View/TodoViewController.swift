//
//  ViewController.swift
//  TodoListUIKit
//
//  Created by John Yun on 5/26/24.
//

import UIKit

class TodoViewController: UIViewController {
    
    // Store에서 관리하면 어땠을지..?
    private let viewModel = TodoViewModel()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        title = "ToDo List"
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TodoCell.self, forCellReuseIdentifier: TodoCell.identifier)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addButtonTapped))
    }
    
    @objc private func addButtonTapped() {
        let addTodoVC = AddTodoViewController()
        addTodoVC.delegate = self
        navigationController?.pushViewController(addTodoVC, animated: true)
    }
}

// 2Store에서 관리하면 어땠을지..?2222
extension TodoViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfTodo
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TodoCell.identifier, for: indexPath) as? TodoCell else {
            return UITableViewCell()
        }
        
        let todo = viewModel.todo(at: indexPath.row)
        cell.configure(with: todo)
        
        cell.toggleCompleteAction = { [weak self] in
            self?.viewModel.toggleComplete(at: indexPath.row)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        return cell
    }
    
    // edit이랑 add 수정 부분 같을 경우에 하나의 뷰로 분기처리해서 사용하시면 수정 및 가독성 더 좋아지지 않을까..?하는 생각입니다!
    //     var todo: Todo? 가 존재할시는 수정,  없을 시는 추가
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let editTodoVC = EditTodoViewController()
        editTodoVC.todo = viewModel.todo(at: indexPath.row)
        editTodoVC.index = indexPath.row
        editTodoVC.delegate = self
        navigationController?.pushViewController(editTodoVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deleteTodo(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

extension TodoViewController: AddTodoDelegate {
    func addTodo(_ todo: Todo) {
        viewModel.addTodo(title: todo.title, date: todo.date)
        tableView.reloadData()
    }
}

// update 부분에서 delegate?.editTodo(todo, at: index)를 사용하였는데 바뀐 부분만 넣은 이유..? 나중에 수정 부분이 많아 질 겨웅 그냥 todo를 보내서 index번호 찾은 수 수정 하는 방향이 더 좋을거같습니다!!
extension TodoViewController: EditTodoDelegate {
    func editTodo(_ todo: Todo, at index: Int) {
        viewModel.updateTodo(at: index, with: todo.title, date: todo.date)
        tableView.reloadData()
    }
}

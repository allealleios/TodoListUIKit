//
//  ViewController.swift
//  TodoListUIKit
//
//  Created by John Yun on 5/26/24.
//


// Test

import UIKit

class TodoViewController: UIViewController {
    
    private let viewModel = TodoViewModel()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        /*
         Ruel: setupUI() 메서드가 UI셋팅하는 부분이기 때문에
         title 도 setupUI 메서드 안에 들어가는게 명확해져서 좋을거같음.(가독성측면)
         */
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let editTodoVC = EditTodoViewController()
        
        /*
         Ruel: EditTodoViewController에 todo와 index를 받는 메서드를 생성하거나
         생성자(init)을 통해 주입시키는게 더 깔끔할거 같음
         
         ex)
         editTodoVC.setup(todo: viewModel.todo(at: indexPath.row), index: indexPath.row)
         EditTodoViewController(todo: viewModel.todo(at: indexPath.row), index: indexPath.row)
         */
        editTodoVC.todo = viewModel.todo(at: indexPath.row)
        editTodoVC.index = indexPath.row
        editTodoVC.delegate = self
        navigationController?.pushViewController(editTodoVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deleteTodo(at: indexPath.row)
            
            /*
             Ruel:
                tableView.deleteRows / tableView.reloadData()와 같이 UI를 새로 업데이트 해주어야 하는경우
             DispatchQueue.main.async {
                 tableView.deleteRows(at:, with:) or tableView.reloadData()
             }
             위와 같이 사용하여 Main Thread에서 작업을
             ⭐️ UI 업데이트는 Main Thread에서만 작업을 해야함
             */
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

extension TodoViewController: EditTodoDelegate {
    func editTodo(_ todo: Todo, at index: Int) {
        viewModel.updateTodo(at: index, with: todo.title, date: todo.date)
        tableView.reloadData()
    }
}

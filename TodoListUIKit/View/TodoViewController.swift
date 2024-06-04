//
//  ViewController.swift
//  TodoListUIKit
//
//  Created by John Yun on 5/26/24.
//

import UIKit
import Combine

class TodoViewController: UIViewController {
    
    private var viewModel = TodoViewModel()
    private var cancellable = Set<AnyCancellable>()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }
    
    private func setupUI() {
        title = "ToDo List"
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
    
    private func setupBindings() {
        viewModel.$todo
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellable)
    }
    
    @objc private func addButtonTapped() {
        let addTodoVC = AddTodoViewController()
        addTodoVC.addTodoPublisher
            .sink { [weak self] newTodo in
                self?.viewModel.addTodo(title: newTodo.title, date: newTodo.date)
            }
            .store(in: &cancellable)
        
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
        
        let todo = viewModel.getTodo(at: indexPath.row)
        cell.configure(with: todo)
        
        cell.toggleCompleteAction = { [weak self] in
            self?.viewModel.toggleComplete(at: indexPath.row)
            self?.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let editTodoVC = EditTodoViewController(todo: viewModel.getTodo(at: indexPath.row), index: indexPath.row)
        
        editTodoVC.editTodoPublisher
            .sink { [weak self] (updateTodo, index) in
                self?.viewModel.updateTodo(at: index, with: updateTodo)
            }
            .store(in: &cancellable)
        navigationController?.pushViewController(editTodoVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deleteTodo(at: indexPath.row)
            DispatchQueue.main.async {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }
}

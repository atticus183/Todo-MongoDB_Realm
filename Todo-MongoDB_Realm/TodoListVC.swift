//
//  ViewController.swift
//  Todo-MongoDB_Realm
//
//  Created by Josh R on 5/16/21.
//

import RealmSwift
import UIKit

class TodoListVC: UIViewController {

    let realm = try! Realm(configuration: RealmManager.shared.configuration)

    var notificationToken: NotificationToken?

    var todos: Results<Todo>?

    let addButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Add", for: .normal)
        button.backgroundColor = .systemPink
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(addBtnTapped), for: .touchUpInside)
        return button
    }()

    let enterTodoTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter todo here"
        textField.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    let todoTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TodoCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableFooterView = UIView()  //removes empty rows
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Todos"
        view.backgroundColor = .systemBackground

        print("Local realm: \(String(describing: realm.configuration.fileURL))")

        todos = realm.objects(Todo.self)

        todoTableView.delegate = self
        todoTableView.dataSource = self

        //Add views
        view.addSubview(enterTodoTextField)
        view.addSubview(addButton)
        view.addSubview(todoTableView)
        setupConstraints()

        addNotificationListener()
    }

    deinit {
        notificationToken?.invalidate()
    }

    private func addNotificationListener() {
        //https://docs.mongodb.com/realm/sdk/ios/examples/react-to-changes/
        notificationToken = todos?.observe { [weak self] changes in
            switch changes {
            case .initial:
                self?.todoTableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                self?.todoTableView.performBatchUpdates({
                    // Always apply updates in the following order: deletions, insertions, then modifications.
                    self?.todoTableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                                   with: .automatic)
                    self?.todoTableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                                   with: .automatic)
                    self?.todoTableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                                   with: .automatic)
                })
            case .error(let error):
                fatalError("\(error)")
            }
        }
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            enterTodoTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            enterTodoTextField.heightAnchor.constraint(equalToConstant: 50),
            enterTodoTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            enterTodoTextField.trailingAnchor.constraint(equalTo: addButton.leadingAnchor),
            addButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            addButton.heightAnchor.constraint(equalToConstant: 40),
            addButton.widthAnchor.constraint(equalToConstant: 100),
            todoTableView.topAnchor.constraint(equalTo: enterTodoTextField.bottomAnchor, constant: 0),
            todoTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            todoTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            todoTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    @objc func addBtnTapped() {
        guard let enteredTodo = enterTodoTextField.text else { return }
        Todo.add(in: realm, text: enteredTodo)
        enterTodoTextField.text = ""
    }

}

extension TodoListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath)
        let todo = todos?[indexPath.row]
        cell.textLabel?.text = todo?.title
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            guard let todo = todos?[indexPath.row] else { return }
            Todo.delete(in: realm, todo: todo)
        default:
            return
        }
    }
}

// MARK: SwiftUI Preview for UIKit

#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct ViewController_Preview: PreviewProvider {

    static var previews: some View {
        NavigationView {
            TodoListVC().toPreview()
                .edgesIgnoringSafeArea(.all)
                .navigationTitle("Todos")
        }
    }
}
#endif

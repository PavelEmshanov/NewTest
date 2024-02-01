//
//  ViewController.swift
//  NewTest
//
//  Created by D. P. on 31.01.2024.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private let manager = CoreManager.shared
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .tertiarySystemFill
        table.layer.cornerRadius = 10
        table.delegate = self
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        return table
    }()
    
    //MARK: - table view methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        manager.notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MyCell(with: manager.notes[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let editScreen = EditViewController()
        editScreen.note = manager.notes[indexPath.row]
        self.navigationController?.pushViewController(editScreen, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            manager.notes[indexPath.row].deletNote()
            manager.fetchAllNotes()
            tableView.deleteRows(at: [indexPath], with: .automatic)        }
    }
    
    //MARK: - Life cicle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        manager.fetchAllNotes()
        tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        greetingsNote()
    }
    
    //MARK: - Setup view
    
    private func setupView() {
        view.addSubview(tableView)
        
        addButtonSetup()
        
        navigationController?.navigationBar.tintColor = .systemGray
        navigationItem.title = "Заметки"
        view.backgroundColor = .systemBackground
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])
    }
    
   //Добавление и конфигурация кнопки добавления заметки
    private func addButtonSetup() {
        let addButton = UIButton(type: .contactAdd)
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        let uIBarButton = UIBarButtonItem(customView: addButton)
        navigationItem.rightBarButtonItem = uIBarButton
    }
    
    @objc func addButtonTapped() {
        let editScreenVC = EditViewController()
        navigationController?.pushViewController(editScreenVC, animated: true)
    }
    
    //Добавление приветственной заметки при первом запуске
    private func greetingsNote() {
        let hasLaunchedBefore = UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
        
        if !hasLaunchedBefore {
            manager.addNewNote(title: "Привет", noteText: "Это приветственная заметка")
            UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
        }
    }
}

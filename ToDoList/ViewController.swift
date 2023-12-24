//
//  ViewController.swift
//  ToDoList
//
//  Created by Artyom on 24.12.2023.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private let table: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    var items = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.items = UserDefaults.standard.stringArray(forKey: "items") ?? []
        
        title = "Список дел"
        view.addSubview(table)
        table.delegate = self
        table.dataSource = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(didTapAdd))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Править",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(toggleEditing))
        
    }
    
    @objc private func didTapAdd() {
        let alert = UIAlertController(title: "Новая заметка", message: "Запишите вашу новую задачу", preferredStyle: .alert)
        
        alert.addTextField { field in
            field.placeholder =  "Вводить текст..."
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { [weak self]
            (_) in
            if let field = alert.textFields?.first {
                if let text = field.text, !text.isEmpty {
                    DispatchQueue.main.async {
                        var currentItems = UserDefaults.standard.stringArray(forKey: "items") ?? []
                        let newEntry = [text]
                        currentItems.append(text)
                        UserDefaults.standard.setValue(currentItems, forKey: "items")
                        self?.items.append(text)
                        self?.table.reloadData()
                    }
                    
                }
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc private func toggleEditing() {
        table.setEditing(!table.isEditing, animated: true)
        
        navigationItem.leftBarButtonItem?.title = table.isEditing ? "Готово" : "Править"
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            UserDefaults.standard.setValue(items, forKey: "items")
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        table.frame = view.bounds
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = items[indexPath.row]
        
        return cell
    }
}


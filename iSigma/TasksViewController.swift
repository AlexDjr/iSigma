//
//  ViewController.swift
//  iSigma
//
//  Created by Alex Delin on 14/12/2018.
//  Copyright © 2018 Alex Delin. All rights reserved.
//

import UIKit

class TasksViewController: UITableViewController {
    var tasks: [Task]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkManager.shared.auth(withUser: "adelin@diasoft.ru") {
            print("Успешная аутентификация!")
            NetworkManager.shared.getTasksForCurrentUser{ tasks in
                self.tasks = tasks
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath)
        
        guard let tasks = tasks else {
            return cell
        }
        
        cell.textLabel?.text = String(tasks[indexPath.row].id)
        cell.detailTextLabel?.text = tasks[indexPath.row].subject
        
        return cell
    }

}


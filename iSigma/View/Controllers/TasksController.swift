//
//  ViewController.swift
//  iSigma
//
//  Created by Alex Delin on 14/12/2018.
//  Copyright © 2018 Alex Delin. All rights reserved.
//

import UIKit

class TasksController: UITableViewController {
    var tasks: [Task]?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

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
    
    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskCell
        
        guard let tasks = tasks else {
            return cell
        }
        
        cell.taskId.text = String(tasks[indexPath.row].id)
        cell.taskType.text = tasks[indexPath.row].type
        cell.taskSubject.text = tasks[indexPath.row].subject
        cell.taskState.text = tasks[indexPath.row].state
        cell.taskAssignee.text = tasks[indexPath.row].assignee
        
        if tasks[indexPath.row].type == "Несоответствие" {
            cell.supplyDateView.isHidden = false
            cell.supplyDateView.layer.cornerRadius = 14.0
            cell.supplyDateView.layer.borderWidth = 1.0
            cell.supplyDateView.layer.borderColor = #colorLiteral(red: 1, green: 0.439357996, blue: 0.6011067629, alpha: 1)
            
            if let supplyPlanDate = tasks[indexPath.row].supplyPlanDate {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd.MM.yyyy"
                cell.supplyDate.text = dateFormatter.string(from: supplyPlanDate)
                dateFormatter.dateFormat = "HH:mm"
                cell.supplyTime.text = dateFormatter.string(from: supplyPlanDate)
            }
            cell.taskType.textColor = #colorLiteral(red: 1, green: 0.439357996, blue: 0.6011067629, alpha: 1)
        } else {
            cell.supplyDateView.isHidden = true
            cell.taskType.textColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
}


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
        
        cell.priorityView.layer.cornerRadius = 12.0
        cell.priorityView.layer.borderWidth = 1.0
        cell.priorityView.layer.borderColor = #colorLiteral(red: 1, green: 0.439357996, blue: 0.6011067629, alpha: 1)
        
        if tasks[indexPath.row].type == "Несоответствие" {
            cell.taskType.textColor = #colorLiteral(red: 1, green: 0.439357996, blue: 0.6011067629, alpha: 1)
            cell.taskTypeTrailingConstraint.constant = 40
            
            cell.priorityView.isHidden = false
            
            if tasks[indexPath.row].priority == 2 {
                cell.priorityView.layer.backgroundColor = #colorLiteral(red: 1, green: 0.439357996, blue: 0.6011067629, alpha: 1)
                cell.priority.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                cell.priorityView.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                cell.priority.textColor = #colorLiteral(red: 1, green: 0.439357996, blue: 0.6011067629, alpha: 1)
            }
            cell.priority.text = String(tasks[indexPath.row].priority)
            
            cell.supplyDate.isHidden = false
            cell.supplyTime.isHidden = false
            
            if let supplyPlanDate = tasks[indexPath.row].supplyPlanDate {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd.MM.yyyy"
                let dateString = dateFormatter.string(from: supplyPlanDate)
                
                let dateAttributedString = NSMutableAttributedString(string: dateString,
                                                                     attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 12)])
                dateAttributedString.insert(NSMutableAttributedString(string: "до "), at: 0)
                cell.supplyDate.attributedText = dateAttributedString
                
                dateFormatter.dateFormat = "HH:mm"
                cell.supplyTime.text = dateFormatter.string(from: supplyPlanDate)
            }
            
        } else {
            cell.taskType.textColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
            cell.taskTypeTrailingConstraint.constant = 10
            
            cell.priorityView.isHidden = true
            
            cell.supplyDate.isHidden = true
            cell.supplyTime.isHidden = true
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
}


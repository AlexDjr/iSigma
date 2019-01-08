//
//  ViewController.swift
//  iSigma
//
//  Created by Alex Delin on 14/12/2018.
//  Copyright © 2018 Alex Delin. All rights reserved.
//

import UIKit

class TasksController: UITableViewController {
    
    var viewModel: TasksViewModel?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = TasksViewModel()
        viewModel?.auth() {
            print("Успешная аутентификация!")
            self.viewModel?.getTasksForCurrentUser{ tasks in
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    //    MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRowsInSection(section) ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as? TaskCell

        guard let taskCell = cell, let viewModel = viewModel else { return UITableViewCell() }
        let cellViewModel = viewModel.cellViewModel(forIndexPath: indexPath)
        taskCell.viewModel = cellViewModel
        
        return taskCell
    }
    
    //    MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel?.heightForRowAt(forIndexPath: indexPath) ?? 44
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let viewModel = self.viewModel else { return nil }
        
        viewModel.selectItem(atIndexPath: indexPath)
        let cellViewModel = viewModel.viewModelForSelectedItem()!
        let task = cellViewModel.task!
        
        var forwardStates: [TaskState] = []
        var backwardStates: [TaskState] = []
        
        if let currentState = task.state {
            
            let proxy = Proxy(withKey: "taskStates+\(task.id)")
            proxy.loadData { objects in
                let taskStateNames = objects as! [String]
                for taskStateName in taskStateNames {
                    let taskState = TaskState(taskType: task.type, name: taskStateName)
                    if taskState == nil {
                        print("Для задачи \(task.id) не найдено соответствие состоянию \(taskStateName)")
                    } else {
                        if taskState!.order < currentState.order {
                            backwardStates.append(taskState!)
                        } else {
                            forwardStates.append(taskState!)
                        }
                    }
                }
                forwardStates.sort(by: { $0.order < $1.order })
                backwardStates.sort(by: { $0.order > $1.order })
            }
            
        } else {
            let alert = UIAlertController(title: "Ошибка!", message: "Для данной задачи не определено текущее состояние!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "ОК", style: .default)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        
        
        let transitForward = UIContextualAction(style: .normal, title: "Переход \n вперед") { (action, view, nil) in
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
            actionSheet.addAction(cancelAction)
            
            for taskState in forwardStates {
                var title = taskState.name
                if taskState.isFinal {
                    title = "⚑ " + title
                }
                let action = UIAlertAction(title: title, style: .default)
                actionSheet.addAction(action)
            }
            self.present(actionSheet, animated: true, completion: nil)
        }
        transitForward.backgroundColor = #colorLiteral(red: 0.3076787591, green: 0.6730349064, blue: 0.009131425992, alpha: 1)
        transitForward.image = #imageLiteral(resourceName: "transitForward")
        
        let transitBackward = UIContextualAction(style: .normal, title: "Переход \n назад") { (action, view, nil) in
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
            actionSheet.addAction(cancelAction)
            
            for taskState in backwardStates {
                let action = UIAlertAction(title: taskState.name, style: .default)
                actionSheet.addAction(action)
            }
            self.present(actionSheet, animated: true, completion: nil)
        }
        transitBackward.backgroundColor = #colorLiteral(red: 0.6734550595, green: 0.8765394092, blue: 0.4567703605, alpha: 1)
        transitBackward.image = #imageLiteral(resourceName: "transitBackward")
        
        let config = UISwipeActionsConfiguration(actions: [transitBackward, transitForward])
        config.performsFirstActionWithFullSwipe = false
        
        return config
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let logWrite = UIContextualAction(style: .destructive, title: "Списание") { (action, view, nil) in
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let worklogController = storyboard.instantiateViewController(withIdentifier: "worklogController") as! WorklogController
            
            guard let viewModel = self.viewModel else { return }
            viewModel.selectItem(atIndexPath: indexPath)
            worklogController.viewModel = viewModel.viewModelForSelectedItem()
            worklogController.navigationItem.title = "Списание"
            
            self.navigationController?.pushViewController(worklogController, animated: true)
        }
        logWrite.backgroundColor = #colorLiteral(red: 0.4971398711, green: 0.7130244374, blue: 0.9623243213, alpha: 1)
        logWrite.image = #imageLiteral(resourceName: "logWrite")
        
        return UISwipeActionsConfiguration(actions: [logWrite])
    }
    
}


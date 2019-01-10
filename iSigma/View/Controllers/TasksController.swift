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
        NotificationCenter.default.addObserver(self, selector: #selector(appWillReturnFromBackground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
        
        var config: UISwipeActionsConfiguration? = nil
        viewModel.taskStates(forIndexPath: indexPath) { isSuccess, taskStates in
            if isSuccess {
                let transitForward = self.getContextualAction(title: "Переход \n вперед", taskStates: taskStates![0])
                transitForward.backgroundColor = #colorLiteral(red: 0.3076787591, green: 0.6730349064, blue: 0.009131425992, alpha: 1)
                transitForward.image = #imageLiteral(resourceName: "transitForward")
                
                let transitBackward = self.getContextualAction(title: "Переход \n назад", taskStates: taskStates![1])
                transitBackward.backgroundColor = #colorLiteral(red: 0.6734550595, green: 0.8765394092, blue: 0.4567703605, alpha: 1)
                transitBackward.image = #imageLiteral(resourceName: "transitBackward")
                
                config = UISwipeActionsConfiguration(actions: [transitBackward, transitForward])
                config!.performsFirstActionWithFullSwipe = false
            } else {
                let alert = UIAlertController(title: "Ошибка!", message: "Для данной задачи не определено текущее состояние!", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "ОК", style: .default)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
        
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let taskInfoController = storyboard.instantiateViewController(withIdentifier: "taskInfoController") as! TaskInfoController
        taskInfoController.navigationItem.title = "Задача"
        self.navigationController?.pushViewController(taskInfoController, animated: true)
    }
    
    //    MARK: - Methods
    func getContextualAction(title: String, taskStates: [TaskState]) -> UIContextualAction {
        let contextualAction = UIContextualAction(style: .normal, title: title) { (action, view, nil) in
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
            actionSheet.addAction(cancelAction)
            
            //    sets handler logic for element of actionSheet
            let handler = { (action: UIAlertAction!) -> () in
                if let index = actionSheet.actions.firstIndex(where: {$0 === action}) {
                    
                    guard let viewModel = self.viewModel else { return }
                    let cellViewModel = viewModel.viewModelForSelectedItem()!
                    
                    let task = cellViewModel.task!
                    let currentTaskState = task.state!.serverId
                    let nextTaskState = taskStates[index - 1].serverId
                    
                    var rowAnimation: UITableView.RowAnimation? = nil
                    if title == "Переход \n вперед" {
                        rowAnimation = UITableView.RowAnimation(rawValue: 2)
                    } else {
                        rowAnimation = UITableView.RowAnimation(rawValue: 1)
                    }
                    
                    //    asks server to perform task transition
                    NetworkManager.shared.putTaskTransition(taskId: task.id, from: currentTaskState, to: nextTaskState) { isSuccess, details in
                        if isSuccess {
                            NetworkManager.shared.cache.removeObject(forKey: "tasks")
                            NetworkManager.shared.cache.removeObject(forKey: "taskStates+\(task.id)" as NSString)
                            viewModel.getTasksForCurrentUser{ tasks in
                                DispatchQueue.main.async {
                                    self.tableView.reloadRows(at: [viewModel.selectedIndexPath!], with: rowAnimation!)
                                }
                            }
                        } else {
                            DispatchQueue.main.async {
                                let alert = UIAlertController(title: "Ошибка!", message: details, preferredStyle: .alert)
                                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                                
                                alert.addAction(okAction)
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                    }
                    DispatchQueue.main.async {
                        self.tableView.isEditing = false
                    }
                }
            }
            
            //    sets actions (elements) for actionSheet
            for taskState in taskStates {
                var title = taskState.name
                if taskState.isFinal {
                    title = "⚑ " + title
                }
                let action = UIAlertAction(title: title, style: .default, handler: handler)
                actionSheet.addAction(action)
            }
            self.present(actionSheet, animated: true, completion: nil)
        }
        return contextualAction
    }
    
    @objc func appWillReturnFromBackground() {
        guard let viewModel = self.viewModel else { return }
        viewModel.reloadTaskStates()
    }
    
}


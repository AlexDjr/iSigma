//
//  TasksViewModel.swift
//  iSigma
//
//  Created by Alex Delin on 19/12/2018.
//  Copyright © 2018 Alex Delin. All rights reserved.
//

import UIKit

class TasksViewModel {
    var tasks : [Task]?
    var selectedIndexPath: IndexPath?
    
    //   MARK: - UITableViewDataSource
    func numberOfRowsInSection(_ section: Int) -> Int {
        return tasks?.count ?? 0
    }
    
    func cellViewModel(forIndexPath indexPath: IndexPath) -> TaskCellViewModel? {
        guard let tasks = tasks else { return nil }
        return TaskCellViewModel(task: tasks[indexPath.row])
    }
    
    //    MARK: - UITableViewDelegate
    func heightForRowAt(forIndexPath indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    
    func taskStates(forIndexPath indexPath: IndexPath, completion: @escaping (Bool, [[TaskState]]?)->()) {
        selectItem(atIndexPath: indexPath)
        guard let selectedIndexPath = selectedIndexPath, let tasks = tasks else { return }
        let task = tasks[selectedIndexPath.row]
        
        var taskStates: [[TaskState]] = []
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
                
                taskStates.append(forwardStates)
                taskStates.append(backwardStates)

                completion(true, taskStates)
            }
        } else {
            completion(false, nil)
        }
    }
    
    //    MARK: - Methods
    func auth(completion: @escaping () -> ()) {
        NetworkManager.shared.auth(withUser: "adelin@diasoft.ru") {
            print("Успешная аутентификация!")
            completion()
        }
    }
    
    func getTasksForCurrentUser(completion: @escaping ([Task]?) -> ()) {
        let proxy = Proxy(withKey: "tasks")
        proxy.loadData { objects in
            let tasks = objects as! [Task]
            self.tasks = tasks
            completion(tasks)
        }
    }
    
    func viewModelForSelectedItem() -> WorklogViewModel? {
        guard let selectedIndexPath = selectedIndexPath, let tasks = tasks else { return nil }
        let task = tasks[selectedIndexPath.row]
        return WorklogViewModel(task: task)
    }
    
    func selectItem(atIndexPath indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
    }
    
//    func getContextualAction(title: String, taskStates: [TaskState]) -> UIContextualAction {
//        let contextualAction = UIContextualAction(style: .normal, title: title) { (action, view, nil) in
//            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//            let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
//            actionSheet.addAction(cancelAction)
//
//            let handler = {}
////            let handler = { (action: UIAlertAction!) -> () in
////                if let index = actionSheet.actions.firstIndex(where: {$0 === action}) {
////                    print(action.title)
////                    print("index = \(index)")
////                    print(taskStates[index - 1])
////
////                    guard let selectedIndexPath = self.selectedIndexPath, let tasks = self.tasks else { return }
////                    let task = tasks[selectedIndexPath.row]
////                    let currentTaskState = task.state!.serverId
////                    let nextTaskState = taskStates[index - 1].serverId
////
////                    var rowAnimation: UITableView.RowAnimation? = nil
////                    if title == "Переход \n вперед" {
////                        rowAnimation = UITableView.RowAnimation(rawValue: 2)
////                    } else {
////                        rowAnimation = UITableView.RowAnimation(rawValue: 1)
////                    }
////
////                    NetworkManager.shared.putTaskTransition(taskId: task.id, from: currentTaskState, to: nextTaskState) { isSuccess, details in
////                        print("isSuccess = \(isSuccess)")
////                        print("details = \(details)")
////
////                        if isSuccess {
////                            NetworkManager.shared.cache.removeObject(forKey: "tasks")
////                            NetworkManager.shared.cache.removeObject(forKey: "taskStates+\(task.id)" as NSString)
////                            getTasksForCurrentUser{ tasks in
////                                DispatchQueue.main.async {
////                                    self.tableView.reloadRows(at: [selectedIndexPath], with: rowAnimation!)
////                                }
////                            }
////                        } else {
////                            DispatchQueue.main.async {
////                                let alert = UIAlertController(title: "Ошибка!", message: details, preferredStyle: .alert)
////                                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
////
////                                alert.addAction(okAction)
////                                self.present(alert, animated: true, completion: nil)
////                            }
////                        }
////                    }
////                    DispatchQueue.main.async {
////                        self.tableView.isEditing = false
////                    }
////                }
////            }
//
//
//            for taskState in taskStates {
//                var title = taskState.name
//                if taskState.isFinal {
//                    title = "⚑ " + title
//                }
//                let action = UIAlertAction(title: title, style: .default, handler: handler)
//                actionSheet.addAction(action)
//            }
//            self.present(actionSheet, animated: true, completion: nil)
//        }
//        return contextualAction
//    }
}

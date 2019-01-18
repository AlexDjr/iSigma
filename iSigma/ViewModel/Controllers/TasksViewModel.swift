//
//  TasksViewModel.swift
//  iSigma
//
//  Created by Alex Delin on 19/12/2018.
//  Copyright © 2018 Alex Delin. All rights reserved.
//

import UIKit

class TasksViewModel {
    var onErrorCallback : ((String) -> ())?
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
            proxy.loadData { objects, description, error in
                let possibleStates = objects as! [TaskState]
                for possibleState in possibleStates {
                    if possibleState.order < currentState.order {
                        backwardStates.append(possibleState)
                    } else {
                        forwardStates.append(possibleState)
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
        proxy.loadData { objects, description, error in
            if error != nil || description != nil {
                self.onErrorCallback?(description!)
            } else {
                let tasks = objects as! [Task]
                self.tasks = tasks
                
                //    saves possible states for each task in cache
                self.reloadTaskStates()
                
                completion(tasks)
            }
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
    
    func reloadTaskStates() {
        guard let tasks = tasks else { return }
        for task in tasks {
            let proxy = Proxy(withKey: "taskStates+\(task.id)")
            proxy.loadData { _, _, _ in }
        }
    }
    
}

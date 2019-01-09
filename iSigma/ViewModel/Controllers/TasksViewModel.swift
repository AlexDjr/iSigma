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
        
        //    saves possible states for each task in cache
        let task = tasks[indexPath.row]
        let proxy = Proxy(withKey: "taskStates+\(task.id)")
        proxy.loadData { _ in }
        
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
    
}

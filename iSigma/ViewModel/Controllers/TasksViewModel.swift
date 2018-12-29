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
    private var selectedIndexPath: IndexPath?
    
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
            self.self.tasks = tasks
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

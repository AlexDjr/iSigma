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
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let logWrite = UIContextualAction(style: .destructive, title: "Списание") { (action, view, nil) in
            print("Списаться")
        }
        logWrite.backgroundColor = #colorLiteral(red: 0.4971398711, green: 0.7130244374, blue: 0.9623243213, alpha: 1)
        logWrite.image = #imageLiteral(resourceName: "logWrite")
        
        return UISwipeActionsConfiguration(actions: [logWrite])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let transitForward = UIContextualAction(style: .normal, title: "Переход \n вперед") { (action, view, nil) in
            print("Переход вперед")
        }
        transitForward.backgroundColor = #colorLiteral(red: 0.3076787591, green: 0.6730349064, blue: 0.009131425992, alpha: 1)
        transitForward.image = #imageLiteral(resourceName: "transitForward")
        
        let transitBackward = UIContextualAction(style: .normal, title: "Переход \n назад") { (action, view, nil) in
            print("Переход назад")
        }
        transitBackward.backgroundColor = #colorLiteral(red: 0.6734550595, green: 0.8765394092, blue: 0.4567703605, alpha: 1)
        transitBackward.image = #imageLiteral(resourceName: "transitBackward")
        
        let config = UISwipeActionsConfiguration(actions: [transitForward, transitBackward])
        config.performsFirstActionWithFullSwipe = false
        
        return config
    }
    
    //    MARK: - Methods
    func auth(completion: @escaping () -> ()) {
        NetworkManager.shared.auth(withUser: "adelin@diasoft.ru") {
            print("Успешная аутентификация!")
            completion()
        }
    }
    
    func getTasksForCurrentUser(completion: @escaping ([Task]?) -> ()) {
        NetworkManager.shared.getTasksForCurrentUser{ tasks in
            self.tasks = tasks
            completion(tasks)
        }
    }
}

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


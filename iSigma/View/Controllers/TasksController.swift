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
        let config = viewModel?.tableView(tableView, leadingSwipeActionsConfigurationForRowAt: indexPath)
        
        return config
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let config = viewModel?.tableView(tableView, trailingSwipeActionsConfigurationForRowAt: indexPath)
        
        return config
    }
    
}


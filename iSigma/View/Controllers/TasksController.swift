//
//  ViewController.swift
//  iSigma
//
//  Created by Alex Delin on 14/12/2018.
//  Copyright © 2018 Alex Delin. All rights reserved.
//

import UIKit

class TasksController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: TasksViewModel?
    var selectedTaskStateIndex: Int?

    let spinner: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.style = .gray
        view.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        view.hidesWhenStopped = true
        return view
    }()
    var loadingView : UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = TasksViewModel()
        
        viewModel?.onErrorCallback = { description in
            DispatchQueue.main.async {
                let okAction = UIAlertAction(title: "ОК", style: .default)
                self.presentAlert(title: "Ошибка!", message: description, actions: okAction)
            }
        }
        
        viewModel?.getTasksForCurrentUser{ tasks in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        NotificationCenter.default.addObserver(self, selector: #selector(appWillReturnFromBackground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //    MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRowsInSection(section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as? TaskCell

        guard let taskCell = cell, let viewModel = viewModel else { return UITableViewCell() }
        let cellViewModel = viewModel.cellViewModel(forIndexPath: indexPath)
        taskCell.viewModel = cellViewModel
        
        return taskCell
    }
    
    //    MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel?.heightForRowAt(forIndexPath: indexPath) ?? 44
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let viewModel = self.viewModel else { return nil }
        
        var config: UISwipeActionsConfiguration? = nil
        //    not showing any alert from onErrorCallback here
        //    so in case of error row couldn't be swiped right at all
        viewModel.taskStates(forIndexPath: indexPath) { isSuccess, taskStates in
            if isSuccess {
                let transitForward = self.getContextualAction(title: "Переход \n вперед", taskStates: taskStates![0])
                transitForward.backgroundColor = AppStyle.transitForwardColor
                transitForward.image = AppStyle.transitForwardImage
                
                let transitBackward = self.getContextualAction(title: "Переход \n назад", taskStates: taskStates![1])
                transitBackward.backgroundColor = AppStyle.transitBackwardColor
                transitBackward.image = AppStyle.transitBackwardImage
                
                config = UISwipeActionsConfiguration(actions: [transitBackward, transitForward])
                config!.performsFirstActionWithFullSwipe = false
            } else {
                let okAction = UIAlertAction(title: "ОК", style: .default)
                self.presentAlert(title: "Ошибка!", message: "Для данной задачи не определено текущее состояние!", actions: okAction)
            }
        }
        
        return config
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let logWrite = UIContextualAction(style: .destructive, title: "Списание") { (action, view, completion) in
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let worklogController = storyboard.instantiateViewController(withIdentifier: "worklogController") as! WorklogController
            
            guard let viewModel = self.viewModel else { return }
            viewModel.selectItem(atIndexPath: indexPath)
            worklogController.viewModel = viewModel.viewModelForSelectedItem()
            worklogController.navigationItem.title = "Списание"
            self.navigationController?.pushViewController(worklogController, animated: true)
            completion(false)
        }
        logWrite.backgroundColor = AppStyle.worklogColor
        logWrite.image = AppStyle.worklogImage
        
        return UISwipeActionsConfiguration(actions: [logWrite])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let taskInfoController = storyboard.instantiateViewController(withIdentifier: "taskInfoController") as! TaskInfoController
        
        guard let tasks = viewModel?.tasks else { return }
        taskInfoController.navigationItem.title = "Задача"
        taskInfoController.viewModel = TaskInfoViewModel(task: tasks[indexPath.row])
        navigationController?.pushViewController(taskInfoController, animated: true)
    }
    
    //    MARK: - Methods
    func getContextualAction(title: String, taskStates: [TaskState]) -> UIContextualAction {
        let contextualAction = UIContextualAction(style: .normal, title: title) { (action, view, completion) in
            //    sets action sheet with task states
            var actionSheetStatesMessage = ""
            if taskStates.isEmpty {
                actionSheetStatesMessage = "Нет доступных состояний"
            } else {
                actionSheetStatesMessage = "Выберите новое состояние задачи"
            }
            let actionSheetStates = UIAlertController(title: nil, message: actionSheetStatesMessage, preferredStyle: .actionSheet)
            let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
            actionSheetStates.addAction(cancelAction)
            
            //    sets action sheet with task assignee options
            let actionSheetAssignee = UIAlertController(title: nil, message: "Изменить ответственного по задаче?", preferredStyle: .actionSheet)
            actionSheetAssignee.addAction(cancelAction)
            
            //    sets action sheet with task assignee names
            let actionSheetChooseAssignee = UIAlertController(title: nil, message: "Выберите ответственного", preferredStyle: .actionSheet)
            actionSheetChooseAssignee.addAction(cancelAction)
            self.setupCollectionViewController(for: actionSheetChooseAssignee)
            
            
            //    sets handler logic for element of actionSheetStates
            let handlerStates = { (action: UIAlertAction!) -> () in
                if let index = actionSheetStates.actions.firstIndex(where: {$0 === action}) {
                    self.selectedTaskStateIndex = index
                    self.present(actionSheetAssignee, animated: true, completion: nil)
                }
            }
            
            //    sets handler logic for element of actionSheetAssignee
            let handlerAssignee = { (action: UIAlertAction!) -> () in
                if let indexStates = self.selectedTaskStateIndex {
                    if let indexAssignee = actionSheetAssignee.actions.firstIndex(where: {$0 === action}) {
                        if indexAssignee == 1 {
                            self.changeTaskState(title: title, taskStates: taskStates, indexState: indexStates)
                        }
                        if indexAssignee == 2 {
                            self.present(actionSheetChooseAssignee, animated: true, completion: nil)
                        }
                    }
                    completion(false)
                }
            }
            
            //    sets actions (elements) for actionSheetStates
            for taskState in taskStates {
                var title = taskState.name
                if taskState.isFinal {
                    title = "⚑ " + title
                }
                let actionState = UIAlertAction(title: title, style: .default, handler: handlerStates)
                actionSheetStates.addAction(actionState)
            }
            
            //    sets actions (elements) for actionSheetAssignee
            let sameAssigneeAction = UIAlertAction(title: "Не изменять", style: .default, handler: handlerAssignee)
            let otherAssigneeAction = UIAlertAction(title: "Изменить", style: .default, handler: handlerAssignee)
            actionSheetAssignee.addAction(sameAssigneeAction)
            actionSheetAssignee.addAction(otherAssigneeAction)
            
            self.present(actionSheetStates, animated: true, completion: nil)
        }
        return contextualAction
    }
    
    @objc func appWillReturnFromBackground() {
        guard let viewModel = viewModel else { return }
        viewModel.reloadTaskStates()
    }
    
    private func setLoadingScreen() {
        spinner.startAnimating()
        loadingView = Utils.getLoadingView(view: view, spinner: spinner)
        tableView.isScrollEnabled = false
        tableView.alpha = 0.3
    }
    
    private func removeLoadingScreen() {
        spinner.stopAnimating()
        loadingView.isHidden = true
        tableView.isScrollEnabled = true
        tableView.alpha = 1.0
    }
    
    private func highlightCell(at indexPath: IndexPath, for index: Int) {
        let cell = tableView.cellForRow(at: indexPath)
        UIView.animate(withDuration: 1.5) {
            if index == 1 {
                cell?.layer.backgroundColor = AppStyle.transitBackwardColor.withAlphaComponent(0.6).cgColor
            }
            if index == 2 {
                cell?.layer.backgroundColor = AppStyle.transitForwardColor.withAlphaComponent(0.6).cgColor
            }
            cell?.layer.backgroundColor = AppStyle.whiteTextColor.cgColor
        }
    }
    
    private func changeTaskState(title: String, taskStates: [TaskState], indexState: Int) {
        guard let viewModel = self.viewModel else { return }
        let task = viewModel.viewModelForSelectedItem()!.task!
        
        let currentTaskState = task.state!.serverId
        let nextTaskState = taskStates[indexState - 1].serverId
        
        var rowAnimation: UITableView.RowAnimation? = nil
        if title == "Переход \n вперед" {
            rowAnimation = UITableView.RowAnimation(rawValue: 2)
        } else {
            rowAnimation = UITableView.RowAnimation(rawValue: 1)
        }
        let actionIndex = rowAnimation?.rawValue ?? 0
        
        self.setLoadingScreen()
        
        //    asks server to perform task transition (with checking for errors)
        viewModel.onErrorCallback = { description in
            DispatchQueue.main.async {
                let okAction = UIAlertAction(title: "ОК", style: .default)
                self.presentAlert(title: "Ошибка!", message: description, actions: okAction)
                self.removeLoadingScreen()
            }
        }
        
        viewModel.putTaskTransition(taskId: task.id, from: currentTaskState, to: nextTaskState) { isSuccess, details in
            if isSuccess {
                viewModel.getTasksForCurrentUser{ tasks in
                    DispatchQueue.main.async {
                        self.tableView.reloadRows(at: [viewModel.selectedIndexPath!], with: rowAnimation!)
                        self.removeLoadingScreen()
                        self.highlightCell(at: viewModel.selectedIndexPath!, for: actionIndex)
                    }
                }
            } else {
                DispatchQueue.main.async {
                    let okAction = UIAlertAction(title: "ОК", style: .default)
                    self.presentAlert(title: "Ошибка!", message: details, actions: okAction)
                    self.removeLoadingScreen()
                }
            }
        }
    }
    
    private func setupCollectionViewController(for alertController: UIAlertController) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let assigneesController = storyboard.instantiateViewController(withIdentifier: "assigneesController") as! AssigneesController
        alertController.addChild(assigneesController)
        
        assigneesController.view.backgroundColor = .clear
        assigneesController.collectionView.backgroundColor = .clear
        alertController.view.addSubview(assigneesController.view)
        
        assigneesController.view.translatesAutoresizingMaskIntoConstraints = false
        assigneesController.view.leftAnchor.constraint(equalTo: alertController.view.leftAnchor, constant: 10).isActive = true
        assigneesController.view.rightAnchor.constraint(equalTo: alertController.view.rightAnchor, constant: -10).isActive = true
        assigneesController.view.topAnchor.constraint(equalTo: alertController.view.topAnchor, constant: 45).isActive = true
        assigneesController.view.bottomAnchor.constraint(equalTo: alertController.view.bottomAnchor, constant: -57 - 8 - 10).isActive = true
        
        alertController.view.translatesAutoresizingMaskIntoConstraints = false
        alertController.view.heightAnchor.constraint(equalToConstant: 450).isActive = true
        
        assigneesController.didMove(toParent: alertController)
    }
}


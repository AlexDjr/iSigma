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
    var selectedTaskState: TaskState?
    
    enum SwipeAction: String {
        case forward = "Переход \n вперед"
        case backward = "Переход \n назад"
        case changeAssignee = "Смена \n ответств. "
        case worklog = "Списание \n"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = TasksViewModel()
        
        viewModel?.onErrorCallback = { [weak self] description in
            DispatchQueue.main.async {
                let okAction = UIAlertAction(title: "ОК", style: .default)
                self?.presentAlert(title: "Ошибка!", message: description, actions: okAction)
            }
        }
        
        viewModel?.getTasksForCurrentUser{ tasks in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        NotificationCenter.default.addObserver(self, selector: #selector(appWillReturnFromBackground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
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
                let transitForward = self.getContextualAction(swipeAction: .forward, taskStates: taskStates![0])
                transitForward.backgroundColor = AppStyle.transitForwardColor
                transitForward.image = AppStyle.transitForwardImage
                
                let transitBackward = self.getContextualAction(swipeAction: .backward, taskStates: taskStates![1])
                transitBackward.backgroundColor = AppStyle.transitBackwardColor
                transitBackward.image = AppStyle.transitBackwardImage
                
                let changeAssignee = self.getContextualAction(swipeAction: .changeAssignee, taskStates: nil)
                changeAssignee.backgroundColor = AppStyle.lightTextColor
                changeAssignee.image = AppStyle.changeAssigneeImage
                
                config = UISwipeActionsConfiguration(actions: [transitBackward, changeAssignee, transitForward])
                config!.performsFirstActionWithFullSwipe = false
            } else {
                let okAction = UIAlertAction(title: "ОК", style: .default)
                self.presentAlert(title: "Ошибка!", message: "Для данной задачи не определено текущее состояние!", actions: okAction)
            }
        }
        
        return config
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let worklog = UIContextualAction(style: .destructive, title: SwipeAction.worklog.rawValue) { (action, view, completion) in
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let worklogController = storyboard.instantiateViewController(withIdentifier: "worklogController") as! WorklogController
            
            guard let viewModel = self.viewModel else { return }
            viewModel.selectItem(atIndexPath: indexPath)
            worklogController.viewModel = viewModel.viewModelForSelectedItem()
            worklogController.navigationItem.title = "Списание"
            self.navigationController?.pushViewController(worklogController, animated: true)
            completion(false)
        }
        worklog.backgroundColor = AppStyle.worklogColor
        worklog.image = AppStyle.worklogImage
        
        return UISwipeActionsConfiguration(actions: [worklog])
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
    func getContextualAction(swipeAction: SwipeAction, taskStates: [TaskState]?) -> UIContextualAction {
        let contextualAction = UIContextualAction(style: .normal, title: swipeAction.rawValue) { (action, view, completion) in
            
            let taskStatesAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let changeAssigneeAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let confirmFinalAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let selectAssigneeAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
            
            //    "Task states" step
            if let taskStates = taskStates {
                let handlerStates = { (action: UIAlertAction!) -> () in
                    if let index = taskStatesAlert.actions.firstIndex(where: {$0 === action}) {
                        let selectedTaskState = taskStates[index]
                        self.selectedTaskState = selectedTaskState
                        if selectedTaskState.isFinal {
                            self.present(confirmFinalAlert, animated: true, completion: nil)
                        } else {
                            self.present(changeAssigneeAlert, animated: true, completion: nil)
                        }
                    }
                }
                
                var taskStatesMessage = ""
                if taskStates.isEmpty {
                    taskStatesMessage = "Нет доступных состояний"
                } else {
                    taskStatesMessage = "Выберите новое состояние задачи"
                }
                taskStatesAlert.message = taskStatesMessage
                
                for taskState in taskStates {
                    let title = taskState.isFinal ? "⚑ " + taskState.name : taskState.name
                    let stateAction = UIAlertAction(title: title, style: .default, handler: handlerStates)
                    taskStatesAlert.addAction(stateAction)
                }
                taskStatesAlert.addAction(cancelAction)
            }
            
            //    "Change assignee" step
            let handlerAssignee = { (action: UIAlertAction!) -> () in
                if let selectedTaskState = self.selectedTaskState {
                    if let indexAssignee = changeAssigneeAlert.actions.firstIndex(where: {$0 === action}) {
                        if indexAssignee == 0 {
                            if let currentUserEmail = UserDefaults.standard.string(forKey: "currentUserEmail") {
                                self.changeTaskState(assignedEmail: currentUserEmail, swipeAction: swipeAction, taskState: selectedTaskState)
                            } else {
                                let okAction = UIAlertAction(title: "ОК", style: .default)
                                self.presentAlert(title: "Ошибка!", message: "Неудалось определить текущего пользователя", actions: okAction)
                            }
                        }
                        if indexAssignee == 1 {
                            self.present(selectAssigneeAlert, animated: true, completion: nil)
                        }
                        if indexAssignee == 2 {
                            self.changeTaskState(assignedEmail: nil, swipeAction: swipeAction, taskState: selectedTaskState)
                        }
                    }
                    completion(false)
                }
            }
            
            changeAssigneeAlert.message = "Изменить ответственного по задаче?"
            let sameAssigneeAction = UIAlertAction(title: "Не изменять", style: .default, handler: handlerAssignee)
            let otherAssigneeAction = UIAlertAction(title: "Изменить", style: .default, handler: handlerAssignee)
            let autoAssigneeAction = UIAlertAction(title: "Автоматически", style: .default, handler: handlerAssignee)
            changeAssigneeAlert.addAction(sameAssigneeAction)
            changeAssigneeAlert.addAction(otherAssigneeAction)
            changeAssigneeAlert.addAction(autoAssigneeAction)
            changeAssigneeAlert.addAction(cancelAction)
            
            //    "Confirm final" step
            let handlerConfirmFinal = { (action: UIAlertAction!) -> () in
                if let selectedTaskState = self.selectedTaskState {
                    if let indexAssignee = confirmFinalAlert.actions.firstIndex(where: {$0 === action}) {
                        if indexAssignee == 0 {
                            self.changeTaskState(assignedEmail: nil, swipeAction: swipeAction, taskState: selectedTaskState)
                        }
                        if indexAssignee == 1 {
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                    completion(false)
                }
            }
            
            confirmFinalAlert.title = "Перевести в конечное состояние?"
            confirmFinalAlert.message = "Задача станет недоступной для изменений"
            let yesConfirmFinalAction = UIAlertAction(title: "Да", style: .default, handler: handlerConfirmFinal)
            let noConfirmFinalAction = UIAlertAction(title: "Нет", style: .default, handler: handlerConfirmFinal)
            confirmFinalAlert.addAction(yesConfirmFinalAction)
            confirmFinalAlert.addAction(noConfirmFinalAction)
            confirmFinalAlert.addAction(cancelAction)
            
            //    "Select assignee" step
            selectAssigneeAlert.message = "Выберите ответственного"
            selectAssigneeAlert.addAction(cancelAction)
            let assigneesController = self.setupCollectionViewController(for: selectAssigneeAlert)
            assigneesController.callback = { result in
                let employee = result as Employee
                if let currentUserEmail = UserDefaults.standard.string(forKey: "currentUserEmail") {
                    if employee.email == currentUserEmail {
                        self.dismiss(animated: true, completion: nil)
                        let okAction = UIAlertAction(title: "ОК", style: .default)
                        self.presentAlert(title: "Ошибка!", message: "Выбран текущий пользователь", actions: okAction)
                    } else if employee.email != "" {
                        if swipeAction == .changeAssignee {
                            self.updateTask(assigneeEmail: employee.email)
                            self.dismiss(animated: true, completion: nil)
                        } else {
                            if let selectedTaskState = self.selectedTaskState {
                                self.changeTaskState(assignedEmail: employee.email, swipeAction: swipeAction, taskState: selectedTaskState)
                                self.dismiss(animated: true, completion: nil)
                            }
                        }
                    } else {
                        self.dismiss(animated: true, completion: nil)
                        let okAction = UIAlertAction(title: "ОК", style: .default)
                        self.presentAlert(title: "Ошибка!", message: "Невозможно перевести задачу на данного сотрудника, так как его email не определен", actions: okAction)
                    }
                }
            }
            
            //    defining first step to show
            if swipeAction == .changeAssignee {
                self.present(selectAssigneeAlert, animated: true, completion: nil)
                completion(false)
            } else {
                self.present(taskStatesAlert, animated: true, completion: nil)
            }
        }
        return contextualAction
    }
    
    @objc func appWillReturnFromBackground() {
        guard let viewModel = viewModel else { return }
        viewModel.reloadTaskStates()
    }
    
    private func setLoadingScreen() {
        view.addActivityIndicator(withBlur: true)
        tableView.isScrollEnabled = false
    }
    
    private func removeLoadingScreen() {
        view.removeActivityIndicator()
        tableView.isScrollEnabled = true
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
    
    private func changeTaskState(assignedEmail: String?, swipeAction: SwipeAction, taskState: TaskState) {
        guard let viewModel = self.viewModel else { return }
        let task = viewModel.viewModelForSelectedItem()!.task!
        
        let currentTaskStateId = task.state!.serverId
        let nextTaskStateId = taskState.serverId
        
        var rowAnimation: UITableView.RowAnimation? = nil
        if swipeAction == .forward {
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
        
        viewModel.putTaskTransition(taskId: task.id, from: currentTaskStateId, to: nextTaskStateId, assignedEmail: assignedEmail) { isSuccess, details in
            if isSuccess {
                let currentTasksCount = viewModel.tasks?.count ?? 0
                viewModel.getTasksForCurrentUser{ tasks in
                    DispatchQueue.main.async {
                        if currentTasksCount > tasks?.count ?? 0 {
                            self.tableView.deleteRows(at: [viewModel.selectedIndexPath!], with: .left)
                        } else {
                            self.tableView.reloadRows(at: [viewModel.selectedIndexPath!], with: rowAnimation!)
                            self.highlightCell(at: viewModel.selectedIndexPath!, for: actionIndex)
                        }
                        self.removeLoadingScreen()
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
    
    private func updateTask(assigneeEmail: String) {
        guard let viewModel = self.viewModel else { return }
        let task = viewModel.viewModelForSelectedItem()!.task!
        
        self.setLoadingScreen()
        
        //    asks server to perform task transition (with checking for errors)
        viewModel.onErrorCallback = { description in
            DispatchQueue.main.async {
                let okAction = UIAlertAction(title: "ОК", style: .default)
                self.presentAlert(title: "Ошибка!", message: description, actions: okAction)
                self.removeLoadingScreen()
            }
        }
        
        viewModel.putTaskUpdate(taskId: task.id, assigneeEmail: assigneeEmail) { isSuccess, details in
            if isSuccess {
                DispatchQueue.main.async {
                    //    manually deleting task from data source, because API method doesn't return updated list of tasks immediately
                    viewModel.deleteTask(withId: task.id)
                    self.tableView.deleteRows(at: [viewModel.selectedIndexPath!], with: .left)
                    self.removeLoadingScreen()
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
    
    private func setupCollectionViewController(for alertController: UIAlertController) -> AssigneesController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let assigneesController = storyboard.instantiateViewController(withIdentifier: "assigneesController") as! AssigneesController
        alertController.addChild(assigneesController)
        
        assigneesController.view.backgroundColor = .clear
        assigneesController.collectionView.backgroundColor = .clear
        alertController.view.addSubview(assigneesController.view)
        
        assigneesController.view.translatesAutoresizingMaskIntoConstraints = false
        assigneesController.view.leftAnchor.constraint(equalTo: alertController.view.leftAnchor).isActive = true
        assigneesController.view.rightAnchor.constraint(equalTo: alertController.view.rightAnchor).isActive = true
        assigneesController.view.topAnchor.constraint(equalTo: alertController.view.topAnchor, constant: 45).isActive = true
        assigneesController.view.bottomAnchor.constraint(equalTo: alertController.view.bottomAnchor, constant: -57 - 8).isActive = true
        
        alertController.view.translatesAutoresizingMaskIntoConstraints = false
        alertController.view.heightAnchor.constraint(equalToConstant: 470).isActive = true
        
        assigneesController.didMove(toParent: alertController)
        
        return assigneesController
    }
}


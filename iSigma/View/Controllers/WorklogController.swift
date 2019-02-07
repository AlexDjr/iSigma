//
//  LogWriteController.swift
//  iSigma
//
//  Created by Alex Delin on 21/12/2018.
//  Copyright © 2018 Alex Delin. All rights reserved.
//

import UIKit

class WorklogController: UIViewController, UITableViewDataSource, UITableViewDelegate, PickerDelegateProtocol, SubmitDelegateProtocol {

    @IBOutlet weak var tableView: UITableView!

    var viewModel: WorklogViewModel?
    var сurrentPickerValue: String?
    var currentWorklogType: WorklogType?
    var currentWorklogDate: String?
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let viewModel = viewModel else { return }
        self.сurrentPickerValue = viewModel.timePickerValue
        self.currentWorklogType = viewModel.worklogType
        self.currentWorklogDate = viewModel.worklogDate
        setSubmitView()
    }

    //    MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.numberOfSections() ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRowsInSection(section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel else { return UITableViewCell() }
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "worklogTaskCell", for: indexPath) as! WorklogTaskCell
            let cellViewModel = viewModel.cellViewModel(forIndexPath: indexPath) as! TaskCellViewModel
            cell.viewModel = cellViewModel
            return cell
        } else {
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "worklogDetailsCell", for: indexPath) as! WorklogDetailsCell
                let cellViewModel = viewModel.cellViewModel(forIndexPath: indexPath) as! WorklogDetailsTimeCellViewModel
                cellViewModel.value = Box(сurrentPickerValue)
                cell.viewModel = cellViewModel
                cell.selectionStyle = .none
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "worklogTimePickerCell", for: indexPath) as! WorklogTimePickerCell
                let cellViewModel = viewModel.cellViewModel(forIndexPath: indexPath) as! WorklogTimePickerCellViewModel
                cell.viewModel = cellViewModel
                cell.delegate = self
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "worklogDetailsCell", for: indexPath) as! WorklogDetailsCell
                let cellViewModel = viewModel.cellViewModel(forIndexPath: indexPath) as! WorklogDetailsTypeCellViewModel
                cellViewModel.value = Box(currentWorklogType?.name)
                cell.viewModel = cellViewModel
                return cell
            case 3:
                let cell = tableView.dequeueReusableCell(withIdentifier: "worklogDetailsCell", for: indexPath) as! WorklogDetailsCell
                let cellViewModel = viewModel.cellViewModel(forIndexPath: indexPath) as! WorklogDetailsDateCellViewModel
                if let currentWorklogDate = currentWorklogDate {
                    cellViewModel.value = Box(viewModel.getAjustedDate(from: currentWorklogDate))
                }
                cell.viewModel = cellViewModel
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
                return cell
            }
        }
    }
    
    //    MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel?.heightForRowAt(forIndexPath: indexPath) ?? 44
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return viewModel?.heightForHeaderInSection(section) ?? 0.0
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return viewModel?.heightForFooterInSection(section) ?? 0.0
    }
    
    func indexPathForPreferredFocusedView(in tableView: UITableView) -> IndexPath? {
        return IndexPath(row: 1, section: 1)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        if indexPath.section == 0 {
            let taskInfoController = storyboard.instantiateViewController(withIdentifier: "taskInfoController") as! TaskInfoController
            guard let task = self.viewModel?.task else { return }
            taskInfoController.navigationItem.title = "Задача"
            taskInfoController.viewModel = TaskInfoViewModel(task: task)
            self.navigationController?.pushViewController(taskInfoController, animated: true)
        } else {
            switch indexPath.row {
            case 2:
                let worklogTypesController = storyboard.instantiateViewController(withIdentifier: "worklogTypesController") as! WorklogTypesController
                worklogTypesController.hidesBottomBarWhenPushed = true
                let viewModel = WorklogTypesViewModel()
                worklogTypesController.viewModel = viewModel
                worklogTypesController.navigationItem.title = "Типы работ"
                self.navigationController?.pushViewController(worklogTypesController, animated: true)
                worklogTypesController.callback = { result in
                    self.currentWorklogType = result
                    let indexPath = IndexPath(row: 2, section: 1)
                    tableView.reloadRows(at: [indexPath], with: .none)
                }
            case 3:
                guard let currentWorklogDate = currentWorklogDate else { return }
                let calendarController = CalendarController()
                calendarController.hidesBottomBarWhenPushed = true
                let viewModel = CalendarViewModel(selectedDate: currentWorklogDate)
                calendarController.viewModel = viewModel
                calendarController.navigationItem.title = "Дата"
                self.navigationController?.pushViewController(calendarController, animated: true)
                calendarController.callback = { result in
                    self.currentWorklogDate = result
                    let indexPath = IndexPath(row: 3, section: 1)
                    tableView.reloadRows(at: [indexPath], with: .none)
                }
            default: break
            }
        }
    }
    
    //    MARK: - PickerDelegateProtocol
    func pickerDidSelectRow(value: String) {
        сurrentPickerValue = value
        let indexPath = IndexPath(row: 0, section: 1)
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    //    MARK: - SubmitDelegateProtocol
    func submitButtonAction() {
        if currentWorklogType == nil {
            setWarningCell(at: IndexPath(item: 2, section: 1))
        } else {
            setLoadingScreen()
            guard let viewModel = viewModel,let taskId = viewModel.task?.id, let time = сurrentPickerValue, let typeId = currentWorklogType?.id, let date = currentWorklogDate else { return }
            
            viewModel.onErrorCallback = { description in
                DispatchQueue.main.async {
                    let okAction = UIAlertAction(title: "ОК", style: .default)
                    self.presentAlert(title: "Ошибка!", message: description, actions: okAction)
                    self.removeLoadingScreen()
                }
            }
            viewModel.postWorklog(task: String(taskId), time: time, type: typeId, date: date) { details in
                DispatchQueue.main.async {
                    let okAction = UIAlertAction(title: "OK", style: .default) { alert in
                        self.navigationController?.popViewController(animated: true)
                    }
                    self.presentAlert(title: "Успешно!", message: details, actions: okAction)
                    self.removeLoadingScreen()
                }
            }
        }
    }
    
    //    MARK: - Methods
    private func setSubmitView() {
        let submitView = SubmitView()
        let submitViewModel = SubmitViewViewModel()
        submitView.viewModel = submitViewModel
        
        let tabBarHeight = tabBarController?.tabBar.frame.height ?? 0
        
        self.view.addSubview(submitView)
        submitView.translatesAutoresizingMaskIntoConstraints = false
        submitView.heightAnchor.constraint(equalToConstant: submitViewModel.viewHeightConstraintConst).isActive = true
        submitView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -tabBarHeight).isActive = true
        submitView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        submitView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
        submitView.delegate = self
    }
    
    private func setWarningCell(at indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        UIView.animate(withDuration: 1.5) {
            cell?.layer.backgroundColor = WorklogDetailsCellViewModel.warningColor
            cell?.layer.backgroundColor = WorklogDetailsCellViewModel.defaultColor
        }
    }
    
    private func setLoadingScreen() {
        self.view.addSubview(UIView().addActivityIndicator(view: self.view))
        tableView.isScrollEnabled = false
    }
    
    private func removeLoadingScreen() {
        Utils.removeLoadingView(from: self.view)
        tableView.isScrollEnabled = true
    }

}

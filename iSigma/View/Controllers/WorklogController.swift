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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
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
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        if indexPath.section == 0 {
            
        } else {
            switch indexPath.row {
            case 2:
                let worklogController = storyboard.instantiateViewController(withIdentifier: "worklogTypesController") as! WorklogTypesController
                let viewModel = WorklogTypesViewModel()
                worklogController.viewModel = viewModel
                worklogController.navigationItem.title = "Типы работ"
                self.navigationController?.pushViewController(worklogController, animated: true)
                worklogController.callback = { result in
                    self.currentWorklogType = result
                    let indexPath = IndexPath(row: 2, section: 1)
                    tableView.reloadRows(at: [indexPath], with: .none)
                }
            case 3:
                let caledarController = CalendarController()
                caledarController.navigationItem.title = "Дата"
                caledarController.currentWorklogDate = currentWorklogDate
                self.navigationController?.pushViewController(caledarController, animated: true)
                caledarController.callback = { result in
                    self.currentWorklogDate = result
                    let indexPath = IndexPath(row: 3, section: 1)
                    tableView.reloadRows(at: [indexPath], with: .none)
                }
            default: break
            }
        }
    }
    
    //    MARK: Methods
    private func setSubmitView() {
        guard let viewModel = viewModel else { return }
        
        let navBarHeight = navigationController?.navigationBar.frame.height ?? 0
        let tabBarHeight = tabBarController?.tabBar.frame.height ?? 0
        
        let width : CGFloat = view.frame.width
        let height : CGFloat = viewModel.heightForSubmitView()
        let x : CGFloat = viewModel.xForSubmitView()
        let y : CGFloat = view.frame.height - navBarHeight - UIApplication.shared.statusBarFrame.height - tabBarHeight - height
        
        let submitView = SubmitView()
        let submitViewModel = SubmitViewViewModel(origin: CGPoint(x: x, y: y), size: CGSize(width: width, height: height))
        submitView.viewModel = submitViewModel
        
        submitView.delegate = self
        
        view.addSubview(submitView)
        view.bringSubviewToFront(submitView)
    }
    
    //    MARK: PickerDelegateProtocol
    func pickerDidSelectRow(value: String) {
        сurrentPickerValue = value
        let indexPath = IndexPath(row: 0, section: 1)
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    //    MARK: SubmitDelegateProtocol
    func submitButtonAction() {
        if currentWorklogType == nil {
            setWarningCell(at: IndexPath(item: 2, section: 1))
        } else {
            
        }
    }
    
    //    MARK: Methods
    private func setWarningCell(at indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        UIView.animate(withDuration: 1.5) {
            cell?.layer.backgroundColor = WorklogDetailsCellViewModel.warningColor
            cell?.layer.backgroundColor = WorklogDetailsCellViewModel.defaultColor
        }
    }
    


}

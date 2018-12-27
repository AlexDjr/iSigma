//
//  LogWriteController.swift
//  iSigma
//
//  Created by Alex Delin on 21/12/2018.
//  Copyright © 2018 Alex Delin. All rights reserved.
//

import UIKit

class WorkLogController: UIViewController, UITableViewDataSource, UITableViewDelegate, PickerDelegateProtocol {

    @IBOutlet weak var tableView: UITableView!

    var viewModel: WorkLogViewModel?
    var сurrentPickerValue: String?
    var currentWorkLogType: WorkLogType?
    
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
        self.currentWorkLogType = viewModel.workLogType
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "workLogTaskCell", for: indexPath) as! WorkLogTaskCell
            let cellViewModel = viewModel.cellViewModel(forIndexPath: indexPath) as! TaskCellViewModel
            cell.viewModel = cellViewModel
            return cell
        } else {
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "workLogDetailsCell", for: indexPath) as! WorkLogDetailsCell
                let cellViewModel = viewModel.cellViewModel(forIndexPath: indexPath) as! WorkLogDetailsTimeCellViewModel
                cellViewModel.value = Box(сurrentPickerValue)
                cell.viewModel = cellViewModel
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "workLogTimePickerCell", for: indexPath) as! WorkLogTimePickerCell
                let cellViewModel = viewModel.cellViewModel(forIndexPath: indexPath) as! WorkLogTimePickerCellViewModel
                cell.viewModel = cellViewModel
                cell.delegate = self
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "workLogDetailsCell", for: indexPath) as! WorkLogDetailsCell
                let cellViewModel = viewModel.cellViewModel(forIndexPath: indexPath) as! WorkLogDetailsTypeCellViewModel
                cellViewModel.value = Box(currentWorkLogType?.name)
                cell.viewModel = cellViewModel
                return cell
            case 3:
                let cell = tableView.dequeueReusableCell(withIdentifier: "workLogDetailsCell", for: indexPath) as! WorkLogDetailsCell
                let cellViewModel = viewModel.cellViewModel(forIndexPath: indexPath) as! WorkLogDetailsDateCellViewModel
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
                let workLogController = storyboard.instantiateViewController(withIdentifier: "workLogTypesController") as! WorkLogTypesController
                let viewModel = WorkLogTypesViewModel()
                workLogController.viewModel = viewModel
                workLogController.navigationItem.title = "Типы работ"
                self.navigationController?.pushViewController(workLogController, animated: true)
                workLogController.callback = { result in
                    self.currentWorkLogType = result
                    let indexPath = IndexPath(row: 2, section: 1)
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
        
        view.addSubview(submitView)
        view.bringSubviewToFront(submitView)
    }
    
    func pickerDidSelectRow(value: String) {
        сurrentPickerValue = value
        let indexPath = IndexPath(row: 0, section: 1)
        tableView.reloadRows(at: [indexPath], with: .none)
    }

}

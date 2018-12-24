//
//  LogWriteController.swift
//  iSigma
//
//  Created by Alex Delin on 21/12/2018.
//  Copyright © 2018 Alex Delin. All rights reserved.
//

import UIKit

class WorkLogController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var viewModel: WorkLogViewModel?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
                cell.viewModel = cellViewModel
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "workLogTimePickerCell", for: indexPath) as! WorkLogTimePickerCell
                let cellViewModel = viewModel.cellViewModel(forIndexPath: indexPath) as! WorkLogTimePickerCellViewModel
                cell.viewModel = cellViewModel
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "workLogDetailsCell", for: indexPath) as! WorkLogDetailsCell
                let cellViewModel = viewModel.cellViewModel(forIndexPath: indexPath) as! WorkLogDetailsTypeCellViewModel
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
        return IndexPath(row: 0, section: 1)
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

}

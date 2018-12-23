//
//  LogWriteController.swift
//  iSigma
//
//  Created by Alex Delin on 21/12/2018.
//  Copyright © 2018 Alex Delin. All rights reserved.
//

import UIKit

class WorkLogController: UITableViewController {

    var viewModel: WorkLogViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //    MARK: - UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.numberOfSections() ?? 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRowsInSection(section) ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
            case 4:
                let cell = tableView.dequeueReusableCell(withIdentifier: "workLogSubmitCell", for: indexPath) as! WorkLogSubmitCell
                let cellViewModel = viewModel.cellViewModel(forIndexPath: indexPath) as! WorkLogSubmitCellViewModel
                cell.viewModel = cellViewModel
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
                return cell
            }
        }
    }
    
    //    MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel?.heightForRowAt(forIndexPath: indexPath) ?? 44
    }
    
    override func  tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    override func  tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }

}

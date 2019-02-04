//
//  SettingsController.swift
//  iSigma
//
//  Created by Alex Delin on 04/02/2019.
//  Copyright © 2019 Alex Delin. All rights reserved.
//

import UIKit

class SettingsController: UITableViewController {

    var viewModel: SettingsViewModel?
    var currentWorklogType: WorklogType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = SettingsViewModel()
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as! SettingsCell
        let cellViewModel = viewModel.cellViewModel(forIndexPath: indexPath) as! SettingsCellViewModel
        cellViewModel.value = Box(currentWorklogType?.name)
        cell.viewModel = cellViewModel
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let viewModel = viewModel else { return nil }
        return viewModel.titleForHeaderInSection(section)
    }
    
    //    MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        let worklogTypesController = storyboard.instantiateViewController(withIdentifier: "worklogTypesController") as! WorklogTypesController
        worklogTypesController.hidesBottomBarWhenPushed = true
        let viewModel = WorklogTypesViewModel()
        worklogTypesController.viewModel = viewModel
        worklogTypesController.navigationItem.title = "Типы работ"
        self.navigationController?.pushViewController(worklogTypesController, animated: true)
        worklogTypesController.callback = { result in
            self.currentWorklogType = result
            let indexPath = IndexPath(row: 0, section: 0)
            tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
}

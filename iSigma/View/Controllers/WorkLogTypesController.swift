//
//  WorkLogTypesController.swift
//  iSigma
//
//  Created by Alex Delin on 26/12/2018.
//  Copyright © 2018 Alex Delin. All rights reserved.
//

import UIKit

class WorkLogTypesController: UITableViewController {

    var viewModel: WorkLogTypesViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let viewModel = viewModel else { return }
        viewModel.getWorkLogTypes {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.numberOfSections() ?? 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRowsInSection(section) ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel, let types = viewModel.types, let typesOftenUsed = viewModel.typesOftenUsed else { return UITableViewCell() }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! WorkLogTypesCell
        let cellViewModel = WorkLogTypesCellViewModel()
        
        if indexPath.section == 0 {
            cellViewModel.value = Box(typesOftenUsed[indexPath.row].name)
        } else {
            cellViewModel.value = Box(types[indexPath.row].name)
        }
        cell.viewModel = cellViewModel
        
        return cell
    }
    
    //    MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let viewModel = viewModel else { return nil}
        return viewModel.titleForHeaderInSection(section)
    }
}

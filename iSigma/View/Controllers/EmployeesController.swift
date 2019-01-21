//
//  EmployeesController.swift
//  iSigma
//
//  Created by Alex Delin on 12/01/2019.
//  Copyright © 2019 Alex Delin. All rights reserved.
//

import UIKit

class EmployeesController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: EmployeesViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = EmployeesViewModel()
        
        viewModel?.onErrorCallback = { description in
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Ошибка!", message: description, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "ОК", style: .default)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
        viewModel?.getEmployees{ employees in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    //    MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRowsInSection(section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "employeeCell", for: indexPath) as? EmployeeCell
        
        guard let employeeCell = cell, let viewModel = viewModel else { return UITableViewCell() }
        let cellViewModel = viewModel.cellViewModel(forIndexPath: indexPath)
        employeeCell.viewModel = cellViewModel
        
        return employeeCell
    }
    
    //    MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel?.heightForRowAt(forIndexPath: indexPath) ?? 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let employeeInfoController = storyboard.instantiateViewController(withIdentifier: "employeeInfoController") as! EmployeeInfoController
        
        guard let employees = viewModel?.employees else { return }
        employeeInfoController.navigationItem.title = "Сотрудник"
        employeeInfoController.viewModel = EmployeeInfoViewModel(employee: employees[indexPath.row])
        navigationController?.pushViewController(employeeInfoController, animated: true)
    }

}

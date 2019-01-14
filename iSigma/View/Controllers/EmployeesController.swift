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
    
    var employees: [Employee]?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkManager.shared.getEmployees{ employees in
            self.employees = employees.sorted(by: { $0.lastName < $1.lastName })
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    //    MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employees?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "employeeCell", for: indexPath) as! EmployeeCell
        
        let employee = employees![indexPath.row]
        cell.photo.image = UIImage(named: "employeeNoPhoto")
        cell.photo.layer.cornerRadius = cell.photo.frame.height / 2
        
        cell.lastName.text = employee.lastName
        cell.firstName.text = employee.firstName
        cell.middleName.text = employee.middleName
        cell.position.text = employee.position
        cell.mobile.text = employee.mobile
        cell.branch.text = employee.branch
        return cell
    }
    
    //    MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }

}

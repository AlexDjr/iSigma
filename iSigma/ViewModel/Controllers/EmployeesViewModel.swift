//
//  EmployeesViewModel.swift
//  iSigma
//
//  Created by Alex Delin on 15/01/2019.
//  Copyright © 2019 Alex Delin. All rights reserved.
//

import UIKit

class EmployeesViewModel {
    var onErrorCallback : ((String) -> ())?
    var employees : [Employee]?
    var filteredEmployees: [Employee]?
    var selectedIndexPath: IndexPath?
    
    //   MARK: - UITableViewDataSource
    func numberOfRowsInSection(_ section: Int, isFiltering: Bool) -> Int {
        if isFiltering {
            return filteredEmployees?.count ?? 0
        } else {
            return employees?.count ?? 0
        }
    }
    
    func cellViewModel(forIndexPath indexPath: IndexPath, isFiltering: Bool) -> EmployeeCellViewModel? {
        guard let employees = employees else { return nil }
        if isFiltering && filteredEmployees != nil {
            return EmployeeCellViewModel(employee: filteredEmployees![indexPath.row])
        } else {
            return EmployeeCellViewModel(employee: employees[indexPath.row])
        }
    }
    
    //    MARK: - UITableViewDelegate
    func heightForRowAt(forIndexPath indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    //    MARK: - Methods
    func getEmployees(completion: @escaping ([Employee]?) -> ()) {
        let proxy = Proxy(withKey: "employees")
        proxy.loadData { objects, errorDescription in
            if errorDescription != nil {
                self.onErrorCallback?(errorDescription!)
            } else {
                let employees = objects as! [Employee]
                self.employees = employees.sorted(by: { $0.lastName == $1.lastName ? $0.firstName < $1.firstName : $0.lastName < $1.lastName })
                completion(employees)
            }
        }
    }
    
    func filteredContentForSearchText(_ searchText: String) {
        guard let employees = employees else { return }
        filteredEmployees = employees.filter { (employee: Employee) -> Bool in
            return employee.lastName.lowercased().contains(searchText.lowercased()) ||
                employee.firstName.lowercased().contains(searchText.lowercased()) ||
                employee.mobile.lowercased().contains(searchText.lowercased())
        }
    }
    
    func getDataSource(_ isFiltering: Bool) -> [Employee] {
        guard let employees = employees else { return [Employee]() }
        if isFiltering && filteredEmployees != nil {
            return filteredEmployees!
        } else {
            return employees
        }
    }
}

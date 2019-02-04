//
//  AssigneesViewModel.swift
//  iSigma
//
//  Created by Alex Delin on 03/02/2019.
//  Copyright © 2019 Alex Delin. All rights reserved.
//

import UIKit

class AssigneesViewModel {
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
    
    func cellViewModel(forIndexPath indexPath: IndexPath, isFiltering: Bool) -> AssigneeCellViewModel? {
        guard let employees = employees else { return nil }
        if isFiltering && filteredEmployees != nil {
            return AssigneeCellViewModel(employee: filteredEmployees![indexPath.row])
        } else {
            return AssigneeCellViewModel(employee: employees[indexPath.row])
        }
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
    
    func filterContentForSearchText(_ searchText: String, searchBarIsEmpty: Bool, scope: String = "Все") {
        guard let employees = employees, let currentUser = getCurrentUser() else { return }
        filteredEmployees = employees.filter { (employee: Employee) -> Bool in
            
            var doesCategoryMatch = true
            if scope == "Отдел/Команда" {
                doesCategoryMatch = employee.departmentId == currentUser.departmentId
            }
            if scope == "Департамент" {
                doesCategoryMatch = employee.topDepartmentId == currentUser.topDepartmentId
            }
            
            if searchBarIsEmpty {
                return doesCategoryMatch
            }
            
            return doesCategoryMatch && (employee.lastName.lowercased().contains(searchText.lowercased()) ||
                                         employee.firstName.lowercased().contains(searchText.lowercased()))
        }
    }
    
    private func getCurrentUser() -> Employee? {
        guard let employees = employees, let currentUserEmail = UserDefaults.standard.string(forKey: "currentUserEmail") else { return nil }
        let currentUser = employees.first { (employee) -> Bool in
            return employee.email == currentUserEmail
        }
        return currentUser
    }
}

//
//  EmployeesViewModel.swift
//  iSigma
//
//  Created by Alex Delin on 15/01/2019.
//  Copyright © 2019 Alex Delin. All rights reserved.
//

import UIKit

class EmployeesViewModel {
    var employees : [Employee]?
    var selectedIndexPath: IndexPath?
    
    //   MARK: - UITableViewDataSource
    func numberOfRowsInSection(_ section: Int) -> Int {
        return employees?.count ?? 0
    }
    
    func cellViewModel(forIndexPath indexPath: IndexPath) -> EmployeeCellViewModel? {
        guard let employees = employees else { return nil }
        return EmployeeCellViewModel(employee: employees[indexPath.row])
    }
    
    //    MARK: - UITableViewDelegate
    func heightForRowAt(forIndexPath indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    //    MARK: - Methods
    func getEmployees(completion: @escaping ([Employee]?) -> ()) {
        let proxy = Proxy(withKey: "employees")
        proxy.loadData { objects, description, error in
            let employees = objects as! [Employee]
            self.employees = employees.sorted(by: { $0.lastName == $1.lastName ? $0.firstName < $1.firstName : $0.lastName < $1.lastName })
            completion(employees)
        }
    }
}

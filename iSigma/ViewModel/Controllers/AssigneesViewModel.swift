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
    var selectedIndexPath: IndexPath?
    
    
    //   MARK: - UITableViewDataSource
    func numberOfRowsInSection(_ section: Int) -> Int {
        return employees?.count ?? 0
    }
    
    func cellViewModel(forIndexPath indexPath: IndexPath) -> AssigneeCellViewModel? {
        guard let employees = employees else { return nil }
        return AssigneeCellViewModel(employee: employees[indexPath.row])
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
}

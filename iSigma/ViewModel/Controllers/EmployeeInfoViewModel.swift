//
//  EmployeeInfoViewModel.swift
//  iSigma
//
//  Created by Alex Delin on 15/01/2019.
//  Copyright © 2019 Alex Delin. All rights reserved.
//

import UIKit

class EmployeeInfoViewModel {
    var employee : Employee
    
    var photo: UIImage
    var lastName: String
    var firstName: String
    var middleName: String
    var position: String
    var branch: String
    var mobile: String
    
    init(employee: Employee) {
        self.employee = employee
        
        self.photo = UIImage()
        self.lastName = ""
        self.firstName = ""
        self.middleName = ""
        self.position = ""
        self.branch = ""
        self.mobile = ""
        
        setupViewModel()
    }
    
    func setupViewModel() {
        
        photo = UIImage(named: "employeeNoPhoto")!
        lastName = employee.lastName
        firstName = employee.firstName
        middleName = employee.middleName
        position = employee.position
        branch = employee.branch
        mobile = employee.mobile
    }
}

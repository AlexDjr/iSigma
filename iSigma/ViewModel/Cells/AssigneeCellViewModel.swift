//
//  AssigneeCellViewModel.swift
//  iSigma
//
//  Created by Alex Delin on 03/02/2019.
//  Copyright © 2019 Alex Delin. All rights reserved.
//

import UIKit

class AssigneeCellViewModel: CellViewModelProtocol {
    var employee : Employee
    
    var photo: UIImage
    var lastName: String
    var firstName: String
    
    init(employee: Employee) {
        self.employee = employee
        
        self.photo = UIImage()
        self.lastName = ""
        self.firstName = ""
        setupViewModel()
    }
    
    func setupViewModel() {
        photo = UIImage(named: "employeeNoPhoto")!
        lastName = employee.lastName
        firstName = employee.firstName
    }
}

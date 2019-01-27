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
    
    var email: String
    var photo: UIImage
    var lastName: String
    var firstName: String
    var middleName: String
    var position: String
    var branch: String
    var mobile: String
    var mobileTextColor: UIColor
    var room: String
    var phone: String
    var skype: String
    var skypeTextColor: UIColor
    var headFullName: String
    var headFullNameTextColor: UIColor
    var topDepartment: String
    var department: String
    
    init(employee: Employee) {
        self.employee = employee
        
        self.email = ""
        self.photo = UIImage()
        self.lastName = ""
        self.firstName = ""
        self.middleName = ""
        self.position = ""
        self.branch = ""
        self.mobile = ""
        self.mobileTextColor = UIColor.clear
        self.room = ""
        self.phone = ""
        self.skype = ""
        self.skypeTextColor = UIColor.clear
        self.headFullName = ""
        self.headFullNameTextColor = UIColor.clear
        self.topDepartment = ""
        self.department = ""
        
        setupViewModel()
    }
    
    func setupViewModel() {
        email = employee.email
        photo = UIImage(named: "employeeNoPhoto")!
        lastName = employee.lastName
        firstName = employee.firstName
        middleName = employee.middleName
        position = employee.position
        branch = employee.branch
        
        if employee.mobile == "" {
            mobile = "---"
            self.mobileTextColor = AppStyle.darkTextColor
        } else {
            mobile = Utils.getFormattedNumber(employee.mobile)
            self.mobileTextColor = AppStyle.mainRedColor
        }
        
        room = employee.room == "" ? "---" : employee.room
        phone = employee.phone == "" ? "---" : employee.phone
        
        if employee.skype == "" {
            skype = "---"
            self.skypeTextColor = AppStyle.darkTextColor
        } else {
            skype = employee.skype
            self.skypeTextColor = AppStyle.mainRedColor
        }
        
        if employee.headFullName == "" {
            headFullName = "---"
            self.headFullNameTextColor = AppStyle.darkTextColor
        } else {
            headFullName = employee.headFullName
            self.headFullNameTextColor = AppStyle.mainRedColor
        }
        
        topDepartment = employee.topDepartment
        department = employee.department
    }
}

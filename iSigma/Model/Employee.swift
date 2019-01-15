//
//  Employee.swift
//  iSigma
//
//  Created by Alex Delin on 14/01/2019.
//  Copyright © 2019 Alex Delin. All rights reserved.
//

import Foundation

struct Employee: CachableProtocol  {
    var id: String
    var headId: String
    var lastName: String
    var firstName: String
    var middleName: String
    var fullName: String
    var brief: String
    var headFullName: String
    var branch: String
    var email: String
    var skype: String
    var room: String
    var phone: String
    var mobile: String
    var position: String
    var topDepartmentId: String
    var topDepartment: String
    var department: String
    var departmentId: String
}

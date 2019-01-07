//
//  TaskType.swift
//  iSigma
//
//  Created by Alex Delin on 07/01/2019.
//  Copyright © 2019 Alex Delin. All rights reserved.
//

import Foundation

struct TaskType {
    var name: String
    var states: [TaskState]
    
    enum Name: String {
        case nse = "Несоответствие"
        case requirement = "Требование"
        case techRequirement = "Технологическое требование"
        case sprintRequirement = "Требование в спринте"
        case consultation = "Консультация"
    }
}

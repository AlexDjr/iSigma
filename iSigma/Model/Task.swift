//
//  Task.swift
//  iSigma
//
//  Created by Alex Delin on 17/12/2018.
//  Copyright © 2018 Alex Delin. All rights reserved.
//

import Foundation

struct Task: CachableProtocol {
    var id: Int
    var subject: String
    var type: TaskType.Name
    var state: String
    var assignee: String
    var author: String
    var priority: Int
    var supplyPlanDate: Date?
}

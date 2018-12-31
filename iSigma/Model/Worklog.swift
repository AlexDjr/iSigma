//
//  Worklog.swift
//  iSigma
//
//  Created by Alex Delin on 23/12/2018.
//  Copyright © 2018 Alex Delin. All rights reserved.
//

import Foundation

struct Worklog {
    var task: Task
    var type: String
    var time: String
    var date: Date
    
    static let hours = ["00","01","02","03","04","05","06","07","08"]
    static let minutes = ["00","05","10","15","20","25","30","35","40","45","50","55"]
}

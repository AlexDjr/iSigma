//
//  TaskCell.swift
//  iSigma
//
//  Created by Alex Delin on 18/12/2018.
//  Copyright © 2018 Alex Delin. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell {

    @IBOutlet weak var taskId: UILabel!
    @IBOutlet weak var taskType: UILabel!
    @IBOutlet weak var taskSubject: UILabel!
    @IBOutlet weak var taskState: UILabel!
    @IBOutlet weak var taskAssignee: UILabel!
    @IBOutlet weak var supplyDateView: UIView!
    @IBOutlet weak var supplyDate: UILabel!
    @IBOutlet weak var supplyTime: UILabel!
    
}

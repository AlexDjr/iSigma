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
    @IBOutlet weak var taskTypeTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var taskSubject: UILabel!
    @IBOutlet weak var taskState: UILabel!
    @IBOutlet weak var taskAssignee: UILabel!
    @IBOutlet weak var supplyDate: UILabel!
    @IBOutlet weak var supplyTime: UILabel!
    @IBOutlet weak var priorityView: UIView!
    @IBOutlet weak var priority: UILabel!
    
    weak var viewModel: TaskCellViewModel? {
        willSet(viewModel) {
            guard let viewModel = viewModel else { return }
            taskId.text = viewModel.taskId
            taskType.text = viewModel.taskType
            taskType.textColor = viewModel.taskTypeTextColor
            taskTypeTrailingConstraint.constant = viewModel.taskTypeTrailingConstraintConstant
            taskSubject.text = viewModel.taskSubject
            taskState.text = viewModel.taskState
            taskAssignee.text = viewModel.taskAssignee
            supplyDate.attributedText = viewModel.supplyDate
            supplyDate.isHidden = viewModel.supplyDateIsHidden
            supplyTime.text = viewModel.supplyTime
            supplyTime.isHidden = viewModel.supplyTimeIsHidden
            priorityView.isHidden = viewModel.priorityViewIsHidden
            priorityView.layer.borderWidth = viewModel.priorityViewBorderWidth
            priorityView.layer.borderColor = viewModel.priorityViewBorderColor
            priorityView.layer.backgroundColor = viewModel.priorityViewBGColor
            priorityView.layer.cornerRadius = viewModel.priorityViewCornerRadius
            priority.text = viewModel.priority
            priority.textColor = viewModel.priorityTextColor
        }
    }
}

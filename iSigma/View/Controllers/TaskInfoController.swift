//
//  TaskInfoController.swift
//  iSigma
//
//  Created by Alex Delin on 10/01/2019.
//  Copyright © 2019 Alex Delin. All rights reserved.
//

import UIKit

class TaskInfoController: UIViewController {

    @IBOutlet weak var taskId: UILabel!
    @IBOutlet weak var taskType: UILabel!
    @IBOutlet weak var taskSubject: UILabel!
    @IBOutlet weak var priority: UILabel!
    @IBOutlet weak var supplyDate: UILabel!
    @IBOutlet weak var supplyTime: UILabel!
    @IBOutlet weak var taskState: UILabel!
    @IBOutlet weak var taskAssignee: UILabel!
    @IBOutlet weak var taskAuthor: UILabel!
    @IBOutlet weak var taskDescription: UILabel!
    
    @IBOutlet weak var taskProjectName: UILabel!
    @IBOutlet weak var taskProjectManager: UILabel!
    @IBOutlet weak var taskProjectClient: UILabel!
    @IBOutlet weak var taskProjectStage: UILabel!
    
    var viewModel: TaskInfoViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let viewModel = viewModel else { return }
        
        taskId.text = viewModel.taskId
        taskType.text = viewModel.taskType
        taskType.textColor = viewModel.taskTypeTextColor
        taskSubject.text = viewModel.taskSubject
        priority.attributedText = viewModel.priority
        priority.textColor = viewModel.priorityTextColor
        supplyDate.attributedText = viewModel.supplyDate
        supplyDate.textColor = viewModel.supplyDateTextColor
        supplyTime.text = viewModel.supplyTime
        supplyTime.isHidden = viewModel.supplyTimeIsHidden
        taskState.text = viewModel.taskState
        taskAssignee.text = viewModel.taskAssignee
        taskAuthor.text = viewModel.taskAuthor
        taskDescription.text = viewModel.taskDescription
        
        taskProjectName.text = viewModel.taskProjectName
        taskProjectManager.text = viewModel.taskProjectManager
        taskProjectClient.text = viewModel.taskProjectClient
        taskProjectStage.text = viewModel.taskProjectStage
    }
}

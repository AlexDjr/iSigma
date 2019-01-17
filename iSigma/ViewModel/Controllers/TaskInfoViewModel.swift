//
//  TaskInfoViewModel.swift
//  iSigma
//
//  Created by Alex Delin on 11/01/2019.
//  Copyright © 2019 Alex Delin. All rights reserved.
//

import UIKit

class TaskInfoViewModel {
    var task : Task
    
    var taskId: String
    
    var taskType: String
    var taskTypeTextColor: UIColor

    var taskSubject: String
    
    var priority: NSAttributedString
    var priorityTextColor: UIColor

    var supplyDate: NSAttributedString
    var supplyDateTextColor: UIColor
    var supplyTime: String
    var supplyTimeTextColor: UIColor
    var supplyTimeIsHidden: Bool
    
    var taskState: String
    var taskAssignee: String
    var taskAuthor: String
    var taskDescription: String
    
    var taskProjectName: String
    var taskProjectManager: String
    var taskProjectClient: String
    var taskProjectStage: String
    
    init(task: Task) {
        self.task = task
        
        self.taskId = ""
        self.taskType = ""
        self.taskTypeTextColor = UIColor.clear
        self.taskSubject = ""
        self.priority = NSAttributedString()
        self.priorityTextColor = UIColor.clear
        self.supplyDate = NSAttributedString()
        self.supplyDateTextColor = UIColor.clear
        self.supplyTime = ""
        self.supplyTimeTextColor = UIColor.clear
        self.supplyTimeIsHidden = true
        self.taskState = ""
        self.taskAssignee = ""
        self.taskAuthor = ""
        self.taskDescription = ""
        self.taskProjectName = ""
        self.taskProjectManager = ""
        self.taskProjectClient = ""
        self.taskProjectStage = ""
        
        setupViewModel()
    }
    
    func setupViewModel() {
        taskId = String(task.id)
        taskType = task.type.rawValue
        taskSubject = task.subject
        
        taskState = task.state?.name ?? ""
        taskAssignee = task.assignee
        taskAuthor = task.author
        taskDescription = task.description
        
        taskProjectName = task.projectName
        taskProjectManager = task.projectManager
        taskProjectClient = task.projectClient
        taskProjectStage = task.projectStage
        
        if task.type == .nse {
            taskTypeTextColor = AppStyle.attentionPinkColor
            priority = NSMutableAttributedString(string: String(task.priority),
                                                 attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
            priorityTextColor = AppStyle.attentionPinkColor
            
            if let supplyPlanDate = task.supplyPlanDate {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd.MM.yyyy"
                let dateString = dateFormatter.string(from: supplyPlanDate)
                supplyDate = NSMutableAttributedString(string: dateString,
                                                       attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
                supplyDateTextColor = AppStyle.attentionPinkColor
                
                dateFormatter.dateFormat = "HH:mm"
                supplyTime = dateFormatter.string(from: supplyPlanDate)
                supplyTimeIsHidden = false
            }
        } else {
            taskTypeTextColor = AppStyle.darkTextColor
            priority = NSMutableAttributedString(string: "---",
                                                 attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)])
            priorityTextColor = AppStyle.darkTextColor
            supplyDate = NSMutableAttributedString(string: "---",
                                                   attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)])
            supplyDateTextColor = AppStyle.darkTextColor
            supplyTime = "---"
            supplyTimeIsHidden = true
        }
    }
}

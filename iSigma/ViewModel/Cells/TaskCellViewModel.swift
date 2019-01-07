//
//  TaskCellViewModel.swift
//  iSigma
//
//  Created by Alex Delin on 19/12/2018.
//  Copyright © 2018 Alex Delin. All rights reserved.
//

import UIKit

class TaskCellViewModel : CellViewModelProtocol {
    private var task : Task
    
    var taskId: String
    
    var taskType: String
    var taskTypeTextColor: UIColor
    var taskTypeTrailingConstraintConstant: CGFloat
    
    var taskSubject: String
    var taskState: String
    var taskAssignee: String
    
    var supplyDate: NSAttributedString
    var supplyDateIsHidden: Bool
    
    var supplyTime: String
    var supplyTimeIsHidden: Bool
    
    var priorityViewIsHidden: Bool
    var priorityViewBorderWidth: CGFloat
    var priorityViewBorderColor: CGColor
    var priorityViewBGColor: CGColor
    var priorityViewCornerRadius: CGFloat
    
    var priority: String
    var priorityTextColor: UIColor
    
    init(task: Task) {
        self.task = task
        
        self.taskId = ""
        self.taskType = ""
        self.taskTypeTextColor = UIColor.clear
        self.taskTypeTrailingConstraintConstant = 0.0
        self.taskSubject = ""
        self.taskState = ""
        self.taskAssignee = ""
        self.supplyDate = NSMutableAttributedString()
        self.supplyDateIsHidden = true
        self.supplyTime = ""
        self.supplyTimeIsHidden = true
        self.priorityViewIsHidden = true
        self.priorityViewBorderWidth = 0.0
        self.priorityViewBorderColor = UIColor.clear.cgColor
        self.priorityViewBGColor = UIColor.clear.cgColor
        self.priorityViewCornerRadius = 0
        self.priority = ""
        self.priorityTextColor = UIColor.clear
        setupViewModel()
    }
    
    func setupViewModel() {
        taskId = String(task.id)
        taskType = task.type.rawValue
        taskSubject = task.subject
        taskState = task.state
        taskAssignee = task.assignee
        
        priorityViewCornerRadius = 12.0
        priorityViewBorderWidth = 1.0
        priorityViewBorderColor = #colorLiteral(red: 1, green: 0.439357996, blue: 0.6011067629, alpha: 1)
        
        if task.type == .nse {
            taskTypeTextColor = #colorLiteral(red: 1, green: 0.439357996, blue: 0.6011067629, alpha: 1)
            taskTypeTrailingConstraintConstant = 40
            
            priorityViewIsHidden = false
            
            if task.priority == 2 {
                priorityViewBGColor = #colorLiteral(red: 1, green: 0.439357996, blue: 0.6011067629, alpha: 1)
                priorityTextColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                priorityViewBGColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                priorityTextColor = #colorLiteral(red: 1, green: 0.439357996, blue: 0.6011067629, alpha: 1)
            }
            priority = String(task.priority)
            
            supplyDateIsHidden = false
            supplyTimeIsHidden = false
            
            if let supplyPlanDate = task.supplyPlanDate {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd.MM.yyyy"
                let dateString = dateFormatter.string(from: supplyPlanDate)
                
                let dateAttributedString = NSMutableAttributedString(string: dateString,
                                                                     attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 12)])
                dateAttributedString.insert(NSMutableAttributedString(string: "до "), at: 0)
                supplyDate = dateAttributedString
                
                dateFormatter.dateFormat = "HH:mm"
                supplyTime = dateFormatter.string(from: supplyPlanDate)
            }
            
        } else {
            taskTypeTextColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
            taskTypeTrailingConstraintConstant = 9
            
            priorityViewIsHidden = true
            
            supplyDateIsHidden = true
            supplyTimeIsHidden = true
        }
    }
}

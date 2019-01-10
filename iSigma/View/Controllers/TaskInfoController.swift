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
    
    var task : Task?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let task = task else { return }
        taskId.text = String(task.id)
        taskType.text = task.type.rawValue
        taskSubject.text = task.subject
        priority.text = String(task.priority)
        supplyDate.text = "---"
        supplyTime.text = ""
        
        if let supplyPlanDate = task.supplyPlanDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            let dateString = dateFormatter.string(from: supplyPlanDate)
            
            let dateAttributedString = NSMutableAttributedString(string: dateString,
                                                                 attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
            supplyDate.attributedText = dateAttributedString
            
            dateFormatter.dateFormat = "HH:mm"
            supplyTime.text = dateFormatter.string(from: supplyPlanDate)
        }
        taskState.text = task.state?.name ?? ""
        taskAssignee.text = task.assignee
        taskAuthor.text = task.author
        taskDescription.text = task.description
        
        taskProjectName.text = task.projectName
        taskProjectManager.text = task.projectManager
        taskProjectClient.text = task.projectClient
        taskProjectStage.text = task.projectStage

    }
    



}

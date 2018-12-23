//
//  WorkLogViewModel.swift
//  iSigma
//
//  Created by Alex Delin on 21/12/2018.
//  Copyright © 2018 Alex Delin. All rights reserved.
//

import UIKit

class WorkLogViewModel {
    var task : Task?
    
    init(task: Task) {
        self.task = task
    }
    
    //   MARK: - UITableViewDataSource
    func numberOfSections() -> Int {
        return 2
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 5
        }
    }
    
    func cellViewModel(forIndexPath indexPath: IndexPath) -> CellViewModelProtocol? {
        guard let task = task else { return nil }
        
        if indexPath.section == 0 {
            return TaskCellViewModel(task: task)
        }
        switch indexPath.row {
        case 0: return WorkLogDetailsTimeCellViewModel()
        case 1: return WorkLogTimePickerCellViewModel()
        case 2: return WorkLogDetailsTypeCellViewModel()
        case 3: return WorkLogDetailsDateCellViewModel()
        case 4: return WorkLogSubmitCellViewModel()
        default:
            return WorkLogDetailsCellViewModel()
        }
    }
    
    //    MARK: - UITableViewDelegate
    func heightForRowAt(forIndexPath indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 120
        } else {
            switch indexPath.row {
            case 0, 2, 3: return 44
            case 1: return 150
            case 4: return 50
            default:
                return 44
            }
        }
    }
}

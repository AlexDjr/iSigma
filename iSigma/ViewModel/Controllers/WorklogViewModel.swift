//
//  WorklogViewModel.swift
//  iSigma
//
//  Created by Alex Delin on 21/12/2018.
//  Copyright © 2018 Alex Delin. All rights reserved.
//

import UIKit

class WorklogViewModel {
    var onErrorCallback : ((String) -> ())?
    var task : Task?
    var timePickerValue : String
    var worklogType : WorklogType?
    var worklogDate : String?
    
    init(task: Task) {
        self.task = task
        self.timePickerValue = "08:00"
        self.worklogType = UserDefaults.getObject(ofType: WorklogType.self, forKey: "settingsDefaultWorklogType") as? WorklogType
        
        self.worklogDate = String.dateFormatter.string(from:Date())
    }
    
    //   MARK: - UITableViewDataSource
    func numberOfSections() -> Int {
        return 2
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 4
        }
    }
    
    func cellViewModel(forIndexPath indexPath: IndexPath) -> CellViewModelProtocol? {
        guard let task = task else { return nil }
        
        if indexPath.section == 0 {
            return TaskCellViewModel(task: task)
        }
        switch indexPath.row {
        case 0: return WorklogDetailsTimeCellViewModel()
        case 1: return WorklogTimePickerCellViewModel()
        case 2: return WorklogDetailsTypeCellViewModel()
        case 3: return WorklogDetailsDateCellViewModel()
        default:
            return WorklogDetailsCellViewModel()
        }
    }
    
    //    MARK: - UITableViewDelegate
    func heightForRowAt(forIndexPath indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 120
        } else {
            switch indexPath.row {
            case 0, 2, 3: return 44
            case 1: return 141
            default:
                return 44
            }
        }
    }
    
    func  heightForHeaderInSection(_ section: Int) -> CGFloat {
        return 4
    }
    
    func  heightForFooterInSection(_ section: Int) -> CGFloat {
        return 0.0001
    }
    
    //    MARK: - SubmitView
    func heightForSubmitView() -> CGFloat {
        return 54
    }
    
    func xForSubmitView() -> CGFloat {
        return 0
    }

    //    MARK: - Methods
    func postWorklog(task: String, time: String, type: Int, date: String, completion: @escaping (String) -> ()){
        NetworkManager.shared.postWorklog(task: task, time: time, type: type, date: date) { isSuccess, details, errorDescription in
            if errorDescription != nil {
                self.onErrorCallback?(errorDescription!)
            } else {
                if isSuccess {
                    completion(details!)
                } else {
                    self.onErrorCallback?(details!)
                }
            }
        }
    }
    
    func getAjustedDate(from string: String) -> String {
        let date = string.date
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.locale = Locale(identifier: "ru_RU")
        if let date = date {
            
            if Calendar.current.isDateInYesterday(date) {
                return "Вчера"
            }
            if Calendar.current.isDate(date, inSameDayAs: Date()) {
                return "Сегодня"
            }
            
            let day = formatter.shortStandaloneWeekdaySymbols[date.weekday - 1]
            return day + ", " + formatter.string(from: date)
        } else {
            return ""
        }
    }
    
}

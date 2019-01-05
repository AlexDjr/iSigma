//
//  CalendarCellViewModel.swift
//  iSigma
//
//  Created by Alex Delin on 04/01/2019.
//  Copyright © 2019 Alex Delin. All rights reserved.
//

import UIKit

class CalendarCellViewModel: CellViewModelProtocol {
    var calendarView: CalendarView?
    var indexPath: IndexPath?
    var selectedDate: String?
    var selection: Bool?
    
    var isCellSelected: Bool
    var dayNumber: String
    var dayTextColor: UIColor
    var cellIsHidden: Bool
    var cellBGColor: UIColor
    var cellBorderWidth: CGFloat
    var cellBorderColor: CGColor
    
    init(indexPath:IndexPath, calendarView: CalendarView, selectedDate: String?, selection: Bool?) {
        self.indexPath = indexPath
        self.calendarView = calendarView
        self.selectedDate = selectedDate
        self.selection = selection
        
        self.isCellSelected = false
        self.dayNumber = ""
        self.dayTextColor = UIColor.clear
        self.cellIsHidden = false
        self.cellBGColor = UIColor.clear
        self.cellBorderWidth = 0.0
        self.cellBorderColor = UIColor.clear.cgColor
        
        setupViewModel()
    }
    
    func setupViewModel() {
        guard let calendarView = calendarView, let indexPath = indexPath else { return }
        
        let day = indexPath.row - calendarView.firstWeekDayOfMonth + 1
        dayNumber = "\(day)"
        
        setDeselected()
        
        //    setting viewModel when user selected cell
        if let selection = selection {
            if selection {
                setSelected()
            } else {
                if isToday(indexPath) {
                    setSelectedToday()
                }
            }
        //    setting viewModel when controller opens
        } else {
        
            if indexPath.item <= calendarView.firstWeekDayOfMonth - 1 {
                cellIsHidden = true
            } else {
                cellIsHidden = false
                if let selectedDate = selectedDate {
                    if selectedDate.date == getDate(indexPath) {
                        setSelected()
                    } else {
                        if isToday(indexPath) {
                            setSelectedToday()
                        }
                    }
                }
            }
        }
    }
    
    //    MARK: - Methods
    func setSelected() {
        isCellSelected = true
        dayTextColor = .white
        cellBGColor = #colorLiteral(red: 0.6860641241, green: 0.1174660251, blue: 0.2384344041, alpha: 1)
    }
    
    func setDeselected() {
        isCellSelected = false
        dayTextColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        cellBGColor = .clear
        cellBorderColor = UIColor.clear.cgColor
    }
    
    func setSelectedToday() {
        cellBGColor = .clear
        dayTextColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        cellBorderWidth = 1.0
        cellBorderColor = #colorLiteral(red: 0.6860641241, green: 0.1174660251, blue: 0.2384344041, alpha: 1).cgColor
    }
    
    func isToday(_ indexPath: IndexPath) -> Bool {
        guard let calendarView = calendarView else { return false }
        let currentDayIndex = indexPath.item - calendarView.firstWeekDayOfMonth + 1
        let calendarDate = "\(calendarView.currentYear)-\(calendarView.currentMonthIndex)-\(currentDayIndex)".date
        if calendarDate == String.dateFormatter.string(from:Date()).date {
            return true
        } else {
            return false
        }
    }
    
    func getDate(_ indexPath: IndexPath) -> Date {
        guard let calendarView = calendarView else { return Date() }
        let currentDayIndex = indexPath.item - calendarView.firstWeekDayOfMonth + 1
        let date = "\(calendarView.currentYear)-\(calendarView.currentMonthIndex)-\(currentDayIndex)".date!
        return date
    }
}

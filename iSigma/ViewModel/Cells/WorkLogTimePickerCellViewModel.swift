//
//  WorkLogTimePickerViewModel.swift
//  iSigma
//
//  Created by Alex Delin on 21/12/2018.
//  Copyright © 2018 Alex Delin. All rights reserved.
//

import UIKit

class WorkLogTimePickerCellViewModel : NSObject, CellViewModelProtocol, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var timePickerSelectedRows: (Int, Int)
    var timePickerComponentWidth: CGFloat
    
    override init() {
        self.timePickerSelectedRows = (0,0)
        self.timePickerComponentWidth = 0.0
        super.init()
        setupViewModel()
    }
    
    func setupViewModel() {
        timePickerSelectedRows = (7,0)
        timePickerComponentWidth = 20.0
    }
    
    //    MARK: - UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0: return WorkLog.hours.count
        case 1: return WorkLog.minutes.count
        default:
            return 0
        }
    }
    
    //    MARK: - UIPickerViewDelegate
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0: return WorkLog.hours[row]
        case 1: return WorkLog.minutes[row]
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 50
    }
    
}

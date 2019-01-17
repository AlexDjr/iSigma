//
//  WorklogTimePickerCell.swift
//  iSigma
//
//  Created by Alex Delin on 21/12/2018.
//  Copyright © 2018 Alex Delin. All rights reserved.
//

import UIKit

class WorklogTimePickerCell: UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet var timePicker: UIPickerView!
    
    var delegate: PickerDelegateProtocol?
    
    var viewModel: WorklogTimePickerCellViewModel? {
        willSet(viewModel) {
            guard let viewModel = viewModel else { return }
            timePicker.dataSource = self
            timePicker.delegate = self
            timePicker.selectRow(viewModel.timePickerSelectedRows.0, inComponent: 0, animated: false)
            timePicker.selectRow(viewModel.timePickerSelectedRows.1, inComponent: 1, animated: false)
        }
    }
    
    //    MARK: - UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //    hiding selection lines
        pickerView.subviews.forEach {
            $0.isHidden = $0.frame.height < 1.0
        }
        switch component {
        case 0: return Worklog.hours.count
        case 1: return Worklog.minutes.count
        default:
            return 0
        }
    }
    
    //    MARK: - UIPickerViewDelegate
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0: return Worklog.hours[row]
        case 1: return Worklog.minutes[row]
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 50
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let hours = Worklog.hours[pickerView.selectedRow(inComponent: 0)]
        var minutes = Worklog.minutes[pickerView.selectedRow(inComponent: 1)]
        if hours == "00" && minutes == "00" {
            pickerView.selectRow(1, inComponent: 1, animated: true)
        }
        if hours == "08" && minutes != "00" {
            pickerView.selectRow(0, inComponent: 1, animated: true)
        }
        minutes = Worklog.minutes[pickerView.selectedRow(inComponent: 1)]
        
        let value = hours + ":" + minutes
        delegate?.pickerDidSelectRow(value: value)
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {        
        var pickerData = ""
        switch component {
        case 0: pickerData = Worklog.hours[row]
        case 1: pickerData = Worklog.minutes[row]
        default: break
        }
        let attributedString = NSAttributedString(string: pickerData, attributes: [NSAttributedString.Key.foregroundColor : AppStyle.pickerTextColor])
        return attributedString
    }
}

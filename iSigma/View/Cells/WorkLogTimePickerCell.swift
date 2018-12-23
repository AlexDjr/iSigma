//
//  WorkLogTimePickerCell.swift
//  iSigma
//
//  Created by Alex Delin on 21/12/2018.
//  Copyright © 2018 Alex Delin. All rights reserved.
//

import UIKit

class WorkLogTimePickerCell: UITableViewCell {

    @IBOutlet var timePicker: UIPickerView!
    
    var viewModel: WorkLogTimePickerCellViewModel? {
        willSet(viewModel) {
            guard let viewModel = viewModel else { return }
            timePicker.dataSource = viewModel
            timePicker.delegate = viewModel
            timePicker.selectRow(viewModel.timePickerSelectedRows.0, inComponent: 0, animated: false)
            timePicker.selectRow(viewModel.timePickerSelectedRows.1, inComponent: 1, animated: false)
        }
    }
}

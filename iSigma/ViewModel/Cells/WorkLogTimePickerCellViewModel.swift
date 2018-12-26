//
//  WorkLogTimePickerViewModel.swift
//  iSigma
//
//  Created by Alex Delin on 21/12/2018.
//  Copyright © 2018 Alex Delin. All rights reserved.
//

import UIKit

class WorkLogTimePickerCellViewModel : NSObject, CellViewModelProtocol {
    
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
    
}

//
//  WorkLogSubmitViewModel.swift
//  iSigma
//
//  Created by Alex Delin on 21/12/2018.
//  Copyright © 2018 Alex Delin. All rights reserved.
//

import UIKit

class WorkLogSubmitCellViewModel : CellViewModelProtocol {
    
    var buttonWBorderWidth: CGFloat
    var buttonBorderColor: CGColor
    var buttonCornerRadius: CGFloat
    
    init() {
        self.buttonWBorderWidth = 0.0
        self.buttonBorderColor = UIColor.clear.cgColor
        self.buttonCornerRadius = 0
        setupViewModel()
    }
    
    func setupViewModel() {
        buttonWBorderWidth = 1.0
        buttonBorderColor = #colorLiteral(red: 0.6860641241, green: 0.1174660251, blue: 0.2384344041, alpha: 1)
        buttonCornerRadius = 3.0
    }
}

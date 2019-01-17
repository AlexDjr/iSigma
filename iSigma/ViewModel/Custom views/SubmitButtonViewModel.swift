//
//  SubmitButtonViewModel.swift
//  iSigma
//
//  Created by Alex Delin on 24/12/2018.
//  Copyright © 2018 Alex Delin. All rights reserved.
//

import UIKit

class SubmitButtonViewModel {
    var borderWidth: CGFloat
    var tintColor: UIColor
    var bgColor: UIColor
    var cornerRadius: CGFloat
    
    init() {
        self.borderWidth = 1.0
        self.tintColor = AppStyle.mainRedColor
        self.bgColor = AppStyle.whiteTextColor
        self.cornerRadius = 3.0
    }
}

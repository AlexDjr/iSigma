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
        self.tintColor = #colorLiteral(red: 0.6860641241, green: 0.1174660251, blue: 0.2384344041, alpha: 1)
        self.bgColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.cornerRadius = 3.0
    }
}

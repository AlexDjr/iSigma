//
//  SubmitViewViewModel.swift
//  iSigma
//
//  Created by Alex Delin on 24/12/2018.
//  Copyright © 2018 Alex Delin. All rights reserved.
//

import UIKit

class SubmitViewViewModel {
    var viewOrigin: CGPoint
    var viewSize: CGSize
    var viewBGColor: CGColor
    
    var buttonConstraintConst: CGFloat
    
    init(origin: CGPoint, size: CGSize) {
        self.viewOrigin = origin
        self.viewSize = size
        self.viewBGColor = UIColor.clear.cgColor
        self.buttonConstraintConst = 9.0
    }
}



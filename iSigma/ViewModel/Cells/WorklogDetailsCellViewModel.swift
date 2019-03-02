//
//  WorklogDetailsCellViewModel.swift
//  iSigma
//
//  Created by Alex Delin on 21/12/2018.
//  Copyright © 2018 Alex Delin. All rights reserved.
//

import UIKit

class WorklogDetailsCellViewModel : CellViewModelProtocol {
    var name: String
    var value: Box<String?>
    static var warningColor = AppStyle.attentionPinkColor.withAlphaComponent(0.2).cgColor
    static var defaultColor = AppStyle.whiteTextColor.cgColor
    
    init() {
        self.name = ""
        self.value = Box("")
    }
}

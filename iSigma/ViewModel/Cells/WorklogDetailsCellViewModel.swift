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
    static var warningColor = #colorLiteral(red: 1, green: 0.439357996, blue: 0.6011067629, alpha: 1).withAlphaComponent(0.2).cgColor
    static var defaultColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).cgColor
    
    init() {
        self.name = ""
        self.value = Box("")
    }
    
    func setupViewModel() {
        
    }
}

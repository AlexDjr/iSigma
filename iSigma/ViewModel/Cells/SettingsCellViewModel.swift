//
//  SettingsCellViewModel.swift
//  iSigma
//
//  Created by Alex Delin on 04/02/2019.
//  Copyright © 2019 Alex Delin. All rights reserved.
//

import UIKit

class SettingsCellViewModel: CellViewModelProtocol {
    var name: String
    var value: Box<String?>
    
    init(name: String) {
        self.name = name
        self.value = Box("")
    }
}

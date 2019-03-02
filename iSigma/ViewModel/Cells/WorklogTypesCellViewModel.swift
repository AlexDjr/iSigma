//
//  WorklogTypesCellViewModel.swift
//  iSigma
//
//  Created by Alex Delin on 26/12/2018.
//  Copyright © 2018 Alex Delin. All rights reserved.
//

import Foundation

class WorklogTypesCellViewModel: CellViewModelProtocol {
    var value: Box<String?>
    
    init() {
        self.value = Box(nil)
    }    
}

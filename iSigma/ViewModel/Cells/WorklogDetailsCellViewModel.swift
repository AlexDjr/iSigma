//
//  WorklogDetailsCellViewModel.swift
//  iSigma
//
//  Created by Alex Delin on 21/12/2018.
//  Copyright © 2018 Alex Delin. All rights reserved.
//

import Foundation

class WorklogDetailsCellViewModel : CellViewModelProtocol {
    var name: String
    var value: Box<String?>
    
    init() {
        self.name = ""
        self.value = Box("")
    }
    
    func setupViewModel() {
        
    }
}

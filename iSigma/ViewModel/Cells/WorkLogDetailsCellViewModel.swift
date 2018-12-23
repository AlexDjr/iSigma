//
//  WorkLogDetailsCellViewModel.swift
//  iSigma
//
//  Created by Alex Delin on 21/12/2018.
//  Copyright © 2018 Alex Delin. All rights reserved.
//

import Foundation

class WorkLogDetailsCellViewModel : CellViewModelProtocol {
    var detailName: String
    var detailValue: String
    
    init() {
        self.detailName = ""
        self.detailValue = ""
    }
    
    func setupViewModel() {
        
    }
}

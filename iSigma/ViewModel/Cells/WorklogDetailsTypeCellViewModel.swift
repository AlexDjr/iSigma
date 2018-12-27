//
//  WorklogDetailsTypeCellViewModel.swift
//  iSigma
//
//  Created by Alex Delin on 22/12/2018.
//  Copyright © 2018 Alex Delin. All rights reserved.
//

import Foundation

class WorklogDetailsTypeCellViewModel: WorklogDetailsCellViewModel {
    override init() {
        super.init()
        self.name = "Тип"
        self.value = Box(nil)
    }
}

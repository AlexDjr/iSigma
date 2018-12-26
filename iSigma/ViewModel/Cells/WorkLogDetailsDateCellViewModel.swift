//
//  WorkLogDetailsDateCellViewModel.swift
//  iSigma
//
//  Created by Alex Delin on 22/12/2018.
//  Copyright © 2018 Alex Delin. All rights reserved.
//

import Foundation

class WorkLogDetailsDateCellViewModel: WorkLogDetailsCellViewModel {
    override init() {
        super.init()
        self.name = "Дата"
        self.value = Box(nil)
    }
}

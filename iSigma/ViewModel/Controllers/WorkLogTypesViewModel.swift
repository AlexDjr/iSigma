//
//  WorkLogTypesViewModel.swift
//  iSigma
//
//  Created by Alex Delin on 26/12/2018.
//  Copyright © 2018 Alex Delin. All rights reserved.
//

import UIKit

class WorkLogTypesViewModel {
    
    var types: [WorkLogType]?
    var typesOftenUsed: [WorkLogType]?
    
    //   MARK: - UITableViewDataSource
    func numberOfSections() -> Int {
        return 2
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        guard let types = types, let typesOftenUsed = typesOftenUsed else { return 0 }
        
        if section == 0 {
            return typesOftenUsed.count
        } else {
            return types.count
        }
        
    }
    
    func cellViewModel(forIndexPath indexPath: IndexPath) -> CellViewModelProtocol? {
        return WorkLogTypesCellViewModel()
    }
    
    //    MARK: - UITableViewDelegate
    func titleForHeaderInSection(_ section: Int) -> String {
        if section == 0 {
            return "Частые"
        } else {
            return "Все типы"
        }
    }
    
    //    MARK: - Methods
    func getWorkLogTypes(completion: @escaping () -> ()) {
        if WorkLog.types == nil {
            NetworkManager.shared.getWorkLogTypes { workLogTypes in
                self.types = workLogTypes
                self.typesOftenUsed = workLogTypes.filter{ $0.isOften == true }
                completion()
            }
        } else {
            self.types = WorkLog.types
            self.typesOftenUsed = WorkLog.types?.filter{ $0.isOften == true }
        }
    }
}

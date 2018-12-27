//
//  WorklogTypesViewModel.swift
//  iSigma
//
//  Created by Alex Delin on 26/12/2018.
//  Copyright © 2018 Alex Delin. All rights reserved.
//

import UIKit

class WorklogTypesViewModel {
    
    var types: [WorklogType]?
    var typesOftenUsed: [WorklogType]?
    
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
        return WorklogTypesCellViewModel()
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
    func getWorklogTypes(completion: @escaping () -> ()) {
        if Worklog.types == nil {
            NetworkManager.shared.getWorklogTypes { worklogTypes in
                self.types = worklogTypes
                self.typesOftenUsed = worklogTypes.filter{ $0.isOften == true }
                completion()
            }
        } else {
            self.types = Worklog.types
            self.typesOftenUsed = Worklog.types?.filter{ $0.isOften == true }
        }
    }
}

//
//  File.swift
//  iSigma
//
//  Created by Alex Delin on 04/02/2019.
//  Copyright © 2019 Alex Delin. All rights reserved.
//

import UIKit

class SettingsViewModel {
    
    //   MARK: - UITableViewDataSource
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        return 1
    }
    
    func cellViewModel(forIndexPath indexPath: IndexPath) -> CellViewModelProtocol? {
        return SettingsCellViewModel(name: Utils.settingsRows[indexPath.section][indexPath.row])
    }
    
    func titleForHeaderInSection(_ section: Int) -> String? {
        return Utils.settingsSections[section]
    }
}

//
//  SettingsCell.swift
//  iSigma
//
//  Created by Alex Delin on 04/02/2019.
//  Copyright © 2019 Alex Delin. All rights reserved.
//

import UIKit

class SettingsCell: UITableViewCell {

    @IBOutlet weak var settingsName: UILabel!
    @IBOutlet weak var settingsValue: UILabel!
    
    weak var viewModel: SettingsCellViewModel? {
        willSet(viewModel) {
            guard let viewModel = viewModel else { return }
            settingsName.text = viewModel.name
            
            viewModel.value.bind{ [unowned self] in
                guard let string = $0 else { return }
                self.settingsValue.text = string
            }
        }
    }
}

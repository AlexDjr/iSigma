//
//  WorkLogTypesCell.swift
//  iSigma
//
//  Created by Alex Delin on 26/12/2018.
//  Copyright © 2018 Alex Delin. All rights reserved.
//

import UIKit

class WorkLogTypesCell: UITableViewCell {
    
    var viewModel: WorkLogTypesCellViewModel? {
        willSet(viewModel) {
            guard let viewModel = viewModel else { return }
            
            viewModel.value.bind{ [unowned self] in
                guard let string = $0 else { return }
                self.textLabel?.text = string
            }
        }
    }
}

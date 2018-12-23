//
//  WorkLogSubmitCell.swift
//  iSigma
//
//  Created by Alex Delin on 21/12/2018.
//  Copyright © 2018 Alex Delin. All rights reserved.
//

import UIKit

class WorkLogSubmitCell: UITableViewCell {

    @IBOutlet weak var submitButton: UIButton!
    
    weak var viewModel: WorkLogSubmitCellViewModel? {
        willSet(viewModel) {
            guard let viewModel = viewModel else { return }
            submitButton.layer.borderWidth = viewModel.buttonWBorderWidth
            submitButton.layer.borderColor = viewModel.buttonBorderColor
            submitButton.layer.cornerRadius = viewModel.buttonCornerRadius
        }
    }
}

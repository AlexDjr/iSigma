//
//  AssigneeCell.swift
//  iSigma
//
//  Created by Alex Delin on 03/02/2019.
//  Copyright © 2019 Alex Delin. All rights reserved.
//

import UIKit

class AssigneeCell: UICollectionViewCell {
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var firstName: UILabel!
    
    var viewModel: AssigneeCellViewModel? {
        willSet(viewModel) {
            guard let viewModel = viewModel else { return }
            photo.image = viewModel.photo
            lastName.text = viewModel.lastName
            firstName.text = viewModel.firstName
        }
    }
}

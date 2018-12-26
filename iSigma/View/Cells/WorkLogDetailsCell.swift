//
//  WorkLogDetailsCell.swift
//  iSigma
//
//  Created by Alex Delin on 21/12/2018.
//  Copyright © 2018 Alex Delin. All rights reserved.
//

import UIKit

class WorkLogDetailsCell: UITableViewCell {

    @IBOutlet weak var detailName: UILabel!
    @IBOutlet weak var detailValue: UILabel!
    
    weak var viewModel: WorkLogDetailsCellViewModel? {
        willSet(viewModel) {
            guard let viewModel = viewModel else { return }
            detailName.text = viewModel.name
            
            viewModel.value.bind{ [unowned self] in
                guard let string = $0 else { return }
                self.detailValue.text = string
            }
        }
    }
}

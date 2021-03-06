//
//  EmployeeCell.swift
//  iSigma
//
//  Created by Alex Delin on 14/01/2019.
//  Copyright © 2019 Alex Delin. All rights reserved.
//

import UIKit

class EmployeeCell: UITableViewCell {

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var middleName: UILabel!
    @IBOutlet weak var position: UILabel!
    @IBOutlet weak var branch: UILabel!
    @IBOutlet weak var mobile: UILabel!
    
    
    weak var viewModel: EmployeeCellViewModel? {
        willSet(viewModel) {
            guard let viewModel = viewModel else { return }
            photo.image = viewModel.photo
            lastName.text = viewModel.lastName
            firstName.text = viewModel.firstName
            middleName.text = viewModel.middleName
            position.text = viewModel.position
            branch.text = viewModel.branch
            mobile.text = viewModel.mobile
            
            mobile.isUserInteractionEnabled = true
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(makeACall))
            mobile.addGestureRecognizer(gestureRecognizer)
        }
    }
    
    @objc func makeACall(){
        let cleanNumber = mobile.text!.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        guard let number = URL(string: "tel://" + cleanNumber) else { return }
        UIApplication.shared.open(number)
    }
}

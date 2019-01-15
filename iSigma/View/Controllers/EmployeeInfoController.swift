//
//  EmployeeInfoController.swift
//  iSigma
//
//  Created by Alex Delin on 15/01/2019.
//  Copyright © 2019 Alex Delin. All rights reserved.
//

import UIKit

class EmployeeInfoController: UIViewController {

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var middleName: UILabel!
    @IBOutlet weak var position: UILabel!
    @IBOutlet weak var branch: UILabel!
    @IBOutlet weak var mobile: UILabel!
    
    var viewModel: EmployeeInfoViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let viewModel = viewModel else { return }
        
        photo.image = viewModel.photo
        lastName.text = viewModel.lastName
        firstName.text = viewModel.firstName
        middleName.text = viewModel.middleName
        position.text = viewModel.position
        branch.text = viewModel.branch
        mobile.text = viewModel.mobile
    }

}

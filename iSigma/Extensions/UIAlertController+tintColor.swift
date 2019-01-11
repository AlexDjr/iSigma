//
//  UIAlertController+tintColor.swift
//  iSigma
//
//  Created by Alex Delin on 11/01/2019.
//  Copyright © 2019 Alex Delin. All rights reserved.
//

import UIKit

extension UIAlertController {
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.tintColor = #colorLiteral(red: 0.6860641241, green: 0.1174660251, blue: 0.2384344041, alpha: 1)
    }
}

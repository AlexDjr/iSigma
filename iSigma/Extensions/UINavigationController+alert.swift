//
//  UINavigationController+alert.swift
//  iSigma
//
//  Created by Alex Delin on 21/01/2019.
//  Copyright © 2019 Alex Delin. All rights reserved.
//

import UIKit

extension UIViewController {
    func presentAlert(title: String?, message: String, actions: UIAlertAction..., animated: Bool = true) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach { alert.addAction($0) }
        self.present(alert, animated: animated, completion: nil)
    }
}

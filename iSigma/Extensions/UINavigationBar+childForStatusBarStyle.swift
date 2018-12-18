//
//  UINavigationBar+childForStatusBarStyle.swift
//  iSigma
//
//  Created by Alex Delin on 18/12/2018.
//  Copyright © 2018 Alex Delin. All rights reserved.
//

import UIKit

extension UINavigationController {
    open override var childForStatusBarStyle: UIViewController? {
        return visibleViewController
    }
}

//
//  UIView+searchSubview.swift
//  iSigma
//
//  Created by Alex Delin on 23/01/2019.
//  Copyright © 2019 Alex Delin. All rights reserved.
//

import UIKit

extension UIView {
    func searchSubviewForViewOfKind(_ kind: AnyClass) -> UIView? {
        var matchingView: UIView?
        for aSubview in subviews {
            if type(of: aSubview) == kind {
                matchingView = aSubview
                return matchingView
            } else {
                if let matchingView = aSubview.searchSubviewForViewOfKind(kind) {
                    return matchingView
                }
            }
        }
        return matchingView
    }
}

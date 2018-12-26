//
//  Equatable+oneOf.swift
//  iSigma
//
//  Created by Alex Delin on 26/12/2018.
//  Copyright © 2018 Alex Delin. All rights reserved.
//

import Foundation

extension Equatable {
    func oneOf(other: Self...) -> Bool {
        return other.contains(self)
    }
}

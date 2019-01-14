//
//  APIEmployeeFlags.swift
//  iSigma
//
//  Created by Alex Delin on 14/01/2019.
//  Copyright © 2019 Alex Delin. All rights reserved.
//

import Foundation

struct APIEmployeeFlags: Decodable {
    var isTech: Bool
    var doNotShowInPhonebook: Bool
}

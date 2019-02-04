//
//  WorklogType.swift
//  iSigma
//
//  Created by Alex Delin on 26/12/2018.
//  Copyright © 2018 Alex Delin. All rights reserved.
//

import Foundation

struct WorklogType: CachableProtocol, Codable {
    var id: Int
    var name: String
    var isOften: Bool
}

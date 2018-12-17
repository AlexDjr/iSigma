//
//  APITaskBase.swift
//  iSigma
//
//  Created by Alex Delin on 17/12/2018.
//  Copyright © 2018 Alex Delin. All rights reserved.
//

import Foundation

struct APITaskBase: Decodable {
    var subject: String
    var typeName: String
    var stateName: String
    var assigneeName: String
    var authorName: String
    var priority: Int
}

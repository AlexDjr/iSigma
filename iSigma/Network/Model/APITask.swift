//
//  APITask.swift
//  iSigma
//
//  Created by Alex Delin on 17/12/2018.
//  Copyright © 2018 Alex Delin. All rights reserved.
//

import Foundation

struct APITask: Decodable {
    var id: String
    var url: String
    var base: APITaskBase
    var extra: APITaskExtra
}

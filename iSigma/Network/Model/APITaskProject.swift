//
//  APITaskProject.swift
//  iSigma
//
//  Created by Alex Delin on 10/01/2019.
//  Copyright © 2019 Alex Delin. All rights reserved.
//

import Foundation

struct APITaskProject: Decodable {
    var clientName: String
    var name: String
    var stageName: String
    var managerName: String
}

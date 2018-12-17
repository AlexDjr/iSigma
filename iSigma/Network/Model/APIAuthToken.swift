//
//  APIAuthToken.swift
//  iSigma
//
//  Created by Alex Delin on 17/12/2018.
//  Copyright © 2018 Alex Delin. All rights reserved.
//

import Foundation

struct APIAuthToken: Decodable {
    var accessToken: String
    var refreshToken: String
}

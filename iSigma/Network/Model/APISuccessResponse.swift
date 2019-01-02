//
//  APIResponse.swift
//  iSigma
//
//  Created by Alex Delin on 02/01/2019.
//  Copyright © 2019 Alex Delin. All rights reserved.
//

import Foundation

struct APISuccessResponse: Decodable {
    var success: Bool
    var details: String
}

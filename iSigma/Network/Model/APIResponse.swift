//
//  APIResponse.swift
//  iSigma
//
//  Created by Alex Delin on 09/01/2019.
//  Copyright © 2019 Alex Delin. All rights reserved.
//

import Foundation

struct APIResponse: Decodable {
    var id: String
    var result: APISuccessResponse
}

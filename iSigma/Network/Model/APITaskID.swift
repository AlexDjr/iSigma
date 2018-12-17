//
//  APITaskID.swift
//  iSigma
//
//  Created by Alex Delin on 17/12/2018.
//  Copyright © 2018 Alex Delin. All rights reserved.
//

import Foundation

struct APITaskID {
    var id: String
}

extension APITaskID: Decodable {
    private enum Key: String, CodingKey {
        case id = "id"
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        self.id = try container.decode(String.self, forKey: .id)
    }
}

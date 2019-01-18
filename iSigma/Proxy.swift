//
//  Proxy.swift
//  iSigma
//
//  Created by Alex Delin on 29/12/2018.
//  Copyright © 2018 Alex Delin. All rights reserved.
//

import Foundation

class Proxy {
    private var key: String
    
    init(withKey key: String) {
        self.key = key
    }
    
    func loadData(completion: @escaping ([CachableProtocol]?, String?, Error?) -> ()) {
        let networkManager = NetworkManager.shared
        if let objects = networkManager.cache.object(forKey: key as NSString) as? Array<CachableProtocol> {
            completion(objects, nil, nil)
        } else {
            networkManager.getData(forKey: key) { objects, description, error in
                if error != nil || description != nil {
                    completion(nil, description, error)
                } else {
                    completion(objects, nil, nil)
                }
            }
        }
    }
}

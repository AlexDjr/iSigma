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
    
    func loadData(completion: @escaping ([CachableProtocol]?, String?) -> ()) {
        let networkManager = NetworkManager.shared
        if let objects = networkManager.cache.object(forKey: key as NSString) as? Array<CachableProtocol> {
            completion(objects, nil)
        } else {
            networkManager.getData(forKey: key) { objects, errorDescription in
                if errorDescription != nil {
                    completion(nil, errorDescription)
                } else {
                    completion(objects, nil)
                }
            }
        }
    }
}

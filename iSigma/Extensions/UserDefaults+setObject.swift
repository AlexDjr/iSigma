//
//  UserDefaults+setObject.swift
//  iSigma
//
//  Created by Alex Delin on 05/02/2019.
//  Copyright © 2019 Alex Delin. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    class func setObject<T: Codable>(_ object: T, forKey key: String) {
        if let encoded = try? JSONEncoder().encode(object) {
            UserDefaults.standard.set(encoded, forKey: key)
            UserDefaults.standard.synchronize()
        }
    }
    
    class func getObject<T: Codable>(ofType type: T.Type, forKey key: String) -> Codable? {
        var object: Codable? = nil
        if let objectData = UserDefaults.standard.data(forKey: key) {
            object = try? JSONDecoder().decode(type, from: objectData)
        }
        return object
    }
    
    class func setTrue(forKey key: String) {
        UserDefaults.standard.set(true, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    class func setString(_ string: String, forKey key: String) {
        UserDefaults.standard.set(string, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    class func removeKey(_ key: String) {
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }
    
}

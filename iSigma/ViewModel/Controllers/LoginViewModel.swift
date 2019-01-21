//
//  LoginViewModel.swift
//  iSigma
//
//  Created by Alex Delin on 21/01/2019.
//  Copyright © 2019 Alex Delin. All rights reserved.
//

import UIKit

class LoginViewModel {
    var onErrorCallback : ((String) -> ())?
    
    //    MARK: - Methods
    func authCheck(completion: @escaping (Bool) -> ()) {
        NetworkManager.shared.authCheck { isOk, errorDescription in
            if errorDescription != nil {
                self.onErrorCallback?(errorDescription!)
            } else {
                completion(isOk)
            }
        }
    }
    
    func auth(withUser user: String, completion: @escaping () -> ())  {
        NetworkManager.shared.auth(withUser: user) { errorDescription in
            if errorDescription != nil {
                self.onErrorCallback?(errorDescription!)
            } else {
                completion()
            }
        }
    }
    
    func authToken(withPin pin: String, completion: @escaping () -> ())  {
        NetworkManager.shared.authToken(withPin: pin) { errorDescription in
            if errorDescription != nil {
                self.onErrorCallback?(errorDescription!)
            } else {
                completion()
            }
        }
    }
    
    func isLoggedIn() -> Bool {
        let userDefaults = UserDefaults.standard
        let keychain = KeychainWrapper.standard
        if userDefaults.value(forKey: "isLoggedIn") != nil && userDefaults.bool(forKey: "isLoggedIn") && keychain.string(forKey: "accessToken") != nil {
            return true
        } else {
            return false
        }
    }
    
    func isPinSent() -> Bool {
        let userDefaults = UserDefaults.standard
        if userDefaults.value(forKey: "isPinSent") != nil && userDefaults.bool(forKey: "isPinSent") {
            return true
        } else {
            return false
        }
    }
    
    func saveKey(_ key: String) {
        UserDefaults.standard.set(true, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    func removeKey(_ key: String) {
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    func validatedString(_ characterSet: CharacterSet, _ text: String, _ range: NSRange, _ string: String) -> String {
        let validationSet = characterSet.inverted
        var newString = ""
        newString = (text as NSString).replacingCharacters(in: range, with: string)
        
        let validComponents = newString.components(separatedBy: validationSet)
        newString = validComponents.joined(separator: "")
        return newString
    }
}

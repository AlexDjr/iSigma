//
//  Utils.swift
//  iSigma
//
//  Created by Alex Delin on 25/01/2019.
//  Copyright © 2019 Alex Delin. All rights reserved.
//

import Foundation

class Utils {
    static func getOnlyMobile(_ number: String) -> String {
        let digitSet = CharacterSet.decimalDigits
        let separatorSet = CharacterSet(charactersIn: ".,;")
        //    result stores only number digits
        var result = ""
        
        for char in number.unicodeScalars.reversed() {
            if digitSet.contains(char) {
                result.insert(Character(char), at: result.startIndex)
            }
            if separatorSet.contains(char) {
                result.removeAll()
            }
        }
        
        if result.count < 10 {
            result.removeAll()
        } else {
            //    not changing anything for vietnamese numbers
            if !result.hasPrefix("84") {
                result = "7" + result.suffix(10)
            }
        }
        return result
    }
    
    static func getFormattedNumber(_ number: String) -> String {
        var mask = ""
        if number.hasPrefix("84") {
            mask = "+XX (XXX) XXX-XXXX"
        } else {
            mask = "+X (XXX) XXX-XX-XX"
        }
        
        var result = ""
        var index = number.startIndex
        for char in mask {
            if index == number.endIndex {
                break
            }
            if char == "X" {
                result.append(number[index])
                index = number.index(after: index)
            } else {
                result.append(char)
            }
        }
        return result
    }
}

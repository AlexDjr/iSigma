//
//  String+date.swift
//  iSigma
//
//  Created by Alex Delin on 29/12/2018.
//  Copyright © 2018 Alex Delin. All rights reserved.
//

import Foundation

extension String {
    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"        
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        return formatter
    }()
    
    var date: Date? {
        return String.dateFormatter.date(from: self)
    }
}

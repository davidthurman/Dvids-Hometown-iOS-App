//
//  NSDateISO8601.swift
//
//  Created by Justin Makaila on 8/11/14.
//  Copyright (c) 2014 Present, Inc. All rights reserved.
//

import Foundation

private struct ISODateFormatters {
    
    static let ISOStringFromDateFormatter: DateFormatter = {
        var dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return dateFormatter
    }()
    
    static let dateFromISOStringFormatter: DateFormatter = {
        var dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = NSTimeZone.local
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter
    }()
    
}

extension Date {
    
    var ISOString: String {
        return Date.ISOStringFromDate(date: self)
    }
    
    static func ISOStringFromDate(date: Date) -> String {
        return ISODateFormatters.ISOStringFromDateFormatter.string(from: date).appending("Z")
    }
    
    static func dateFromISOString(string: String) -> Date? {
        return ISODateFormatters.dateFromISOStringFormatter.date(from: string)
    }
    
}

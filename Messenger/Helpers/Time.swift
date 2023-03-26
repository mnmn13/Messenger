//
//  Time.swift
//  Messenger
//
//  Created by MN on 14.03.2023.
//  Copyright © 2023 Nikita Moshyn. All rights reserved.
//

import Foundation

//class Time {
//
//    static let formatter: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.dateStyle = .medium
//        formatter.timeStyle = .long
//        formatter.locale = .current
//        return formatter
//    }()
//}

class Time {
    
    static func dateToString(date: Date) -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd,MM,yy,HH,mm,ss"
//        formatter.timeZone = .current
//        formatter.timeZone = .gmt
        let string = formatter.string(from: date)
        
        return string
        
    }
    /// Returns date in string format dd,MM,yy,HH,mm,ss
    static func stringToDate(string: String) -> Date {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd,MM,yy,HH,mm,ss"
//        formatter.timeZone = .current
//        formatter.timeZone = .gmt
        guard let date = formatter.date(from: string) else { return Date() }
        return date
        
    }
    /// Returns string in format HH:mm
    static func dateToStringLastActivity(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let string = formatter.string(from: date)
        return string
    }
    /// Returns string from timeInterval (Double)
    static func timeIntervalToString(dateDouble: Double) -> String { dateToString(date: Date(timeIntervalSince1970: dateDouble)) }
    /// Returns TimeInterval (Double) since 1970
    static func timeIntervalStringToTimeInterval(dateString: String) -> TimeInterval { stringToDate(string: dateString).timeIntervalSince1970 }
    
    static func timeIntervalToDate(time: TimeInterval) -> Date { Date(timeIntervalSince1970: time) }
    
}

//
//  Date+Extension.swift
//  TicketGateway
//
//  Created by Apple on 19/06/23.
//

import Foundation
import UIKit

extension Date {
    var workoutStartTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss+00:00"
        return dateFormatter.string(from: self)
    }
    
    var workoutEndTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss+00:00"
        return dateFormatter.string(from: self)
    }
    func getOnlyTimeFromDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        // dateFormatter.timeZone = .current
        //dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "hh:mm a" // output format
        let time = dateFormatter.string(from: date)
        return time
    }
    func getOnlyTimeFromDateForProfile(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "hh:mm a" // output format
        let time = dateFormatter.string(from: date)
        return time
    }
    func getWeekDay(date: Date) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        //dateFormatter.timeZone = .current
        //dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        return dateFormatter.string(from: date).capitalized
    }
    func convertToString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let currentDate = Date()
        let dateString = dateFormatter.string(from: currentDate)
        return dateString
    }
}

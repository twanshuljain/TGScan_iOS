//
//  String+Extension.swift
//  TicketGateway
//
//  Created by Apple  on 14/04/23.
//

import Foundation
import UIKit
import CoreImage

extension String {
    public func trim() -> String {
       return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
    }
    
    func timeStampToString(timeStamp: Double) -> (strdate: String, strtime: String)? {
        let date = NSDate(timeIntervalSince1970: timeStamp / 1000)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd, MMM yyyy"
        //dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        let dateString = dateFormatter.string(from: date as Date)
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss a"
       // timeFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        let timeString = timeFormatter.string(from: date as Date)
        return (dateString, timeString)
    }
    
    var toDouble: Double {
        return NumberFormatter().number(from: self)?.doubleValue ?? 0.0
    }
   
    var toInt: Int {
        return NumberFormatter().number(from: self)?.intValue ?? 0
    }
    
    
//    func getDateFormattedFrom(_ dateFormate: String = "MMM d") -> String {
//        let dateFormatter = DateFormatter()
//        let tempLocale = dateFormatter.locale // save locale temporarily
//        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
//        if dateFormatter.date(from: self) == nil{
//            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
//            let date = dateFormatter.date(from: self) ?? Date.init()
//            dateFormatter.dateFormat = dateFormate
//            dateFormatter.locale = tempLocale // reset the locale
//            let dateString = dateFormatter.string(from: date)
//            return dateString
//        }else{
//            let date = dateFormatter.date(from: self) ?? Date.init()
//            dateFormatter.dateFormat = dateFormate
//            dateFormatter.locale = tempLocale // reset the locale
//            let dateString = dateFormatter.string(from: date)
//            return dateString
//        }
//        //?? Date.init()
//
//    }
    func getDateFormattedFrom(_ dateFormate: String = "MMM d") -> String {
        let dateFormatter = DateFormatter()
        //dateFormatter.timeZone = .current
        let tempLocale = dateFormatter.locale // save locale temporarily
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        //dateFormatter.timeZone = .current //TimeZone(identifier: "UTC")
        if dateFormatter.date(from: self) == nil {
          dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
          let date = dateFormatter.date(from: self) ?? Date.init()
          dateFormatter.dateFormat = dateFormate
          dateFormatter.locale = tempLocale // reset the locale
          let dateString = dateFormatter.string(from: date)
          return dateString
        } else {
          let date = dateFormatter.date(from: self) ?? Date.init()
          dateFormatter.dateFormat = dateFormate
          dateFormatter.locale = tempLocale // reset the locale
          let dateString = dateFormatter.string(from: date)
          return dateString
        }
      }
    
    func getDateFormattedFromTo() -> String {
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale // save locale temporarily
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        //dateFormatter.timeZone = .current //TimeZone(identifier: "UTC")
        if dateFormatter.date(from: self) == nil{
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            let date = dateFormatter.date(from: self) ?? Date.init()
            dateFormatter.dateFormat = "MMM d, yyyy"
            dateFormatter.locale = tempLocale // reset the locale
            let dateString = dateFormatter.string(from: date)
            return dateString
        }else{
            let date = dateFormatter.date(from: self) ?? Date.init()
            dateFormatter.dateFormat = "MMM d, yyyy"
            dateFormatter.locale = tempLocale // reset the locale
            let dateString = dateFormatter.string(from: date)
            return dateString
        }
        
    }
    
    func removeTimeFromDate() -> String {
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale // save locale temporarily
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        // dateFormatter.timeZone = .current //TimeZone(identifier: "UTC")
        if dateFormatter.date(from: self) == nil{
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            let date = dateFormatter.date(from: self) ?? Date.init()
            dateFormatter.dateFormat = "MMM d, yyyy"
            dateFormatter.locale = tempLocale // reset the locale
            let dateString = dateFormatter.string(from: date)
            return dateString
        }else{
            let date = dateFormatter.date(from: self) ?? Date.init()
            dateFormatter.dateFormat = "MMM d, yyyy"
            dateFormatter.locale = tempLocale // reset the locale
            let dateString = dateFormatter.string(from: date)
            return dateString
        }
        
    }
    
    func getDayFormattedFromTo() -> String {
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale // save locale temporarily
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        // dateFormatter.timeZone = .current //TimeZone(identifier: "UTC")
        if dateFormatter.date(from: self) == nil{
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            let date = dateFormatter.date(from: self) ?? Date.init()
            dateFormatter.dateFormat = "EEE"
            dateFormatter.locale = tempLocale // reset the locale
            let dateString = dateFormatter.string(from: date)
            return dateString
        }else{
            let date = dateFormatter.date(from: self) ?? Date.init()
            dateFormatter.dateFormat = "EEE"
            dateFormatter.locale = tempLocale // reset the locale
            let dateString = dateFormatter.string(from: date)
            return dateString
        }
        
    }
    
    func getDateFormattedISOFromTo() -> String {
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale // save locale temporarily
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSXXX"
        //dateFormatter.timeZone = .current //TimeZone(identifier: "UTC")
        if dateFormatter.date(from: self) == nil{
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            let date = dateFormatter.date(from: self) ?? Date.init()
            dateFormatter.dateFormat = "MMM d, yyyy"
            dateFormatter.locale = tempLocale // reset the locale
            let dateString = dateFormatter.string(from: date)
            return dateString
        }else{
            let date = dateFormatter.date(from: self) ?? Date.init()
            dateFormatter.dateFormat = "MMM d, yyyy"
            dateFormatter.locale = tempLocale // reset the locale
            let dateString = dateFormatter.string(from: date)
            return dateString
        }
        
    }
    
    
    
    func changeDateFormate() -> String {
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale // save locale temporarily
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZZZZZ"
        // dateFormatter.timeZone = .current //TimeZone(identifier: "UTC")
        let date = dateFormatter.date(from: self) ?? Date.init()
        dateFormatter.dateFormat = "MMM d, yyyy"
        dateFormatter.locale = tempLocale // reset the locale
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    func convertToDate() -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        //formatter.timeZone = .current
        //formatter.timeZone = TimeZone(abbreviation: "GMT")
        let result = formatter.date(from: self) ?? Date()
        return result
      }
      func convertStringToDateForTime() -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        let result = formatter.date(from: self) ?? Date()
        return result
      }
    
    func getFormattedTime() -> String{
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale // save locale temporarily
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "HH:mm:ss"
        let date = dateFormatter.date(from: self) ?? Date.init()
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.locale = tempLocale // reset the locale
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    func getDateFormattedDateFromString(_ timeFormat: String = "dd MMM yyyy", _ stringDateFormate: String = "dd MMM yyyy") -> Date {
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale // save locale temporarily
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = stringDateFormate
        let date = dateFormatter.date(from: self)!
        dateFormatter.dateFormat = timeFormat
        dateFormatter.locale = tempLocale // reset the locale
        let dateString = dateFormatter.string(from: date)
        let mainDate = dateFormatter.date(from: dateString) ?? Date()
        return mainDate
    }
    func convertStringToDate(date: String) -> Date {
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale // save locale temporarily
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        var date = dateFormatter.date(from: date) ?? Date()
        return date
    }
    func convertStringToDateForProfile(date: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZZZZZ"
        let date = dateFormatter.date(from: date) ?? Date()
        return date
    }
    func getCleanedURL() -> URL? {
        guard self.isEmpty == false else {
            return nil
        }
        if let url = URL(string: self) {
            return url
        } else {
            if let urlEscapedString = self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) , let escapedURL = URL(string: urlEscapedString){
                return escapedURL
            }
        }
        return nil
    }
    
    func getSeparatedFirstName() -> String{
        var firstName = ""
        var components = self.components(separatedBy: " ")
        if components.count > 0 {
         firstName = components.removeFirst()
         let lastName = components.joined(separator: " ")
         debugPrint(firstName)
        }
        
        return firstName
    }
    
    func getSeparatedLastName() -> String{
        var lastName = ""
        var components = self.components(separatedBy: " ")
        if components.count > 0 {
         let firstName = components.removeFirst()
         lastName = components.joined(separator: " ")
         debugPrint(lastName)
        }
        return lastName
    }
    

    func generateQRCode(qrCodeImageView:UIImageView) -> UIImage? {
        if let data = Data(base64Encoded: self) {
            let qrFilter = CIFilter(name: "CIQRCodeGenerator")
            qrFilter?.setValue(data, forKey: "inputMessage")

            if let qrImage = qrFilter?.outputImage {
                let scaleX = qrCodeImageView.frame.size.width / qrImage.extent.size.width
                let scaleY = qrCodeImageView.frame.size.height / qrImage.extent.size.height
                let transformedImage = qrImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))

                return UIImage(ciImage: transformedImage)
            }
        }

        return nil
    }
    
    func base64ToImage() -> UIImage? {
        if let url = URL(string: self),let data = try? Data(contentsOf: url),let image = UIImage(data: data) {
            return image
        }
        return nil
    }
    
    func getCountry() -> String{
        return Locale.current.localizedString(forRegionCode: Locale.current.regionCode ?? "") ?? "Toronto"
    }
    // Passwords Validations
    func isValidPasswords(password: String) -> Bool {
        let passRegEx = "^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[!@#$%^&*()_+\\-={};:',.<>?/\\|]).{8,}$"
        let passPred = NSPredicate(format: "SELF MATCHES %@", passRegEx)
        return passPred.evaluate(with: password)
    }
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    func isValidEmail(emaiId: String) -> Bool {
        let emailRegEx = NSPredicate(format: "SELF MATCHES %@",
                                     "^([a-zA-Z0-9_\\-\\.]+)@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\\]?)$")
        return emailRegEx.evaluate(with: emaiId)
    }
    var isContainsOnlyNumber: Bool {
        return self.range(
            of: "^[0-9]*$",
            options: .regularExpression) != nil
    }
}

extension StringProtocol {
    var firstUppercased: String { return prefix(1).uppercased() + dropFirst() }
    var firstCapitalized: String { return prefix(1).capitalized + dropFirst() }
}

//
//  UserDefaultManager.swift
//  TicketGateway
//
//  Created by Apple  on 19/04/23.
//

import UIKit

import Foundation
import SwiftUI

class UserDefaultManager {
    
    static let share = UserDefaultManager()
    
    let defaults = UserDefaults.standard
    private let keyIsLikedAnyEvent = "isLikedAnyEvent"
    // In use
    private let isAlreadyLoginKey = "isAlreadyLogin"
    private let scanEventIdKey = "scanEventIdKey"
    private let selectedTicketsKey = "selectedTickets"
    func storeModelToUserDefault<T>(userData: T, key: UserDefaultModelKeys) where T: Codable {
        defaults.set(try? JSONEncoder().encode(userData), forKey: key.rawValue)
    }
    
    func getModelDataFromUserDefults<T: Codable>(userData: T.Type, key: UserDefaultModelKeys) -> T? {
        print(userData)
        guard let data = defaults.data(forKey: key.rawValue) else {
            return nil
        }
        guard let value = try? JSONDecoder().decode(T.self, from: data) else {
            fatalError("unable to decode this data")
        }
        return value
    }
    func removeUserDefualtsModels(key: UserDefaultModelKeys) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }
    
    func getDataFromUserDefults(key: UserDefaultModelKeys) {
        
    }
    
    func getFirstNameFromFullName(fullName: String) -> (String) {
        let components = fullName.components(separatedBy: " ")
        
        if components.count == 2 {
            let firstName = components[0]
            let lastName = components[1]
            return (firstName)
        } else {
            // Handle cases where the full name does not consist of exactly two parts
            return ("")
        }
    }
    
    func getLastNameFromFullName(fullName: String) -> (String) {
        let components = fullName.components(separatedBy: " ")
        
        if components.count == 2 {
            let firstName = components[0]
            let lastName = components[1]
            return (lastName)
        } else {
            // Handle cases where the full name does not consist of exactly two parts
            return ("")
        }
    }
    
    func clearAllUserDataAndModel() {
        removeUserdefultsKey(key: .userAuthData)
        
    }
    
    func removeUserdefultsKey(key: UserDefaultKeys) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }
    
  
}

extension UserDefaultManager {
    func guestUserLogin(value: Bool, key: UserDefaultKeys){
        UserDefaults.standard.setValue(value, forKey: key.rawValue)
    }
    
    func setUserLoginUserDefaultValue(value: [String: Any], key: UserDefaultKeys) {
        UserDefaults.standard.setValue(value, forKey: key.rawValue)
    }
    func getUserLoginUserDefaultValue(key: UserDefaultKeys) -> [String: Any] {
        return UserDefaults.standard.value(forKey: key.rawValue) as? [String: Any] ?? [:]
    }
    
    func setUserStressLevelValue(value: Date, key: UserDefaultKeys) {
        UserDefaults.standard.setValue(value, forKey: key.rawValue)
    }
    func getUserStressLevelValue(key: UserDefaultKeys) -> Date? {
        return UserDefaults.standard.value(forKey: key.rawValue) as? Date ?? nil
    }
    
    func setUserBoolValue(value: Bool, key: UserDefaultKeys) {
        UserDefaults.standard.setValue(value, forKey: key.rawValue)
    }
    func getUserBoolValue(key: UserDefaultKeys) -> Bool {
        return UserDefaults.standard.value(forKey: key.rawValue) as? Bool ?? false
    }
    
    func setUserStirngValue(value: String, key: UserDefaultKeys) {
        UserDefaults.standard.setValue(value, forKey: key.rawValue)
    }
    func getUserStirngValue(key: UserDefaultKeys) -> String {
        return UserDefaults.standard.value(forKey: key.rawValue) as? String ?? ""
    }
    // In use
    func saveScanEventId(eventId: String) {
        UserDefaults.standard.set(eventId, forKey: scanEventIdKey)
    }
    func getScanEventId() -> String? {
        guard let token = UserDefaults.standard.string(forKey: scanEventIdKey) else {
            return nil
        }
        return token
    }
    func removeScanEventId() {
        UserDefaults.standard.removeObject(forKey: scanEventIdKey)
    }
    func setSelectedTicketTypes(selectedTickets: [GetTicketTypesResponseModel]) {
        if let encodedSelectedTickets = try? JSONEncoder().encode(selectedTickets) {
            UserDefaults.standard.set(encodedSelectedTickets, forKey: selectedTicketsKey)
        }
    }
    func getSelectedTicketTypes() -> [GetTicketTypesResponseModel] {
        if let data = UserDefaults.standard.object(forKey: selectedTicketsKey) as? Data,
           let selectedTickets = try? JSONDecoder().decode(
            [GetTicketTypesResponseModel].self,
            from: data
           ) {
             return selectedTickets
        }
        return []
    }
    func removeSelectedTicketTypes() {
        UserDefaults.standard.removeObject(forKey: selectedTicketsKey)
    }
}

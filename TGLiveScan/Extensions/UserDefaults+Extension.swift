//
//  UserDefaults.swift
//  TicketGateway
//
//  Created by Apple  on 10/04/23.
//

import Foundation
import AVKit

extension UserDefaults {
    func saveEmail(_ email: String?) {
        set(email, forKey: "email")
        synchronize()
    }
    var email: String? {
        value(forKey: "email") as? String
    }
    
    func saveToken(_ token: String?) {
        set(token, forKey: "token")
        synchronize()
    }
    var token: String? {
        value(forKey: "token") as? String
    }
    
    func saveLastLoginDate(_ date: String?) {
        set(date, forKey: "curruntDate")
        synchronize()
    }
    var lastLoginDate: String? {
        value(forKey: "curruntDate") as? String
    }
    
    func saveUserImage(_ img: Data?) {
        set(img, forKey: "userImage")
        synchronize()
    }
    var getUserImage: Data? {
        value(forKey: "userImage") as? Data
    }
    
    func saveBiometricEnabled(_ isEnable: Bool?) {
        set(isEnable, forKey: "biometric")
        synchronize()
    }
    var isBiometricEnabled: Bool? {
        value(forKey: "biometric") as? Bool
    }
    
//    var userDetail: AuthoriseUserModel? {
//        get {
//            if let stringValue = string(forKey: #function), let data = stringValue.data(using: .utf8) {
//                do {
//                    return try JSONDecoder().decode(AuthoriseUserModel.self, from: data)
//                } catch {
//                    print("Error in parsing")
//                }
//            }
//            return nil
//        }
//        set {
//            guard let data = try? JSONEncoder().encode(newValue) else { return }
//            let responseString = String(data: data, encoding: String.Encoding.utf8)
//            set(responseString, forKey: #function)
//        }
//    }
//    
//    var userProfile: GetProfileModel? {
//        get {
//            if let stringValue = string(forKey: #function), let data = stringValue.data(using: .utf8) {
//                do {
//                    return try JSONDecoder().decode(GetProfileModel.self, from: data)
//                } catch {
//                    print("Error in parsing")
//                }
//            }
//            return nil
//        }
//        set {
//            guard let data = try? JSONEncoder().encode(newValue) else { return }
//            let responseString = String(data: data, encoding: String.Encoding.utf8)
//            set(responseString, forKey: #function)
//        }
//    }
}

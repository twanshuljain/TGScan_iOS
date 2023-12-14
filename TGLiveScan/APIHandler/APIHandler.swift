//
//  APIHandler.swift
//  BrakingCalculator
//
//  Created by Apple on 28/06/22.
//

import SVProgressHUD
import UIKit
public enum MethodType: String {
    case POST, GET, PUT, DELETE
}
public enum APIName: String {
    //******SignUp*******//
    case signUpEmail = "auth/signup-email/"
    case signInNumber = "auth/user/login/mobile/"
    case verifyEmailOtp = "auth/verify-otp/"
    case verifyNumberOtp = "auth/user/login/mobile/otp/verify/"
    case checkoutVerifyNumberOtp = "payment/checkout/verify-otp/"
    case checkoutVerifyResendOtp = "payment/checkout/resend-otp/"
    case registerUser = "auth/register/"
    case signInUser = "auth/user/login/"
    case signInUserByNumberEmail = "auth/user/mobile-linked/email/login/"
    case forgotPassword = "auth/user/forget-password/"
    case logoutUser = ""
    //******HOME*******//
    case GetEventList = "events/list/"
    case GetEventListCategoryWise = "events/filter-types/list/"
    case GetEventDetail = "events/detail/"
    case GetMultiLocationList = "events/multilocation/list/"
    case GetRecurringList = "events/recurring/list/"
    case GetEventCategoryList = "events/category/list/"
    case GetEventSubCategoryList =  "events/sub/category/list/"
    case GetEventSuggestedCategoryList = "events/suggestion/" //"events/category/"
    case GetOrganizersList = "organizer/featured-organizer/list/"
    case organizerSuggestedList = "organizer/suggested/list/"
    
    case GetEventSearchByCategory = "events/event/search/category/"
    case GetEventSearch = "events/event/search/category/?"
    
    case GetTicketList = "events/show-ticket/"
    case getAddOnList = "events/ticket-add-on-list/"
    case GetFeeStructure = "events/charges/"
    //case GetFeeStructure = "default/data/fee/structure/get/"
    case favoriteEvents = "events/like/unlike/"
    case followUnfollow = "organizer/follow-unfollow/"
    
    case checkEmail = "payment/check-email/checkout-user"
    
    case downloadTicket = "ticket/myticket/download/"
    
    //STRIPE
    case CreateStripeCustomer = "payment/stripe/create-customer/"
    case AddCardForUser = "payment/add-card/"
    case CreateCheckout = "payment/checkout/"
    case CreateCharge = "payment/stripe/create-charge/"
    case checkoutValidateUser = "payment/validate/checkout-user/"
    case cardList = "payment/customer/card/list/"
    
    case ApplyAccessCode = "ticket/apply/access-code/"
    case applyPromoCode = "ticket/apply/promo-code/"
    
    // Orders
    case myOrders = "events/my/order/"
    // Get Favourite List
    case myFavourite = "events/like/list/"
    case myVenue = "venue/like/list/"
    case venueLikeDislike = "venue/like-unlike/"
    
    case ContactOrganizer = "organizer/contact/form/"
    case ChangeTicketName = "ticket/transfer/user-name/change/"
    case GetMyTicketList = "ticket/my-ticket/list/"
    case TransferTicket = "ticket/transfer/"
    case ResendTicketTransfer = "ticket/re-transfer/details/"
    
    // Profile Tab
    case getUserProfileData = "auth/me/"
    case updateUserProfileData = "auth/user/update/profile/"
    
    // Scan Ticket
    case loginScan = "ticketscanapi/livescan.php"//"tgscan/login/"
    case getTickets = "ticketscanapi/get_tickets.php"
    case updateTickets = "ticketscanapi/update_tixids.php"
    case scanCount = "ticketscanapi/scancount.php?"
    case scanBarCode = "ticketscanapi/livescan.php?"
    case getEmailOrders = "ticketscanapi/get_emailorders.php"
    case updateEmailsEntry = "ticketscanapi/confim_orderemail_v2.php"
    case offlineFetchBarcode = "ticketscanapi/fetch_barcode.php"
    case scanDetail = "tgscan/scan/detail"
    case scanSummary = "tgscan/scan/summary/"
}
public enum GroupApiName: String {
    case auth = "auth"
}
struct ResponseCode {
    static let success = 200
    static let sessionExpire = 401
    static let serverError = 500
}
class APIHandler: NSObject {
    static var shared = APIHandler()
    private override init() {}
    private let session = URLSession.shared
    var baseURL = "https://www.ticketgateway.com/" //"http://3.21.114.70/"
    //let baseURL = "http://3.19.250.147/"
    let previousBaseURL = "http://18.224.21.11/"
    let s3URL = "https://tw-staging-media.s3.us-east-2.amazonaws.com/"
    private let boundary = "Boundary-\(NSUUID().uuidString)"
    
    
    func executeRequestWith<T: Decodable, U: Encodable>(of type: T.Type = T.self, apiName: APIName, parameters: U?, methodType: MethodType, getURL: String? = "",  authRequired: Bool = true, authTokenString:Bool? = false, complition: @escaping(Result<ResponseModal<T>, Error>) -> Void) {
        
        var finalURL = baseURL + apiName.rawValue
        
        if methodType == .GET{
            if let URL = getURL, URL != ""  {
                finalURL = baseURL + URL
            }
        }else if methodType == .POST && (apiName == .followUnfollow || apiName == .ChangeTicketName || apiName == .TransferTicket){
            if let URL = getURL, URL != ""  {
                finalURL = baseURL + URL
            }
        }else if methodType == .POST && parameters == nil{
            if let URL = getURL, URL != ""  {
                finalURL = baseURL + URL
            }
        }
        
        guard var requestURL = URL(string: finalURL) else {
            complition(.failure("Incorrect request URL"))
            return
        }
      finalURL = finalURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
//        if methodType == .GET{
//            if let URL = getURL, URL != ""  {
//                if #available(iOS 16.0, *) {
//                    requestURL = requestURL.appending(queryItems: [URLQueryItem.init(name: "", value: "39")])
//                } else {
//                    // Fallback on earlier versions
//                }
//            }
//        }
        
        if methodType == .GET{
            if parameters != nil {
              //  if #available(iOS 16.0, *) {
                    let param = try? JSONEncoder().encode(parameters!)
                    do {
                        let json = try JSONSerialization.jsonObject(with: param!, options: []) as? [String : Any]
                       // print("---------------", json ?? "")
//                        requestURL = requestURL.appending(queryItems: [URLQueryItem.init(name: json?.keys.first ?? "", value: (json?.values.first as? String) ?? "")])
                        var queryItems = [URLQueryItem]()
                        for (key, value) in json! {
                            let queryItem = URLQueryItem(name: key, value: "\(value)")
                            queryItems.append(queryItem)
                        }
                        requestURL =  requestURL.appending(queryItems) ?? requestURL
                        
                    } catch {
                        print("errorMsg")
                    }
                    //requestURL = requestURL.appending(queryItems: [URLQueryItem.init(name: param, value: "39")])
//                } else {
//                    // Fallback on earlier versions
//                }
            }
        }
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = methodType.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        /*
         if authTokenString == true{
            if let token = userModel?.accessToken {
                request.setValue("Bearer "+token, forHTTPHeaderField: "Authorization")
             }
         }else{
             if authRequired, let token = userModel?.accessToken {
                 print("userModel?.accessToken........ ",userModel!.accessToken! )
                 request.setValue("Bearer "+token, forHTTPHeaderField: "Authorization")
             }
         }
         */
        
        let userModel = UserDefaultManager.share.getModelDataFromUserDefults(userData: SignInAuthModel.self, key: .userAuthData)
        
        if authRequired, let token = userModel?.accessToken {
            print("userModel?.accessToken........ ",userModel!.accessToken! )
            request.setValue("Bearer "+token, forHTTPHeaderField: "Authorization")
        }
        debugPrint("finalURL is \(finalURL)")
        debugPrint("parameters is \(String(describing: parameters))")
        
        if methodType == .POST{
            if parameters != nil {
                let param = try? JSONEncoder().encode(parameters!)
                request.httpBody = param
            }
        }
        
       
      
        print("\(request.httpMethod ?? "") \(request.url)")
        let str = String(decoding: request.httpBody ?? Data(), as: UTF8.self)
        print("BODY \n \(str)")
        print("HEADERS \n \(request.allHTTPHeaderFields)")
        
        session.dataTask(with: request) { data, response, error in
            var httpStatusCode = 0
            if let httpResponse = response as? HTTPURLResponse {
                httpStatusCode = httpResponse.statusCode
            }
            if error != nil {
                complition(.failure(error?.localizedDescription ?? "Something went wrong"))
            } else {
                if httpStatusCode == 401 {
                    // Refresh Token
                    if let fbData = data {
                        let message = String(decoding: fbData, as: UTF8.self)
                        complition(.failure(message))
                    } else {
                        let message = response?.url?.lastPathComponent
                        complition(.failure("API \(message ?? "") Invalid Response."))
                    }
                } else if httpStatusCode == 200, let data = data {
                    let JSON = self.nsdataToJSON(data: data as NSData)
                    print("----------------JSON in APIClient", JSON)
                    do {
                        let responseModel = try JSONDecoder().decode(ResponseModal<T>.self, from: data)
                        complition(.success(responseModel))
                    }
                    catch {
                        print(error)
                    }
                } else {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
                        complition(.failure(json["message"] as? String ?? "something went wrong"))
                    } catch {
                        complition(.failure("Unable to get json."))
                    }
                }
            }
        }.resume()
    }
    // Api Calling//etc called
    func executeClientRequestWith<U: Encodable>(apiName: String, parameters: U?, methodType: MethodType, authRequired: Bool = true, complition: @escaping(Data?, Error?) -> Void) {
        SVProgressHUD.show()
        let finalURL = baseURL + apiName
        guard let requestURL = URL(string: finalURL) else {
            complition(nil, "Incorrect request URL")
            return
        }
        var request = URLRequest(url: requestURL)
        request.httpMethod = methodType.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if authRequired, let token = UserDefaults.standard.token {
            request.setValue(token, forHTTPHeaderField: "Authorization")
        }
        debugPrint("finalURL is \(finalURL)")
        debugPrint("parameters is \(String(describing: parameters))")
        if parameters != nil {
            let param = try? JSONEncoder().encode(parameters!)
            request.httpBody = param
        }
        session.dataTask(with: request) { data, response, error in
            var httpStatusCode = 0
            if let httpResponse = response as? HTTPURLResponse {
                httpStatusCode = httpResponse.statusCode
            }
            if error != nil {
                complition(nil, error?.localizedDescription ?? "Something went wrong")
                SVProgressHUD.dismiss()
            } else {
                if httpStatusCode > 200 && httpStatusCode < 500 {
                    // Refresh Token
                    if let fbData = data {
                        let message = String(decoding: fbData, as: UTF8.self)
                        complition(nil, message)
                        SVProgressHUD.dismiss()
                    } else {
                        let message = "Something went wrong with api \(response?.url?.lastPathComponent ?? "")"
                        complition(nil, message)
                        SVProgressHUD.dismiss()
                    }
                } else if httpStatusCode == 200, let data = data {
                    do {
                        complition(data, nil)
                        SVProgressHUD.dismiss()
                    } catch {
                        debugPrint(data)
                        complition(nil, "Something went wrong")
                        SVProgressHUD.dismiss()
                    }
                } else {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
                        complition(nil , (json["message"] as? String ?? "something went wrong"))
                        SVProgressHUD.dismiss()
                    } catch {
                        complition(nil, "Something went wrong")
                        SVProgressHUD.dismiss()
                    }
                }
            }
        }.resume()
    }
    
    
    func backgroundRequest(apiName: APIName, methodType: MethodType) {
        let strWorkoutId = "RealmDBManager.shared.tasks.last?.workoutId"
        let sem = DispatchSemaphore(value: 0)
        let finalURL = baseURL + apiName.rawValue
        guard let requestURL = URL(string: finalURL) else {
            return
        }
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let token = UserDefaults.standard.token {
            request.setValue(token, forHTTPHeaderField: "Authorization")
        }
        let params = ["status_id": strWorkoutId]
        if params != nil {
            let param = try? JSONEncoder().encode(params)
            request.httpBody = param
        }
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            sem.signal()//When task complete then signal will call
        })
        task.resume()
        // sem.signal()
        sem.wait()//waiting until task complete
    }
    func nsdataToJSON(data: NSData) -> AnyObject? {
        do {
            return try JSONSerialization.jsonObject(with: data as Data, options: .mutableContainers) as AnyObject
        } catch let myJSONError {
            debugPrint(myJSONError)
        }
        return nil
    }
}
// You can take this extension outside of that class also
extension String: LocalizedError {
    public var errorDescription: String? { return self }
}
extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
extension APIHandler {
    func getPostString(params:[String:Any]) -> String {
        var data = [String]()
        for(key, value) in params {
            data.append(key + "=\(value)")
        }
        return data.map { String($0) }.joined(separator: "&")
    }
    // MARK: Scan Login API
    func scanLoginAPI(apiName: APIName, parameters: LoginScanModel,
                      methodType: MethodType,
                      complition: @escaping(Result<GetScanEventResponse, Error>) -> Void) {
        var requestURL = "\(APIHandler.shared.baseURL)\(apiName.rawValue)"
        var request = URLRequest(url: URL(string: requestURL)!)
        request.httpMethod = methodType.rawValue
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type")
        request.setValue(NSLocalizedString("lang", comment: ""), forHTTPHeaderField:"Accept-Language")
        let dictBody: [String: Any] = [
            "username": parameters.username,
            "device_id": UIDevice.current.identifierForVendor?.uuidString ?? "",
            "browser": parameters.browser,
            "pin": parameters.pin
        ]
        let postString = getPostString(params: dictBody as [String : Any])
        request.httpBody = postString.data(using: .utf8)
        
        print("Method/URL:-\(request.httpMethod ?? "") \(String(describing: request.url))")
        let str = String(decoding: request.httpBody ?? Data(), as: UTF8.self)
        print("BODY \n \(str)")
        print("HEADERS \n \(String(describing: request.allHTTPHeaderFields))")
        
        session.dataTask(with: request) { data, response, error in
            var httpStatusCode = 0
            if let httpResponse = response as? HTTPURLResponse {
                httpStatusCode = httpResponse.statusCode
            }
            if error != nil {
                complition(.failure(error?.localizedDescription ?? "Something went wrong"))
            } else {
                if httpStatusCode == 401 {
                    // Refresh Token
                    if let fbData = data {
                        let message = String(decoding: fbData, as: UTF8.self)
                        complition(.failure(message))
                    } else {
                        let message = response?.url?.lastPathComponent
                        complition(.failure("API \(message ?? "") Invalid Response."))
                    }
                } else if httpStatusCode == 200, let data = data {
                    let JSON = self.nsdataToJSON(data: data as NSData)
                    print("----------------JSON in APIClient", JSON as Any)
                    do {
                        let responseModel = try JSONDecoder().decode(GetScanEventResponse.self, from: data)
                        complition(.success(responseModel))
                    }
                    catch {
                        print(error)
                    }
                } else {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
                        complition(.failure(json["message"] as? String ?? "something went wrong"))
                    } catch {
                        complition(.failure("Unable to get json."))
                    }
                }
            }
        }.resume()
    }
    // MARK: Get Ticket List
    func getTicketTypeList(apiName: APIName, eventId: Int,
                           methodType: MethodType,
                           complition: @escaping(Result<[GetTicketTypesResponseModel], Error>) -> Void) {
        var requestURL = "\(APIHandler.shared.baseURL)\(apiName.rawValue)"
        var request = URLRequest(url: URL(string: requestURL)!)
        request.httpMethod = methodType.rawValue
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type")
        request.setValue(NSLocalizedString("lang", comment: ""), forHTTPHeaderField:"Accept-Language")
        let dictBody: [String: Any] = [
            "event_id": eventId
        ]
        let postString = getPostString(params: dictBody as [String : Any])
        request.httpBody = postString.data(using: .utf8)
        
        print("Method/URL:-\(request.httpMethod ?? "") \(String(describing: request.url))")
        let str = String(decoding: request.httpBody ?? Data(), as: UTF8.self)
        print("BODY \n \(str)")
        print("HEADERS \n \(String(describing: request.allHTTPHeaderFields))")
        
        session.dataTask(with: request) { data, response, error in
            var httpStatusCode = 0
            if let httpResponse = response as? HTTPURLResponse {
                httpStatusCode = httpResponse.statusCode
            }
            if error != nil {
                complition(.failure(error?.localizedDescription ?? "Something went wrong"))
            } else {
                if httpStatusCode == 401 {
                    // Refresh Token
                    if let fbData = data {
                        let message = String(decoding: fbData, as: UTF8.self)
                        complition(.failure(message))
                    } else {
                        let message = response?.url?.lastPathComponent
                        complition(.failure("API \(message ?? "") Invalid Response."))
                    }
                } else if httpStatusCode == 200, let data = data {
                    let JSON = self.nsdataToJSON(data: data as NSData)
                    print("----------------JSON in APIClient", JSON as Any)
                    do {
                        let responseModel = try JSONDecoder().decode([GetTicketTypesResponseModel].self, from: data)
                        complition(.success(responseModel))
                    }
                    catch {
                        print(error)
                    }
                } else {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
                        complition(.failure(json["message"] as? String ?? "something went wrong"))
                    } catch {
                        complition(.failure("Unable to get json."))
                    }
                }
            }
        }.resume()
    }
    // MARK: Update Tickets
    func updateTickets(apiName: APIName,
                       parameter: UpdateTicketModel,
                       methodType: MethodType,
                       complition: @escaping(Result<String, Error>) -> Void) {
        var requestURL = "\(APIHandler.shared.baseURL)\(apiName.rawValue)"
        var request = URLRequest(url: URL(string: requestURL)!)
        request.httpMethod = methodType.rawValue
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type")
        request.setValue(NSLocalizedString("lang", comment: ""), forHTTPHeaderField:"Accept-Language")
        let dictBody: [String: Any] = [
            "device_id": UIDevice.current.identifierForVendor?.uuidString ?? "",
            "ticket_ids": parameter.ticketIds,
            "event_id": parameter.eventId
        ]
        let postString = getPostString(params: dictBody as [String : Any])
        request.httpBody = postString.data(using: .utf8)
        
        print("Method/URL:-\(request.httpMethod ?? "") \(String(describing: request.url))")
        let str = String(decoding: request.httpBody ?? Data(), as: UTF8.self)
        print("BODY \n \(str)")
        print("HEADERS \n \(String(describing: request.allHTTPHeaderFields))")
        
        session.dataTask(with: request) { data, response, error in
            var httpStatusCode = 0
            if let httpResponse = response as? HTTPURLResponse {
                httpStatusCode = httpResponse.statusCode
                print("httpStatusCode:- \(httpStatusCode)")
            }
            if error != nil {
                complition(.failure(error?.localizedDescription ?? "Something went wrong"))
            } else {
                if httpStatusCode == 401 {
                    // Refresh Token
                    if let fbData = data {
                        let message = String(decoding: fbData, as: UTF8.self)
                        complition(.failure(message))
                    } else {
                        let message = response?.url?.lastPathComponent
                        complition(.failure("API \(message ?? "") Invalid Response."))
                    }
                } else if httpStatusCode == 200 {
                    complition(.success("Success"))
                } else {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
                        complition(.failure(json["message"] as? String ?? "something went wrong"))
                    } catch {
                        complition(.failure("Unable to get json."))
                    }
                }
            }
        }.resume()
    }
    // MARK: Get Scan Details (ScanCount)
    func getScanDetails(
        apiName: APIName,
        eventId: Int,
        methodType: MethodType,
        complition: @escaping(Result<GetScanDetailData, Error>) -> Void
    ) {
        let requestURL = "\(APIHandler.shared.baseURL)\(apiName.rawValue)"
        var request = URLRequest(url: URL(string: requestURL)!)
        request.httpMethod = methodType.rawValue
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type")
        request.setValue(NSLocalizedString("lang", comment: ""), forHTTPHeaderField:"Accept-Language")
        let dictBody: [String: Any] = [
            "device_id": UIDevice.current.identifierForVendor?.uuidString ?? "",
            "event_id": eventId
        ]
        let postString = getPostString(params: dictBody as [String : Any])
        request.httpBody = postString.data(using: .utf8)
        
        print("Method/URL:-\(request.httpMethod ?? "") \(String(describing: request.url))")
        let str = String(decoding: request.httpBody ?? Data(), as: UTF8.self)
        print("BODY \n \(str)")
        print("HEADERS \n \(String(describing: request.allHTTPHeaderFields))")
        
        session.dataTask(with: request) { data, response, error in
            var httpStatusCode = 0
            if let httpResponse = response as? HTTPURLResponse {
                httpStatusCode = httpResponse.statusCode
                print("httpStatusCode:- \(httpStatusCode)")
            }
            if error != nil {
                complition(.failure(error?.localizedDescription ?? "Something went wrong"))
            } else {
                if httpStatusCode == 401 {
                    // Refresh Token
                    if let fbData = data {
                        let message = String(decoding: fbData, as: UTF8.self)
                        complition(.failure(message))
                    } else {
                        let message = response?.url?.lastPathComponent
                        complition(.failure("API \(message ?? "") Invalid Response."))
                    }
                } else if httpStatusCode == 200, let data = data {
                    let JSON = self.nsdataToJSON(data: data as NSData)
                    print("----------------JSON in APIClient", JSON as Any)
                    do {
                        let responseModel = try JSONDecoder().decode(GetScanDetailData.self, from: data)
                        complition(.success(responseModel))
                    }
                    catch {
                        print(error)
                    }
                } else {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
                        complition(.failure(json["message"] as? String ?? "something went wrong"))
                    } catch {
                        complition(.failure("Unable to get json."))
                    }
                }
            }
        }.resume()
    }
    // MARK: Scan Bar Code
    func scanBarCode(
        apiName: APIName,
        parameter: ScanBarCodeModel,
        methodType: MethodType,
        complition: @escaping(Result<GetBarCodeScanResponse, Error>) -> Void
    ) {
        let requestURL = "\(APIHandler.shared.baseURL)\(apiName.rawValue)"
        var request = URLRequest(url: URL(string: requestURL)!)
        request.httpMethod = methodType.rawValue
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type")
        request.setValue(NSLocalizedString("lang", comment: ""), forHTTPHeaderField:"Accept-Language")
        let dictBody: [String: Any] = [
            "barcode": parameter.barcode,
            "event_id": parameter.eventId,
            "device_id": UIDevice.current.identifierForVendor?.uuidString ?? "",
            "opername": parameter.operatorName
        ]
        let postString = getPostString(params: dictBody as [String : Any])
        request.httpBody = postString.data(using: .utf8)
        
        print("Method/URL:-\(request.httpMethod ?? "") \(String(describing: request.url))")
        let str = String(decoding: request.httpBody ?? Data(), as: UTF8.self)
        print("BODY \n \(str)")
        print("HEADERS \n \(String(describing: request.allHTTPHeaderFields))")
        
        session.dataTask(with: request) { data, response, error in
            var httpStatusCode = 0
            if let httpResponse = response as? HTTPURLResponse {
                httpStatusCode = httpResponse.statusCode
                print("httpStatusCode:- \(httpStatusCode)")
            }
            if error != nil {
                complition(.failure(error?.localizedDescription ?? "Something went wrong"))
            } else {
                if httpStatusCode == 401 {
                    // Refresh Token
                    if let fbData = data {
                        let message = String(decoding: fbData, as: UTF8.self)
                        complition(.failure(message))
                    } else {
                        let message = response?.url?.lastPathComponent
                        complition(.failure("API \(message ?? "") Invalid Response."))
                    }
                } else if httpStatusCode == 200, let data = data {
                    let JSON = self.nsdataToJSON(data: data as NSData)
                    print("----------------JSON in APIClient", JSON as Any)
                    do {
                        let responseModel = try JSONDecoder().decode(GetBarCodeScanResponse.self, from: data)
                        complition(.success(responseModel))
                    }
                    catch {
                        print(error)
                    }
                } else {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
                        complition(.failure(json["message"] as? String ?? "something went wrong"))
                    } catch {
                        complition(.failure("Unable to get json."))
                    }
                }
            }
        }.resume()
    }
    // MARK: Get Scan Summary
    func getScanSummary(
        apiName: APIName,
        parameter: [String: Any],
        methodType: MethodType,
        complition: @escaping(Result<GetScanSummaryResponse, Error>) -> Void
    ) {
        let requestURL = "\(APIHandler.shared.baseURL)\(apiName.rawValue)"
        var request = URLRequest(url: URL(string: requestURL)!)
        request.httpMethod = methodType.rawValue
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type")
        request.setValue(NSLocalizedString("lang", comment: ""), forHTTPHeaderField:"Accept-Language")
        let postString = getPostString(params: parameter as [String : Any])
        request.httpBody = postString.data(using: .utf8)
        
        print("Method/URL:-\(request.httpMethod ?? "") \(String(describing: request.url))")
        let str = String(decoding: request.httpBody ?? Data(), as: UTF8.self)
        print("BODY \n \(str)")
        print("HEADERS \n \(String(describing: request.allHTTPHeaderFields))")
        
        session.dataTask(with: request) { data, response, error in
            var httpStatusCode = 0
            if let httpResponse = response as? HTTPURLResponse {
                httpStatusCode = httpResponse.statusCode
                print("httpStatusCode:- \(httpStatusCode)")
            }
            if error != nil {
                complition(.failure(error?.localizedDescription ?? "Something went wrong"))
            } else {
                if httpStatusCode == 401 {
                    // Refresh Token
                    if let fbData = data {
                        let message = String(decoding: fbData, as: UTF8.self)
                        complition(.failure(message))
                    } else {
                        let message = response?.url?.lastPathComponent
                        complition(.failure("API \(message ?? "") Invalid Response."))
                    }
                } else if httpStatusCode == 200, let data = data {
                    let JSON = self.nsdataToJSON(data: data as NSData)
                    print("----------------JSON in APIClient", JSON as Any)
                    do {
                        let responseModel = try JSONDecoder().decode(GetScanSummaryResponse.self, from: data)
                        complition(.success(responseModel))
                    }
                    catch {
                        print(error)
                        complition(.failure(error))
                    }
                } else {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
                        complition(.failure(json["message"] as? String ?? "something went wrong"))
                    } catch {
                        complition(.failure("Unable to get json."))
                    }
                }
            }
        }.resume()
    }
    // MARK: Offline Fetch Bar Code
    func offlineFetchBarCode(
        apiName: APIName,
        parameter: OfflineFetchBarCodeModel,
        methodType: MethodType,
        complition: @escaping(Result<GetOfflineFetchBarCodeResponse, Error>) -> Void
    ) {
        let requestURL = "\(APIHandler.shared.baseURL)\(apiName.rawValue)"
        var request = URLRequest(url: URL(string: requestURL)!)
        request.httpMethod = methodType.rawValue
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type")
        request.setValue(NSLocalizedString("lang", comment: ""), forHTTPHeaderField:"Accept-Language")
        let dictBody: [String: Any] = [
            "status": parameter.status,
            "event_id": parameter.eventId
        ]
        let postString = getPostString(params: dictBody as [String : Any])
        request.httpBody = postString.data(using: .utf8)
        
        print("Method/URL:-\(request.httpMethod ?? "") \(String(describing: request.url))")
        let str = String(decoding: request.httpBody ?? Data(), as: UTF8.self)
        print("BODY \n \(str)")
        print("HEADERS \n \(String(describing: request.allHTTPHeaderFields))")
        
        session.dataTask(with: request) { data, response, error in
            var httpStatusCode = 0
            if let httpResponse = response as? HTTPURLResponse {
                httpStatusCode = httpResponse.statusCode
                print("httpStatusCode:- \(httpStatusCode)")
            }
            if error != nil {
                complition(.failure(error?.localizedDescription ?? "Something went wrong"))
            } else {
                if httpStatusCode == 401 {
                    // Refresh Token
                    if let fbData = data {
                        let message = String(decoding: fbData, as: UTF8.self)
                        complition(.failure(message))
                    } else {
                        let message = response?.url?.lastPathComponent
                        complition(.failure("API \(message ?? "") Invalid Response."))
                    }
                } else if httpStatusCode == 200, let data = data {
                    let JSON = self.nsdataToJSON(data: data as NSData)
                    print("----------------JSON in APIClient", JSON as Any)
                    do {
                        let responseModel = try JSONDecoder().decode(GetOfflineFetchBarCodeResponse.self, from: data)
                        complition(.success(responseModel))
                    }
                    catch {
                        complition(.failure(error))
                        print(error)
                    }
                } else {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
                        complition(.failure(json["message"] as? String ?? "something went wrong"))
                    } catch {
                        complition(.failure("Unable to get json."))
                    }
                }
            }
        }.resume()
    }
    // MARK: Get Email Order Search
    func getEmailOrders(
        apiName: APIName,
        parameter: EmailSearchDataModel,
        methodType: MethodType,
        complition: @escaping(Result<[GetEmailOrdersResponse], Error>) -> Void
    ) {
        let requestURL = "\(APIHandler.shared.baseURL)\(apiName.rawValue)"
        var request = URLRequest(url: URL(string: requestURL)!)
        request.httpMethod = methodType.rawValue
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type")
        request.setValue(NSLocalizedString("lang", comment: ""), forHTTPHeaderField:"Accept-Language")
        let dictBody: [String: Any] = [
            "email_id": parameter.emailId,
            "event_id": parameter.eventId
        ]
        let postString = getPostString(params: dictBody as [String : Any])
        request.httpBody = postString.data(using: .utf8)
        
        print("Method/URL:-\(request.httpMethod ?? "") \(String(describing: request.url))")
        let str = String(decoding: request.httpBody ?? Data(), as: UTF8.self)
        print("BODY \n \(str)")
        print("HEADERS \n \(String(describing: request.allHTTPHeaderFields))")
        
        session.dataTask(with: request) { data, response, error in
            var httpStatusCode = 0
            if let httpResponse = response as? HTTPURLResponse {
                httpStatusCode = httpResponse.statusCode
                print("httpStatusCode:- \(httpStatusCode)")
            }
            if error != nil {
                complition(.failure(error?.localizedDescription ?? "Something went wrong"))
            } else {
                if httpStatusCode == 401 {
                    // Refresh Token
                    if let fbData = data {
                        let message = String(decoding: fbData, as: UTF8.self)
                        complition(.failure(message))
                    } else {
                        let message = response?.url?.lastPathComponent
                        complition(.failure("API \(message ?? "") Invalid Response."))
                    }
                } else if httpStatusCode == 200, let data = data {
                    let JSON = self.nsdataToJSON(data: data as NSData)
                    print("----------------JSON in APIClient", JSON as Any)
                    do {
                        let responseModel = try JSONDecoder().decode([GetEmailOrdersResponse].self, from: data)
                        complition(.success(responseModel))
                    }
                    catch {
                        print(error)
                    }
                } else {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
                        complition(.failure(json["message"] as? String ?? "something went wrong"))
                    } catch {
                        complition(.failure("Unable to get json."))
                    }
                }
            }
        }.resume()
    }
    // MARK: Update Email Order Get Entry
    func getEmailOrders(
        apiName: APIName,
        parameter: UpdateEmailEntry,
        methodType: MethodType,
        complition: @escaping(Result<UpdateEmailOrderResponse, Error>) -> Void
    ) {
        let requestURL = "\(APIHandler.shared.baseURL)\(apiName.rawValue)"
        var request = URLRequest(url: URL(string: requestURL)!)
        request.httpMethod = methodType.rawValue
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type")
        request.setValue(NSLocalizedString("lang", comment: ""), forHTTPHeaderField:"Accept-Language")
        let dictBody: [String: Any] = [
            "device_id": UIDevice.current.identifierForVendor?.uuidString ?? "",
            "event_id": parameter.eventId,
            "barcode_list": parameter.barCodeList,
            "opername": parameter.operatorName,
            "order_id": parameter.orderId
        ]
        let postString = getPostString(params: dictBody as [String : Any])
        request.httpBody = postString.data(using: .utf8)
        
        print("Method/URL:-\(request.httpMethod ?? "") \(String(describing: request.url))")
        let str = String(decoding: request.httpBody ?? Data(), as: UTF8.self)
        print("BODY \n \(str)")
        print("HEADERS \n \(String(describing: request.allHTTPHeaderFields))")
        
        session.dataTask(with: request) { data, response, error in
            var httpStatusCode = 0
            if let httpResponse = response as? HTTPURLResponse {
                httpStatusCode = httpResponse.statusCode
                print("httpStatusCode:- \(httpStatusCode)")
            }
            if error != nil {
                complition(.failure(error?.localizedDescription ?? "Something went wrong"))
            } else {
                if httpStatusCode == 401 {
                    // Refresh Token
                    if let fbData = data {
                        let message = String(decoding: fbData, as: UTF8.self)
                        complition(.failure(message))
                    } else {
                        let message = response?.url?.lastPathComponent
                        complition(.failure("API \(message ?? "") Invalid Response."))
                    }
                } else if httpStatusCode == 200, let data = data {
                    let JSON = self.nsdataToJSON(data: data as NSData)
                    print("----------------JSON in APIClient", JSON as Any)
                    do {
                        let responseModel = try JSONDecoder().decode(UpdateEmailOrderResponse.self, from: data)
                        complition(.success(responseModel))
                    }
                    catch {
                        print(error)
                    }
                } else {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
                        complition(.failure(json["message"] as? String ?? "something went wrong"))
                    } catch {
                        complition(.failure("Unable to get json."))
                    }
                }
            }
        }.resume()
    }
    // MARK: Get Bar Code Searched Data
    func getBarCodeSearchedData(
        apiName: APIName,
        parameter: ScanBarCodeModel,
        methodType: MethodType,
        complition: @escaping(Result<GetBarCodeSearchedResponse, Error>) -> Void
    ) {
        let requestURL = "\(APIHandler.shared.baseURL)\(apiName.rawValue)"
        var request = URLRequest(url: URL(string: requestURL)!)
        request.httpMethod = methodType.rawValue
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type")
        request.setValue(NSLocalizedString("lang", comment: ""), forHTTPHeaderField:"Accept-Language")
        let dictBody: [String: Any] = [
            "device_id": UIDevice.current.identifierForVendor?.uuidString ?? "",
            "event_id": parameter.eventId,
            "barcode": parameter.barcode,
            "opername": parameter.operatorName
        ]
        let postString = getPostString(params: dictBody as [String : Any])
        request.httpBody = postString.data(using: .utf8)
        
        print("Method/URL:-\(request.httpMethod ?? "") \(String(describing: request.url))")
        let str = String(decoding: request.httpBody ?? Data(), as: UTF8.self)
        print("BODY \n \(str)")
        print("HEADERS \n \(String(describing: request.allHTTPHeaderFields))")
        
        session.dataTask(with: request) { data, response, error in
            var httpStatusCode = 0
            if let httpResponse = response as? HTTPURLResponse {
                httpStatusCode = httpResponse.statusCode
                print("httpStatusCode:- \(httpStatusCode)")
            }
            if error != nil {
                complition(.failure(error?.localizedDescription ?? "Something went wrong"))
            } else {
                if httpStatusCode == 401 {
                    // Refresh Token
                    if let fbData = data {
                        let message = String(decoding: fbData, as: UTF8.self)
                        complition(.failure(message))
                    } else {
                        let message = response?.url?.lastPathComponent
                        complition(.failure("API \(message ?? "") Invalid Response."))
                    }
                } else if httpStatusCode == 200, let data = data {
                    let JSON = self.nsdataToJSON(data: data as NSData)
                    print("----------------JSON in APIClient", JSON as Any)
                    do {
                        let responseModel = try JSONDecoder().decode(GetBarCodeSearchedResponse.self, from: data)
                        complition(.success(responseModel))
                    }
                    catch {
                        print(error)
                    }
                } else {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
                        complition(.failure(json["message"] as? String ?? "something went wrong"))
                    } catch {
                        complition(.failure("Unable to get json."))
                    }
                }
            }
        }.resume()
    }
    // MARK: Get Bar Code Searched Data
    func sendReportToPromoter(
        apiName: APIName,
        eventId: Int,
        methodType: MethodType,
        complition: @escaping(Result<SendReportToPromoterResponseModel, Error>) -> Void
    ) {
        let requestURL = "\(APIHandler.shared.baseURL)\(apiName.rawValue)"
        var request = URLRequest(url: URL(string: requestURL)!)
        request.httpMethod = methodType.rawValue
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type")
        request.setValue(NSLocalizedString("lang", comment: ""), forHTTPHeaderField:"Accept-Language")
        let dictBody: [String: Any] = [
            "event_id": eventId,
            "email_to_send": "1"
        ]
        let postString = getPostString(params: dictBody as [String : Any])
        request.httpBody = postString.data(using: .utf8)
        
        print("Method/URL:-\(request.httpMethod ?? "") \(String(describing: request.url))")
        let str = String(decoding: request.httpBody ?? Data(), as: UTF8.self)
        print("BODY \n \(str)")
        print("HEADERS \n \(String(describing: request.allHTTPHeaderFields))")
        
        session.dataTask(with: request) { data, response, error in
            var httpStatusCode = 0
            if let httpResponse = response as? HTTPURLResponse {
                httpStatusCode = httpResponse.statusCode
                print("httpStatusCode:- \(httpStatusCode)")
            }
            if error != nil {
                complition(.failure(error?.localizedDescription ?? "Something went wrong"))
            } else {
                if httpStatusCode == 401 {
                    // Refresh Token
                    if let fbData = data {
                        let message = String(decoding: fbData, as: UTF8.self)
                        complition(.failure(message))
                    } else {
                        let message = response?.url?.lastPathComponent
                        complition(.failure("API \(message ?? "") Invalid Response."))
                    }
                } else if httpStatusCode == 200, let data = data {
                    let JSON = self.nsdataToJSON(data: data as NSData)
                    print("----------------JSON in APIClient", JSON as Any)
                    do {
                        let responseModel = try JSONDecoder().decode(SendReportToPromoterResponseModel.self, from: data)
                        complition(.success(responseModel))
                    }
                    catch {
                        print(error)
                    }
                } else {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
                        complition(.failure(json["message"] as? String ?? "something went wrong"))
                    } catch {
                        complition(.failure("Unable to get json."))
                    }
                }
            }
        }.resume()
    }
}

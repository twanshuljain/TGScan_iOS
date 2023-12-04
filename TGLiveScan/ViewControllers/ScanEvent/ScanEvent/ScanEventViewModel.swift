//
//  ScanEventViewModel.swift
//  TicketGateway
//
//  Created by Apple on 30/06/23.
//

import Foundation

class ScanEventViewModel {
    // MARK: - Variables
    var loginScanModel = LoginScanModel()
//    var eventId: String = ""
    var scanTicketDetails = ScanTicketDetails()
    var getScanEventResponse: GetScanEventResponse?
    func scanTicketApi(scanTicketModel: LoginScanModel, complition: @escaping (Bool, String) -> Void ) {
        APIHandler.shared.scanLoginAPI(apiName: .loginScan, parameters: loginScanModel, methodType: .POST) { (result: Result<GetScanEventResponse, Error>) in
            switch result {
            case .success(let response):
                if response.statusCode == "200" {
                    print("response....",response)
                    self.getScanEventResponse = response
                    self.getScanEventResponse?.userName = self.loginScanModel.username
                    
                    // Save user data in UserDefault
                    UserDefaultManager.share.storeModelToUserDefault(
                        userData: self.getScanEventResponse,
                        key: .userAuthData
                    )
                    print("after SAVE try to get scan id", UserDefaultManager.share.getModelDataFromUserDefults(userData: GetScanEventResponse.self, key: .userAuthData) as Any)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                        complition(true, response.message ?? "")
                    })
                } else {
                    complition(false,response.message ?? "error message")
                }
            case .failure(let error):
                complition(false,"\(error)")
            }
        }
    }
}

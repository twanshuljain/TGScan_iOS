//
//  SearchViewModel.swift
//  TicketGateway
//
//  Created by Apple on 30/06/23.

import Foundation

protocol DidPopupDismis {
    func updateDataAfterPopupDismissed(isFromCancel: Bool,
                                       selectedBarCodes: String)
}
class SearchViewModel: NSObject {
    var isFromSearchTxtField: Bool = false
    var updateTicketModel = UpdateTicketModel()
    // used
    var emailSearchDataModel: EmailSearchDataModel?
    var arrGetEmailOrdersResponse: [GetEmailOrdersResponse]?
    var orderId: String = ""
    var updateEmailEntry: UpdateEmailEntry?
    var emailId: String = "" // which user enter during search by email
    var scanBarCodeModel = ScanBarCodeModel()
    var getBarCodeSearchedResponse: GetBarCodeSearchedResponse?
    var arrGlobalSearchData: [[String: Any]] = [[:]]
    var isGlobalApiActive: Bool = false
   
    func getEmailSearchedData(emailId: String, complition: @escaping (Bool, String) -> Void) {
        self.emailSearchDataModel = EmailSearchDataModel(
            eventId: "\(updateTicketModel.eventId)",
            emailId: emailId
        )
        APIHandler.shared.getEmailOrders(
            apiName: .getEmailOrders,
            parameter: emailSearchDataModel ?? EmailSearchDataModel(),
            methodType: .POST
        ) { (result: Result<[GetEmailOrdersResponse], Error>) in
            switch result {
            case .success(let response):
                print("response....", response)
                self.arrGetEmailOrdersResponse = response
                complition(true, "Success")
            case .failure(let error):
                complition(false,"\(error)")
            }
        }
    }
    func getEmailOrders(selectedBarCode: String, complition: @escaping (Bool, String) -> Void) {
        self.updateEmailEntry = UpdateEmailEntry(
            eventId: "\(updateTicketModel.eventId)",
            barCodeList: selectedBarCode,
            operatorName: updateTicketModel.userName,
            orderId: orderId
        )
        APIHandler.shared.getEmailOrders(
            apiName: .updateEmailsEntry,
            parameter: updateEmailEntry ?? UpdateEmailEntry(),
            methodType: .POST
        ) { (result: Result<UpdateEmailOrderResponse, Error>) in
            switch result {
            case .success(let response):
                print("response....", response)
                complition(true, "Success")
            case .failure(let error):
                complition(false,"\(error)")
            }
        }
    }
    func getBarCodeSearchedData(
        barCode: String,
        complition: @escaping (Bool, String) -> Void
    ) {
        self.scanBarCodeModel = ScanBarCodeModel(
            barcode: barCode,
            eventId: Int(updateTicketModel.eventId),
            operatorName: "\(updateTicketModel.userName)"
        )
        APIHandler.shared.getBarCodeSearchedData(
            apiName: .scanBarCode,
            parameter: scanBarCodeModel,
            methodType: .POST
        ) { (result: Result<GetBarCodeSearchedResponse, Error>) in
            switch result {
            case .success(let response):
                print("response....", response)
                if response.statusCode == "200" {
                    self.arrGetEmailOrdersResponse = [GetEmailOrdersResponse(orderID: response.orderID, firstName: response.firstName, lastName: response.lastName, nameOnCard: "-", cardNumber: "-", barcodeData: [])
                    ]
                    complition(true, response.message ?? "")
                } else {
//                    self.arrGetEmailOrdersResponse?.removeAll()
                    complition(false, response.message ?? "")
                }
            case .failure(let error):
                complition(false,"\(error)")
            }
        }
    }
    func getGlobalSearchedData(
        keyword: String,
        complition: @escaping (Bool, String) -> Void
    ) {
        APIHandler.shared.getGlobalSearchedData(
            apiName: .scanBarCode,
            parameter: scanBarCodeModel,
            methodType: .POST
        ) { (result: Result<AnyObject?, Error>) in
            switch result {
            case .success(let response):
                let data = response?["data"] as? [String: Any]
                print("data", data as Any)
                self.convertToObjectArray(data ?? [:])
                let statuscode = data?["statuscode"] as? String
                print("statusCode", statuscode as Any)
                if statuscode == "200" {
                    complition(true, "Success")
                } else {
                    complition(false, "No record found.")
                }
            case .failure(let error):
                complition(false,"\(error)")
            }
        }
    }
    func convertToObjectArray(_ data: [String: Any]) {
        arrGlobalSearchData.removeAll()
        arrGlobalSearchData = data.compactMap { $0.value as? [String: Any] }
        arrGetEmailOrdersResponse = []
        arrGlobalSearchData.forEach { record in
            arrGetEmailOrdersResponse?.append(
                GetEmailOrdersResponse(
                    orderID: "", 
                    firstName: record["first_name"] as? String,
                    lastName: record["last_name"] as? String,
                    nameOnCard: "",
                    cardNumber: "",
                    barcodeData: [
                        GetEmailOrdersData(
                            id: "", barcode: record["barcode"] as? String,
                            firstName: "", lastName: "", 
                            isSelected: false
                        )
                    ]
                )
            )
        }
    }
}

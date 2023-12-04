//
//  SearchViewModel.swift
//  TicketGateway
//
//  Created by Apple on 30/06/23.

import Foundation

struct SearchDummyData {
    let name: String?
    let orderID: String? 
    let cardNo: String?
    let nameOnCard: String?
}
protocol DidPopupDismis {
    func updateDataAfterPopupDismissed(isFromCancel: Bool,
                                       selectedBarCodes: String)
}
class SearchViewModel: NSObject {
    var orderInfo: [SearchDummyData] = []
    var searchData: [SearchDummyData] = []
    var isFromSearchTxtField: Bool = false
    var updateTicketModel = UpdateTicketModel()
    var numberOfRows: Int {
        return isFromSearchTxtField ? searchData.count : orderInfo.count
    }
    // used
    var emailSearchDataModel: EmailSearchDataModel?
    var arrGetEmailOrdersResponse: [GetEmailOrdersResponse]?
    var orderId: String = ""
    var updateEmailEntry: UpdateEmailEntry?
    var emailId: String = "" // which user enter during search by email
    var scanBarCodeModel = ScanBarCodeModel()
    var getBarCodeSearchedResponse: GetBarCodeSearchedResponse?
    
    func getItem(indexPath: Int) -> SearchDummyData {
        return isFromSearchTxtField ? searchData[indexPath] : orderInfo[indexPath]
    }
    override init() {
        super.init()
        self.setDummyData()
    }
    func setDummyData() {
        for _ in 0...4 {
            let data = SearchDummyData(name: "Mangesh Yahoo", orderID: "213456755", cardNo: "XXXXXXXX2145", nameOnCard: "Mnages Kamdim")
            orderInfo.append(data)
        }
    }
    // MARK: - SEARCH FUNC
    open func searchFilter(text: String, searchText: String) -> Bool {
        return text.range(of: searchText, options: .caseInsensitive) != nil
    }
    func filterData(searchText: String, completionHandler: @escaping() -> Void) {
        searchData.removeAll()
        var searchedItems = [SearchDummyData]()
        let filter = orderInfo.filter { info in
            return searchFilter(text: info.name ?? "", searchText: searchText) || searchFilter(text: info.cardNo ?? "", searchText: searchText)
        }
        searchedItems.append(contentsOf: filter)
        searchData = searchedItems
        completionHandler()
    }
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
                    self.getBarCodeSearchedResponse = response
                    self.arrGetEmailOrdersResponse = [GetEmailOrdersResponse(orderID: response.orderID, firstName: response.firstName, lastName: response.lastName, nameOnCard: "-", cardNumber: "-", barcodeData: [])
                    ]
                    complition(true, response.message ?? "")
                } else {
                    self.arrGetEmailOrdersResponse?.removeAll()
                    self.getBarCodeSearchedResponse = response
                    complition(false, response.message ?? "")
                }
            case .failure(let error):
                complition(false,"\(error)")
            }
        }
    }
}

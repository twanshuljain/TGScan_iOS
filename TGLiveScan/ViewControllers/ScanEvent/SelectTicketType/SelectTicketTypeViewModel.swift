//
//  SelectTicketTypeViewModel.swift
//  TicketGateway
//
//  Created by Apple on 30/06/23.
//

import Foundation
class SelectTicketTypeViewModel {
    // MARK: All Properties
    var isSelectAll: Bool = false
    var arrTicketTypes: [GetTicketTypesResponseModel] = []
    var updateTicketModel = UpdateTicketModel()
    var isOfflineSwitchEnable: Bool = false
    var isFromScannerVC: Bool = false
    
    // MARK: Custom Functions
    func getTicketTypeList(complition: @escaping (Bool, String) -> Void ) {
        APIHandler.shared.getTicketTypeList(
            apiName: .getTickets,
            eventId: updateTicketModel.eventId,
            methodType: .POST
        ) { (result: Result<[GetTicketTypesResponseModel], Error>) in
            switch result {
            case .success(let response):
                print("response....",response)
                // Get selected ticket types from User defaults if available else get response from API.
                self.arrTicketTypes = UserDefaultManager.share.getSelectedTicketTypes()
                if self.arrTicketTypes.isEmpty {
                    self.arrTicketTypes = response
                }
                complition(true, "Success")
            case .failure(let error):
                complition(false,"\(error)")
            }
        }
    }
    func updateTickets(complition: @escaping (Bool, String) -> Void ) {
        APIHandler.shared.updateTickets(
            apiName: .updateTickets,
            parameter: updateTicketModel,
            methodType: .POST
        ) { (result: Result<String, Error>) in
            switch result {
            case .success(let response):
                print("response....",response)
                complition(true, "Success")
            case .failure(let error):
                complition(false,"\(error)")
            }
        }
    }
}

//
//  ScanSummaryViewModel.swift
//  TicketGateway
//
//  Created by Apple on 30/06/23.
//

import Foundation

class ScanSummaryViewModel {
    // MARK: - Variables
    var isOnline: Bool = true
    var scanSummaryModel = ScanSummaryModel()
    var getScanOverviewData = GetScanOverviewData()
    var getScanSummaryItem = [GetScanSummaryItem]()
    var arrOfValueChart: [Int] = []
    
    var getScanSummaryResponse: GetScanSummaryResponse?
    var updateTicketModel = UpdateTicketModel()
    // MARK: Custom Functions
    func getScanSummary(completion: @escaping (Bool, String) -> Void) {
        let dictBody: [String: Any] = [
            "event_id": updateTicketModel.eventId as Any
        ]
        APIHandler.shared.getScanSummary(apiName: .scanBarCode, parameter: dictBody, methodType: .POST) { (result: Result<GetScanSummaryResponse, Error>) in
            switch result {
            case .success(let response):
                print("success scan summary api")
                DispatchQueue.main.async {
                    self.getScanSummaryResponse = response
                    completion(true, "Success")
                }
            case .failure(let error):
                print("error", error)
                print("failure scan summary api ")
                completion(false, error as? String ?? "")
            }
        }
    }
}

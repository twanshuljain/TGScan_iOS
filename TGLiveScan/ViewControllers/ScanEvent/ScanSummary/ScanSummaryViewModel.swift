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
//    func getScanOverview(completion: @escaping (Bool, String) -> Void) {
//        
//        APIHandler.shared.executeRequestWith(apiName: .scanDetail, parameters: scanOverviewModel, methodType: .GET) { (result: Result<ResponseModal<GetScanOverviewData>, Error>) in
//            switch result {
//            case .success(let response):
//                print("success scan overview api")
//                if response.status_code == 200 {
//                    DispatchQueue.main.async {
//                        if let data = response.data {
//                            self.getScanOverviewData = data
//                            completion(true, response.message ?? "")
//                        }
//                    }
//                }
//            case .failure(let error):
//                print("error", error)
//                print("failure scan overview api ")
//                completion(false, error as? String ?? "")
//            }
//        }
//    }
//    func getScanSummary(completion: @escaping (Bool, String) -> Void) {
//        APIHandler.shared.executeRequestWith(apiName: .scanSummary, parameters: scanSummaryModel, methodType: .GET) { (result: Result<ResponseModal<GetScanSummaryData>, Error>) in
//            switch result {
//            case .success(let response):
//                print("success scan summary api")
//                if response.status_code == 200 {
//                    DispatchQueue.main.async {
//                        if let data = response.data {
//                            self.getScanSummaryItem.removeAll()
//                            self.getScanSummaryItem = data.items ?? []
//                            completion(true, response.message ?? "")
//                        }
//                    }
//                }
//            case .failure(let error):
//                print("error", error)
//                print("failure scan summary api ")
//                completion(false, error as? String ?? "")
//            }
//        }
//    }
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

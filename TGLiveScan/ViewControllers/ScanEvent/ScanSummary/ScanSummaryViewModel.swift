//
//  ScanSummaryViewModel.swift
//  TicketGateway
//
//  Created by Apple on 30/06/23.
//

import Foundation

class ScanSummaryViewModel {
    
    // MARK: - Variables
    var scanSummaryModel = ScanSummaryModel()
    var getScanOverviewData = GetScanOverviewData()
    var getScanSummaryItem = [GetScanSummaryItem]()
    var arrOfValueChart: [Int] = []
    var getScanSummaryResponse: GetScanSummaryResponse?
    var updateTicketModel = UpdateTicketModel()
    var arrUpdateOfflineDataOnServerModel: [UpdateOfflineDataOnServerModel]?
    
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
    // MARK: Send status report to promoter
    func sendReportToPromoter(completion: @escaping (Bool, String) -> Void) {
        APIHandler.shared.sendReportToPromoter(
            apiName: .scanBarCode,
            eventId: updateTicketModel.eventId,
            methodType: .POST
        ) { (result: Result<SendReportToPromoterResponseModel, Error>) in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    completion(true, response.info ?? "")
                }
            case .failure(let error):
                print("error", error)
                completion(false, error as? String ?? "")
            }
        }
    }
    // MARK: Upload data on live server
    func dataUpdateOnServer(dataDictToUpdate: [[String: Any]],
                            completion: @escaping (Bool, String) -> Void) {
        APIHandler.shared.dataUpdateOnServer(
            apiName: .updateDataOnServer,
            arrDataToUpload: dataDictToUpdate,
            methodType: .POST
        ) { (result: Result<AnyObject?, Error>) in
            switch result {
            case .success(let response):
                // Convert from dict to array and remove data from db which uploaded sucessfully to live server.
                self.convertToArray(response as? [String : [String : Any]] ?? [:])
                DispatchQueue.main.async {
                    completion(true, "Data upload successfully")
                }
            case .failure(let error):
                print("error", error)
                completion(false, error as? String ?? "")
            }
        }
    }
    
    func convertToArray(_ data: [String : [String : Any]]) {
        var arr = self.insertKeyInValueToArray(json: data)
        print(arr)
        // Remove non 200 statusCode records
        arr.removeAll { data in
            return (data["statuscode"] as? String ?? "") != "200"
        }
        // Now, Remove records from DB which is updated to server
        removeDataFromDB(record: arr)
    }
    // Here we insert key (barcode) in value of dictionary
    func insertKeyInValueToArray(json: [String: [String: Any]]) -> [[String: Any]] {
        return json.compactMap { (entry) in
            var updatedValue = entry.value
            updatedValue["barcode"] = entry.key
            return updatedValue
        }
    }
    func removeDataFromDB(record: [[String : Any]]) {
        record.forEach { item in
            let barCode = item["barcode"] as? String ?? ""
            if !(DatabaseHelper.shareInstance.fetchRecordByBarCode(barCode: barCode) == nil) {
                DatabaseHelper.shareInstance.deleteRecord(barCode: barCode)
            }
        }
    }
}

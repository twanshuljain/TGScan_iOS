//
//  ScannerViewModel.swift
//  TicketGateway
//
//  Created by Apple on 30/06/23.
//

import Foundation
import AVFoundation

class ScannerViewModel {
    // MARK: - Variables
    var scanTicketDetails = ScanTicketDetails()
    // In use
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var getScanDetailData: GetScanDetailData?
    var updateTicketModel = UpdateTicketModel()
    var scanBarCodeModel = ScanBarCodeModel()
    var getBarCodeScanResponse: GetBarCodeScanResponse?
    var offlineFetchBarCodeModel = OfflineFetchBarCodeModel()
    var offlineData = [
        GetOfflineFetchBarCodeResponse(barCode: "956317744891", eventId: "29344", ticketId: "41462", ticketType: "1", usedStatus: "N"),
        GetOfflineFetchBarCodeResponse(barCode: "956317703383", eventId: "29344", ticketId: "41502", ticketType: "1", usedStatus: "Y"),
        GetOfflineFetchBarCodeResponse(barCode: "956317703384", eventId: "29344", ticketId: "41462", ticketType: "1", usedStatus: "N"),
        GetOfflineFetchBarCodeResponse(barCode: "956317744892", eventId: "29344", ticketId: "41462", ticketType: "1", usedStatus: "N"),
        GetOfflineFetchBarCodeResponse(barCode: "956317744893", eventId: "29344", ticketId: "41462", ticketType: "1", usedStatus: "Y"),
        GetOfflineFetchBarCodeResponse(barCode: "956317744894", eventId: "29344", ticketId: "41462", ticketType: "1", usedStatus: "N"),
        GetOfflineFetchBarCodeResponse(barCode: "9563177448945", eventId: "29344", ticketId: "41462", ticketType: "1", usedStatus: "N"),
        GetOfflineFetchBarCodeResponse(barCode: "9563177448956", eventId: "29344", ticketId: "41462", ticketType: "1", usedStatus: "N"),
        GetOfflineFetchBarCodeResponse(barCode: "956317744897", eventId: "29344", ticketId: "41462", ticketType: "1", usedStatus: "N")
    ]
    // MARK: Custom Functions
    func getScanDetail(complition: @escaping (Bool, String) -> Void) {
        APIHandler.shared.getScanDetails(
            apiName: .scanCount,
            eventId: updateTicketModel.eventId,
            methodType: .POST
        ) { (result: Result<GetScanDetailData, Error>) in
            switch result {
            case .success(let response):
                print("response....", response)
                self.getScanDetailData = response
                complition(true, "Success")
            case .failure(let error):
                complition(false,"\(error)")
            }
        }
    }
    func scanBarCodeApi(complition: @escaping (Bool, String) -> Void ) {
        print("scanBarCodeModel", scanBarCodeModel)
        APIHandler.shared.scanBarCode(
            apiName: .scanBarCode,
            parameter: scanBarCodeModel,
            methodType: .POST
        ) { (result: Result<GetBarCodeScanResponse, Error>) in
            switch result {
            case .success(let response):
                if response.statusCode == "200" {
                    print("response....",response)
                    self.getBarCodeScanResponse = response
                    complition(true, response.message ?? "")
                } else {
                    complition(false, response.message ?? "error message")
                }
            case .failure(let error):
                complition(false,"\(error)")
            }
        }
    }
    func offlineFetchBarCode(complition: @escaping (Bool, String) -> Void) {
        offlineFetchBarCodeModel.eventId = updateTicketModel.eventId
        offlineFetchBarCodeModel.status = 1
        APIHandler.shared.offlineFetchBarCode(
            apiName: .offlineFetchBarcode,
            parameter: offlineFetchBarCodeModel,
            methodType: .POST
        ) { (result: Result<GetOfflineFetchBarCodeResponse, Error>) in
            switch result {
            case .success(let response):
                if response.statusCode == "200" {
//                    print("success api", Date./)
//                    self.storeOfflineDataInDataBase(offlineRecord: response, complition: { isStored in
//                        print("return after stored", Date.now)
//
//                    })
                    complition(true, "Message")
                } else {
                    complition(false, response.message ?? "")
                }
            case .failure(let error):
                print("error",error)
                complition(false,"\(error)")
            }
        }
    }
    func saveOfflineRecords(
        offlineRecord: [GetOfflineFetchBarCodeResponse],
        complition: @escaping (Bool) -> Void
    ) {
        // Store array in DB
        offlineRecord.forEach { record in
            DatabaseHelper.shareInstance.save(offlineScan: record)
        }
        complition(true)
    }
    
}

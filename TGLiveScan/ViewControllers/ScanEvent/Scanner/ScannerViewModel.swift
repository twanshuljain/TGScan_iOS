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
//    var scanDetailModel = ScanDetailModel()
    var scanTicketDetails = ScanTicketDetails()
    // In use
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var getScanDetailData: GetScanDetailData?
    var updateTicketModel = UpdateTicketModel()
    var scanBarCodeModel = ScanBarCodeModel()
    var getBarCodeScanResponse: GetBarCodeScanResponse?
    var offlineFetchBarCodeModel = OfflineFetchBarCodeModel()
    
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
    func offlineFetchBarCode(complition: @escaping (Bool, String) -> Void ) {
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
                    complition(true, "Message")
                } else {
                    complition(false, response.message ?? "")
                }
            case .failure(let error):
                complition(false,"\(error)")
            }
        }
    }
}

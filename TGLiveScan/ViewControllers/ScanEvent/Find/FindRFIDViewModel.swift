//
//  FindRFIDViewModel.swift
//  TicketGateway
//
//  Created by Apple on 30/06/23.
//

import Foundation
import CoreNFC

class FindRFIDViewModel {
    // MARK: - Variables
    var isConnected: Bool = false
    var getScanTicketDetails = ScanTicketDetails()
    var updateTicketModel = UpdateTicketModel()
    var nfcSession: NFCNDEFReaderSession?
    var nfcBarCodeId: [String] = []
    var scanBarCodeModel = ScanBarCodeModel()
    var getBarCodeScanResponse: GetBarCodeScanResponse?

    // Gets entry by the bar code of NFC tag
    func scanBarCodeApi(complition: @escaping (Bool, String) -> Void ) {
        print("scanBarCodeModel", scanBarCodeModel)
        scanBarCodeModel.barcode = nfcBarCodeId.first ?? ""
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
}

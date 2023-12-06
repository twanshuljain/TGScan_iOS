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
}

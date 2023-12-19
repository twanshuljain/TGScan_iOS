//
//  ScanDetailModel.swift
//  TicketGateway
//
//  Created by apple on 9/7/23.
//

import Foundation

struct ScanBarCodeModel: Codable {
    var barcode: String = ""
    var deviceId: String = ""
    var eventId: Int = 0
    var operatorName: String = ""
}

// MARK: Offline Scan Model For Local Store
struct OfflineScanLocalModel: Codable {
    // For dashboard
    var acceptedCount: Int = 0
    var rejectedCount: Int = 0
    var totalCount: Int = 0
    // For Scan Summary
    var tixToScan: String = ""
    var tixScanned: String = ""
    var summaryAcceptedCount: String = ""
    var summaryRejectedCount: String = ""
    var scannedHardTix: String = ""
    var scannedPdfTix: String = ""
    var scannedCompsTix: String = ""
}

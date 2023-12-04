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

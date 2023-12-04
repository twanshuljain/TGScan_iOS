//
//  UpdateTicketModel.swift
//  TGLiveScan
//
//  Created by apple on 11/20/23.
//

import Foundation
struct UpdateTicketModel {
    // For API Body
    var deviceId: String = ""
    var ticketIds: String = ""
    var eventId: Int = 0
    // Use for local data passing
    var eventName: String = ""
    var date: String = ""
    var userName: String = ""
}
struct OfflineFetchBarCodeModel {
    var eventId: Int = 0
    var status: Int = 0
}

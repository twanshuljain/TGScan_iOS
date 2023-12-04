//
//  ScanEventModel.swift
//  TicketGateway
//
//  Created by apple on 9/6/23.
//

import Foundation
struct LoginScanModel: Encodable {
    var username: String = ""
    var deviceId: String = ""
    var browser: String = "iphone"
    var pin: String = ""
}
struct ScanTicketDetails {
    var name: String = ""
    var eventId: Int = 0
    var imageUrl: String = ""
    var eventName: String = ""
    var selectedTicketType: [GetTicketTypesResponseModel] = []
    var availableTicketList: [String] = []
    var date: String = ""
}

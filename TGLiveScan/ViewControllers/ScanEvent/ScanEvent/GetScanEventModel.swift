//
//  GetScanEventModel.swift
//  TicketGateway
//
//  Created by apple on 9/6/23.
//

import Foundation
struct GetScanEventResponse : Codable {
    let info : GetScanEventData?
    let showDate : String?
    let message : String?
    let statusCode : String?
    var userName: String?
    enum CodingKeys: String, CodingKey {
        case info = "info"
        case showDate = "showdate"
        case message = "message"
        case statusCode = "statuscode"
        case userName = "userName"
    }
}
struct GetScanEventData : Codable {
    let pin : String?
    let canScan : String?
    let masterId : String?
    let eventName : String?
    let showdate : String?
    let proId : String?
    let status : String?
    let lsCreatedby : String?
    let lsLastedit : String?
    enum CodingKeys: String, CodingKey {
        case pin = "pin"
        case canScan = "canScan"
        case masterId = "master_id"
        case eventName = "abbrev"
        case showdate = "showdate"
        case proId = "pro_id"
        case status = "status"
        case lsCreatedby = "ls_createdby"
        case lsLastedit = "ls_lastedit"
    }
}

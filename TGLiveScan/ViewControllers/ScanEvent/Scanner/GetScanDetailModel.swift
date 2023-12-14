//
//  GetScanDetailModel.swift
//  TicketGateway
//
//  Created by apple on 9/7/23.
//

import Foundation
struct GetScanDetailData: Codable {
    var acceptedDevice: String?
    var rejectedDevice: String?
    var accepted: String?
    enum CodingKeys: String, CodingKey {
        case acceptedDevice = "Accepted_device"
        case rejectedDevice = "Rejected_device"
        case accepted = "Accepted"
    }
}
struct GetBarCodeScanResponse: Codable {
    let id, categoryid, ticketID, type: String?
    let tixOrder, barcode, firstName, lastName: String?
    let scanQty, ticketPrice, ticketName, holdStatus: String?
    let soldStatus, usedStatus, orderID, generatedDate: String?
    let layout, soldDate, holdDate, usedDate: String?
    let generatedStatus, ticketType, cancelled, isFraud: String?
    let sizes, otherOptions, notes, blockStatus: String?
    let noOfRejection, transStatus, promoterStatus, isSent: String?
    let multipleScan, allowRefundShow, podNumber, podDis: String?
    let message, statusCode, status: String?

    enum CodingKeys: String, CodingKey {
        case id, categoryid
        case ticketID = "ticket_id"
        case type
        case tixOrder = "tix_order"
        case barcode
        case firstName = "first_name"
        case lastName = "last_name"
        case scanQty = "scan_qty"
        case ticketPrice = "ticket_price"
        case ticketName = "ticket_name"
        case holdStatus = "hold_status"
        case soldStatus = "sold_status"
        case usedStatus = "used_status"
        case orderID = "order_id"
        case generatedDate = "generated_date"
        case layout
        case soldDate = "sold_date"
        case holdDate = "hold_date"
        case usedDate = "used_date"
        case generatedStatus = "generated_status"
        case ticketType = "ticket_type"
        case cancelled
        case isFraud = "is_fraud"
        case sizes
        case otherOptions = "other_options"
        case notes
        case blockStatus = "block_status"
        case noOfRejection = "no_of_rejection"
        case transStatus = "trans_status"
        case promoterStatus = "promoter_status"
        case isSent = "is_sent"
        case multipleScan = "multiple_scan"
        case allowRefundShow = "allow_refund_show"
        case podNumber = "pod_number"
        case podDis = "pod_dis"
        case message = "message"
        case statusCode = "statuscode"
        case status = "status"
    }
}
struct GetOfflineFetchBarCodeResponse: Codable {
    var message: String?
    var statusCode: String?
    var barCode: String?
    var eventId: String?
    var ticketId: String?
    var ticketType: String?
    var usedStatus: String?
    var countForRejection: Int32?
    
    enum CodingKeys: String, CodingKey {
        case message
        case statusCode = "statuscode"
        case eventId = "event_id"
        case barCode = "barcode"
        case ticketId = "ticket_id"
        case ticketType = "ticket_type"
        case usedStatus = "used_status"
        case countForRejection = "countForRejection"
    }
}

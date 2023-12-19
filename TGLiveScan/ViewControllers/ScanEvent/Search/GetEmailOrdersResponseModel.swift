//
//  GetEmailOrdersResponseModel.swift
//  TGLiveScan
//
//  Created by apple on 11/27/23.
//

import Foundation
// MARK: - WelcomeElement
struct GetEmailOrdersResponse: Codable {
    let orderID: String?
    let firstName: String?
    let lastName: String?
    let nameOnCard, cardNumber: String?
    let barcodeData: [GetEmailOrdersData]?

    enum CodingKeys: String, CodingKey {
        case orderID = "order_id"
        case firstName = "first_name"
        case lastName = "last_name"
        case nameOnCard = "name_on_card"
        case cardNumber = "card_number"
        case barcodeData = "barcode_data"
    }
}
struct GetEmailOrdersData: Codable {
    let id, barcode: String?
    let firstName: String?
    let lastName: String?
    var isSelected: Bool = true
    enum CodingKeys: String, CodingKey {
        case id, barcode
        case firstName = "first_name"
        case lastName = "last_name"
    }
}

// MARK: UpdateEmail Order Response
struct UpdateEmailOrderResponse: Codable {
    let data: UpdateEmailOrderData?
}
struct UpdateEmailOrderData: Codable {
    let count: Int?
}

// MARK: - Get Bar Code Searched Response
struct GetBarCodeSearchedResponse: Codable {
    var id, categoryid, ticketID, type: String?
    var tixOrder, barcode, firstName, lastName: String?
    var scanQty, ticketPrice, ticketName, holdStatus: String?
    var soldStatus, usedStatus, orderID, generatedDate: String?
    var layout, soldDate, holdDate, usedDate: String?
    var generatedStatus, ticketType, cancelled, isFraud: String?
    var sizes, otherOptions, notes, blockStatus: String?
    var noOfRejection, transStatus, promoterStatus, isSent: String?
    var multipleScan, allowRefundShow, podNumber, podDis: String?
    var message, statusCode, status: String?

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
        case message, status
        case statusCode = "statuscode"
    }
}
// MARK: - Get Global Searched Response
struct GetGlobalSearchResponseModel: Codable {
    var id: String?
    var firstName: String?
    var lastName: String?
    var barcode: String?
    var ticketName: String?
    
    enum CodingKeys: String, CodingKey {
        case id, barcode
        case firstName = "first_name"
        case lastName = "last_name"
        case ticketName = "ticket_name"
    }
}

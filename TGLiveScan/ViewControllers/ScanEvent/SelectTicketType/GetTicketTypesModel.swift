//
//  GetTicketTypesModel.swift
//  TGLiveScan
//
//  Created by apple on 11/20/23.
//

import Foundation
struct GetTicketTypesResponseModel: Codable {
    var id: String
    var ticketName: String
    var isSelected: Bool?
    enum CodingKeys: String, CodingKey {
        case id
        case ticketName = "ticket_name"
        case isSelected = "isSelected"
    }
}

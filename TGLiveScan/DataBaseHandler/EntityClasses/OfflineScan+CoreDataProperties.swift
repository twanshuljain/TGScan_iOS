//
//  OfflineScan+CoreDataProperties.swift
//  TGLiveScan
//
//  Created by apple on 14/12/23.
//
//

import Foundation
import CoreData


extension OfflineScan {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<OfflineScan> {
        return NSFetchRequest<OfflineScan>(entityName: "OfflineScan")
    }

    @NSManaged public var barCode: String?
    @NSManaged public var countForRejection: Int32
    @NSManaged public var eventId: String?
    @NSManaged public var ticketId: String?
    @NSManaged public var ticketType: String?
    @NSManaged public var usedStatus: String?

}

extension OfflineScan : Identifiable {

}

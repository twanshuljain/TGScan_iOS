//
//  OfflineScan+CoreDataProperties.swift
//  TGLiveScan
//
//  Created by apple on 12/5/23.
//
//

import Foundation
import CoreData

extension OfflineScan {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<OfflineScan> {
        return NSFetchRequest<OfflineScan>(entityName: "OfflineScan")
    }

    @NSManaged public var eventId: String?
    @NSManaged public var ticketId: String?
    @NSManaged public var ticketType: String?
    @NSManaged public var barCode: String?
    @NSManaged public var usedStatus: String?
    @NSManaged public var countForRejection: String?

}

extension OfflineScan : Identifiable {

}

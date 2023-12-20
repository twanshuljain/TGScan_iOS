//
//  DataBaseHelper.swift
//  TGLiveScan
//
//  Created by apple on 12/5/23.
//

import UIKit
import Foundation
import CoreData

class DatabaseHelper {
        
    // MARK: All Properties
    static let shareInstance = DatabaseHelper()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private init () { }
    
    // MARK: Custom Functions
    func save(offlineScan: GetOfflineFetchBarCodeResponse) {
        let entityName = NSEntityDescription.insertNewObject(forEntityName: "OfflineScan", into: context) as? OfflineScan
        entityName?.barCode = offlineScan.barCode
        entityName?.ticketId = offlineScan.ticketId
        entityName?.ticketType = offlineScan.ticketType
        entityName?.usedStatus = offlineScan.usedStatus
        entityName?.eventId = offlineScan.eventId
        entityName?.countForRejection = offlineScan.countForRejection ?? 0
        do {
            try context.save()
            debugPrint("Core data Save Successfully")
        } catch {
            debugPrint("Data not save, Error:", error)
        }
    }
    // Function to fetch a record by ID
    func fetchRecordByBarCode(barCode: String) -> OfflineScan? {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "OfflineScan")
        // Set the predicate to filter based on the barCode
        fetchRequest.predicate = NSPredicate(format: "barCode == %@", "\(barCode)")
        do {
            // Fetch the records that match the predicate
            let records = try context.fetch(fetchRequest)
            // Return the first record (assuming IDs are unique)
            let data = records.first as? OfflineScan
            debugPrint("barCode", data?.barCode as Any)
            return records.first as? OfflineScan
        } catch {
            debugPrint("Error fetching record: \(error)")
            return nil
        }
    }
    
    func getEntry(barCode: String, completion: @escaping (Bool) -> Void) -> OfflineScan?  {
        // Get data throught Bar Code
        if let data = self.fetchRecordByBarCode(barCode: barCode) {
            // If already gets entry increase rejection count else set status yes ("Y")
            if data.usedStatus == "Y" {
                data.countForRejection += 1
                completion(false)
            } else {
                data.usedStatus = "Y"
                completion(true)
            }
            do {
                try context.save()
                debugPrint("DB Save Success")
            } catch {
                debugPrint("Error:", error)
            }
            return data
        }
        return nil
    }
    // Function to get All Data
    func getAllData() -> [OfflineScan] {
        var employee: [OfflineScan] = []
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "OfflineScan")
        do {
            employee = try context.fetch(fetchRequest) as! [OfflineScan]
        } catch {
            debugPrint("Not get data, Error:", error)
        }
        return employee
    }
    // Function to delete all data
    func deleteAllData(forEntity entityName: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try AppDelegate.shared.persistentContainer.viewContext.execute(batchDeleteRequest)
            try AppDelegate.shared.persistentContainer.viewContext.save()
            debugPrint("Core data, Delete all Data Successfully")
        } catch {
            debugPrint("Error deleting all data: \(error)")
        }
    }
    func deleteRecord(barCode: String) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "OfflineScan")
        // Set the predicate to filter based on the ID
        fetchRequest.predicate = NSPredicate(format: "barCode == %@", "\(barCode)")
        do {
            let results = try context.fetch(fetchRequest)
            if let recordToDelete = results.first {
                context.delete(recordToDelete)
                // Save the changes
                try context.save()
                debugPrint("Record deleted: \(barCode)")
            } else {
                debugPrint("Record not found: \(barCode)")
            }
        } catch {
            debugPrint("Error deleting record: \(error)")
        }
    }
}

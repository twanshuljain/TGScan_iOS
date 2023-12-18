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
            print("Core data Save Successfully")
        } catch {
            print("Data not save, Error:", error)
        }
    }
    // Function to fetch a record by ID
    func fetchRecordByBarCode(barCode: String) -> OfflineScan? {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "OfflineScan")
        // Set the predicate to filter based on the ID
        fetchRequest.predicate = NSPredicate(format: "barCode == %@", "\(barCode)")
        do {
            // Fetch the records that match the predicate
            let records = try context.fetch(fetchRequest)
            // Return the first record (assuming IDs are unique)
            let data = records.first as? OfflineScan
            print("barCode", data?.barCode as Any)
            return records.first as? OfflineScan
        } catch {
            print("Error fetching record: \(error)")
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
                print("Core data Gets entry successfully")
            } catch {
                print("Error:", error)
            }
            return data
        }
        completion(false)
        return nil
    }
    // Function to get All Data
    func getAllData() -> [OfflineScan] {
        var employee: [OfflineScan] = []
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "OfflineScan")
        do {
            employee = try context.fetch(fetchRequest) as! [OfflineScan]
        } catch {
            print("Not get data, Error:", error)
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
            print("Core data, Delete all Data Successfully")
        } catch {
            print("Error deleting all data: \(error)")
        }
    }
}

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
        entityName?.countForRejection = offlineScan.countForRejection
        do {
            try context.save()
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
            var data = records.first as? OfflineScan
            print("barCode", data?.barCode)
            return records.first as? OfflineScan
        } catch {
            print("Error fetching record: \(error)")
            return nil
        }
    }
    
    func checkBarCodeExistance(barCode: String) -> OfflineScan?  {
        // Get data throught Bar Code
        if let data = self.fetchRecordByBarCode(barCode: barCode) {
            // Check that this barcode gets entry or not.
            if data.usedStatus == "Y" {
//                data.countForRejection = "2"
            } else {
                data.usedStatus = "Y"
            }
            do {
                try context.save()
            } catch {
                print("Cannot delete data, Error:", error)
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
            print("Not get data, Error:", error)
        }
        return employee
    }
    // Function to delete all data
    func deleteData(index: Int) -> [OfflineScan] {
        var employee = getAllData()
        context.delete(employee[index])
        employee.remove(at: index)
        do {
            try context.save()
        } catch {
            print("Cannot delete data, Error:", error)
        }
        return employee
    }
}

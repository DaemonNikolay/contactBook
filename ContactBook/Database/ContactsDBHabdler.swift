import Foundation
import CoreData
import UIKit

final class ContactsDBHandler {
  static var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "SavingLearn")
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    return container
  }()
  
  static var context: NSManagedObjectContext {
    return persistentContainer.viewContext
  }
  
  static func add(name: String, phoneNumber: String) {
    let contactDB = ContactDB(context: context)
    contactDB.id = .init()
    contactDB.name = name
    contactDB.phoneNumber = phoneNumber
    
    try? context.save()
  }
}

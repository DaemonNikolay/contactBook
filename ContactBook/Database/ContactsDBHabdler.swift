import Foundation
import CoreData
import UIKit

final class ContactsDBHandler {
	static func all() -> [ContactDB]? {
		let request: NSFetchRequest = ContactDB.fetchRequest()
		
		return try? context.fetch(request)
	}
	
	static func add(name: String, phoneNumber: String) {
		let contact = ContactDB(context: context)
		contact.id = .init()
		contact.name = name
		contact.phoneNumber = phoneNumber
		
		try? context.save()
	}
	
	static func update(id: UUID, name: String? = nil, phoneNumber: String? = nil) {
		let request: NSFetchRequest = ContactDB.fetchRequest()
		request.predicate = NSPredicate(format: "id = %@", [id.description])
		
		guard let contact = try? context.fetch(request)[0] else { return }
		
		if let name = name {
			contact.name = name
		}
		
		if let phoneNumber = phoneNumber {
			contact.phoneNumber = phoneNumber
		}
		
		try? context.save()
	}
	
	static func delete(id: UUID) {
		let request: NSFetchRequest = ContactDB.fetchRequest()
		request.predicate = NSPredicate(format: "id = %@", [id.description])
		
		guard let contact = try? context.fetch(request)[0] else { return }
		
		context.delete(contact)
		try? context.save()
	}
	
	private static var context: NSManagedObjectContext {
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		let context = appDelegate.persistentContainer.viewContext
		
		return context
	}
}

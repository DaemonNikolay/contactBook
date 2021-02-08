import UIKit

class ContactCell: UITableViewCell {
	// MARK: - Outlets
	
	@IBOutlet var name: UILabel!
	@IBOutlet var phoneNumber: UILabel!
	
	
  // MARK: - Public constants
  
  static let reuseIdentifier: String = "ContactCell"
	
	// MARK: - Public variables
	
	var contactId: UUID?
  
	// MARK: - Public methods
	
	func setup(contactId: UUID?, phoneNumber: String, name: String) {
		self.contactId = contactId
		self.phoneNumber.text = phoneNumber
		self.name.text = name
	}
}

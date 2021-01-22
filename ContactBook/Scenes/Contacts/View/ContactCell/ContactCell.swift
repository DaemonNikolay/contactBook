import UIKit

class ContactCell: UITableViewCell {
	// MARK: - Outlets
	
	@IBOutlet var phoneNumber: UITextField!
	@IBOutlet var name: UITextField!
	
  // MARK: - Public constants
  
  static let reuseIdentifier: String = "ContactCell"
  
	// MARK: - Public methods
	
	func setup(phoneNumber: String, name: String) {
		self.phoneNumber.text = phoneNumber
		self.name.text = name
	}
}

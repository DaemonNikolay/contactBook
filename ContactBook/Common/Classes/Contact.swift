import Foundation

final class Contact {
	var id: UUID

	var name: String
	var phoneNumber: String
	var birthdayDate: Int64

	// MARK: - Initialize
	
	init(id: UUID, name: String, phoneNumber: String, birthdayDate: Int64) {
		self.id = id
		self.name = name
		self.phoneNumber = phoneNumber
		self.birthdayDate = birthdayDate
	}
	
	init() {
		self.id = .init()
		self.name = .init()
		self.phoneNumber = .init()
		self.birthdayDate = .zero
	}
}

import Foundation

final class Contact {
	var id: UUID

	var name: String
	var phoneNumber: String

	// MARK: - Initialize
	
	init(id: UUID, name: String, phoneNumber: String) {
		self.id = id
		self.name = name
		self.phoneNumber = phoneNumber
	}
	
	init() {
		self.id = .init()
		self.name = .init()
		self.phoneNumber = .init()
	}
}

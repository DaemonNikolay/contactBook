import UIKit
import RxCocoa
import RxSwift

final class ContactsViewModel: ViewModel, DIConfigurable {
	
	// MARK: - Private constant
	
	private let router: ContactsRouter
	private let bag = DisposeBag()
	
	// MARK: - Private properties
	
	private var dataSource: BehaviorRelay<[Contact]> = .init(value: .init())
	
	// MARK: - Lifecycle
	
	init(container: Container) {
		router = container.router
		
		NotificationCenter.default.addObserver(self,
																					 selector: #selector(reloadTable),
																					 name: .reloadTable,
																					 object: nil)
	}
	
	@objc private func reloadTable() {
		dataSource.accept(contacts())
	}
	
	// MARK: - Public methods
	
	func transform(input: Input) -> Output {
		input.tableView.drive(onNext: { [weak self] (tableView) in
			guard let tableView = tableView, let itSelf = self else { return }
			
			itSelf.setupTable(tableView)
			itSelf.initDataSource()
		})
		.disposed(by: bag)
		
		input.navItem
			.drive(onNext: { [weak self] (navItem) in
				guard let itSelf = self else { return }
				
				navItem?.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"),
																											style: .done,
																											target: self,
																											action: #selector(itSelf.addContact))
			})
			.disposed(by: bag)
		
		return Output()
	}
	
	// MARK: - Private methods
	
	private func contacts() -> [Contact] {
		guard let contactsDB = ContactsDBHandler.all() else { return .init() }
		
		var contacts: [Contact] = .init()
		contactsDB.forEach { contactDB in
			
			guard let contactId = contactDB.id,
						let name = contactDB.name,
						let phoneNumber = contactDB.phoneNumber else { return }
			
			let contact: Contact = .init(id: contactId,
																	 name: name,
																	 phoneNumber: phoneNumber,
																	 birthdayDate: contactDB.birthdayDate)
			
			contacts.append(contact)
		}
		
		return contacts
	}
	
	private func initDataSource() {
		dataSource.accept(contacts())
	}
	
	private func setupTable(_ tableView: UITableView) {
		tableView.register(UINib(nibName: ContactCell.reuseIdentifier, bundle: nil),
											 forCellReuseIdentifier: ContactCell.reuseIdentifier)
		
		dataSource.bind(to: tableView.rx.items(cellIdentifier: ContactCell.reuseIdentifier,
																					 cellType: ContactCell.self)) { _, contact, cell in
			
			cell.setup(contactId: contact.id,
								 phoneNumber: contact.phoneNumber,
								 name: contact.name)
		}
		.disposed(by: bag)
		
		tableView.rx
			.modelSelected(Contact.self)
			.subscribe(onNext: { [weak self] (contact) in
				guard let itSelf = self else { return }
				
				itSelf.showDetail(contact)
			})
			.disposed(by: bag)
		
		tableView.rx
			.modelDeleted(Contact.self)
			.subscribe(onNext: { [weak self] (contact) in
				guard let itSelf = self else { return }
				
				ContactsDBHandler.delete(id: contact.id)
				itSelf.reloadTable()
			})
			.disposed(by: bag)
	}
	
	private func showDetail(_ contact: Contact) {
		router.showDetail(contact)
	}
	
	@objc private func addContact() {
		router.showDetailForNew()
	}
}

// MARK: - Nested Types / Enums

extension ContactsViewModel {
	struct Input {
		let tableView: Driver<UITableView?>
		let navItem: Driver<UINavigationItem?>
	}
	
	struct Output { }
	
	struct Container {
		let router: ContactsRouter
	}
}

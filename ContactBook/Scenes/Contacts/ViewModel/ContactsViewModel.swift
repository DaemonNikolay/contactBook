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
	}
	
	// MARK: - Public methods
	
	func transform(input: Input) -> Output {
    input.tableView.drive(onNext: { [unowned self] (tableView) in
      guard let tableView = tableView else { return }
      
      setupTable(tableView)
			initDataSource()
    })
    .disposed(by: bag)
    
    input.navItem
      .drive(onNext: { [unowned self] (navItem) in
        navItem?.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                                      style: .done,
                                                      target: self,
                                                      action: #selector(addContact))
      })
      .disposed(by: bag)
    
		return Output()
	}
  
  // MARK: - Private methods
	
	private func initDataSource() {
		guard let contactsDB = ContactsDBHandler.all() else { return }

		var contacts: [Contact] = .init()
		contactsDB.forEach { contactDB in
			guard let contactId = contactDB.id,
						let name = contactDB.name,
						let phoneNumber = contactDB.phoneNumber else { return }
			
			contacts.append(.init(id: contactId,
														name: name,
														phoneNumber: phoneNumber))
		}
		
		dataSource.accept(contacts)
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
      .subscribe(onNext: { [unowned self] (contact) in
				showDetail(contact)
      })
      .disposed(by: bag)
		
		tableView.rx
			.modelDeleted(ContactCell.self)
			.subscribe(onNext: { cell in
				print("Remove: \(cell.name)")
				
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

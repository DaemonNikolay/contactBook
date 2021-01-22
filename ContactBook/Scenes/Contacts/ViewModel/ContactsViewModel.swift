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
  
  private func setupTable(_ tableView: UITableView) {
    dataSource.bind(to: tableView.rx.items(cellIdentifier: ContactCell.reuseIdentifier,
                                           cellType: ContactCell.self)) { _, record, cell in
      cell.setup(phoneNumber: record.phoneNumber,
                 name: record.name)
    }
    .disposed(by: bag)
    
    tableView.rx
      .modelSelected(Contact.self)
      .subscribe(onNext: { [unowned self] (contact) in
        showDetail(contact)
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

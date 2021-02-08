import UIKit
import RxCocoa
import RxSwift

final class ContactsViewController: UIViewController, DIConfigurable {
	// MARK: - Outlets
	
	@IBOutlet var contactsList: UITableView!
	
	// MARK: - Public properties
	
	private var viewModel: ContactsViewModel!
	
	// MARK: - Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
    
    setupBindings()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		navigationController?.setNavigationBarHidden(false, animated: animated)
    navigationController?.navigationBar.topItem?.title = "Contacts"
	}

	// MARK: - Public methods
	
	func inject(dependencies: Container) {
		viewModel = dependencies.viewModel
	}
  
  // MARK: - Private methods
  
  private func setupBindings() {
    let tableViewDriver: Driver<UITableView?> = .just(contactsList)
    let navItem: Driver<UINavigationItem?> = .just(navigationItem)
		
    let input = ContactsViewModel.Input(tableView: tableViewDriver,
                                        navItem: navItem)
    
    _ = viewModel.transform(input: input)
  }
}

// MARK: - DI container

extension ContactsViewController {
	struct Container {
		let viewModel: ContactsViewModel
	}
}

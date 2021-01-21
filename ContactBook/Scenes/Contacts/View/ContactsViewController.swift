import UIKit

class ContactsViewController: UIViewController, DIConfigurable {
	// MARK: - Outlets
	
	@IBOutlet var contactsList: UITableView!
	
	// MARK: - Public properties
	
	var viewModel: ContactsViewModel!
	
	// MARK: - Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		navigationController?.setNavigationBarHidden(true, animated: animated)
	}

	// MARK: - Public methods
	
	func inject(dependencies: Container) {
		viewModel = dependencies.viewModel
	}
}

// MARK: - DI container

extension ContactsViewController {
	struct Container {
		let viewModel: ContactsViewModel
	}
}

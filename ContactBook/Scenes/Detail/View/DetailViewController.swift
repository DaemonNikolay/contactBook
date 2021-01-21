import UIKit

class DetailViewController: UIViewController, DIConfigurable {
	// MARK: - Outlets
	
	@IBOutlet var name: UITextField!
	@IBOutlet var phoneNumber: UITextField!
	
	@IBOutlet var save: UIButton!
	
	// MARK: - Public properties
	
	var viewModel: DetailViewModel!
	
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

extension DetailViewController {
	struct Container {
		let viewModel: DetailViewModel
	}
}

import UIKit

class SplashViewController: UIViewController, DIConfigurable {
	// MARK: - Public properties
	
	var viewModel: SplashViewModel!
	
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

extension SplashViewController {
	struct Container {
		let viewModel: SplashViewModel
	}
}

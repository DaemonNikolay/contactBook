import UIKit
import RxCocoa
import RxSwift

class SplashViewController: UIViewController, DIConfigurable {
	// MARK: - Public properties
	
	var viewModel: SplashViewModel!
	
	// MARK: - Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupBindings()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		navigationController?.setNavigationBarHidden(true, animated: animated)
	}
	
	// MARK: - Public methods
	
	func inject(dependencies: Container) {
		viewModel = dependencies.viewModel
	}
	
	// MARK: - Private methods
	
	private func setupBindings() {
		let input = SplashViewModel.Input()
		
		_ = viewModel.transform(input: input)
	}
}

// MARK: - DI container

extension SplashViewController {
	struct Container {
		let viewModel: SplashViewModel
	}
}

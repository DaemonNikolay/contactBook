import UIKit

struct SplashModule {
	let view: UIViewController
	
	init(transition: Transition) {
		let router = SplashRouter()
		
		let viewModelContainer = SplashViewModel.Container(router: router)
		let viewModel = SplashViewModel(container: viewModelContainer)
		
		let viewContainer = SplashViewController.Container(viewModel: viewModel)
		let view = SplashViewController()
		view.inject(dependencies: viewContainer)
		
		router.viewController = view
		router.openTransition = transition
		
		self.view = view
	}
}

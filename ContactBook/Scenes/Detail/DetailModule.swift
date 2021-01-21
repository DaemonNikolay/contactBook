import UIKit

struct DetailModule {
	let view: UIViewController
	
	init(transition: Transition) {
		let router = DetailRouter()
		
		let viewModelContainer = DetailViewModel.Container(router: router)
		let viewModel = DetailViewModel(container: viewModelContainer)
		
		let viewContainer = DetailViewController.Container(viewModel: viewModel)
		let view = DetailViewController()
		view.inject(dependencies: viewContainer)
		
		router.viewController = view
		router.openTransition = transition
		
		self.view = view
	}
}

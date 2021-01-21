import UIKit

struct ContactsModule {
	let view: UIViewController
	
	init(transition: Transition) {
		let router = ContactsRouter()
		
		let viewModelContainer = ContactsViewModel.Container(router: router)
		let viewModel = ContactsViewModel(container: viewModelContainer)
		
		let viewContainer = ContactsViewController.Container(viewModel: viewModel)
		let view = ContactsViewController()
		view.inject(dependencies: viewContainer)
		
		router.viewController = view
		router.openTransition = transition
		
		self.view = view
	}
}

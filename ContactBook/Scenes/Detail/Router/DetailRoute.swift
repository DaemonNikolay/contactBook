protocol DetailRoute {
	func showDetail()
}

extension DetailRoute where Self: RouterProtocol {
	func showDetail() {
		let transition = ModalTransition(animator: nil,
																		 isAnimated: true,
																		 modalTransitionStyle: .coverVertical,
																		 modalPresentationStyle: .formSheet)
		
		let module = DetailModule(transition: transition)

		open(module.view, transition: transition)
	}
}

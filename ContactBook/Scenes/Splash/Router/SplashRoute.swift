protocol SplashRoute {
	func showSplash()
}

extension SplashRoute where Self: RouterProtocol {
	func showSplash() {
		let transition = WindowTransition()
		let module = SplashModule(transition: transition)

		open(module.view, transition: transition)
	}
}

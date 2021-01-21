protocol ContactsRoute {
	func showContacts()
}

extension ContactsRoute where Self: RouterProtocol {
	func showContacts() {
		let transition = PushTransition(animator: FadeAnimator())
		let module = ContactsModule(transition: transition)

		open(module.view, transition: transition)
	}
}
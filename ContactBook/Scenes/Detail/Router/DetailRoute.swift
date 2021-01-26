protocol DetailRoute {
  func showDetail(_ contact: Contact)
}

extension DetailRoute where Self: RouterProtocol {
  func showDetail(_ contact: Contact) {
		let transition = PushTransition(animator: FadeAnimator(), isAnimated: true)
		let module = DetailModule(transition: transition, contact: contact, mode: .read)

		open(module.view, transition: transition)
	}
  
  func showDetailForNew() {
    let transition = PushTransition(animator: FadeAnimator(), isAnimated: true)
		let module = DetailModule(transition: transition, mode: .add)

    open(module.view, transition: transition)
  }
}

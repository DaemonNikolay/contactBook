protocol DetailRoute {
  func showDetail(_ contact: Contact)
}

extension DetailRoute where Self: RouterProtocol {
  func showDetail(_ contact: Contact) {
		let transition = PushTransition(animator: FadeAnimator(), isAnimated: true)
    let module = DetailModule(transition: transition, contact: contact)

		open(module.view, transition: transition)
	}
  
  func showDetailForNew() {
    let transition = PushTransition(animator: FadeAnimator(), isAnimated: true)
    let module = DetailModule(transition: transition)

    open(module.view, transition: transition)
  }
}

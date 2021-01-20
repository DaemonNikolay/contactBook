import UIKit

protocol AlertRoute {
	func show(title: String?, message: String?, actions: [UIAlertAction])
}

extension AlertRoute where Self: RouterProtocol {
	func show(title: String? = "", message: String? = "", actions: [UIAlertAction]) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		actions.forEach { [weak alert] in
			alert?
				.addAction($0)
		}
		viewController?
			.showModal(alert, sender: self)
	}
}

extension UIViewController {
	// это пока здесь. нужно для размышления как разруливать два модальных контроллера?
	@objc
	func showModal(_ viewController: UIViewController, sender: Any?) {
		guard (presentedViewController is UIAlertController) == false else {
			return
		}
		if let presentedViewController = presentedViewController {
			presentedViewController.showModal(viewController, sender: sender)
		} else {
			present(viewController, animated: true, completion: nil)
		}
	}
}

import UIKit

protocol DIConfigurable {
	associatedtype Container
	
	init(container: Container)
	
	func inject(dependencies: Container)
}

extension DIConfigurable {
	func inject(dependencies _: Container) {}
}

extension DIConfigurable where Self: UIViewController {
	init(container _: Container) {
		fatalError("For UIViewController use inject(dependencies: Container)")
	}
}

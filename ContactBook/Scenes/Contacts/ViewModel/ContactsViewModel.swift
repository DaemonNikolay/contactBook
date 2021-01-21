import UIKit
import RxCocoa
import RxSwift

final class ContactsViewModel: ViewModel, DIConfigurable {
	
	// MARK: - Private constant
	
	private let router: ContactsRouter
	private let bag = DisposeBag()
	
	// MARK: - Lifecycle
	
	init(container: Container) {
		router = container.router
	}
	
	// MARK: - Public methods
	
	func transform(input: Input) -> Output {
		return Output()
	}
}

// MARK: - Nested Types / Enums

extension ContactsViewModel {
	struct Input { }
	
	struct Output { }
	
	struct Container {
		let router: ContactsRouter
	}
}

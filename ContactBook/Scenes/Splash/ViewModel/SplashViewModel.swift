import UIKit
import RxCocoa
import RxSwift

final class SplashViewModel: ViewModel, DIConfigurable {
	
	// MARK: - Private constant
	
	private let router: SplashRouter
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

extension SplashViewModel {
	struct Input { }
	
	struct Output { }
	
	struct Container {
		let router: SplashRouter
	}
}

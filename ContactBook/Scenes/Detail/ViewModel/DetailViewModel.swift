import UIKit
import RxCocoa
import RxSwift

final class DetailViewModel: ViewModel, DIConfigurable {
	
	// MARK: - Private constant
	
	private let router: DetailRouter
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

extension DetailViewModel {
	struct Input { }
	
	struct Output { }
	
	struct Container {
		let router: DetailRouter
	}
}

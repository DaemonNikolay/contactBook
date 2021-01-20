protocol ViewModel {
	associatedtype Input
	associatedtype Output

	@discardableResult
	func transform(input: Input) -> Output
}

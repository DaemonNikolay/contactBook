import UIKit
import RxCocoa
import RxSwift
import CoreData

final class DetailViewController: UIViewController, DIConfigurable {
	
	// MARK: - Outlets
	
	@IBOutlet var name: UITextField!
	@IBOutlet var phoneNumber: UITextField!
	
	@IBOutlet var birthdayDate: UIDatePicker!
	
  // MARK: - Private constants
  
  private let bag = DisposeBag()
	
	// MARK: - Public properties
	
	private var viewModel: DetailViewModel!
	
	// MARK: - Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
    
    setupBindigs()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		navigationController?.setNavigationBarHidden(false, animated: animated)
	}

	// MARK: - Public methods
	
	func inject(dependencies: Container) {
		viewModel = dependencies.viewModel
	}
  
  // MARK: - Private methods
	
  private func setupBindigs() {
		let navigationItemDriver: Driver<UINavigationItem?> = Driver.just(navigationItem)
		let nameDriver: Driver<UITextField?> = Driver.just(name)
		let phoneNumberDriver: Driver<UITextField?> = Driver.just(phoneNumber)
		let birthdayDateDriver: Driver<UIDatePicker?> = Driver.just(birthdayDate)
		
		let input = DetailViewModel.Input(navigationItem: navigationItemDriver,
																			name: nameDriver,
																			phoneNumber: phoneNumberDriver,
																			birthdayDate: birthdayDateDriver)
    
    let output = viewModel.transform(input: input)
		
		output.showAlert.drive(onNext: { [weak self] (alert) in
			guard let alert = alert, let itSelf = self else { return }
			
			itSelf.present(alert, animated: true)
		})
		.disposed(by: bag)
  }
}

// MARK: - DI container

extension DetailViewController {
	struct Container {
		let viewModel: DetailViewModel
	}
}

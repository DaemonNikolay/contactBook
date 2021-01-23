import UIKit
import RxCocoa
import RxSwift
import CoreData

class DetailViewController: UIViewController, DIConfigurable {
	// MARK: - Outlets
	
	@IBOutlet var name: UITextField!
	@IBOutlet var phoneNumber: UITextField!
	
	@IBOutlet var save: UIButton!
  
  // MARK: - Private constants
  
  private let bag = DisposeBag()
	
	// MARK: - Public properties
	
	var viewModel: DetailViewModel!
	
	// MARK: - Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
    
    save.layer.borderWidth = 1
    save.layer.cornerRadius = 5
    save.tintColor = .black
    save.layer.borderColor = UIColor.black.cgColor
    
    self.navigationItem.title = "rere"
    
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
    let nameDriver: Driver<String?> = name.rx
      .text
      .observe(on: MainScheduler.asyncInstance)
      .debounce(.milliseconds(400), scheduler: MainScheduler.instance)
      .asDriver(onErrorJustReturn: name.text)
    
    let phoneNumberDriver: Driver<String?> = phoneNumber.rx
      .text
      .observe(on: MainScheduler.asyncInstance)
      .debounce(.milliseconds(400), scheduler: MainScheduler.instance)
      .asDriver(onErrorJustReturn: phoneNumber.text)
    
    let saveDriver: Driver<Void> = save.rx.tap.asDriver()
    let navigationItemDriver: Driver<UINavigationItem?> = Driver.just(navigationItem)
    
    let input = DetailViewModel.Input(name: nameDriver,
                                      phoneNumber: phoneNumberDriver,
                                      save: saveDriver,
                                      navigationItem: navigationItemDriver)
    
    let output = viewModel.transform(input: input)
    output.name.drive(name.rx.text).disposed(by: bag)
    output.phoneNumber.drive(phoneNumber.rx.text).disposed(by: bag)
  }
}

// MARK: - DI container

extension DetailViewController {
	struct Container {
		let viewModel: DetailViewModel
	}
}

import UIKit
import RxCocoa
import RxSwift

final class DetailViewModel: ViewModel, DIConfigurable {
	// MARK: - Private constant
	
	private let router: DetailRouter
	private let bag = DisposeBag()
  
  // MARK: - Private properties
  
  private var name: String?
  private var phoneNumber: String?
	
	// MARK: - Lifecycle
	
	init(container: Container) {
		router = container.router
    
    name = container.contact?.name
    phoneNumber = container.contact?.phoneNumber
	}
	
	// MARK: - Public methods
	
	func transform(input: Input) -> Output {
    input.name
      .drive(onNext: { [unowned self] (content) in
        name = content
      })
      .disposed(by: bag)
    
    input.phoneNumber
      .drive(onNext: { [unowned self] (content) in
        phoneNumber = content
      })
      .disposed(by: bag)
    
    input.save
      .drive(onNext: { [unowned self] in
        print(name, phoneNumber)
      })
      .disposed(by: bag)
    
    input.navigationItem.drive(onNext: { [unowned self] (navItem) in
      guard let _ = name else {
        navItem?.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                                      style: .done,
                                                      target: self,
                                                      action: #selector(addClick))

        return
      }
      
      navItem?.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gearshape"),
                                                   style: .done,
                                                   target: self,
                                                   action: #selector(editClick))
    })
    .disposed(by: bag)
    
    let nameDriver: Driver<String?> = Driver.just(name)
    let phoneNumberDriver: Driver<String?> = Driver.just(phoneNumber)
    
    return Output(name: nameDriver,
                  phoneNumber: phoneNumberDriver)
	}
  
  // MARK: - Private methods
  
  @objc private func editClick() {
    print("edit")
  }
  
  @objc private func addClick() {
    print("add")
  }
}

// MARK: - Nested Types / Enums

extension DetailViewModel {
	struct Input {
    let name: Driver<String?>
    let phoneNumber: Driver<String?>
    let save: Driver<Void>
    let navigationItem: Driver<UINavigationItem?>
  }
	
	struct Output {
    let name: Driver<String?>
    let phoneNumber: Driver<String?>
  }
	
	struct Container {
		let router: DetailRouter
    let contact: Contact?
	}
}

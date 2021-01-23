import UIKit
import RxCocoa
import RxSwift

final class DetailViewModel: ViewModel, DIConfigurable {
	// MARK: - Private constant
	
	private let router: DetailRouter
	private let bag = DisposeBag()
  private let isNew: Bool
  
  // MARK: - Private properties
  
  private var name: String?
  private var phoneNumber: String?
	
	// MARK: - Lifecycle
	
	init(container: Container) {
		router = container.router
    
    name = container.contact?.name
    phoneNumber = container.contact?.phoneNumber
    isNew = name == nil
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
				addContact(name: name, phoneNumber: phoneNumber)
      })
      .disposed(by: bag)
    
    input.navigationItem.drive(onNext: { [unowned self] (navItem) in
      guard isNew else {
        navItem?.title = name
        return
      }
      
      navItem?.title = "New contact"
    })
    .disposed(by: bag)
    
    let nameDriver: Driver<String?> = Driver.just(name)
    let phoneNumberDriver: Driver<String?> = Driver.just(phoneNumber)
    
    return Output(name: nameDriver,
                  phoneNumber: phoneNumberDriver)
	}
  
  // MARK: - Private methods
  
	private func addContact(name: String?, phoneNumber: String?) {
		guard let name = name, let phoneNumber = phoneNumber else { return }
		
		ContactsDBHandler.add(name: name, phoneNumber: phoneNumber)
  }
  
  private func editContact() {
    
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

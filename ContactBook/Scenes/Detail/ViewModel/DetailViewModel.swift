import UIKit
import RxCocoa
import RxSwift

final class DetailViewModel: ViewModel, DIConfigurable {
	// MARK: - Private constant
	
	private let router: DetailRouter
	private let bag = DisposeBag()
	
	private lazy var saveButtonItem: UIBarButtonItem = {
		UIBarButtonItem(barButtonSystemItem: .save,
										target: self,
										action: #selector(saveContactAction))
	}()
	
	private lazy var editButtonItem: UIBarButtonItem = {
		UIBarButtonItem(barButtonSystemItem: .edit,
										target: self,
										action: #selector(changeContactMode))
	}()
	
	// MARK: - Private properties
	
	private var contact: Contact?
	private var mode: BehaviorRelay<DatailContactMode>
	
	private var navItem: UINavigationItem?
	private var nameField: UITextField?
	private var phoneNumberField: UITextField?
	private var birthdayDatePicker: UIDatePicker?
	
	// MARK: - Lifecycle
	
	init(container: Container) {
		router = container.router
		
		contact = container.contact ?? Contact()
		mode = .init(value: container.mode)
	}
	
	// MARK: - Public methods
	
	func transform(input: Input) -> Output {
		input.navigationItem.drive(onNext: { [unowned self] (navItem) in
			guard let navItem = navItem else { return }
			
			self.navItem = navItem
			
			switch mode.value {
			case .add:
				navItem.title = "New contact"
				navItem.rightBarButtonItem = saveButtonItem
			case .edit:
				navItem.title = contact?.name ?? "😎"
				navItem.rightBarButtonItem = saveButtonItem
			case .read:
				navItem.title = contact?.name ?? "😎"
				navItem.rightBarButtonItem = editButtonItem
			}
		})
		.disposed(by: bag)
		
		input.name.drive(onNext: { [unowned self] (textField) in
			guard var textField = textField else { return }
			
			nameField = textField
			
			settingTextField(textField: &textField, content: contact?.name)
			
			textField.rx.text.subscribe(onNext: { [unowned self] (content) in
				guard let content = content else { return }
				contact?.name = content
			})
			.disposed(by: bag)
		})
		.disposed(by: bag)
		
		input.phoneNumber.drive(onNext: { [unowned self] (textField) in
			guard var textField = textField else { return }
			
			phoneNumberField = textField
			
			settingTextField(textField: &textField, content: contact?.phoneNumber)
			
			textField.rx.text.subscribe(onNext: { [unowned self] (content) in
				guard let content = content else { return }
				contact?.phoneNumber = content
			})
			.disposed(by: bag)
		})
		.disposed(by: bag)
		
		input.birthdayDate.drive(onNext: { [unowned self] (datePicker) in
			guard let datePicker = datePicker else { return }
			
			birthdayDatePicker = datePicker
			
			switch mode.value {
			case .read:
				datePicker.isEnabled = false
				datePicker.date = dateFromTimestamp(contact?.birthdayDate)
			case .edit:
				datePicker.date = dateFromTimestamp(contact?.birthdayDate)
			default: break
			}
			
			datePicker.rx.date
				.subscribe(onNext: { date in
					contact?.birthdayDate = Int64(date.timeIntervalSince1970)
				})
				.disposed(by: bag)
		})
		.disposed(by: bag)
		
		mode.subscribe(onNext: { [unowned self] (mode) in
			switch mode {
			case .edit:
				nameField?.isEnabled = true
				phoneNumberField?.isEnabled = true
				birthdayDatePicker?.isEnabled = true
				
				navItem?.rightBarButtonItem = saveButtonItem
				
			default: break
			}
		})
		.disposed(by: bag)
		
		return Output()
	}
	
	// MARK: - Actions
	
	@objc private func changeContactMode() {
		mode.accept(.edit)
	}
	
	@objc private func saveContactAction() {
		switch mode.value {
		case .add:
			addContact(name: contact?.name,
								 phoneNumber: contact?.phoneNumber,
								 birthdayDate: contact?.birthdayDate)
		case .edit:
			editContact(id: contact?.id,
									name: contact?.name,
									phoneNumber: contact?.phoneNumber,
									birthdayDate: contact?.birthdayDate)
		default: break
		}
		
		NotificationCenter.default.post(.init(name: .reloadTable))
		router.close()
	}
	
	// MARK: - Private methods
	
	private func dateFromTimestamp(_ timestamp: Int64?) -> Date {
		Date(timeIntervalSince1970: TimeInterval(timestamp ?? .zero))
	}
	
	private func settingTextField(textField: inout UITextField, content: String?) {
		switch mode.value {
		case .read:
			textField.isEnabled = false
			textField.text = content
		case .edit:
			textField.text = content
		default: break
		}
	}
	
	private func addContact(name: String?, phoneNumber: String?, birthdayDate: Int64?) {
		guard let name = name,
					let phoneNumber = phoneNumber,
					let birthdayDate = birthdayDate else { return }
		
		ContactsDBHandler.add(name: name, phoneNumber: phoneNumber, birthdayDate: birthdayDate)
	}
	
	private func editContact(id: UUID?,
													 name: String? = nil,
													 phoneNumber: String? = nil,
													 birthdayDate: Int64? = nil) {
		
		guard let contactId = id else { return }
		
		ContactsDBHandler.update(id: contactId,
														 name: name,
														 phoneNumber: phoneNumber,
														 birthdayDate: birthdayDate)
	}
}

// MARK: - Nested Types / Enums

extension DetailViewModel {
	struct Input {
		let navigationItem: Driver<UINavigationItem?>
		let name: Driver<UITextField?>
		let phoneNumber: Driver<UITextField?>
		let birthdayDate: Driver<UIDatePicker?>
	}
	
	struct Output {	}
	
	struct Container {
		let router: DetailRouter
		let contact: Contact?
		let mode: DatailContactMode
	}
}

enum DatailContactMode {
	case add
	case edit
	case read
}

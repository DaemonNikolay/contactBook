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
	
	private var alert: BehaviorRelay<UIAlertController?> = .init(value: nil)
	
	// MARK: - Lifecycle
	
	init(container: Container) {
		router = container.router
		
		contact = container.contact ?? Contact()
		mode = .init(value: container.mode)
	}
	
	// MARK: - Public methods
	
	func transform(input: Input) -> Output {
		input.navigationItem.drive(onNext: { [weak self] (navItem) in
			guard let navItem = navItem, let itSelf = self else { return }
			
			itSelf.navItem = navItem
			
			switch itSelf.mode.value {
			case .add:
				navItem.title = "New contact"
				navItem.rightBarButtonItem = itSelf.saveButtonItem
			case .edit:
				navItem.title = itSelf.contact?.name ?? "😎"
				navItem.rightBarButtonItem = itSelf.saveButtonItem
			case .read:
				navItem.title = itSelf.contact?.name ?? "😎"
				navItem.rightBarButtonItem = itSelf.editButtonItem
			}
		})
		.disposed(by: bag)
		
		input.name.drive(onNext: { [weak self] (textField) in
			guard var textField = textField, let itSelf = self else { return }
			
			itSelf.nameField = textField
			
			itSelf.settingTextField(textField: &textField, content: itSelf.contact?.name)
			
			textField.rx.text.subscribe(onNext: { [weak self] (content) in
				guard let content = content, let itSelf = self else { return }
				itSelf.contact?.name = content
			})
			.disposed(by: itSelf.bag)
		})
		.disposed(by: bag)
		
		input.phoneNumber.drive(onNext: { [weak self] (textField) in
			guard var textField = textField, let itSelf = self else { return }
			
			itSelf.phoneNumberField = textField
			
			itSelf.settingTextField(textField: &textField, content: itSelf.contact?.phoneNumber)
			
			textField.rx.text.subscribe(onNext: { [weak self] (content) in
				guard let content = content, let itSelf = self  else { return }
				itSelf.contact?.phoneNumber = content
			})
			.disposed(by: itSelf.bag)
		})
		.disposed(by: bag)
		
		input.birthdayDate.drive(onNext: { [weak self] (datePicker) in
			guard let datePicker = datePicker, let itSelf = self else { return }
			
			itSelf.birthdayDatePicker = datePicker
			
			switch itSelf.mode.value {
			case .read:
				datePicker.isEnabled = false
				datePicker.date = itSelf.dateFromTimestamp(itSelf.contact?.birthdayDate)
			case .edit:
				datePicker.date = itSelf.dateFromTimestamp(itSelf.contact?.birthdayDate)
			default: break
			}
			
			datePicker.rx.date
				.subscribe(onNext: { [weak self] date in
					guard let itSelf = self else { return }
					itSelf.contact?.birthdayDate = Int64(date.timeIntervalSince1970)
				})
				.disposed(by: itSelf.bag)
		})
		.disposed(by: bag)
		
		mode.subscribe(onNext: { [weak self] (mode) in
			guard let itSelf = self else { return }
			
			switch mode {
			case .edit:
				itSelf.nameField?.isEnabled = true
				itSelf.phoneNumberField?.isEnabled = true
				itSelf.birthdayDatePicker?.isEnabled = true
				
				itSelf.navItem?.rightBarButtonItem = itSelf.saveButtonItem
				
			default: break
			}
		})
		.disposed(by: bag)
		
		let alertDriver: Driver<UIAlertController?> = alert.asDriver()
		
		return Output(showAlert: alertDriver)
	}
	
	// MARK: - Actions
	
	@objc private func changeContactMode() {
		mode.accept(.edit)
	}
	
	@objc private func saveContactAction() {
		switch mode.value {
		case .add:
			guard let name = trim(contact?.name),
						let phoneNumber = trim(contact?.phoneNumber),
						let birthdayDate = contact?.birthdayDate,
						!name.isEmpty,
						!phoneNumber.isEmpty else {
				
				alert.accept(createAlert(title: "Saving", message: "Fields has be not empty."))
				return
			}
			
			addContact(name: name,
								 phoneNumber: phoneNumber,
								 birthdayDate: birthdayDate)
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
	
	private func trim(_ content: String?) -> String? {
		guard let content = content else { return nil }
		
		return content.trimmingCharacters(in: .whitespacesAndNewlines)
	}
	
	private func createAlert(title: String, message: String) -> UIAlertController {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Ok", style: .default))
		
		return alert
	}
	
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
	
	private func addContact(name: String, phoneNumber: String, birthdayDate: Int64) {
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
	
	struct Output {
		let showAlert: Driver<UIAlertController?>
	}
	
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

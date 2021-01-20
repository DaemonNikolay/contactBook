//
//  WindowTransition.swift
//  PhotoMed
//
//  Created by Vladimir Shutov on 12/02/2019.
//  Copyright © 2019 PhotoMed. All rights reserved.
//

import UIKit

class WindowTransition: NSObject {
	weak var viewController: UIViewController?
}

// MARK: - Transition

extension WindowTransition: Transition {
	func open(_ viewController: UIViewController) {
		let appDelegate = UIApplication.shared.delegate as? AppDelegate
		let window = appDelegate?.window ?? UIWindow()
		window.rootViewController = viewController
		
		UIView.transition(
			with: window,
			duration: .transition,
			options: .transitionCrossDissolve,
			animations: nil,
			completion: nil
		)
		
		window.makeKeyAndVisible()
	}
	
	func close(_: UIViewController) {}
}

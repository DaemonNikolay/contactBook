//
//  WindowNavigationTransition.swift
//  FamilyClient
//
//  Created by Ivan Tsaryov on 05/04/2019.
//  Copyright © 2019 SBI. All rights reserved.
//

import UIKit

class WindowNavigationTransition: NSObject {
  weak var viewController: UIViewController?
}

// MARK: - Transition

extension WindowNavigationTransition: Transition {
  func open(_ viewController: UIViewController) {
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    let window = appDelegate?.window ?? UIWindow()
    window.rootViewController = UINavigationController(rootViewController: viewController)
		
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

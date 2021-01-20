//
//  ModalNavigationTransition.swift
//  UgCS
//
//  Created by Vladimir Shutov on 07/10/2019.
//  Copyright © 2019 65apps. All rights reserved.
//

import UIKit

class ModalNavigationTransition: NSObject {
  var animator: Animator?
  var isAnimated: Bool = true

  var modalTransitionStyle: UIModalTransitionStyle
  var modalPresentationStyle: UIModalPresentationStyle

  var completionHandler: (() -> Void)?

  weak var viewController: UIViewController?

  init(animator: Animator? = nil,
       isAnimated: Bool = true,
       modalTransitionStyle: UIModalTransitionStyle = .coverVertical,
       modalPresentationStyle: UIModalPresentationStyle = .fullScreen) {
    self.animator = animator
    self.isAnimated = isAnimated
    self.modalTransitionStyle = modalTransitionStyle
    self.modalPresentationStyle = modalPresentationStyle
  }
}

// MARK: - Transition

extension ModalNavigationTransition: Transition {
  @objc func open(_ viewController: UIViewController) {
    let navigationController = UINavigationController(rootViewController: viewController)

    navigationController.transitioningDelegate = self
    navigationController.modalTransitionStyle = modalTransitionStyle
    navigationController.modalPresentationStyle = modalPresentationStyle

    self
      .viewController?
      .present(navigationController, animated: isAnimated, completion: completionHandler)
  }

  func close(_ viewController: UIViewController) {
    viewController.dismiss(animated: isAnimated, completion: completionHandler)
  }
}

// MARK: - UIViewControllerTransitioningDelegate

extension ModalNavigationTransition: UIViewControllerTransitioningDelegate {
  func animationController(forPresented _: UIViewController,
                           presenting _: UIViewController,
                           source _: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    guard let animator = animator else {
      return nil
    }
    animator.isPresenting = true
    return animator
  }

  func animationController(forDismissed _: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    guard let animator = animator else {
      return nil
    }
    animator.isPresenting = false
    return animator
  }
}

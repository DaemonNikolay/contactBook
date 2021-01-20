//
// Created by Shishov Dmitry on 05.11.2019.
// Copyright (c) 2019 65apps. All rights reserved.
//

import UIKit

class PopupTransition: NSObject {
  var animator: Animator?
  var isAnimated: Bool = true
  var popoverArrowDirection: UIPopoverArrowDirection = .up

  var sourceObject: NSObject? {
    willSet {
      switch newValue {
      case let value as UIView:
        sourceView = value
        sourceBarButtonItem = nil
      case let value as UIBarButtonItem:
        sourceBarButtonItem = value
        sourceView = nil
      default:
        sourceView = nil
        sourceBarButtonItem = nil
      }
    }
  }

  private var sourceView: UIView?
  private var sourceBarButtonItem: UIBarButtonItem?

  var completionHandler: (() -> Void)?

  weak var viewController: UIViewController?

  init(animator: Animator? = nil,
       isAnimated: Bool = true,
       popoverArrowDirection: UIPopoverArrowDirection = .up,
       sourceView: NSObject? = nil) {
    self.animator = animator
    self.isAnimated = isAnimated
    self.popoverArrowDirection = popoverArrowDirection
    defer {
      self.sourceObject = sourceView
    }
    super.init()
  }
}

// MARK: - Transition

extension PopupTransition: Transition {
  @objc func open(_ viewController: UIViewController) {
    viewController.transitioningDelegate = self
    viewController.modalTransitionStyle = .coverVertical
    viewController.modalPresentationStyle = .popover
    guard let popoverController = viewController.popoverPresentationController else {
      return
    }
    popoverController.sourceView = sourceView
    popoverController.sourceRect = sourceView?.frame ?? CGRect.zero
    popoverController.barButtonItem = sourceBarButtonItem
    popoverController.permittedArrowDirections = popoverArrowDirection
    popoverController.delegate = self

    self
      .viewController?
      .present(viewController, animated: isAnimated, completion: completionHandler)
  }

  func close(_ viewController: UIViewController) {
    viewController.dismiss(animated: isAnimated, completion: completionHandler)
  }
}

// MARK: - UIViewControllerTransitioningDelegate

extension PopupTransition: UIViewControllerTransitioningDelegate {
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

// MARK: - UIPopoverPresentationControllerDelegate

extension PopupTransition: UIPopoverPresentationControllerDelegate {
  func adaptivePresentationStyleForPresentationController(controller _: UIPresentationController)
    -> UIModalPresentationStyle {
    return UIModalPresentationStyle.none
  }

  func adaptivePresentationStyle(for _: UIPresentationController, traitCollection _: UITraitCollection)
    -> UIModalPresentationStyle {
    return UIModalPresentationStyle.none
  }
}

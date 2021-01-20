//
//  FadeAnimator.swift
//  PhotoMed
//
//  Created by Vladimir Shutov on 12/02/2019.
//  Copyright © 2019 PhotoMed. All rights reserved.
//

import UIKit

final class FadeAnimator: NSObject, Animator {
  let isModal: Bool
  var isPresenting: Bool = true

  init(isModal: Bool = false) {
    self.isModal = isModal
    super.init()
  }

  func transitionDuration(using _: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.25
  }

  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    if isPresenting {
      present(using: transitionContext)
    } else {
      dismiss(using: transitionContext)
    }
  }

  private func present(using transitionContext: UIViewControllerContextTransitioning) {
    guard let toViewController = transitionContext.viewController(forKey: .to) else {
      return
    }

    let containerView = transitionContext.containerView
    containerView.addSubview(toViewController.view)

    toViewController.view.alpha = 0
    toViewController.view.frame = containerView.bounds
    toViewController.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]

    UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
      toViewController.view.alpha = 1.0
    }, completion: { _ in
      transitionContext.completeTransition(true)
    })
  }

  private func dismiss(using transitionContext: UIViewControllerContextTransitioning) {
    guard let toViewController = transitionContext.viewController(forKey: .to) else {
      return
    }
    guard let fromViewController = transitionContext.viewController(forKey: .from) else {
      return
    }

    if isModal == false {
      let containerView = transitionContext.containerView
      containerView.addSubview(toViewController.view)
      containerView.addSubview(fromViewController.view)
    }

    UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
      fromViewController.view.alpha = 0.0
    }, completion: { _ in
      transitionContext.completeTransition(true)
    })
  }
}

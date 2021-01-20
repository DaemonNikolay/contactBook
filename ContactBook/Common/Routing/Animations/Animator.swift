//
//  Animator.swift
//  PhotoMed
//
//  Created by Vladimir Shutov on 12/02/2019.
//  Copyright © 2019 PhotoMed. All rights reserved.
//

import UIKit

protocol Animator: UIViewControllerAnimatedTransitioning {
  var isPresenting: Bool { get set }
}

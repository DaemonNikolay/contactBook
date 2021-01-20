//
//  Transition.swift
//  PhotoMed
//
//  Created by Vladimir Shutov on 12/02/2019.
//  Copyright © 2019 PhotoMed. All rights reserved.
//

import UIKit

protocol Transition: AnyObject {
  var viewController: UIViewController? { get set }

  func open(_ viewController: UIViewController)
  func close(_ viewController: UIViewController)
}

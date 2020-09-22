//
//  UITableView+Register.swift
//  EDRD
//
//  Created by Oleksandr Yakobshe on 21.09.2020.
//  Copyright © 2020 Oleksandr Yakobshe. All rights reserved.
//

import UIKit

public extension UITableView {
  func register<T: UITableViewCell & Reusable>(_ aClass: T.Type, for identifier: String = T.reuseIdentifier) {
    if let aClass = aClass as? NibRepresentable.Type {
      register(aClass.nib, forCellReuseIdentifier: identifier)
    } else {
      register(aClass, forCellReuseIdentifier: identifier)
    }
  }
  
  func register<T: UITableViewHeaderFooterView & Reusable>(_ aClass: T.Type, for identifier: String = T.reuseIdentifier) {
    if let aClass = aClass as? NibRepresentable.Type {
      register(aClass.nib, forHeaderFooterViewReuseIdentifier: identifier)
    } else {
      register(aClass, forHeaderFooterViewReuseIdentifier: identifier)
    }
  }
}

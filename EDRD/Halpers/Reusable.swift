//
//  Reusable.swift
//  EDRD
//
//  Created by Oleksandr Yakobshe on 21.09.2020.
//  Copyright © 2020 Oleksandr Yakobshe. All rights reserved.
//

import UIKit

public protocol Reusable {
  static var reuseIdentifier: String { get }
}

public extension Reusable where Self: NSObject {
  static var reuseIdentifier: String {
    return className
  }
}

//
//  NSobject+ClassName.swift
//  EDRD
//
//  Created by Oleksandr Yakobshe on 21.09.2020.
//  Copyright © 2020 Oleksandr Yakobshe. All rights reserved.
//

import Foundation

public extension NSObject {
  static var className: String {
    return try! String(describing: self).substringMatches(regex: "[[:word:]]+").first!
  }
}

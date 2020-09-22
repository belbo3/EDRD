//
//  String+isBlank.swift
//  EDRD
//
//  Created by Oleksandr Yakobshe on 23.09.2020.
//  Copyright © 2020 Oleksandr Yakobshe. All rights reserved.
//

extension String {
  var isBlank: Bool {
    return allSatisfy({ $0.isWhitespace })
  }
}

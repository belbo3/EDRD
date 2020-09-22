//
//  String+Regex.swift
//  EDRD
//
//  Created by Oleksandr Yakobshe on 21.09.2020.
//  Copyright © 2020 Oleksandr Yakobshe. All rights reserved.
//

import Foundation

public extension String {
  func replacingMatches(regex: String, with string: String) -> String {
    return replacingOccurrences(of: regex, with: string, options: .regularExpression, range: nil)
  }
  
  func substringMatches(regex: String) throws -> [String] {
    let regex = try NSRegularExpression(pattern: regex, options: [])
    let range = NSMakeRange(0, (self as NSString).length)
    let matches = regex.matches(in: self, options: [], range: range)
    
    let string = self as NSString
    var substrings = [String]()
    for match in matches {
      substrings.append(string.substring(with: match.range) as String)
    }
    
    return substrings
  }
}

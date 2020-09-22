//
//  PersonModelSection.swift
//  EDRD
//
//  Created by Oleksandr Yakobshe on 21.09.2020.
//  Copyright © 2020 Oleksandr Yakobshe. All rights reserved.
//

import Foundation

struct PersonModelSection {
  var items: [PersonModelItem]
  
  init(items: [PersonModelItem]) {
    self.items = items
  }
}

enum PersonModelItem {
  case person(fullName: String?, job: String?, position: String?, comment: String?, id: String, bookAction: Action?, markAction: Action?)
}

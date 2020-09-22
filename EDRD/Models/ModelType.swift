//
//  ModelType.swift
//  EDRD
//
//  Created by Oleksandr Yakobshe on 22.09.2020.
//  Copyright © 2020 Oleksandr Yakobshe. All rights reserved.
//

enum ModelType: String {
  case favorite = "Favorite"
  
  var entity: String {
    switch self {
      case .favorite: return "Favorite"
    }
  }
}

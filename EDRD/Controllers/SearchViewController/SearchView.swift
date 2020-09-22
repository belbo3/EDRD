//
//  SearchView.swift
//  EDRD
//
//  Created by Oleksandr Yakobshe on 21.09.2020.
//  Copyright © 2020 Oleksandr Yakobshe. All rights reserved.
//

import UIKit

final class SearchView: UIView {
  // MARK: - Outlets
  
  @IBOutlet private(set) var tableView: UITableView! {
    didSet {
      tableView.allowsSelection = false
    }
  }
}

//
//  MainTabBarController.swift
//  EDRD
//
//  Created by Oleksandr Yakobshe on 21.09.2020.
//  Copyright © 2020 Oleksandr Yakobshe. All rights reserved.
//

import UIKit

final class MainTabBarController: UITabBarController {
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewControllers = [initialSearchController(), initialFavoriteController()]
  }
}

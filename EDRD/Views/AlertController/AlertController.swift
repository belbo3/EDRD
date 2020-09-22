//
//  AlertController.swift
//  EDRD
//
//  Created by Oleksandr Yakobshe on 22.09.2020.
//  Copyright © 2020 Oleksandr Yakobshe. All rights reserved.
//

// FIXME: - проверить работу 

import UIKit

struct AlertAction {
  var title: String
  var action: Action
}

protocol AlertController {
  func showAlert(title: String?, message: String?, actions: [AlertAction]) -> UIAlertController
}

extension AlertController {
  func showAlert(title: String?, message: String?, actions: [AlertAction]) -> UIAlertController {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    _ = actions.map { action in
      let action = UIAlertAction(title: action.title, style: .default, handler: {(alert: UIAlertAction!) in action.action()} )
      alertController.addAction(action)
    }
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    alertController.addAction(cancelAction)
    return alertController
  }
}

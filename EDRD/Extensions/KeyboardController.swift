//
//  KeyboardController.swift
//  EDRD
//
//  Created by Oleksandr Yakobshe on 23.09.2020.
//  Copyright © 2020 Oleksandr Yakobshe. All rights reserved.
//

import UIKit

public protocol KeyboardControllerDelegate: AnyObject {
  func keyboardWillShow(_ userInfo: [AnyHashable : Any])
  func keyboardWillHide(_ userInfo: [AnyHashable : Any])
  func keyboardDidShow(_ userInfo: [AnyHashable : Any])
  func keyboardDidHide(_ userInfo: [AnyHashable : Any])
}

open class KeyboardController: Then {
  // MARK: - Public properties
  
  open weak var delegate: KeyboardControllerDelegate?
  open weak var scrollView: UIScrollView? {
    didSet { defaultInset = scrollView?.contentInset ?? .zero }
  }
  
  // MARK: - Private properties
  
  private var defaultInset: UIEdgeInsets = .zero
  
  // MARK: - Inits
  
  public init() {
    let sel = #selector(keyboardNotification(_:))
    let center = NotificationCenter.default
    center.addObserver(self, selector: sel, name: UIView.keyboardWillShowNotification, object: nil)
    center.addObserver(self, selector: sel, name: UIView.keyboardWillHideNotification, object: nil)
    center.addObserver(self, selector: sel, name: UIView.keyboardDidShowNotification, object: nil)
    center.addObserver(self, selector: sel, name: UIView.keyboardDidHideNotification, object: nil)
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  // MARK: - Actions
  
  @objc private func keyboardNotification(_ notification: Notification) {
    guard let userInfo = notification.userInfo else { return }
    
    var inset = scrollView?.contentInset ?? .zero
    
    switch notification.name {
    case UIView.keyboardWillShowNotification:
      delegate?.keyboardWillShow(userInfo)
      let frame = (userInfo[UIView.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue ?? .zero
      let offset = (scrollView?.window?.frame.height ?? 0) - (scrollView?.frame.maxY ?? 0)
      inset.bottom = frame.height - offset
    case UIView.keyboardWillHideNotification:
      delegate?.keyboardWillHide(userInfo)
      inset = defaultInset
    case UIView.keyboardDidShowNotification:
      delegate?.keyboardDidShow(userInfo)
    case UIView.keyboardDidHideNotification:
      delegate?.keyboardDidHide(userInfo)
    default:
      return
    }
    
    scrollView?.contentInset = inset
  }
}

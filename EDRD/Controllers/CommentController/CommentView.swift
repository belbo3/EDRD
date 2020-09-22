//
//  CommentView.swift
//  EDRD
//
//  Created by Oleksandr Yakobshe on 23.09.2020.
//  Copyright © 2020 Oleksandr Yakobshe. All rights reserved.
//

import UIKit

final class CommentView: UIView {
  // MARK: - Outlets
  
  @IBOutlet private(set) var aligmentConstraintY: NSLayoutConstraint!
  
  @IBOutlet private(set) var textView: UITextView! {
    didSet {
      textView.text = nil
    }
  }
  
  @IBOutlet private(set) var cancelButton: UIButton! {
    didSet {
      cancelButton.setTitle("Cancel", for: .normal)
    }
  }
  
  @IBOutlet private(set) var okButton: UIButton! {
    didSet {
      okButton.setTitle("OK", for: .normal)
    }
  }
}

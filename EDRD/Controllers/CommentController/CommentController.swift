//
//  CommentController.swift
//  EDRD
//
//  Created by Oleksandr Yakobshe on 23.09.2020.
//  Copyright © 2020 Oleksandr Yakobshe. All rights reserved.
//

import UIKit

func initialCommentController(comment: String? = nil, callBack: @escaping (_ comment: String?) -> ()) -> UIViewController {
  let storyboard = UIStoryboard(name: "Storyboard", bundle: nil)
  
  let commentController = storyboard.instantiateViewController(withIdentifier: "CommentController") as! CommentController
  commentController.callBack = callBack
  commentController.comment = comment
  
  return commentController
}

final class CommentController: UIViewController {
  // MARK: - Properties
  
  private var mainView: CommentView {
    get { view as! CommentView }
  }
  
  private var keyboardController = KeyboardController()
  
  var callBack: ((_ comment: String?) -> ())!
  
  var comment: String? {
    get { mainView.textView.text }
    set { mainView.textView.text = newValue }
  }
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    keyboardController.delegate = self
    
    mainView.cancelButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
    mainView.okButton.addTarget(self, action: #selector(okAction), for: .touchUpInside)
  }
  
  // MARK: - Actions
  
  @objc private func cancelAction() {
    dismiss(animated: true, completion: nil)
  }
  
  @objc private func okAction() {
    if let text = mainView.textView.text, !text.isBlank {
      callBack(text)
    } else {
      callBack(nil)
    }
    dismiss(animated: true, completion: nil)
  }
}

// MARK: - KeyboardControllerDelegate

extension CommentController: KeyboardControllerDelegate {
  
  func keyboardWillShow(_ userInfo: [AnyHashable : Any]) {
    if let keyboardFrame: NSValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
      let keyboardRectangle = keyboardFrame.cgRectValue
      let keyboardHeight = keyboardRectangle.height
      let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
      let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
      UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions(rawValue: curve), animations: {
        self.mainView.aligmentConstraintY.constant = -(keyboardHeight / 2)
        self.mainView.layoutIfNeeded()
      }, completion: nil)
    }
  }
  
  func keyboardWillHide(_ userInfo: [AnyHashable : Any]) {
    let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
    let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
    UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions(rawValue: curve), animations: {
      self.mainView.aligmentConstraintY.constant = 0
      self.mainView.layoutIfNeeded()
    }, completion: nil)
  }
  
  func keyboardDidShow(_ userInfo: [AnyHashable : Any]) {}
  
  func keyboardDidHide(_ userInfo: [AnyHashable : Any]) {}
}

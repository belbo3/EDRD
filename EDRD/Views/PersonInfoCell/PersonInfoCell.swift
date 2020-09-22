//
//  PersonInfoCell.swift
//  EDRD
//
//  Created by Oleksandr Yakobshe on 21.09.2020.
//  Copyright © 2020 Oleksandr Yakobshe. All rights reserved.
//

import UIKit

typealias Action = () -> ()

final class PersonInfoCell: UITableViewCell, Reusable, NibRepresentable {
  // MARK: - Outlets
  
  @IBOutlet private var fullNameLabel: UILabel! {
    didSet {
      fullNameLabel.numberOfLines = 0
    }
  }
  
  @IBOutlet private var jobLabel: UILabel! {
    didSet {
      jobLabel.numberOfLines = 0
    }
  }
  
  @IBOutlet private var positionLabel: UILabel! {
    didSet {
      positionLabel.numberOfLines = 0
    }
  }
  
  @IBOutlet private var commentLabel: UILabel! {
    didSet {
      commentLabel.numberOfLines = 0
    }
  }
  
  @IBOutlet private var bookButton: UIButton! {
    didSet {
      bookButton.addTarget(self, action: #selector(bookButtonAction), for: .touchUpInside)
      bookButton.setImage(.icBook, for: .normal)
    }
  }
  
  @IBOutlet private var markButton: UIButton! {
    didSet {
      markButton.addTarget(self, action: #selector(markButtonAction), for: .touchUpInside)
      markButton.setImage(.icMarkPassive, for: .normal)
    }
  }
  
  // MARK: - Properties
  
  var fullName: String? {
    get { fullNameLabel.text }
    set { fullNameLabel.text = newValue }
  }
  
  var job: String? {
    get { jobLabel.text }
    set { jobLabel.text = newValue }
  }
  
  var position: String? {
    get { positionLabel.text }
    set { positionLabel.text = newValue }
  }
  
  var comment: String? {
    get { commentLabel.text }
    set {
      commentLabel.text = newValue
      commentLabel.isHidden = newValue == nil
    }
  }
  
  var bookAction: Action? {
    didSet {
      bookButton.isHidden = bookAction == nil
    }
  }
  
  var markAction: Action?
  
  var favoriteMark: Bool = false {
    didSet {
      if favoriteMark {
        markButton.setImage(.icMarkActive, for: .normal)
      } else {
        markButton.setImage(.icMarkPassive, for: .normal)
      }
    }
  }
  
  // MARK: - Lifecycle
  
  override public func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override public func prepareForReuse() {
    super.prepareForReuse()
    fullName = nil
    job = nil
    position = nil
    comment = nil
    bookAction = nil
    markAction = nil
  }
  
  // MARK: - Actions
  
  @objc private func bookButtonAction() {
    bookAction?()
  }
  
  @objc private func markButtonAction() {
    markAction?()
  }
}

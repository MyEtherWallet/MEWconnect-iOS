//
//  CheckboxButton.swift
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 18/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

import UIKit
import M13Checkbox

private struct CheckboxButtonConstants {
  struct button {
    static let height: CGFloat = 112.0
    static let highlightOpacity: Float = 0.5
    static let leading: CGFloat = 16.0
    static let trailing: CGFloat = 8.0
  }
  struct checkbox {
    static let height: CGFloat = 32.0
    static let leading: CGFloat = 16.0
  }
  struct image {
    static let trailing: CGFloat = 16.0
    static let cornerRadius: CGFloat = 5.0
  }
}

private struct SignedMessageConstants {
  struct Fields {
    static let Address  = "address"
    static let Msg      = "msg"
    static let Sig      = "sig"
    static let Version  = "version"
    static let Signer   = "signer"
  }
  struct Values {
    static let Version  = "3"
    static let Signer   = "MEW"
  }
}

@objc
class CheckboxButton: UIButton {
  private let checkboxView = M13Checkbox(frame: .zero)
  private var rightImageView: UIImageView?
  
  private var contentTitle: String? { didSet { _update() } }
  private var contentText: String? { didSet { _update() } }
  private var contentDescription: String? { didSet { _update() } }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    _commonInit();
  }
  
  //MARK: - Public
  
  func update(withContentTitle text: String?) {
    contentTitle = text
  }
  
  func update(withContentText text: String?) {
    contentText = text
  }
  
  func update(withContentDescription text: String?) {
    contentDescription = text
  }
  
  func update(rightImage image: UIImage?) {
    if image != nil {
      if rightImageView == nil {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = CheckboxButtonConstants.image.cornerRadius
        imageView.translatesAutoresizingMaskIntoConstraints = false
        rightImageView = imageView
      }
      if let imageView = self.rightImageView, imageView.superview == nil {
        self.addSubview(imageView)
        imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: CheckboxButtonConstants.image.trailing).isActive = true
      }
      rightImageView?.image = image
    } else {
      rightImageView?.removeFromSuperview()
    }
    setNeedsLayout()
    layoutIfNeeded()
  }
  
  //MARK: - Private
  
  private func _commonInit() {
    titleLabel?.numberOfLines = 0
    //Checkbox
    checkboxView.isUserInteractionEnabled = false
    checkboxView.stateChangeAnimation = .bounce(.fill)
    checkboxView.translatesAutoresizingMaskIntoConstraints = false
    checkboxView.enableMorphing = true
    checkboxView.checkmarkLineWidth = 2.0
    checkboxView.tintColor = .mainApplication()
    checkboxView.secondaryTintColor = .mainApplication()
    addSubview(checkboxView)
    
    checkboxView.heightAnchor.constraint(equalToConstant: CheckboxButtonConstants.checkbox.height).isActive = true
    checkboxView.widthAnchor.constraint(equalTo: checkboxView.heightAnchor).isActive = true
    checkboxView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: CheckboxButtonConstants.checkbox.leading).isActive = true
    checkboxView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    
    setNeedsLayout()
    layoutIfNeeded()
  }
  
  private func _update() {
    
    let attributedTitle = NSMutableAttributedString()
    let contentDescriptionFontSize: CGFloat
    let contentTextFontSize: CGFloat
    let contentTitleFontSize: CGFloat
    
    if UIScreen.main.screenSizeType() == .inches40 {
      contentDescriptionFontSize = 13.0
      contentTextFontSize = 13.0
      contentTitleFontSize = 14.0
    } else {
      contentDescriptionFontSize = 14.0
      contentTextFontSize = 17.0
      contentTitleFontSize = 14.0
    }
    
    if let cDescription = contentDescription {
      let descriptionAttributes:[String:Any] = [NSFontAttributeName: UIFont.systemFont(ofSize: contentDescriptionFontSize, weight: UIFontWeightRegular),
                                                NSForegroundColorAttributeName: UIColor.lightGreyText(),
                                                NSParagraphStyleAttributeName: NSParagraphStyle()]
      attributedTitle.append(NSAttributedString(string: cDescription, attributes: descriptionAttributes))
    }
    if let cText = contentText {
      let text: String
      if attributedTitle.length > 0 {
        text = cText + "\n"
      } else {
        text = cText
      }
      let textParagraphStyle = NSMutableParagraphStyle()
      textParagraphStyle.lineSpacing = 4.0
      textParagraphStyle.paragraphSpacing = 2.0
      let textAttributes = [NSFontAttributeName: UIFont.systemFont(ofSize: contentTextFontSize, weight: UIFontWeightSemibold),
                            NSForegroundColorAttributeName: UIColor.black,
                            NSParagraphStyleAttributeName: textParagraphStyle]
      attributedTitle.insert(NSAttributedString(string: text, attributes: textAttributes), at: 0)
    }
    if let cTitle = contentTitle {
      let text: String
      if attributedTitle.length > 0 {
        text = cTitle + "\n"
      } else {
        text = cTitle
      }
      let titleParagraphSpacing = NSMutableParagraphStyle()
      titleParagraphSpacing.paragraphSpacing = 6.0
      let titleAttributes = [NSFontAttributeName: UIFont.systemFont(ofSize: contentTitleFontSize, weight: UIFontWeightRegular),
                             NSForegroundColorAttributeName: UIColor.black,
                             NSParagraphStyleAttributeName: titleParagraphSpacing]
      attributedTitle.insert(NSAttributedString(string: text, attributes: titleAttributes), at: 0)
    }
    
    setAttributedTitle(attributedTitle, for: .normal)
    setAttributedTitle(attributedTitle, for: .selected)
  }
  
  //MARK: - Override frames
  
  override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
    var rect = super.titleRect(forContentRect: contentRect)
    rect.origin.x = checkboxView.frame.maxX + CheckboxButtonConstants.button.leading
    rect.size.width = bounds.width - rect.minX - (rightImageView?.bounds.width ?? 0.0) - (rightImageView != nil ? CheckboxButtonConstants.button.trailing : 0.0) - CheckboxButtonConstants.image.trailing
    return rect
  }
  
  //MARK: - Override states
  
  override var isSelected: Bool {
    didSet {
      self.checkboxView.setCheckState(isSelected ? .checked : .unchecked, animated: true)
      _update()
    }
  }
  
  override var isHighlighted: Bool {
    didSet {
      UIView.beginAnimations(nil, context: nil)
      CATransaction.begin()
      layer.opacity = isHighlighted ? CheckboxButtonConstants.button.highlightOpacity : 1.0
      CATransaction.commit()
      UIView.commitAnimations()
    }
  }
  
  //MARK: - Layout
  
  override var intrinsicContentSize: CGSize {
    return CGSize(width: UIViewNoIntrinsicMetric, height: CheckboxButtonConstants.button.height)
  }
}

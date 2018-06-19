//
//  UIImage+RandSeed.swift
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 09/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
  func part(seed: String, size: CGSize) -> UIImage? {
    let randOrigin = CGPoint.rand(seed: seed)
    let scaledSize = CGSize(width: size.width * scale,
                            height: size.height * scale)
    let croppingFrame = CGRect(origin: CGPoint(x: round(randOrigin.x * (self.size.width - scaledSize.width)),
                                               y: round(randOrigin.y * (self.size.height - scaledSize.height))),
                               size: scaledSize)
    guard let cgImagePart = cgImage?.cropping(to: croppingFrame) else { return nil }
    return UIImage(cgImage: cgImagePart, scale: scale, orientation: imageOrientation)
  }
}

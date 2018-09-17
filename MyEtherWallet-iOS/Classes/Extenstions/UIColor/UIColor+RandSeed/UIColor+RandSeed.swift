//
//  UIColor+RandSeed.swift
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 10/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

import UIKit

extension UIColor {
  static func color(seed: String) -> [UIColor] {
    var colors:[UIColor] = [];
    var randSeed = seed.randSeed()
    colors.append(UIColor(seed: &randSeed) ?? UIColor.black)
    colors.append(UIColor(seed: &randSeed) ?? UIColor.black)
    colors.append(UIColor(seed: &randSeed) ?? UIColor.black)
    return colors
  }
  
  convenience init?(seed: inout [UInt32]) {
    let h = Double(seed.rand() * 360)
    let s = Double(((seed.rand() * 60) + 40)) / Double(100)
    let l = Double((seed.rand() + seed.rand() + seed.rand() + seed.rand()) * 25) / Double(100)
    
    self.init(h: h, s: s, l: l)
  }
}

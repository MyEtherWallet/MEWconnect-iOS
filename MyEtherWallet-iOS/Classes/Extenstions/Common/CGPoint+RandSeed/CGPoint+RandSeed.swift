//
//  CGPoint+RandSeed.swift
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 10/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

import UIKit

extension CGPoint {
  static func rand(seed: String) -> CGPoint {
    var randSeed = seed.randSeed(count: 2)
    let x = Double(((randSeed.rand() + randSeed.rand()) * 40) + 10) / Double(100)
    let y = Double(((randSeed.rand() + randSeed.rand()) * 45) + 5) / Double(100)
    return CGPoint(x: x, y: y)
  }
}

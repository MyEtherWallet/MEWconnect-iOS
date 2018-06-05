//
//  CheckboxButton+Blockies.swift
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 18/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

import Foundation
import BlockiesSwift

extension CheckboxButton {
  func update(rightImageWithSeed seed: String) {
    let blockies = Blockies(seed: seed.lowercased())
    update(rightImage: blockies.createImage())
  }
}

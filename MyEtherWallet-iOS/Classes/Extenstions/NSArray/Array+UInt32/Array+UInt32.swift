//
//  Array+UInt32.swift
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 10/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

import Foundation

extension Array where Element == UInt32 {
  mutating func rand() -> Double {
    let t = (self.first ?? 0) ^ ((self.first ?? 0) << 11)
    let tmp = Int32(bitPattern: self.last ?? 0)
    let tmpT = Int32(bitPattern: t)
    
    //shift items
    self.remove(at: 0)
    self.append(UInt32(bitPattern: (tmp ^ (tmp >> 19) ^ tmpT ^ (tmpT >> 8))))
    
    let divisor = Int32.max
    
    return Double((UInt32(self.last ?? 0) >> UInt32(0))) / Double(divisor)
  }
}

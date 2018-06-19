//
//  HexNSDecimalNumber.swift
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 04/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

import Foundation
import BigInt

@objc
extension NSString {
  func hexStringToDecimalString() -> NSString? {
    var str = self as String
    if str.hasPrefix("0x") {
      let indexStart = str.index(str.startIndex, offsetBy: 2)
      str = String(str[indexStart...])
    }
    
    guard let bigUInt = BigUInt(str, radix: 16) else { return nil }
    let decimalString = String(bigUInt, radix: 10)
    return decimalString as NSString
//
//
//    var asd = "0x0771d2fbfbcfa436037800"
//
//    if asd.hasPrefix("0x") {
//      let indexStart = asd.index(asd.startIndex, offsetBy: 2)
//      asd = String(asd[indexStart...])
//    }
//
//    let bui = BigUInt(asd, radix: 16)
//    let str = String(bui!, radix: 10)
//
//    return nil
    
  }
}

//
//  Web3SwiftWrapper.swift
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 24/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

import Foundation
import web3swift
import BigInt
/*
class Web3SwiftWrapper:NSObject {
  public class func hash(data: Data) -> Data? {
    return Web3.Utils.hashPersonalMessage(data);
  }
  
  public class func test() {
    var asd = "0x0771d2fbfbcfa436037800"
    
    if asd.hasPrefix("0x") {
      let indexStart = asd.index(asd.startIndex, offsetBy: 2)
      asd = String(asd[indexStart...])
    }
    
    let bui = BigUInt(asd, radix: 16)
    let str = String(bui!, radix: 10)
    
    
    let jsonString = "{\"version\":3,\"id\":\"1e4834eb-5f7f-4001-a1d1-f603680fb1f2\",\"crypto\":{\"ciphertext\":\"6a1fe3789a907547a83c32be9d3bdabe78e85d5ea7cff6fef3f992ba0947c137\",\"cipherparams\":{\"iv\":\"fea0aaafeb7a2bdaa7b8067c69db4606\"},\"kdf\":\"scrypt\",\"kdfparams\":{\"r\":8,\"p\":6,\"n\":4096,\"dklen\":32,\"salt\":\"84813de1461cb85a84fb3f33272af3f8a1b9cf581fe03999515b396c1921bfeb\"},\"mac\":\"9c680c2ffc21aaecd58f9ffa73cee735cf2be9d6080296988cd38f7d978f86b8\",\"cipher\":\"aes-128-ctr\"},\"type\":\"private-key\",\"address\":\"6d7bA7b29e601EFd15148Bb83a40796dFA550065\"}";
//    let jsonString = "[{\"constant\":true,\"inputs\":[],\"name\":\"name\",\"outputs\":[{\"name\":\"\",\"type\":\"string\"}],\"payable\":false,\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"name\":\"_spender\",\"type\":\"address\"},{\"name\":\"_value\",\"type\":\"uint256\"}],\"name\":\"approve\",\"outputs\":[{\"name\":\"success\",\"type\":\"bool\"}],\"payable\":false,\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"totalSupply\",\"outputs\":[{\"name\":\"\",\"type\":\"uint256\"}],\"payable\":false,\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"name\":\"_from\",\"type\":\"address\"},{\"name\":\"_to\",\"type\":\"address\"},{\"name\":\"_value\",\"type\":\"uint256\"}],\"name\":\"transferFrom\",\"outputs\":[{\"name\":\"success\",\"type\":\"bool\"}],\"payable\":false,\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"decimals\",\"outputs\":[{\"name\":\"\",\"type\":\"uint8\"}],\"payable\":false,\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"version\",\"outputs\":[{\"name\":\"\",\"type\":\"string\"}],\"payable\":false,\"type\":\"function\"},{\"constant\":true,\"inputs\":[{\"name\":\"_owner\",\"type\":\"address\"}],\"name\":\"balanceOf\",\"outputs\":[{\"name\":\"balance\",\"type\":\"uint256\"}],\"payable\":false,\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"symbol\",\"outputs\":[{\"name\":\"\",\"type\":\"string\"}],\"payable\":false,\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"name\":\"_to\",\"type\":\"address\"},{\"name\":\"_value\",\"type\":\"uint256\"}],\"name\":\"transfer\",\"outputs\":[{\"name\":\"success\",\"type\":\"bool\"}],\"payable\":false,\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"name\":\"_spender\",\"type\":\"address\"},{\"name\":\"_value\",\"type\":\"uint256\"},{\"name\":\"_extraData\",\"type\":\"bytes\"}],\"name\":\"approveAndCall\",\"outputs\":[{\"name\":\"success\",\"type\":\"bool\"}],\"payable\":false,\"type\":\"function\"},{\"constant\":true,\"inputs\":[{\"name\":\"_owner\",\"type\":\"address\"},{\"name\":\"_spender\",\"type\":\"address\"}],\"name\":\"allowance\",\"outputs\":[{\"name\":\"remaining\",\"type\":\"uint256\"}],\"payable\":false,\"type\":\"function\"},{\"inputs\":[{\"name\":\"_initialAmount\",\"type\":\"uint256\"},{\"name\":\"_tokenName\",\"type\":\"string\"},{\"name\":\"_decimalUnits\",\"type\":\"uint8\"},{\"name\":\"_tokenSymbol\",\"type\":\"string\"}],\"type\":\"constructor\"},{\"payable\":false,\"type\":\"fallback\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"name\":\"_from\",\"type\":\"address\"},{\"indexed\":true,\"name\":\"_to\",\"type\":\"address\"},{\"indexed\":false,\"name\":\"_value\",\"type\":\"uint256\"}],\"name\":\"Transfer\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"name\":\"_owner\",\"type\":\"address\"},{\"indexed\":true,\"name\":\"_spender\",\"type\":\"address\"},{\"indexed\":false,\"name\":\"_value\",\"type\":\"uint256\"}],\"name\":\"Approval\",\"type\":\"event\"},]"
    // create normal keystore
    
//    base hole face guess possible child rain brief produce crash person decorate
    
    let keystoreV3 = EthereumKeystoreV3(jsonString)

     let userDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
//    try? FileManager.default.removeItem(atPath: userDir + "/bip32_keystore"+"/key.json")
    //create BIP32 keystore
    let bip32keystoreManager = KeystoreManager.managerForPath(userDir + "/bip32_keystore", scanForHDwallets: true)
    var bip32ks: BIP32Keystore? = bip32keystoreManager?.bip32keystores.first
    if (bip32ks == nil) {
      bip32ks = try! BIP32Keystore.init(mnemonics: "base hole face guess possible child rain brief produce crash person decorate", password: "", mnemonicsPassword: "", language: .english, prefixPath: HDNode.defaultPath)
      let keydata = try! JSONEncoder().encode(bip32ks!.keystoreParams)
      FileManager.default.createFile(atPath: userDir + "/bip32_keystore"+"/key.json", contents: keydata, attributes: nil)
    } else {
      bip32ks = bip32keystoreManager?.bip32keystores.first
    }
    print(bip32ks?.addresses)
    guard let bip32sender = bip32ks?.addresses?.first else {return}
    print(bip32sender)
    
//{"nonce":"0x00",
//  "gasPrice":"0x098bca5a00",
//  "gasLimit":"0x52d4",
//  "to":"0x66030EAD7F8DC9dAA14a58c799Ac49fe14B063B9",
//  "value":"0x0de0b6b3a7640000",
//  "data":"0x011111",
//  "chainId":1}

//    0xf86f8085098bca5a008252d49466030ead7f8dc9daa14a58c799ac49fe14b063b9880de0b6b3a76400008301111126a0f6abd626cd8d39b8af2dfb64561b54188de1aefe762181a8e0cd1b97ab6d33b2a074ab9bfaf8204437366348988c6a980b9dfca19797c1948110edbaabaa73001d
    
    var trans = EthereumTransaction(gasPrice: 0x098bca5a00,
                        gasLimit: 0x52d4,
                        to: EthereumAddress("0x66030EAD7F8DC9dAA14a58c799Ac49fe14B063B9"),
                        value: 0x1bc16d674ec80000,
                        data: Data.fromHex("0x222222")!)
    trans.UNSAFE_setChainID(1)
    
    let pdks = try! bip32ks?.UNSAFE_getPrivateKeyData(password: "", account: bip32sender)
    try! Web3Signer.EIP155Signer.sign(transaction: &trans, privateKey: pdks!, useExtraEntropy: false)
    let ksEnc = trans.encode()?.toHexString()
    let ksHash = trans.hash;
    let txid = trans.txid;
    
//    let verifier = EthereumTransaction.fromRaw(Data.fromHex(ksEnc!)!)
    
//    let verifier = EthereumTransaction.fromRaw(Data.fromHex("0xf86f8085098bca5a008252d49466030ead7f8dc9daa14a58c799ac49fe14b063b9881bc16d674ec800008322222226a02bca58f825777f87e6655bc616a0106569346b8b4aae0a520922e127c3c1757ca02d5e381780b0ed60e6897aebe5de769b188d8eec3207cc781fb80eefee17ec2e")!)
    
    
//    0xf86f8085098bca5a008252d49466030ead7f8dc9daa14a58c799ac49fe14b063b9881bc16d674ec800008322222226a02bca58f825777f87e6655bc616a0106569346b8b4aae0a520922e127c3c1757ca02d5e381780b0ed60e6897aebe5de769b188d8eec3207cc781fb80eefee17ec2e
    //0xf86f8085098bca5a008252d49466030ead7f8dc9daa14a58c799ac49fe14b063b9881bc16d674ec800008322222226a02bca58f825777f87e6655bc616a0106569346b8b4aae0a520922e127c3c1757ca02d5e381780b0ed60e6897aebe5de769b188d8eec3207cc781fb80eefee17ec2e
//    0xf86f8085098bca5a008252d49466030ead7f8dc9daa14a58c799ac49fe14b063b9881bc16d674ec800008322222226a0f57be22162144d602f9f7425248db973b0046b0ce9d7022c504c9daa5e85b2eaa03ce926340f9390a84f3f52830ebf22c9cd85e5cfe72e947a8e8de83f18f7168e
    
    
//    let tr = trans.encode(forSignature: false, chainID: 1)
//    try? Web3Signer.signTX(transaction: &trans, keystore: bip32ks!, account: bip32sender, password: "")
//    let data = trans.encode(forSignature: false, chainID: 1)!
    print("encode")
    let tt = Web3HttpProvider(URL(string: "https://api.myetherapi.com/eth")!)
    tt?.attachedKeystoreManager = bip32keystoreManager
//    tt?.sendWithRawResult(request: <#T##JSONRPCrequest#>)

    let w3 = web3(provider: tt!);
    var w3options = Web3Options.defaultOptions()
    w3options.from = bip32ks?.addresses!.first!
    w3options.to = bip32ks?.addresses!.first!
    w3options.gasLimit = trans.gasLimit;
    w3options.gasPrice = trans.gasPrice;
    w3options.value = trans.value;
    let txv = w3.browserFunctionsFunctions.signTransaction(trans, options: w3options, password: "")
//    let txv = w3.browserFunctionsFunctions.prepareTxForApproval(trans, options: Web3Options.defaultOptions())
    print(txv)
//    web3.init(provider: <#T##Web3Provider#>, queue: <#T##OperationQueue?#>, dispatcher: <#T##OperationDispatcher?#>)
//    print(String(data: data, encoding: .utf8))
//    let sign = try? Web3Signer.FallbackSigner.sign(transaction: &trans, privateKey: bip32ks!.UNSAFE_getPrivateKeyData(password: "", account: bip32sender))
//    let sign = try? Web3Signer.signTX(transaction: &trans, keystore: bip32ks!, account: bip32sender, password: "")
//    print(trans.description)
    
    let data = "Test message".data(using: .utf8)!
    let hashdata = Web3.Utils.hashPersonalMessage(data)!;
    
//    let testmessage = try? Web3Signer.signPersonalMessage(data, keystore: bip32ks!, account: bip32sender, password: "", useExtraEntropy: false)
    let messageSign = w3.browserFunctionsFunctions.sign(data, account: "0x66030EAD7F8DC9dAA14a58c799Ac49fe14B063B9", password: "")
    print(messageSign)
    
    
    print("asd")
    
//    {
//      "address": "0x66030ead7f8dc9daa14a58c799ac49fe14b063b9",
//      "msg": "Test message",
//      "sig": "0x22a21f44e3a74e06579042d2ca781a972e7d3b12331e34f38b2e1b24fce62101404a91e199ee17d3528d3bc8b49f9d7c392b480fc16b6a7c24924211f239b3311c",
//      "version": "3",
//      "signer": "MEW"
//    }
    
    
    
//
//
//
//    print(keystoreV3?.addresses ?? "")
//    let privateKey = try! keystoreV3?.UNSAFE_getPrivateKeyData(password: "Arnold20", account: (keystoreV3?.addresses![0] as! EthereumAddress))
//
//    print(privateKey)
//
//    {
//      "address": "0x6d7ba7b29e601efd15148bb83a40796dfa550065",
//      "msg": "Test message",
//      "sig": "0xa4d315d93399d9dd3832d5611457746f42ba477dd6931dfe856c7fc84ed68ad3301a26f9fe74215c931bdf184f47d20cab2066773109b3e453b158bee058f8421c",
//      "version": "3",
//      "signer": "MEW"
//    }
    
    
//    JSONDecoder().decode(<#T##type: Decodable.Protocol##Decodable.Protocol#>, from: <#T##Data#>)
    
//    try! EthereumKeystoreV3(<#T##jsonString: String##String#>)
//
//    let userDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
//    let keystoreManager = KeystoreManager.managerForPath(userDir + "/keystore")
//    var ks: EthereumKeystoreV3?
//    if (keystoreManager?.addresses?.count == 0) {
//      ks = try! EthereumKeystoreV3(password: "BANKEXFOUNDATION")
//      let keydata = try! JSONEncoder().encode(ks!.keystoreParams)
//      FileManager.default.createFile(atPath: userDir + "/keystore"+"/key.json", contents: keydata, attributes: nil)
//    } else {
//      ks = keystoreManager?.walletForAddress((keystoreManager?.addresses![0])!) as! EthereumKeystoreV3
//    }
//    guard let sender = ks?.addresses?.first else {return}
//    print(sender)
  }
}
*/

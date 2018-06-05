//
//  Web3Wrapper.swift
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 03/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

import Foundation
import web3swift
import KeychainAccess
import BigInt
import Result

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

enum TransactionParametersField: String {
  case data     = "data"
  case from     = "from"
  case gas      = "gas"
  case gasPrice = "gasPrice"
  case to       = "to"
  case value    = "value"
  static let allValues = [data, from, gas, gasPrice, to, value]
}

extension TransactionParameters {
  static func fieldKeyPath(_ key: TransactionParametersField) -> WritableKeyPath<TransactionParameters, String?> {
    switch key {
    case .data: return \TransactionParameters.data
    case .from: return \TransactionParameters.from
    case .gas: return \TransactionParameters.gas
    case .gasPrice: return \TransactionParameters.gasPrice
    case .to: return \TransactionParameters.to
    case .value: return \TransactionParameters.value
    }
  }
}

@objc
class Web3Wrapper: NSObject {
  static func hash(data: Data) -> Data? {
    return Web3.Utils.hashPersonalMessage(data);
  }
  
  static func createWallet(password: String, words: [String]?) -> String? {
    let mnemonics: String
    if words != nil {
      mnemonics = words!.joined(separator: " ")
    } else {
      guard let generatedMnemonics = try? BIP39.generateMnemonics(bitsOfEntropy: 256, language: .english), generatedMnemonics != nil else { return nil }
      mnemonics = generatedMnemonics!
    }
    
    guard let bip32Keystore = try? BIP32Keystore(mnemonics: mnemonics, password: password, mnemonicsPassword: "", language: .english, prefixPath: HDNode.defaultPath), bip32Keystore != nil else { return nil }
    
    guard let keydata = try? JSONEncoder().encode(bip32Keystore!.keystoreParams) else { return nil }
    let keychain = Keychain(service: "mew")
    keychain[data: "keydata"] = keydata
    /* Restoring case */
    if words == nil {
      guard let entropy = BIP39.mnemonicsToEntropy(mnemonics) else { return nil }
      keychain[data: "entropy"] = entropy
    } else {
      //Make sure that we don't have entropy from anywhere
      try? keychain.remove("entropy")
    }
    
    guard let account = bip32Keystore?.addresses?.first else { return nil }
    return account.address
  }
  
  static func validatePassword(password: String) -> String? {
    let keychain = Keychain(service: "mew")
    guard let keydata = keychain[data: "keydata"] else { return nil }
    
    guard let bip32Keystore = BIP32Keystore(keydata) else { return nil }
    guard let account = bip32Keystore.addresses?.first else { return nil }
    do {
      _ = try bip32Keystore.UNSAFE_getPrivateKeyData(password: password, account: account/*, prefixPath: HDNode.defaultPathMetamaskPrefix*/)
    } catch {
      return nil
    }
    return account.address
  }
  
  static func obtainAddress() -> String? {
    let keychain = Keychain(service: "mew")
    guard let keydata = keychain[data: "keydata"] else { return nil }
    
    guard let bip32Keystore = BIP32Keystore(keydata) else { return nil }
    guard let account = bip32Keystore.addresses?.first else { return nil }
    return account.address
  }
  
  static func signMessage(_ message: String, password: String) -> [String: String]? {
    let keychain = Keychain(service: "mew")
    guard let keydata = keychain[data: "keydata"] else { return nil }
    
    guard let bip32Keystore = BIP32Keystore(keydata) else { return nil }
    guard let account = bip32Keystore.addresses?.first else { return nil }
    guard var privateKey = try? bip32Keystore.UNSAFE_getPrivateKeyData(password: password, account: account/*, prefixPath: HDNode.defaultPath*/) else { return nil }
    defer {Data.zero(&privateKey)}
    
    guard let data = message.data(using: .utf8) else { return nil }
    guard let hashData = Web3.Utils.hashPersonalMessage(data) else { return nil }
    
    guard let signedData = SECP256K1.signForRecovery(hash: hashData, privateKey: privateKey, useExtraEntropy: false).serializedSignature else { return nil }
    let signedMessage = signedData.toHexString().addHexPrefix()
    var signature: [String: String] = [:]
    signature[SignedMessageConstants.Fields.Address]  = account.address
    signature[SignedMessageConstants.Fields.Msg]      = message
    signature[SignedMessageConstants.Fields.Sig]      = signedMessage
    signature[SignedMessageConstants.Fields.Version]  = SignedMessageConstants.Values.Version
    signature[SignedMessageConstants.Fields.Signer]   = SignedMessageConstants.Values.Signer
    
    return signature
  }
  
  static func signTransaction(_ transaction: MEWConnectTransaction, password: String) -> String? {
    let keychain = Keychain(service: "mew")
    guard let keydata = keychain[data: "keydata"] else { return nil }
    
    guard let bip32Keystore = BIP32Keystore(keydata) else { return nil }
    guard let account = bip32Keystore.addresses?.first else { return nil }
    guard var privateKey = try? bip32Keystore.UNSAFE_getPrivateKeyData(password: password, account: account/*, prefixPath: HDNode.defaultPath*/) else { return nil }
    defer {Data.zero(&privateKey)}
    
    guard let gasPrice = BigUInt(transaction.gasPrice.stripHexPrefix(), radix: 16) else { return nil }
    guard let gasLimit = BigUInt(transaction.gasLimit.stripHexPrefix(), radix: 16) else { return nil }
    guard let value = BigUInt(transaction.value.stripHexPrefix(), radix: 16) else { return nil }
    guard let data = Data.fromHex(transaction.data) else { return nil }
    guard let nonce = BigUInt(transaction.nonce.stripHexPrefix(), radix: 16) else { return nil }
    let chainId = BigUInt(transaction.chainId.intValue)
    
    guard let to = EthereumAddress(transaction.to) else { return nil }
    
    var ethereumTransaction = EthereumTransaction(gasPrice: gasPrice,
                                                  gasLimit: gasLimit,
                                                  to: to,
                                                  value: value,
                                                  data: data)
    
    ethereumTransaction.UNSAFE_setChainID(chainId)
    ethereumTransaction.nonce = nonce
    
    do {
      try Web3Signer.EIP155Signer.sign(transaction: &ethereumTransaction, privateKey: privateKey, useExtraEntropy: false)
    } catch {
      return nil
    }
    
    guard let signature = ethereumTransaction.encode()?.toHexString() else { return nil }
    return signature
  }
  
  static func balanceRequest(forAddress address: String) -> Data? {
    var request = JSONRPCRequestFabric.prepareRequest(.getBalance, parameters: [address, "latest"])
    request.id = address
    guard let jsonData = try? JSONEncoder().encode(request) else { return nil }
    return jsonData
  }
  
  static func contractRequest(forAddress address: String, contractAddresses: [String], abi: String, method: String, options: [AnyObject] = [], transactionFields:[String]) -> Data? {
    guard let contract = ContractV2.init(abi) else { return nil }
    
    var methodParameters = [address] as [AnyObject]
    methodParameters += options
    
    var options = Web3Options.defaultOptions()
    guard let fromAddress = EthereumAddress(address) else { return nil }
    options.from = fromAddress
    
    var requests:[JSONRPCrequest] = []

    if contractAddresses.count > 1 {
      for contractAddress in contractAddresses {
        guard let ethContractAddress = EthereumAddress(contractAddress) else { return nil }
        options.to = ethContractAddress
        guard let request = request(from: fromAddress, contract: contract, contractAddress: ethContractAddress, method: method, parameters: methodParameters, options: options, transactionFields: transactionFields) else {
          continue
        }
        requests.append(request)
      }
      guard let jsonData = try? JSONEncoder().encode(requests) else { return nil }
      return jsonData
    } else {
      guard let contractAddress = contractAddresses.first else {
        return nil
      }
      guard let ethContractAddress = EthereumAddress(contractAddress) else { return nil }
      options.to = ethContractAddress
      guard let request = request(from: fromAddress, contract: contract, contractAddress: ethContractAddress, method: method, parameters: methodParameters, options: options, transactionFields: transactionFields) else {
        return nil
      }
      guard let jsonData = try? JSONEncoder().encode(request) else { return nil }
      return jsonData
    }
  }
  
  static func erc20TokensTransaction(forAddress address: String, contractAddresses: [String]) -> Data? {
    let abi = Web3.Utils.erc20ABI
    let fields = TransactionParametersField.allValues.map { $0.rawValue }
    return contractRequest(forAddress: address, contractAddresses: contractAddresses, abi: abi, method: "balanceOf", transactionFields: fields)
  }
  
  static func bip39Words() -> [String] {
    return BIP39Language.english.words
  }
  
  static func recoveryMnemonicsWords() -> [String]? {
    let keychain = Keychain(service: "mew")
    guard let entropy = keychain[data: "entropy"] else { return nil }
    guard let mnemonics = BIP39.generateMnemonicsFromEntropy(entropy: entropy) else { return nil }
    return mnemonics.components(separatedBy: " ")
  }
  
  static func resetBackup() {
    let keychain = Keychain(service: "mew")
    try? keychain.remove("entropy")
  }
  
  static func isBackedUp() -> Bool {
    let keychain = Keychain(service: "mew")
    guard let _ = keychain[data: "entropy"] else { return true }
    return false
  }
  
  //MARK: - Private
  
  private static func request(from: EthereumAddress, contract: ContractV2, contractAddress: EthereumAddress, method: String, parameters: [AnyObject], options: Web3Options, transactionFields:[String]) -> JSONRPCrequest? {
    guard let transaction = contract.method(method, parameters: parameters, options: options) else { return nil }
    guard var txParams = transaction.encodeAsDictionary(from: from) else { return nil }
    for (name, _) in Mirror(reflecting: txParams).children {
      guard let name = name else { continue }
      if !transactionFields.contains(name) {
        guard let field = TransactionParametersField(rawValue: name) else { return nil }
        let kp = TransactionParameters.fieldKeyPath(field)
        txParams[keyPath: kp] = nil
      }
    }
    let requestParameters = [txParams] as Array<Encodable>
    let request = JSONRPCRequestFabric.prepareRequest(.call, parameters: requestParameters)
    return request
  }
}

//
//  Web3Wrapper.swift
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 03/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

import Foundation
import Web3swift
import BigInt
import secp256k1_swift
import EthereumAddress
import EthereumABI

private struct SignedMessageConstants {
  struct Fields {
    static let Address  = "address"
    static let Sig      = "sig"
  }
  struct Values {
    static let Version  = "3"
    static let Signer   = "MEW"
  }
}

private enum TransactionParametersField: String {
  case data     = "data"
  case from     = "from"
  case gas      = "gas"
  case gasPrice = "gasPrice"
  case to       = "to"
  case value    = "value"
  static let allValues = [data, from, gas, gasPrice, to, value]
}

private struct KeychainInfo {
  static let service          = "mew"
  struct Fields {
    static let keydata        = "keydata"
    static let entropy        = "entropy"
    static let publicAddress  = "publickey"
  }
}

private struct KeySettings {
  private struct DerivationPaths {
    static var mainnet: String  = "m/44'/60'/0'/0"
    static var ropsten: String  = "m/44'/1'/0'/0"
  }
  
  static func derivationPath(_ network: BlockchainNetworkType) -> String {
    switch network {
    case .mainnet:
      return DerivationPaths.mainnet
    case .ropsten:
      return DerivationPaths.ropsten
    }
  }
}

extension TransactionParameters {
  fileprivate static func fieldKeyPath(_ key: TransactionParametersField) -> WritableKeyPath<TransactionParameters, String?> {
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
  internal var MEWcrypto: MEWcrypto?
  internal var keychainService: KeychainService?
  
  /**
   Creates a new or restoring entropy from BIP39 mnemonics words
   and store it into keychain
   
   - Parameter password: User-defined password. Using for encryption entropy
   - Parameter words: BIP39 mnemonics words to restore entropy
   - Parameter account: CoreData account for reference
   */
  func createWallet(password: String, words: [String]?, account: AccountPlainObject) {
    let mnemonics: String
    if words != nil {
      mnemonics = words!.joined(separator: " ")
    } else {
      guard let generatedMnemonics = try? BIP39.generateMnemonics(bitsOfEntropy: 256, language: .english), generatedMnemonics != nil else { return }
      mnemonics = generatedMnemonics!
    }
    
    guard let entropy = BIP39.mnemonicsToEntropy(mnemonics) else { return }
    guard let encryptedEntropy = self.MEWcrypto?.encryptData(entropy, withPassword: password) else { return }
    self.keychainService?.saveEntropy(encryptedEntropy, ofAccount: account)
  }
  
  /**
   Creates a new private key from entropy
   and store it into keychain
   
   **m/44'/60'/0'/0** prefix is using for private key in Mainnet
   
   **m/44'/1'/0'/0** prefix is using for private key in Ropsten
   
   - Parameter password: User-defined password. Using for encryption private key and entropy
   - Parameter account: CoreData account for reference
   - Parameter masterToken: CoreData token for reference
   - Parameter network: Blockchain network: **mainnet** or **ropsten**
   
   - Returns: Public Ethereum address
   */
  func createPrivateKey(password: String, account: AccountPlainObject, masterToken: MasterTokenPlainObject, network: BlockchainNetworkType = .mainnet) -> String? {
    guard let encryptedEntropy = self.keychainService?.obtainEntropy(ofAccount: account) else { return nil }
    guard let entropy = self.MEWcrypto?.decryptData(encryptedEntropy, withPassword: password) else { return nil }
    
    guard let mnemonics = BIP39.generateMnemonicsFromEntropy(entropy: entropy) else { return nil }
    guard let seed = BIP39.seedFromMmemonics(mnemonics) else { return nil }
    
    let prefixPath = KeySettings.derivationPath(network)
    NSLog("1")
    guard let bip32Keystore = try? BIP32Keystore(seed: seed, password: password, prefixPath: prefixPath), bip32Keystore != nil else { return nil }
    NSLog("2")
    guard let keydata = try? JSONEncoder().encode(bip32Keystore!.keystoreParams) else { return nil }
    NSLog("3")
    guard let encryptedKeydata = self.MEWcrypto?.encryptData(keydata, withPassword: password) else { return nil }
    
    guard let keyAccount = bip32Keystore?.addresses?.first else { return nil }
    
    self.keychainService?.saveKeydata(encryptedKeydata, forAddress:keyAccount.address, ofAccount: account, inChainID: network.rawValue)
    
    return keyAccount.address
  }
  
  /**
   Validated user password
   
   - Parameter password: User-typed password. Using for decryption private key
   - Parameter masterToken: CoreData masterToken for reference
   
   - Returns: true/false
   */
  func validatePassword(password: String, masterToken: MasterTokenPlainObject, account: AccountPlainObject, network: BlockchainNetworkType = .mainnet) -> Bool {
    guard let encryptedKeydata = self.keychainService?.obtainKeydata(ofMasterToken: masterToken, ofAccount: account, inChainID: network.rawValue)  else { return false }
    guard let keydata = self.MEWcrypto?.decryptData(encryptedKeydata, withPassword: password) else { return false }

    guard let bip32Keystore = BIP32Keystore(keydata) else { return false }
    guard let account = bip32Keystore.addresses?.first else { return false }
    do {
      _ = try bip32Keystore.UNSAFE_getPrivateKeyData(password: password, account: account/*, prefixPath: HDNode.defaultPathMetamaskPrefix*/)
    } catch {
      return false
    }
    return true
  }
  
  /**
   Obtaining public address of network with provided mnemonic words
   
   - Parameter words: BIP39 mnemonics words to restore entropy
   - Parameter network: Blockchain network: **mainnet** or **ropsten**
   
   - Returns: Public Ethereum address
   */
  
  func obtainAddress(words: [String], network: BlockchainNetworkType = .mainnet) -> String? {
    let mnemonics: String = words.joined(separator: " ")
    guard let seed = BIP39.seedFromMmemonics(mnemonics) else { return nil }
    
    let prefixPath = KeySettings.derivationPath(network)
    guard let bip32Keystore = try? BIP32Keystore(seed: seed, password: "", prefixPath: prefixPath), bip32Keystore != nil else { return nil }
    
    guard let keyAccount = bip32Keystore?.addresses?.first else { return nil }
    
    return keyAccount.address
  }
  
  /**
   Signing message by using private key
   
   - Parameter message: Message that should be signed
   - Parameter password: User password to decrypt private key
   - Parameter masterToken: CoreData masterToken for reference
   
   - Returns: Signed message, that can be verified at https://www.myetherwallet.com/signmsg.html
   or **nil** if something goes wrong
   */
  func signMessage(_ message: MEWConnectMessage, password: String, masterToken: MasterTokenPlainObject, account: AccountPlainObject, network: BlockchainNetworkType = .mainnet) -> [String: String]? {
    guard let data = message.message.data(using: .utf8) else { return nil }
    guard let hashData = Web3.Utils.hashPersonalMessage(data) else { return nil }
    if hashData != message.messageHash { return nil }

    guard let encryptedKeydata = self.keychainService?.obtainKeydata(ofMasterToken: masterToken, ofAccount: account, inChainID: network.rawValue) else { return nil }
    guard let keydata = self.MEWcrypto?.decryptData(encryptedKeydata, withPassword: password) else { return nil }

    guard let bip32Keystore = BIP32Keystore(keydata) else { return nil }
    guard let account = bip32Keystore.addresses?.first else { return nil }
    guard var privateKey = try? bip32Keystore.UNSAFE_getPrivateKeyData(password: password, account: account) else { return nil }
    defer {Data.zero(&privateKey)}

    guard let signedData = SECP256K1.signForRecovery(hash: hashData, privateKey: privateKey, useExtraEntropy: false).serializedSignature else { return nil }
    let signedMessage = signedData.toHexString().addHexPrefix()
    var signature: [String: String] = [:]
    signature[SignedMessageConstants.Fields.Address]  = account.address
    signature[SignedMessageConstants.Fields.Sig]      = signedMessage

    return signature
  }
  
  /**
   Signing transaction by using private key
   
   - Parameter transaction: Raw transaction that should be signed
   - Parameter password: User password to decrypt private key
   - Parameter masterToken: CoreData masterToken for reference
   
   - Returns: Signed transaction or **nil** if something goes wrong
   */
  func signTransaction(_ transaction: MEWConnectTransaction, password: String, masterToken: MasterTokenPlainObject, account: AccountPlainObject, network: BlockchainNetworkType = .mainnet) -> String? {
    guard let encryptedKeydata = self.keychainService?.obtainKeydata(ofMasterToken: masterToken, ofAccount: account, inChainID: network.rawValue) else { return nil }
    guard let keydata = self.MEWcrypto?.decryptData(encryptedKeydata, withPassword: password) else { return nil }

    guard let bip32Keystore = BIP32Keystore(keydata) else { return nil }
    guard let account = bip32Keystore.addresses?.first else { return nil }
    guard var privateKey = try? bip32Keystore.UNSAFE_getPrivateKeyData(password: password, account: account) else { return nil }
    defer {Data.zero(&privateKey)}

    guard let gasPrice = BigUInt(transaction.gasPrice.stripHexPrefix(), radix: 16) else { return nil }
    guard let gasLimit = BigUInt(transaction.gas.stripHexPrefix(), radix: 16) else { return nil }
    guard let value = BigUInt(transaction.value.stripHexPrefix(), radix: 16) else { return nil }
    guard let data = Data.fromHex(transaction.data) else { return nil }
    guard let nonce = BigUInt(transaction.nonce.stripHexPrefix(), radix: 16) else { return nil }
    let chainId = BigUInt(transaction.chainId.intValue)

    var to = EthereumAddress(transaction.to)
    if to == nil {
      to = EthereumAddress.contractDeploymentAddress()
    }

    if to == nil { return nil }

    var ethereumTransaction = EthereumTransaction(gasPrice: gasPrice,
                                                  gasLimit: gasLimit,
                                                  to: to!,
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
    guard var contract = EthereumContract.init(abi) else { return nil }

    var methodParameters = [address] as [AnyObject]
    methodParameters += options

    var options = Web3Options.defaultOptions()
    guard let fromAddress = EthereumAddress(address) else { return nil }
    options.from = fromAddress

    var requests:[JSONRPCrequest] = []

    if contractAddresses.count > 1 {
      for contractAddress in contractAddresses {
        guard let ethContractAddress = EthereumAddress(contractAddress) else { return nil }
        contract.address = ethContractAddress
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
      contract.address = ethContractAddress
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
  
  /**
   Validating BIP39 mnemonics phrase
   
   - Parameter words: entered mnemonics phrase
   
   - Returns: Validation result
   */
  
  func validateMnemonics(withWords words: [String]) -> Bool {
    guard let _ = BIP39.mnemonicsToEntropy(words.joined(separator: " ")) else { return false }
    return true
  }

  func bip39Words() -> [String] {
    return BIP39Language.english.words
  }

  func recoveryMnemonicsWords(password: String, account: AccountPlainObject) -> [String]? {
    guard let encryptedEntropy = self.keychainService?.obtainEntropy(ofAccount: account) else { return nil }
    guard let entropy = self.MEWcrypto?.decryptData(encryptedEntropy, withPassword: password) else { return nil }
    guard let mnemonics = BIP39.generateMnemonicsFromEntropy(entropy: entropy) else { return nil }
    return mnemonics.components(separatedBy: " ")
  }

  //MARK: - Private

  private static func request(from: EthereumAddress, contract: EthereumContract, contractAddress: EthereumAddress, method: String, parameters: [AnyObject], options: Web3Options, transactionFields:[String]) -> JSONRPCrequest? {
    guard var transaction = contract.method(method, parameters: parameters) else { return nil }
    if let toAddress = options.to {
      transaction.to = toAddress
    }
    guard var txParams = transaction.encodeAsDictionary(from: from) else { return nil }
    for (name, _) in Mirror(reflecting: txParams).children {
      guard let name = name else { continue }
      if !transactionFields.contains(name) {
        guard let field = TransactionParametersField(rawValue: name) else { return nil }
        let kp = TransactionParameters.fieldKeyPath(field)
        txParams[keyPath: kp] = nil
      }
    }
    let requestParameters = [txParams, "latest"] as Array<Encodable>
    let request = JSONRPCRequestFabric.prepareRequest(.call, parameters: requestParameters)
    return request
  }
}

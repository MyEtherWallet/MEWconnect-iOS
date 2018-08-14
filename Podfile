platform :ios, '10.0'

use_frameworks!
inhibit_all_warnings!

abstract_target 'MEWconnect' do
  # VIPER
  pod 'Typhoon', '3.5.1'
  
  # Navigation
  pod 'ViperMcFlurryX', :git => 'https://github.com/Foboz/ViperMcFlurryX.git'
  
  # Network
  pod 'AFNetworking'
  pod 'Socket.IO-Client-Swift'
  
  # Other
  pod 'libextobjc', '~> 0.4'
  pod 'RamblerAppDelegateProxy', '0.0.3'
  pod 'zxcvbn-ios'
  
  # Logging & crash reporting
  pod 'CocoaLumberjack', '~> 3.4'
  
  # Core Data
  pod 'MagicalRecord', '~> 2.3'
  
  # Images & Video
  pod 'SDWebImage', '~> 3.7'
  
  # UI
  pod 'Nimbus/Models'
  pod 'Nimbus/Collections'
  pod 'BlockiesSwift'
  pod 'YLProgressBar', '~> 3.10.2'
  pod 'TTTAttributedLabel', '~> 2.0.0'
  pod 'GSKStretchyHeaderView', '~> 1.0.4'
  pod 'BEMCheckBox', '~> 1.0.0'
  pod 'M13Checkbox', :git => 'https://github.com/Foboz/M13Checkbox.git'
  pod 'DZNWebViewController', :git => 'https://github.com/Foboz/DZNWebViewController.git'
  pod 'UITextView+Placeholder', '~> 1.2.0'
  pod 'CHIPageControl/Chimayo'
  
  # Ethereum
  pod 'web3swift', :git => 'https://github.com/Foboz/web3swift.git'
  pod 'GoogleWebRTC'
  
  # Cryptographic
  pod 'TrezorCrypto'#, :git => 'https://github.com/Foboz/trezor-crypto-ios.git'
  
  # Keychain
  pod 'UICKeyChainStore', '~> 2.1'
  
  # Data mapping
  pod 'EasyMapping', '~> 0.15'

  target 'MyEtherWallet-iOS' do
    
    #VIPER
    pod 'RamblerTyphoonUtils/AssemblyCollector', '1.5.0'
    
    target 'MyEtherWallet-iOSTests' do
      # Pods for testing
      
      pod 'OCMock', '3.3.1'
      pod 'RamblerTyphoonUtils/AssemblyTesting', '1.5.0'
    end
    
  end
  
  target 'MyEtherWallet-iOS-Beta' do
    
    #VIPER
    pod 'RamblerTyphoonUtils/AssemblyCollector', '1.5.0'
    
  end
  
  target 'MyEtherWallet-iOSUITests' do
    inherit! :search_paths
    
    # Pods for testing
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '4.0'
      if target.name == 'RamblerTyphoonUtils-AssemblyTesting' ||
         target.name == 'RamblerTyphoonUtils-AssemblyCollector-AssemblyTesting' ||
         target.name == 'WebRTC'
        config.build_settings['ENABLE_BITCODE'] = 'NO'
      end
    end
  end
end

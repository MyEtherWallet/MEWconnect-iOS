platform :ios, '10.0'

target 'MyEtherWallet-iOS' do
  inhibit_all_warnings!
  use_frameworks!

  # Pods for MyEtherWallet-iOS
  
  # VIPER
  pod 'Typhoon', '3.5.1'
  pod 'RamblerTyphoonUtils/AssemblyCollector', '1.5.0'
  
  # Navigation
  pod 'ViperMcFlurry'

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
  
  # Ethereum
  pod 'web3swift', :git => 'https://github.com/Foboz/web3swift.git'
  pod 'WebRTC'
  
  # Keychain
  pod 'KeychainAccess', '~> 3.1'
  
  # Data mapping
  pod 'EasyMapping', '~> 0.15'

  target 'MyEtherWallet-iOSTests' do
    inherit! :search_paths
    # Pods for testing
    
    pod 'OCMock', '3.3.1'
    pod 'RamblerTyphoonUtils/AssemblyTesting', '1.5.0'
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
         target.name == 'WebRTC'
        config.build_settings['ENABLE_BITCODE'] = 'NO'
      end
    end
  end
end

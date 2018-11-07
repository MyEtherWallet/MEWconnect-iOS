//
//  SystemInfrastructureAssembly.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 15/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import UIKit;
@import Typhoon.TyphoonAssembly;
@import RamblerTyphoonUtils.AssemblyCollector;

@interface SystemInfrastructureAssembly : TyphoonAssembly <RamblerInitialAssembly>
- (NSUserDefaults *) userDefaults;
- (NSHTTPCookieStorage *) httpCookieStorage;
- (NSNotificationCenter *) notificationCenter;
- (UIApplication *) application;
- (NSFileManager *) fileManager;
- (UIWindow *) mainWindow;
- (NSBundle *) mainBundle;
@end

//
//  BackupWordsInteractor.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 23/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import UIKit;

#import "BackupWordsInteractor.h"

#import "BackupWordsInteractorOutput.h"

#import "MEWCrypto.h"

@implementation BackupWordsInteractor

#pragma mark - BackupWordsInteractorInput

- (NSArray <NSString *> *)recoveryMnemonicsWords {
  return [self.cryptoService recoveryMnemonicsWords];
}

- (void) subscribeToEvents {
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_userDidTakeScreenshort:) name:UIApplicationUserDidTakeScreenshotNotification object:nil];
}

- (void) unsubscribeFromEvents {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - NSNotifications

- (void) _userDidTakeScreenshort:(NSNotification *)notification {
  [self.output userDidTakeScreenshot];
}

@end

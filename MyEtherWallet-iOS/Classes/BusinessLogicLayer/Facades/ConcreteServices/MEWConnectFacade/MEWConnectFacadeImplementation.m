//
//  MEWConnectFacadeImplementation.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 19/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import libextobjc.EXTScope;

#import "MEWConnectFacadeImplementation.h"

#import "MEWConnectFacadeConstants.h"

#import "AccountsService.h"
#import "Ponsomizer.h"
#import "AccountPlainObject.h"

#import "MEWConnectService.h"
#import "MEWConnectServiceDelegate.h"

#import "MEWConnectCommand.h"
#import "MEWConnectResponse.h"

@interface MEWConnectFacadeImplementation () <MEWConnectServiceDelegate>
@end

@implementation MEWConnectFacadeImplementation

#pragma mark - MEWConnectFacade

- (BOOL)connectWithData:(NSString *)data {
  return [self.connectService connectWithData:data];
}

- (void)disconnect {
  [self.connectService disconnect];
}

- (MEWConnectStatus) connectionStatus {
  return [self.connectService connectionStatus];
}

- (BOOL)sendMessage:(MEWConnectResponse *)message {
  return [self.connectService sendMessage:message];
}

#pragma mark - MEWConnectServiceDelegate

- (void) MEWConnect:(id <MEWConnectService>)mewConnect didReceiveMessage:(MEWConnectCommand *)message {
  switch (message.type) {
    case MEWConnectCommandTypeGetAddress: {
      AccountModelObject *accountModelObject = [self.accountsService obtainActiveAccount];
      
      NSArray *ignoringProperties = @[NSStringFromSelector(@selector(backedUp)),
                                      NSStringFromSelector(@selector(fromNetwork)),
                                      NSStringFromSelector(@selector(price)),
                                      NSStringFromSelector(@selector(tokens))];
      AccountPlainObject *account = [self.ponsomizer convertObject:accountModelObject ignoringProperties:ignoringProperties];
      MEWConnectResponse *response = [MEWConnectResponse responseForCommand:message data:account.publicAddress];
      [self.connectService sendMessage:response];
      break;
    }
    case MEWConnectCommandTypeSignMessage:
    case MEWConnectCommandTypeSignTransaction:
    case MEWConnectCommandTypeText:
    case MEWConnectCommandTypeUnknown:
    default: {
      NSNotificationQueue *queue = [NSNotificationQueue defaultQueue];
      NSNotification *notification = [NSNotification notificationWithName:MEWConnectFacadeDidReceiveMessageNotification
                                                                   object:self
                                                                 userInfo:@{kMEWConnectFacadeMessage: message}];
      [queue enqueueNotification:notification postingStyle:NSPostNow coalesceMask:NSNotificationNoCoalescing forModes:@[NSDefaultRunLoopMode]];
      break;
    }
  }
}

- (void) MEWConnectDidConnected:(id <MEWConnectService>)mewConnect {
  NSNotificationQueue *queue = [NSNotificationQueue defaultQueue];
  NSNotification *notification = [NSNotification notificationWithName:MEWConnectFacadeDidConnectNotification
                                                               object:self
                                                             userInfo:@{}];
  [queue enqueueNotification:notification postingStyle:NSPostNow coalesceMask:NSNotificationCoalescingOnSender|NSNotificationCoalescingOnName forModes:@[NSDefaultRunLoopMode]];
}

- (void) MEWConnectDidDisconnected:(id<MEWConnectService>)mewConnect {
  NSNotificationQueue *queue = [NSNotificationQueue defaultQueue];
  NSNotification *notification = [NSNotification notificationWithName:MEWConnectFacadeDidDisconnectNotification
                                                               object:self
                                                             userInfo:@{kMEWConnectFacadeDisconnectReason: kMEWConnectFacadeReasonClosed}];
  [queue enqueueNotification:notification postingStyle:NSPostNow coalesceMask:NSNotificationCoalescingOnSender|NSNotificationCoalescingOnName forModes:@[NSDefaultRunLoopMode]];
}

- (void) MEWConnectDidDisconnectedByTimeout:(id <MEWConnectService>)mewConnect {
  NSNotificationQueue *queue = [NSNotificationQueue defaultQueue];
  NSNotification *notification = [NSNotification notificationWithName:MEWConnectFacadeDidDisconnectNotification
                                                               object:self
                                                             userInfo:@{kMEWConnectFacadeDisconnectReason: kMEWConnectFacadeReasonTimeout}];
  [queue enqueueNotification:notification postingStyle:NSPostNow coalesceMask:NSNotificationCoalescingOnSender|NSNotificationCoalescingOnName forModes:@[NSDefaultRunLoopMode]];
}

- (void) MEWConnectDidReceiveError:(id <MEWConnectService>)mewConnect {
  NSNotificationQueue *queue = [NSNotificationQueue defaultQueue];
  NSNotification *notification = [NSNotification notificationWithName:MEWConnectFacadeDidDisconnectNotification
                                                               object:self
                                                             userInfo:@{kMEWConnectFacadeDisconnectReason: kMEWConnectFacadeReasonError}];
  [queue enqueueNotification:notification postingStyle:NSPostNow coalesceMask:NSNotificationCoalescingOnSender|NSNotificationCoalescingOnName forModes:@[NSDefaultRunLoopMode]];
}

@end

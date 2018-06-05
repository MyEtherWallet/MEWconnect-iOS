//
//  MEWConnectCommandTypeUnknown.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 03/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#ifndef MEWConnectCommandTypeUnknown_h
#define MEWConnectCommandTypeUnknown_h

typedef NS_ENUM(short, MEWConnectCommandType) {
  MEWConnectCommandTypeUnknown,
  MEWConnectCommandTypeGetAddress,
  MEWConnectCommandTypeSignTransaction,
  MEWConnectCommandTypeSignMessage,
  MEWConnectCommandTypeText,
};

#endif /* MEWConnectCommandTypeUnknown_h */

//
//  LinkedLabel.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 19/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import UIKit;

@protocol LinkedLabelDelegate;

@interface LinkedLabel : UILabel
@property (nonatomic, weak) IBOutlet id <LinkedLabelDelegate> delegate;
@end

@protocol LinkedLabelDelegate <NSObject>
- (void) linkedLabel:(LinkedLabel *)label didSelectURL:(NSURL *)url;
@end

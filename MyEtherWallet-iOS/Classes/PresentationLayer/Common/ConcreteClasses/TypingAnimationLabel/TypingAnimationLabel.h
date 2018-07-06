//
//  TypingAnimationLabel.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 02/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import UIKit;

typedef void(^TypingAnimationLabelCompletionHandler)(NSAttributedString *updatedAttributedString);

@protocol TypingAnimationLabelDelegate;

@interface TypingAnimationLabel : UILabel
@property (nonatomic, weak) IBOutlet id <TypingAnimationLabelDelegate> delegate;
@property (nonatomic) NSTimeInterval typingDelay;
@property (nonatomic) NSTimeInterval typingSpeed;
@property (nonatomic) NSTimeInterval caretBlinkingTime;
@property (nonatomic) CGFloat nextPartDelay;
- (void) animateTextArray:(NSArray <NSAttributedString *> *)array;
- (void) updateCaretAttributedString:(NSAttributedString *)attributedString;

@end

@protocol TypingAnimationLabelDelegate <NSObject>
@optional
- (void) typingAnimationLabel:(TypingAnimationLabel *)label performCustomAnimationWithCompletionHandler:(TypingAnimationLabelCompletionHandler)completion;
- (void) typingAnimationLabelDidFinishAnimation:(TypingAnimationLabel *)label;
@end

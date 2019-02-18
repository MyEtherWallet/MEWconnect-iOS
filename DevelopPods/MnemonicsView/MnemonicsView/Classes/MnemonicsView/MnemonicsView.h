//
//  MnemonicsView.h
//
//  Created by Mikhail Nikanorov.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

IB_DESIGNABLE
@interface MnemonicsView : UIControl
@property (nonatomic, getter=isCentered) IBInspectable BOOL centered;
@property (nonatomic) IBInspectable NSUInteger numberOfWords;
@property (nonatomic, strong, readonly) NSString *mnemonics;
@end

NS_ASSUME_NONNULL_END

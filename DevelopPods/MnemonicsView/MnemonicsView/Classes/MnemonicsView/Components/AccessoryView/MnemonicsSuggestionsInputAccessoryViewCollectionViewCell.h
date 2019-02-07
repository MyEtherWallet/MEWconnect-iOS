//
//  MnemonicsSuggestionsInputAccessoryViewCollectionViewCell.h
//
//  Created by Mikhail Nikanorov.
//

#import <UIKit/UIKit.h>
#import "MnemonicsSuggestionsInputAccessoryViewCollectionViewCellUpdateProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MnemonicsSuggestionsInputAccessoryViewCollectionViewCell : UICollectionViewCell <MnemonicsSuggestionsInputAccessoryViewCollectionViewCellUpdateProtocol>
+ (UIColor *) textColor;
+ (UIFont *) font;
@end

NS_ASSUME_NONNULL_END

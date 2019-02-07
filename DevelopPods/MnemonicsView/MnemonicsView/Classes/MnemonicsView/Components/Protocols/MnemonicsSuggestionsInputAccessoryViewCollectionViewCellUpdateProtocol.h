//
//  MnemonicsSuggestionsInputAccessoryViewCollectionViewCellUpdateProtocol.h
//
//  Created by Mikhail Nikanorov.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MnemonicsSuggestionsInputAccessoryViewCollectionViewCellUpdateProtocol <NSObject>
- (void) updateWithWord:(NSString * __nullable)word;
@end

NS_ASSUME_NONNULL_END

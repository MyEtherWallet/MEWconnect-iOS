//
//  MnemonicsSuggestionsInputAccessoryView.h
//
//  Created by Mikhail Nikanorov.
//

#import <UIKit/UIKit.h>
#import "MnemonicsItemViewUpdateProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@class MnemonicsSuggestionsInputAccessoryViewDataSource;
@protocol MnemonicsSuggestionsInputAccessoryViewDelegate;

@interface MnemonicsSuggestionsInputAccessoryView : UIView <MnemonicsItemViewUpdateProtocol>
@property (nonatomic, weak, nullable) id <MnemonicsSuggestionsInputAccessoryViewDelegate> delegate;
- (void) setLast:(BOOL)last;
@end

@protocol MnemonicsSuggestionsInputAccessoryViewDelegate <NSObject>
- (void) mnemonicsSuggestions:(MnemonicsSuggestionsInputAccessoryView *)view didSelectWord:(NSString *)word;
- (void) mnemonicsSuggestionsDidCompletion:(MnemonicsSuggestionsInputAccessoryView *)view;
@end

NS_ASSUME_NONNULL_END

//
//  MnemonicsTextField.h
//
//  Created by Mikhail Nikanorov.
//

#import <UIKit/UIKit.h>
#import "MnemonicsSuggestionsInputAccessoryView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MnemonicsTextFieldDelegate <UITextFieldDelegate>
- (void) textFieldDidTryDeleteEmptyText:(UITextField *)textField;
- (void) textField:(UITextField *)textField didCreateNewInputAccessoryView:(MnemonicsSuggestionsInputAccessoryView *)accessoryView;
- (void) textFieldDidFireTabCommand:(UITextField *)textField;
@end

@interface MnemonicsTextField : UITextField
@property (nullable, nonatomic, weak) id<MnemonicsTextFieldDelegate> delegate;
@property (nullable, readwrite, strong) __kindof MnemonicsSuggestionsInputAccessoryView *inputAccessoryView;
@property (nonatomic, readonly, getter=isCorrect) BOOL correct;
- (void) markAsCorrect;
- (void) markAsIncorrect;
@end

NS_ASSUME_NONNULL_END

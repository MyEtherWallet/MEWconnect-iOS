//
//  MnemonicsItemView.h
//
//  Created by Mikhail Nikanorov.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MnemonicsProviderProtocol;
@protocol MnemonicsItemViewDelegate;

@interface MnemonicsItemView : UIView
@property (nonatomic, weak) id <MnemonicsItemViewDelegate> delegate;
@property (nonatomic, weak, readonly) UITextField *textField;
@property (nonatomic, weak, readonly) UILabel *label;
@property (nonatomic, weak, readonly) UIView *placeholder;
@property (nonatomic, strong, readonly) id <MnemonicsProviderProtocol> mnemonicsProvider;
//@property (nonatomic, strong) SuggestionView *suggestionC;
@property (nonatomic, readonly) NSInteger index;
@property (nonatomic) BOOL last;
+ (instancetype) itemWithIndex:(NSInteger)index mnemonicsProvider:(id <MnemonicsProviderProtocol>)mnemonicsProvider;
- (void) updateText:(NSString *)text;
@end

@protocol MnemonicsItemViewDelegate <NSObject>
- (void) mnemonicsItemViewDidEndEditing:(MnemonicsItemView *)view; //end
- (void) mnemonicsItemViewDidEndErasing:(MnemonicsItemView *)view; //askprevious
- (void) mnemonicsItemView:(MnemonicsItemView *)view didPasteWords:(NSArray <NSString *> *)words;
- (void) mnemonicsItemViewDidChangeState:(MnemonicsItemView * __nullable)view;
@end

NS_ASSUME_NONNULL_END

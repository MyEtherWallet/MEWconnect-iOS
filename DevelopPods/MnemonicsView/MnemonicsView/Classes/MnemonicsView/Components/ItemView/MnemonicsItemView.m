//
//  MnemonicsItemView.m
//
//  Created by Mikhail Nikanorov.
//

#import "MnemonicsItemView.h"
#import "MnemonicsTextField.h"
#import "MnemonicsProviderProtocol.h"
#import "MnemonicsSuggestionsInputAccessoryView.h"
#import "MnemonicsSuggestionsInputAccessoryViewDataSource.h"

static CGFloat const kMnemonicsItemViewPlaceholderHeight                          = 16.0;

@interface MnemonicsItemView () <MnemonicsTextFieldDelegate, MnemonicsSuggestionsInputAccessoryViewDelegate>
@property (nonatomic, strong) NSString *previousTerm;
@property (nonatomic, weak) MnemonicsTextField *textField;
@property (nonatomic, weak) UILabel *label;
@property (nonatomic, weak) UIView *placeholder;
@end

@implementation MnemonicsItemView

#pragma mark - Lifecycle

- (instancetype) initWithIndex:(NSInteger)index mnemonicsProvider:(id<MnemonicsProviderProtocol>)mnemonicsProvider {
  self = [super init];
  if (self) {
    _index = index;
    _mnemonicsProvider = mnemonicsProvider;
    
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [label setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [label setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self addSubview:label];
    
    label.text = [NSString stringWithFormat:@"%zd", index + 1];
    
    self.label = label;
    
    CGSize maxLabelSize = [@"00" boundingRectWithSize:CGSizeMake(1000.0, 1000.0)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{NSFontAttributeName: [[self class] selectedFont]}
                                              context:nil].size;
    
    UIView *placeholder = [[UIView alloc] init];
    placeholder.translatesAutoresizingMaskIntoConstraints = NO;
    placeholder.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:244.0/255.0 blue:247.0/255.0 alpha:1.0];
    placeholder.layer.cornerRadius = 3.0;
    
    self.placeholder = placeholder;
    
    [self addSubview:placeholder];
    
    MnemonicsTextField *textField = [[MnemonicsTextField alloc] init];
    [textField addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    textField.markedTextStyle = @{NSBackgroundColorAttributeName: [UIColor colorWithRed:229.0/255.0 green:237.0/255.0 blue:251.0/255.0 alpha:1.0]};
    textField.delegate = self;
    textField.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:textField];
    
    textField.hidden = YES;
    textField.suggestionsInputAccessoryView.delegate = self;
    
    self.textField = textField;
    self.textField.inputAccessoryView = nil;
    [self.textField.inputAccessoryView reloadInputViews];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tap];
    
    [NSLayoutConstraint activateConstraints:
     @[
       [self.leadingAnchor constraintEqualToAnchor:label.leadingAnchor],
       [placeholder.heightAnchor constraintEqualToConstant:kMnemonicsItemViewPlaceholderHeight],
       [placeholder.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
       [placeholder.leadingAnchor constraintEqualToAnchor:label.trailingAnchor constant:8.0],
       [self.trailingAnchor constraintEqualToAnchor:placeholder.trailingAnchor constant:arc4random_uniform(29) + 11.0],
       [textField.topAnchor constraintEqualToAnchor:self.topAnchor],
       [textField.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
       [textField.leadingAnchor constraintEqualToAnchor:label.trailingAnchor constant:5.0],
       [self.trailingAnchor constraintEqualToAnchor:textField.trailingAnchor constant:11.0],
       [label.widthAnchor constraintEqualToConstant:maxLabelSize.width],
       [label.centerYAnchor constraintEqualToAnchor:textField.centerYAnchor constant:1.0],
       ]];
  }
  return self;
}

+ (instancetype) itemWithIndex:(NSInteger)index mnemonicsProvider:(id<MnemonicsProviderProtocol>)mnemonicsProvider {
  return [[[self class] alloc] initWithIndex:index mnemonicsProvider:mnemonicsProvider];
}

- (void)updateText:(NSString *)text {
  [self.textField setText:text];
  self.textField.hidden = NO;
  self.placeholder.hidden = YES;
  [self _textFieldDidChanged:self.textField reloadInputs:NO];
}

#pragma mark - Override

- (CGSize) intrinsicContentSize {
  return CGSizeMake(UIViewNoIntrinsicMetric, 40.0);
}

- (BOOL)becomeFirstResponder {
  [self.textField becomeFirstResponder];
  return NO;
}

#pragma mark - Actions

- (void) tapAction:(UITapGestureRecognizer *)tap {
  [self.textField becomeFirstResponder];
}

#pragma mark - UITextFieldDelegate

- (void) textFieldDidBeginEditing:(UITextField *)textField {
  self.placeholder.hidden = YES;
  [self _updateTitle];
  if (textField.markedTextRange != nil) {
    UITextRange *textRange = [textField textRangeFromPosition:textField.markedTextRange.start toPosition:textField.markedTextRange.start];
    [textField setSelectedTextRange:textRange];
  }
}

- (void) textFieldDidEndEditing:(UITextField *)textField {
  if (@available(iOS 11.0, *)) { } else {
    NSArray <NSString *> *words = [self.mnemonicsProvider wordsWithSearchTerm:textField.text];
    
    ((MnemonicsTextField *)textField).showInputAccessoryView = [words count] > 1;
    [((MnemonicsTextField *)textField).inputAccessoryView updateWithWords:words];
    if ([words count] == 1) {
      [((MnemonicsTextField *)textField).inputAccessoryView makeCompleted];
    }
  }
  self.placeholder.hidden = (textField.text.length != 0);
  [self _updateTitle];
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
  self.previousTerm = nil;
  NSMutableCharacterSet *separators = [[NSCharacterSet whitespaceAndNewlineCharacterSet] mutableCopy];
  [separators addCharactersInString:@".,\n"];
  NSArray *components = [string componentsSeparatedByCharactersInSet:separators];
  components = [components filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.length > 0"]];
  if ([components count] > 1) {
    string = [components firstObject];
    if (textField.markedTextRange != nil) {
      if (@available(iOS 12.0, *)) {
        [textField setMarkedText:nil selectedRange:NSMakeRange(0, 0)];
      } else {
        [textField setMarkedText:@"" selectedRange:NSMakeRange(0, 0)];
      }
      [textField unmarkText];
    }
    textField.text = string;
    [self _textFieldDidChanged:(MnemonicsTextField *)textField reloadInputs:NO];
    
    NSArray *leftComponents = [components subarrayWithRange:NSMakeRange(1, [components count] - 1)];
    [self.delegate mnemonicsItemView:self didPasteWords:leftComponents];
    return NO;
  } else if (textField.markedTextRange != nil) {
    if (@available(iOS 12.0, *)) {
      [textField setMarkedText:nil selectedRange:NSMakeRange(0, 0)];
    } else {
      [textField setMarkedText:@"" selectedRange:NSMakeRange(0, 0)];
    }
    [textField unmarkText];
    NSString *oldText = textField.text;
    if (range.location > [oldText length]) {
      range.location = [oldText length];
    }
    if (NSMaxRange(range) > [oldText length]) {
      range.length = [oldText length] - range.location;
    }
    NSString *newString = [oldText stringByReplacingCharactersInRange:range withString:string];
    textField.text = newString;
    UITextPosition *position = [textField positionFromPosition:textField.beginningOfDocument offset:range.location + [string length]];
    UITextRange *textRange = [textField textRangeFromPosition:position toPosition:position];
    [textField setSelectedTextRange:textRange];
    return NO;
  }
  return YES;
}

- (BOOL)textFieldShouldReturn:(MnemonicsTextField *)textField {
  if ([textField.inputAccessoryView isCompleted]) {
    [self.delegate mnemonicsItemViewDidEndEditing:self];
  } else {
    [textField unmarkText];
    if ([textField isCorrect]) {
      [self.delegate mnemonicsItemViewDidEndEditing:self];
    }
  }
  return NO;
}

- (void) textFieldDidChanged:(MnemonicsTextField *)textField {
  [self _textFieldDidChanged:textField reloadInputs:YES];
}

- (void)textFieldDidTryDeleteEmptyText:(UITextField *)textField {
  [self.delegate mnemonicsItemViewDidEndErasing:self];
}

- (void)textField:(UITextField *)textField didCreateNewInputAccessoryView:(MnemonicsSuggestionsInputAccessoryView *)inputAccessoryView {
  inputAccessoryView.delegate = self;
  [inputAccessoryView setLast:self.last];
}

- (void)textFieldDidFireTabCommand:(UITextField *)textField {
  [self.delegate mnemonicsItemViewDidEndEditing:self];
}

#pragma mark - MnemonicsSuggestionsInputAccessoryViewDelegate

- (void) mnemonicsSuggestions:(nonnull MnemonicsSuggestionsInputAccessoryView *)view didSelectWord:(nonnull NSString *)word {
  [self.textField setText:word];
  [self.textField unmarkText];
  UITextRange *range = [self.textField textRangeFromPosition:self.textField.endOfDocument toPosition:self.textField.endOfDocument];
  [self.textField setSelectedTextRange:range];
  self.textField.returnKeyType = UIReturnKeyNext;
  [view makeCompleted];
  [self.textField reloadInputViews];
  [self.delegate mnemonicsItemViewDidChangeState:self];
  [self.delegate mnemonicsItemViewDidEndEditing:self];
}

- (void) mnemonicsSuggestionsDidCompletion:(nonnull MnemonicsSuggestionsInputAccessoryView *)view {
  if ([view isCompleted]) {
    if (self.textField.markedTextRange != nil) {
      [self.textField unmarkText];
    }
    [self.delegate mnemonicsItemViewDidEndEditing:self];
  } else {
    [self.textField unmarkText];
  }
}

#pragma mark - Private

- (void) _textFieldDidChanged:(__kindof MnemonicsTextField *)textField reloadInputs:(BOOL)reloadInputs {
  dispatch_async(dispatch_get_main_queue(), ^{
    //jap - todo
    if ([textField.text length] == 0) {
      [self _textFieldDidChangedCompletion:textField empty:YES correct:YES completed:NO reloadInputs:reloadInputs];
      return;
    }
    
    NSString *term = nil;
    if (textField.markedTextRange) {
      UITextRange *range = [textField textRangeFromPosition:textField.beginningOfDocument
                                                 toPosition:textField.markedTextRange.start];
      term = [textField textInRange:range];
    } else {
      term = textField.text;
    }
    //To stop infinite loop, because of setMarkedText:
    if ([self.previousTerm isEqualToString:term]) {
      return;
    }
    self.previousTerm = term;
    term = [term stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([term length] == 0) {
      [self _textFieldDidChangedCompletion:textField empty:YES correct:YES completed:NO reloadInputs:reloadInputs];
      return;
    }
    
    NSArray <NSString *> *words = [self.mnemonicsProvider wordsWithSearchTerm:term];
    if ([words count] == 0) {
      [self _textFieldDidChangedCompletion:textField empty:NO correct:NO completed:NO reloadInputs:reloadInputs];
      return;
    }
    
    NSString *fullSuggestion = [words firstObject];
    if (fullSuggestion && (![term isEqualToString:fullSuggestion] || [words count] > 1)) {
      textField.showInputAccessoryView = YES;
      [textField.inputAccessoryView updateWithWords:words];
      NSString *suggestion = [fullSuggestion substringFromIndex:[term length]];
      
      if (![[[self.textField.text stringByAppendingString:suggestion] lowercaseString] containsString:fullSuggestion]) {
        [self _textFieldDidChangedCompletion:textField empty:NO correct:NO completed:NO reloadInputs:reloadInputs];
      } else {
        UITextRange *oldTextRange = textField.selectedTextRange;
        UITextPosition *position = textField.endOfDocument;
        UITextRange *textRange = [textField textRangeFromPosition:position toPosition:position];
        [textField setSelectedTextRange:textRange];
        [textField setMarkedText:suggestion selectedRange:NSMakeRange(0, 0)];
        [textField setSelectedTextRange:oldTextRange];
        
        [self _textFieldDidChangedCompletion:textField empty:NO correct:YES completed:([words count] == 1) reloadInputs:reloadInputs];
      }
    } else if (textField.markedTextRange != nil) {
      textField.inputAccessoryView = textField.inputAccessoryView;
      [textField.inputAccessoryView updateWithWords:words];
      [self _textFieldDidChangedCompletion:textField empty:NO correct:YES completed:NO reloadInputs:reloadInputs];
    } else if ([words count] == 1) {
      [self _textFieldDidChangedCompletion:textField empty:NO correct:YES completed:YES reloadInputs:reloadInputs];
    }
  });
}

- (void) _textFieldDidChangedCompletion:(__kindof MnemonicsTextField *)textField empty:(BOOL)empty correct:(BOOL)correct completed:(BOOL)completed reloadInputs:(BOOL)reloadInputs {
  if (empty) {
    textField.showInputAccessoryView = NO;
    [textField markAsCorrect];
    self.textField.returnKeyType = UIReturnKeyDone;
  }
  if (correct) {
    [textField markAsCorrect];
    if (!empty) {
      textField.showInputAccessoryView = YES;
    }
  } else {
    textField.showInputAccessoryView = NO;
    [textField markAsIncorrect];
    self.textField.returnKeyType = UIReturnKeyDone;
  }
  if (completed) {
    textField.showInputAccessoryView = NO;
    [textField.inputAccessoryView makeCompleted];
    if (!self.last) {
      self.textField.returnKeyType = UIReturnKeyNext;
    } else {
      self.textField.returnKeyType = UIReturnKeyDone;
    }
  } else {
    self.textField.returnKeyType = UIReturnKeyDone;
  }
  if (reloadInputs) {
    [self.textField reloadInputViews];
  }
  [self _updateTitle];
  [self.delegate mnemonicsItemViewDidChangeState:self];
}

- (void) _updateTitle {
  UIColor *color = nil;
  UIFont *font = nil;
  BOOL isCorrect = [(MnemonicsTextField *)self.textField isCorrect];
  if ([self.textField isFirstResponder]) {
    font = [[self class] selectedFont];
    if (isCorrect) {
      color = [UIColor colorWithRed:6.0/255.0 green:77.0/255.0 blue:214.0/255.0 alpha:1.0];
    } else {
      color = [UIColor colorWithRed:214.0/255.0 green:6.0/255.0 blue:6.0/255.0 alpha:1.0];
    }
  } else {
    font = [[self class] normalFont];
    if (isCorrect) {
      color = [UIColor blackColor];
    } else {
      color = [UIColor colorWithRed:214.0/255.0 green:6.0/255.0 blue:6.0/255.0 alpha:1.0];
    }
  }
  self.label.textColor = color;
  self.label.font = font;
}

+ (UIFont *) selectedFont {
  return [UIFont systemFontOfSize:15.0 weight:UIFontWeightMedium];
}

+ (UIFont *) normalFont {
  return [UILabel appearanceWhenContainedInInstancesOfClasses:@[[MnemonicsItemView class]]].font;
}

@end

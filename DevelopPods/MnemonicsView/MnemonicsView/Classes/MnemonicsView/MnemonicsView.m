//
//  MnemonicsView.m
//
//  Created by Mikhail Nikanorov.
//

#import "MnemonicsView.h"
#import "MnemonicsItemView.h"
#import "MnemonicsProvider.h"

static UIEdgeInsets const kMnemonicsDefaultInsets                   = {15.0, 16.0, 15.0, 20.0};
static UIEdgeInsets const kMnemonicsDefaultDecreasedInsets          = {8.0, 8.0, 8.0, 16.0};
static UIEdgeInsets const kMnemonicsDefaultCenteredInsets           = {16.0, 16.0, 16.0, 16.0};
static UIEdgeInsets const kMnemonicsDefaultDecreasedCenteredInsets  = {8.0, 8.0, 8.0, 8.0};

static CGFloat      const kDecreasedSizeThreshold                   = 305.0;

typedef NS_OPTIONS(short, MnemonicsViewLayoutState) {
  MnemonicsViewLayoutStateDefault           = 0 << 0,
  MnemonicsViewLayoutStateDecreasedSize     = 1 << 0,
  MnemonicsViewLayoutStateCentered          = 1 << 1,
  MnemonicsViewLayoutStateDecreasedCentered = MnemonicsViewLayoutStateDecreasedSize | MnemonicsViewLayoutStateCentered,
  MnemonicsViewLayoutStateCustom            = 1 << 2
};

static NSUInteger const MnemonicsViewDefaultCount     = 24;

@interface MnemonicsView () <MnemonicsItemViewDelegate>
@property (nonatomic, weak) NSLayoutConstraint *containerTopConstraint;
@property (nonatomic, weak) NSLayoutConstraint *containerLeadingConstraint;
@property (nonatomic, weak) NSLayoutConstraint *containerBottomConstraint;
@property (nonatomic, weak) NSLayoutConstraint *containerTrailingConstraint;
@property (nonatomic, weak) UIStackView *columnsStackView;
@property (nonatomic, getter=isDecreasedSize) BOOL decreasedSize;
@property (nonatomic, strong) NSPointerArray *items;
@property (nonatomic, strong) id <MnemonicsProviderProtocol> mnemonicsProvider;
@property (nonatomic) BOOL pasteSentence;
@end

@implementation MnemonicsView {
  MnemonicsViewLayoutState _layoutState;
}

@dynamic centered;
@dynamic decreasedSize;

- (instancetype) init {
  self = [super init];
  if (self) {
    [self _commonInit];
  }
  return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    [self _commonInit];
  }
  return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    [self _commonInit];
  }
  return self;
}

- (void) prepareForInterfaceBuilder {
  [self _commonInit];
}

#pragma mark - Private

- (void) _commonInit {
  self.items = [NSPointerArray weakObjectsPointerArray];
  if (!self.columnsStackView) {
    UIStackView *hStackView = [[UIStackView alloc] init];
    hStackView.distribution = UIStackViewDistributionFillEqually;
    hStackView.alignment = UIStackViewAlignmentTop;
    hStackView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:hStackView];
    
    self.columnsStackView = hStackView;
    
    NSLayoutConstraint *top = [hStackView.topAnchor constraintEqualToAnchor:self.topAnchor];
    NSLayoutConstraint *leading = [hStackView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor];
    NSLayoutConstraint *bottom = [self.bottomAnchor constraintEqualToAnchor:hStackView.bottomAnchor];
    NSLayoutConstraint *trailing = [self.trailingAnchor constraintEqualToAnchor:hStackView.trailingAnchor];
    
    [NSLayoutConstraint activateConstraints:@[leading, trailing, top, bottom]];
    
    self.containerTopConstraint = top;
    self.containerLeadingConstraint = leading;
    self.containerBottomConstraint = bottom;
    self.containerTrailingConstraint = trailing;
    if (self.numberOfWords == 0) {
      self.numberOfWords = MnemonicsViewDefaultCount;
    }
  }
}

- (void) _prepareColumns {
  if (self.columnsStackView) {
    
    NSUInteger secondHalf = _numberOfWords / 2;
    NSUInteger firstHalf = _numberOfWords - secondHalf;
    
    [self.columnsStackView.arrangedSubviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if (!self.mnemonicsProvider) {
      self.mnemonicsProvider = [[MnemonicsProvider alloc] initWithLanguage:MnemonicsProviderLanguageEnglish];
    }
    
    [self.columnsStackView addArrangedSubview:[self _prepareColumnWithNumberOfItems:firstHalf startIndex:0 mnemonicsProvider:self.mnemonicsProvider]];
    [self.columnsStackView addArrangedSubview:[self _prepareColumnWithNumberOfItems:secondHalf startIndex:firstHalf mnemonicsProvider:self.mnemonicsProvider]];
    MnemonicsItemView *item = [[self.items allObjects] lastObject];
    item.last = YES;
    [self.items addPointer:NULL]; //https://stackoverflow.com/questions/31322290/nspointerarray-weird-compaction
    [self.items compact];
  }
}

- (UIStackView *) _prepareColumnWithNumberOfItems:(short)numberOfItems startIndex:(short)startIndex mnemonicsProvider:(id <MnemonicsProviderProtocol>)mnemonicsProvider {
  UIStackView *stackView = [[UIStackView alloc] init];
  stackView.axis = UILayoutConstraintAxisVertical;
  stackView.distribution = UIStackViewDistributionFillProportionally;
  
  UILabel *label = nil;
  for (short i = 0; i < numberOfItems; ++i) {
    MnemonicsItemView *item = [MnemonicsItemView itemWithIndex:startIndex+i mnemonicsProvider:mnemonicsProvider];
    //TODO weak self?
    item.delegate = self;
    item.translatesAutoresizingMaskIntoConstraints = NO;
    [stackView addArrangedSubview:item];
    if (label) {
      [item.label.widthAnchor constraintEqualToAnchor:label.widthAnchor].active = YES;
    }
    label = item.label;
    [self.items addPointer:(__bridge void *)item];
  }
  return stackView;
}

#pragma mark - Override

- (void) setCentered:(BOOL)centered {
  if (centered != [self isCentered]) {
    if (centered) {
      _layoutState |= MnemonicsViewLayoutStateCentered;
    } else {
      _layoutState &= ~MnemonicsViewLayoutStateCentered;
    }
    [self setNeedsUpdateConstraints];
  }
}

- (BOOL) isCentered {
  return (_layoutState & MnemonicsViewLayoutStateCentered) == MnemonicsViewLayoutStateCentered;
}

- (void)setDecreasedSize:(BOOL)decreasedSize {
  if (decreasedSize != [self isDecreasedSize]) {
    if (decreasedSize) {
      _layoutState |= MnemonicsViewLayoutStateDecreasedSize;
    } else {
      _layoutState &= ~MnemonicsViewLayoutStateDecreasedSize;
    }
    [self setNeedsUpdateConstraints];
  }
}

- (BOOL)isDecreasedSize {
  return (_layoutState & MnemonicsViewLayoutStateDecreasedSize) == MnemonicsViewLayoutStateDecreasedSize;
}

- (void)setNumberOfWords:(NSUInteger)numberOfWords {
  _numberOfWords = MAX(numberOfWords, 1);
  [self _prepareColumns];
}

- (BOOL)becomeFirstResponder {
  NSArray *items = [self.items allObjects];
  NSArray *emptyObjects = [items filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.textField.text.length == 0"]];
  MnemonicsItemView *nextItem = nil;
  if ([emptyObjects count] == 0) {
    nextItem = [items lastObject];
  } else {
    nextItem = [emptyObjects firstObject];
  }
  [nextItem becomeFirstResponder];
  return NO;
}

#pragma mark - Autolayout

- (void) layoutSubviews {
  [super layoutSubviews];
  self.decreasedSize = CGRectGetWidth(self.bounds) < kDecreasedSizeThreshold;
}

- (void)updateConstraints {
  [super updateConstraints];
  
  UIEdgeInsets insets = UIEdgeInsetsZero;
  switch (_layoutState) {
    case MnemonicsViewLayoutStateDefault:            { insets = kMnemonicsDefaultInsets;                  break; }
    case MnemonicsViewLayoutStateCentered:           { insets = kMnemonicsDefaultCenteredInsets;          break; }
    case MnemonicsViewLayoutStateDecreasedSize:      { insets = kMnemonicsDefaultDecreasedInsets;         break; }
    case MnemonicsViewLayoutStateDecreasedCentered:  { insets = kMnemonicsDefaultDecreasedCenteredInsets; break; }
    default: break;
  }
  if (@available(iOS 11.0, *)) {
    NSDirectionalEdgeInsets directionalInsets = NSDirectionalEdgeInsetsMake(insets.top, insets.left, insets.bottom, insets.right);
    self.containerTopConstraint.constant = directionalInsets.top;
    self.containerLeadingConstraint.constant = directionalInsets.leading;
    self.containerBottomConstraint.constant = directionalInsets.bottom;
    self.containerTrailingConstraint.constant = directionalInsets.trailing;
  } else {
    self.containerTopConstraint.constant = insets.top;
    self.containerLeadingConstraint.constant = insets.left;
    self.containerBottomConstraint.constant = insets.bottom;
    self.containerTrailingConstraint.constant = insets.right;
  }
  
}

#pragma mark - MnemonicsItemViewDelegate

- (void) mnemonicsItemViewDidEndEditing:(MnemonicsItemView *)view {
  //https://gist.github.com/gamenerds/62e7a13b786dcb807507
  NSInteger nextItemIdx = view.index + 1;
  if (nextItemIdx < [[self.items allObjects] count]) {
    MnemonicsItemView *nextItem = [self.items allObjects][nextItemIdx];
    [nextItem becomeFirstResponder];
  } else {
    [self sendActionsForControlEvents:UIControlEventEditingDidEnd];
    [self endEditing:YES];
  }
}

- (void) mnemonicsItemViewDidEndErasing:(MnemonicsItemView *)view {
  NSInteger previousItemIdx = view.index - 1;
  if (previousItemIdx >= 0) {
    MnemonicsItemView *previousItem = [self.items allObjects][previousItemIdx];
    [previousItem becomeFirstResponder];
  }
}

- (void)mnemonicsItemView:(MnemonicsItemView *)view didPasteWords:(NSArray<NSString *> *)words {
  self.pasteSentence = YES;
  NSInteger itemIdx = view.index + 1;
  NSArray <MnemonicsItemView *> *items = [self.items allObjects];
  for (NSInteger wordIdx = 0; itemIdx < [items count] && wordIdx < [words count]; ++itemIdx, ++wordIdx) {
    NSString *word = words[wordIdx];
    MnemonicsItemView *item = items[itemIdx];
    [item updateText:word];
  }
  MnemonicsItemView *item = nil;
  if (itemIdx < [items count]) {
    item = items[itemIdx];
  } else {
    item = [items lastObject];
  }
  [item becomeFirstResponder];
  
  dispatch_async(dispatch_get_main_queue(), ^{
    self.pasteSentence = NO;
    [self mnemonicsItemViewDidChangeState:nil];
  });
}

- (void) mnemonicsItemViewDidChangeState:(MnemonicsItemView *)view {
  if (!self.pasteSentence) {
    NSMutableArray <NSString *> *words = [[NSMutableArray alloc] initWithCapacity:0];
    for (MnemonicsItemView *item in [self.items allObjects]) {
      NSString *value = [[item.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] lowercaseString];
      if ([value length] > 0) {
        [words addObject:value];
      }
    }
    BOOL validated = [self.mnemonicsProvider validateWords:words];
    if (validated) {
      _mnemonics = [words componentsJoinedByString:@" "];
    } else {
      _mnemonics = nil;
    }
    [self sendActionsForControlEvents:UIControlEventValueChanged];
  }
}

@end

//
//  MnemonicsSuggestionsInputAccessoryView.m
//
//  Created by Mikhail Nikanorov.
//

#import "MnemonicsSuggestionsInputAccessoryView.h"
#import "MnemonicsSuggestionsInputAccessoryViewDataSource.h"

static CGFloat const kMnemonicsSuggestionsInputDefaultHeight = 42.0;

@interface MnemonicsSuggestionsInputAccessoryView () <MnemonicsSuggestionsInputAccessoryViewDataSourceDelegate>
@property (nonatomic, strong) MnemonicsSuggestionsInputAccessoryViewDataSource *dataSource;
@property (nonatomic, weak) UICollectionView *collectionView;
@end

@implementation MnemonicsSuggestionsInputAccessoryView
@dynamic words;

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    [self _commonInit];
  }
  return self;
}

- (void)setLast:(BOOL)last {
  self.dataSource.last = last;
}

#pragma mark - Private

- (void) _commonInit {
  self.translatesAutoresizingMaskIntoConstraints = NO;
  self.backgroundColor = [UIColor colorWithRed:229.0/255.0 green:237.0/255.0 blue:251.0/255.0 alpha:1.0];
  [self invalidateIntrinsicContentSize];
  [self layoutIfNeeded];
  
  UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
  flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

  UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
  collectionView.backgroundColor = [UIColor whiteColor];
  collectionView.translatesAutoresizingMaskIntoConstraints = NO;
  [self addSubview:collectionView];
  
  [NSLayoutConstraint activateConstraints:
   @[[self.leftAnchor constraintEqualToAnchor:collectionView.leftAnchor],
     [self.topAnchor constraintEqualToAnchor:collectionView.topAnchor],
     [self.rightAnchor constraintEqualToAnchor:collectionView.rightAnchor],
     [collectionView.heightAnchor constraintEqualToConstant:kMnemonicsSuggestionsInputDefaultHeight]]
   ];
  
  self.dataSource = [[MnemonicsSuggestionsInputAccessoryViewDataSource alloc] initWithCollectionView:collectionView];
  self.dataSource.delegate = self;
}

#pragma mark - MnemonicsItemViewUpdateProtocol

- (BOOL)isCompleted {
  return self.dataSource.isCompleted;
}

- (void)updateWithWords:(NSArray<NSString *> *)words {
  [self.dataSource updateWithWords:words];
}

- (void)makeCompleted {
  [self.dataSource makeCompleted];
}

#pragma mark - MnemonicsSuggestionsInputAccessoryViewDataSourceDelegate

- (void)mnemonicsSuggestionsInputAccessoryViewDataSource:(MnemonicsSuggestionsInputAccessoryViewDataSource *)dataSource didSelectItemAtIndex:(NSUInteger)idx {
  if ([self isCompleted]) {
    [self.delegate mnemonicsSuggestionsDidCompletion:self];
  } else {
    NSString *word = dataSource.words[idx];
    [self.delegate mnemonicsSuggestions:self didSelectWord:word];
  }
}

#pragma mark - Override

- (CGSize)intrinsicContentSize {
  CGSize size = CGSizeMake(UIViewNoIntrinsicMetric, kMnemonicsSuggestionsInputDefaultHeight);
  if (@available(iOS 11.0, *)) {
    size.height += self.safeAreaInsets.bottom;
  }
  return size;
}

- (void)safeAreaInsetsDidChange {
  [self invalidateIntrinsicContentSize];
  [super safeAreaInsetsDidChange];
}


@end

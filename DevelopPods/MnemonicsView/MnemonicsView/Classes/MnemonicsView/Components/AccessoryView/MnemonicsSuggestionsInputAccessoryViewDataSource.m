//
//  MnemonicsSuggestionsInputAccessoryViewDataSource.m
//
//  Created by Mikhail Nikanorov.
//

#import <UIKit/UIKit.h>

#import "MnemonicsSuggestionsInputAccessoryViewDataSource.h"
#import "MnemonicsSuggestionsInputAccessoryViewCollectionViewCell.h"
#import "MnemonicsSuggestionsInputAccessoryViewCollectionViewDoneCell.h"

@interface MnemonicsSuggestionsInputAccessoryViewDataSource () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, weak) UICollectionView *collectionView;
@end

@implementation MnemonicsSuggestionsInputAccessoryViewDataSource
@synthesize completed = _completed;
@synthesize words = _words;

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView {
  self = [super init];
  if (self) {
    self.collectionView = collectionView;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    Class cellClass = [self cellClass];
    Class doneCellClass = [self doneCellClass];
    [self.collectionView registerClass:cellClass forCellWithReuseIdentifier:NSStringFromClass(cellClass)];
    [self.collectionView registerClass:doneCellClass forCellWithReuseIdentifier:NSStringFromClass(doneCellClass)];
  }
  return self;
}

#pragma mark - UICollectionViewDataSource

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
  NSString *identifier = _completed ? NSStringFromClass([self doneCellClass]) : NSStringFromClass([self cellClass]);
  __kindof MnemonicsSuggestionsInputAccessoryViewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
  if (!_completed) {
    NSString *word = nil;
    if (indexPath.row < [_words count]) {
      word = _words[indexPath.row];
      [cell updateWithWord:word];
    }
  } else {
    if (self.last) {
      [cell updateWithWord:NSLocalizedString(@"DONE", nil)];
    } else {
      [cell updateWithWord:NSLocalizedString(@"NEXT WORD", nil)];
    }
  }
  return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  return 1;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return _completed ? 1 : MIN([_words count], 3);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  CGFloat availableWidth = CGRectGetWidth(collectionView.frame);
  if (@available(iOS 11.0, *)) {
    availableWidth = availableWidth - (collectionView.adjustedContentInset.left + collectionView.adjustedContentInset.right);
  }
  UIEdgeInsets sectionInsets = [self collectionView:collectionView layout:collectionViewLayout insetForSectionAtIndex:indexPath.section];
  availableWidth -= sectionInsets.left + sectionInsets.right;
  
  if (self.completed) {
    return CGSizeMake(availableWidth, CGRectGetHeight(collectionView.frame));
  } else {
    CGFloat lineSpacing = [self collectionView:collectionView layout:collectionViewLayout minimumLineSpacingForSectionAtIndex:indexPath.section];
    NSUInteger numberOfSpacings = MAX(MIN([_words count], 3) - 1, 0);
    CGFloat totalWidth = availableWidth - (numberOfSpacings * lineSpacing);
    CGFloat width = totalWidth / MIN([_words count], 3);
    return CGSizeMake(width, CGRectGetHeight(collectionView.frame));
  }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
  return 1.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
  return 0.0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
  UIEdgeInsets insets = UIEdgeInsetsZero;
  if (@available(iOS 11.0, *)) {
    insets.left = collectionView.safeAreaInsets.left;
    insets.right = collectionView.safeAreaInsets.right;
  }
  return insets;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  [collectionView deselectItemAtIndexPath:indexPath animated:YES];
  [self.delegate mnemonicsSuggestionsInputAccessoryViewDataSource:self didSelectItemAtIndex:indexPath.row];
}

#pragma mark - Override

- (CGSize)intrinsicContentSize {
  return CGSizeMake(UIViewNoIntrinsicMetric, 42.0);
}

#pragma mark - Public

- (Class)cellClass {
  return [MnemonicsSuggestionsInputAccessoryViewCollectionViewCell class];
}

- (Class) doneCellClass {
  return [MnemonicsSuggestionsInputAccessoryViewCollectionViewDoneCell class];
}

- (void) updateWithWords:(NSArray *)words {
  _completed = NO;
  _words = words;
  [self.collectionView reloadData];
}

- (void) makeCompleted {
  _completed = YES;
  [self.collectionView reloadData];
}

@end

//
//  MnemonicsSuggestionsInputAccessoryViewCollectionViewCell.m
//
//  Created by Mikhail Nikanorov.
//

#import "MnemonicsSuggestionsInputAccessoryViewCollectionViewCell.h"

@interface MnemonicsSuggestionsInputAccessoryViewCollectionViewCell ()
@property (nonatomic, weak) UILabel *titleLabel;
@end

@implementation MnemonicsSuggestionsInputAccessoryViewCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:self.contentView.bounds];
    titleLabel.textColor = [[self class] textColor];
    titleLabel.font = [[self class] font];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:titleLabel];
    [NSLayoutConstraint activateConstraints:
     @[[self.contentView.leadingAnchor constraintEqualToAnchor:titleLabel.leadingAnchor],
       [self.contentView.topAnchor constraintEqualToAnchor:titleLabel.topAnchor],
       [self.contentView.trailingAnchor constraintEqualToAnchor:titleLabel.trailingAnchor],
       [self.contentView.bottomAnchor constraintEqualToAnchor:titleLabel.bottomAnchor]
       ]];
    self.titleLabel = titleLabel;
  }
  return self;
}

#pragma mark - MnemonicsSuggestionsInputAccessoryViewCollectionViewCellUpdateProtocol

- (void)updateWithWord:(NSString *)word {
  self.titleLabel.text = word;
}

+ (UIColor *) textColor {
  return [UIColor colorWithRed:6.0/255 green:77/255.0 blue:214/255.0 alpha:1.0];
}

+ (UIFont *) font {
  return [UIFont systemFontOfSize:17.0];
}

@end

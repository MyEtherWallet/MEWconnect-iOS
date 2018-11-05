//
//  LinkedLabel.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 19/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import libextobjc.EXTScope;

#import "LinkedLabel.h"

@interface LinkedLabel ()
@property (nonatomic, strong) NSLayoutManager *layoutManager;
@property (nonatomic, strong) NSTextContainer *textContainer;
@property (nonatomic, strong) NSTextStorage *textStorage;
@property (nonatomic, strong) NSArray *linkRanges;
@end

@implementation LinkedLabel

- (void)awakeFromNib
{
  [super awakeFromNib];
  self.userInteractionEnabled = YES;
  UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
  [self addGestureRecognizer:tapGesture];
  self.numberOfLines = 0;
  
  self.layoutManager = [[NSLayoutManager alloc] init];
  self.textContainer = [[NSTextContainer alloc] initWithSize:self.bounds.size];
  
  self.textContainer.lineFragmentPadding = 0.0;
  self.textContainer.lineBreakMode = self.lineBreakMode;
  self.textContainer.maximumNumberOfLines = self.numberOfLines;
  
  [self.layoutManager addTextContainer:self.textContainer];
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
  [super setAttributedText:attributedText];
  self.textStorage = [[NSTextStorage alloc] initWithAttributedString:attributedText];
  [self.textStorage addLayoutManager:self.layoutManager];
  
  [attributedText enumerateAttribute:NSParagraphStyleAttributeName
                             inRange:NSMakeRange(0, [attributedText length])
                             options:0
                          usingBlock:^(NSParagraphStyle * _Nullable value, __unused NSRange range, BOOL * _Nonnull stop) {
                            self.textContainer.lineBreakMode = value.lineBreakMode;
                            *stop = YES;
                          }];
  NSMutableArray *ranges = [[NSMutableArray alloc] init];
  [attributedText enumerateAttribute:NSLinkAttributeName
                             inRange:NSMakeRange(0, [attributedText length])
                             options:0
                          usingBlock:^(id  _Nullable value, NSRange range, __unused BOOL * _Nonnull stop) {
                            if (range.length > 0 && value) {
                              [ranges addObject:[NSValue valueWithRange:range]];
                            }
                          }];
  self.linkRanges = ranges;
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  self.textContainer.size = self.bounds.size;
}

- (void) tapAction:(UITapGestureRecognizer *)tapGesture
{
  [self.layoutManager ensureLayoutForGlyphRange:NSMakeRange(0, self.attributedText.length)];
  CGPoint locationOfTouchInLabel = [tapGesture locationInView:tapGesture.view];
  CGPoint locationOfTouchInTextContainer = CGPointMake(locationOfTouchInLabel.x,
                                                       locationOfTouchInLabel.y);
  NSInteger indexOfCharacter = [self.layoutManager characterIndexForPoint:locationOfTouchInTextContainer
                                                          inTextContainer:self.textContainer
                                 fractionOfDistanceBetweenInsertionPoints:nil];
  for (NSValue *rangeValue in self.linkRanges) {
    NSRange linkRange = [rangeValue rangeValue];
    if (NSLocationInRange(indexOfCharacter, linkRange)) {
      @weakify(self);
      [self.attributedText enumerateAttribute:NSLinkAttributeName inRange:linkRange options:0 usingBlock:^(id _Nullable value, __unused NSRange range, __unused BOOL * _Nonnull stop) {
        @strongify(self);
        [self.delegate linkedLabel:self didSelectURL:value];
      }];
    }
  }
}

//HACK: iOS 11 don't allow to change foreground color of linked attribute
- (void)drawTextInRect:(__unused CGRect)rect
{
  CGRect textRect = [self textRectForBounds:self.bounds limitedToNumberOfLines:self.numberOfLines];
  NSMutableAttributedString *attributedString = [self.attributedText mutableCopy];
  [attributedString removeAttribute:NSLinkAttributeName range:NSMakeRange(0, [attributedString length])];
  [attributedString drawInRect:textRect];
}

@end

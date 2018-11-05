//
//  TypingAnimationLabel.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 02/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import libextobjc.EXTScope;

#import "TypingAnimationLabel.h"

static NSTimeInterval kTypingAnimationDefaultTypingSpeed        = 1.0/60.0;
#if DEBUG
static NSTimeInterval kTypingAnimationDefaultTypingDelay        = 0.1;
#else
static NSTimeInterval kTypingAnimationDefaultTypingDelay        = 2.0;
#endif
static NSTimeInterval kTypingAnimationDefaultCaretBlinkingTime  = 0.25;

@interface TypingAnimationLabel ()
@property (nonatomic, strong) UILabel *caretLabel;
@property (nonatomic, strong) NSArray <NSAttributedString *> *texts;
@property (nonatomic, strong) NSTimer *typingTimer;
@property (nonatomic, strong) NSTimer *delayTimer;

@property (nonatomic, strong) NSMutableAttributedString *currentAttributedString;
@end

@implementation TypingAnimationLabel {
  NSInteger _currentTextIdx;
  NSInteger _currentCharacterIdx;
}

#pragma mark - Lifecycle

- (void)awakeFromNib {
  [super awakeFromNib];
  self.typingSpeed = kTypingAnimationDefaultTypingSpeed;
  self.typingDelay = kTypingAnimationDefaultTypingDelay;
  [self addSubview:self.caretLabel];
  [self _updateCaretPosition:_currentAttributedString];
}

- (void)dealloc {
  [self.typingTimer invalidate];
  [self.delayTimer invalidate];
}

#pragma mark - Public

- (void)animateTextArray:(NSArray<NSAttributedString *> *)array {
  [self _stopAnimation];
  [self _reset];
  self.texts = [array copy];
  [self _startAnimation];
}

- (void) updateCaretAttributedString:(NSAttributedString *)attributedString {
  self.caretLabel.attributedText = attributedString;
  [self.caretLabel sizeToFit];
  [self _updateCaretPosition:_currentAttributedString];
}

#pragma mark - Override

- (UILabel *)caretLabel {
  if (!_caretLabel) {
    _caretLabel = [[UILabel alloc] init];
  }
  return _caretLabel;
}

#pragma mark - Timers
                      
- (void) _typeTick:(__unused NSTimer *)timer {
  [self _addNextCharacter];
  [self _updateCaretPosition:_currentAttributedString];
  //update caret
}

- (void) _delayTick:(__unused NSTimer *)timer {
  if ([self.delegate respondsToSelector:@selector(typingAnimationLabel:performCustomAnimationWithCompletionHandler:)]) {
    @weakify(self);
    [self.delegate typingAnimationLabel:self performCustomAnimationWithCompletionHandler:^(NSAttributedString *updatedAttributedString) {
      @strongify(self);
      self.currentAttributedString = [updatedAttributedString mutableCopy];
      [self _updateCaretPosition:updatedAttributedString];
      [self _startTypingAnimation];
    }];
  } else {
    [self _startTypingAnimation];
  }
}

#pragma mark - Private

- (void) _reset {
  _currentAttributedString = [[NSMutableAttributedString alloc] init];
}

- (void) _stopAnimation {
  [self.typingTimer invalidate];
}

- (void) _startAnimation {
  [self _startTypingAnimation];
  [self _startBlinkingAnimation];
}

- (void) _startTypingAnimation {
  self.typingTimer = [NSTimer timerWithTimeInterval:self.typingSpeed
                                             target:self
                                           selector:@selector(_typeTick:)
                                           userInfo:nil
                                            repeats:YES];
  [[NSRunLoop mainRunLoop] addTimer:self.typingTimer forMode:NSDefaultRunLoopMode];
}

- (void) _startBlinkingAnimation {
  [UIView animateWithDuration:kTypingAnimationDefaultCaretBlinkingTime
                        delay:0.0
                      options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat | UIViewAnimationOptionAllowUserInteraction
                   animations:^{
    self.caretLabel.alpha = 0.0;
  } completion:NULL];
}

- (void) _startNextAnimation {
  [self.typingTimer invalidate];
  
  _currentCharacterIdx = 0;
  ++_currentTextIdx;
  if (_currentTextIdx == [self.texts count]) {
    [self _stopAnimation];
    if ([self.delegate respondsToSelector:@selector(typingAnimationLabelDidFinishAnimation:)]) {
      [self.delegate typingAnimationLabelDidFinishAnimation:self];
    }
  } else {
    if (self.typingDelay > 0.0) {
      self.delayTimer = [NSTimer timerWithTimeInterval:self.typingDelay
                                                target:self
                                              selector:@selector(_delayTick:)
                                              userInfo:nil
                                               repeats:NO];
      [[NSRunLoop mainRunLoop] addTimer:self.delayTimer forMode:NSDefaultRunLoopMode];
    } else {
      [self _delayTick:nil];
    }
  }
}

- (void) _addNextCharacter {
  //If we have text
  if (_currentTextIdx < [self.texts count]) {
    NSAttributedString *text = self.texts[_currentTextIdx];
    //If current character is not last
    if (_currentCharacterIdx < [text length]) {
      NSRange range = NSMakeRange(_currentCharacterIdx, 1);
      NSMutableAttributedString *character = [[text attributedSubstringFromRange:range] mutableCopy];
      //NO WORD WRAPPING DURING TYPING ANIMATION
      if ([character.string isEqualToString:@" "]) {
        NSRange leftRange = NSMakeRange(_currentCharacterIdx + 1, [text length] - (_currentCharacterIdx + 1));
        //Calculate left text
        if (leftRange.length > 0) {
          NSAttributedString *leftText = [text attributedSubstringFromRange:leftRange];
          NSRange nextSpace = [leftText.string rangeOfString:@" "];
          NSAttributedString *nextWord = nil;
          if (nextSpace.location != NSNotFound) {
            nextWord = [leftText attributedSubstringFromRange:NSMakeRange(0, nextSpace.location)];
          } else {
            nextWord = leftText;
          }
          NSRange newlineRange = [nextWord.string rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet]];
          if (newlineRange.location != NSNotFound) {
            nextWord = [nextWord attributedSubstringFromRange:NSMakeRange(0, newlineRange.location)];
          }
          if ([nextWord length] > 0) {
            if ([self _shouldAppendNewLineForAttributedString:_currentAttributedString nextWord:nextWord]) {
              [character.mutableString replaceOccurrencesOfString:@" " withString:@"\n" options:0 range:NSMakeRange(0, 1)];
              NSRange paragraphRange = NSMakeRange([_currentAttributedString length] - _currentCharacterIdx, _currentCharacterIdx);
              [_currentAttributedString removeAttribute:NSParagraphStyleAttributeName range:paragraphRange];
            }
          }
        }
      }
      //Need to correct calculation of caret rect (Correcting space)
      if ([character.string isEqualToString:@"\n"]) {
        [character.mutableString appendString:@" "];
        UIFont *font = [self _nextCharacterFontWithTextIdx:_currentTextIdx currentCharacterIdx:_currentCharacterIdx];
        //Adding font of the next character to prevent "jumping"
        if (font) {
          [character addAttribute:NSFontAttributeName value:font range:NSMakeRange([character length] - 1, 1)];
        }
      }
      BOOL replaceLastCharacter = NO;
      //Replace "correcting space" to normal character
      if ([_currentAttributedString length] > 1) {
        NSRange last2CharactersRange = NSMakeRange([_currentAttributedString length] - 2, 2);
        NSString *last2Characters = [_currentAttributedString.string substringWithRange:last2CharactersRange];
        replaceLastCharacter = [last2Characters isEqualToString:@"\n "];
      }
      if (replaceLastCharacter) {
        NSRange lastCharacterRange = NSMakeRange([_currentAttributedString length] - 1, 1);
        [_currentAttributedString replaceCharactersInRange:lastCharacterRange withAttributedString:character];
      } else {
        [_currentAttributedString appendAttributedString:character];
      }
      self.attributedText = _currentAttributedString;
      ++_currentCharacterIdx;
    } else { //Switch to next text
      [self _startNextAnimation];
    }
  }
}

- (BOOL) _shouldAppendNewLineForAttributedString:(NSAttributedString *)attributedString nextWord:(NSAttributedString *)nextWord {
  //Calculate current bounds
  CGSize size = CGSizeMake(CGRectGetWidth(self.bounds), CGFLOAT_MAX);
  CGRect currentBounds = [attributedString boundingRectWithSize:size
                                                        options:NSStringDrawingUsesLineFragmentOrigin
                                                        context:nil];
  NSMutableAttributedString *newAttributedString = [attributedString mutableCopy];
  [newAttributedString.mutableString appendString:@" "];
  [newAttributedString appendAttributedString:nextWord];
  CGRect newBounds = [newAttributedString boundingRectWithSize:size
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                       context:nil];
  return fabs(CGRectGetHeight(currentBounds) - CGRectGetHeight(newBounds)) > DBL_EPSILON;
}

- (void) _updateCaretPosition:(NSAttributedString *)attributedString {
  BOOL caretAtMinX = NO;
  if ([attributedString length] > 1) {
    NSRange last2CharactersRange = NSMakeRange([attributedString length] - 2, 2);
    NSString *last2Characters = [attributedString.string substringWithRange:last2CharactersRange];
    caretAtMinX = [last2Characters isEqualToString:@"\n "];
  }
  CGRect lastCharacterRect = [self _lastCharacterRectForAttributedString:attributedString];
  CGRect caretRect = self.caretLabel.frame;
  caretRect.origin = CGPointMake(floor(caretAtMinX ? CGRectGetMinX(lastCharacterRect) : CGRectGetMaxX(lastCharacterRect) + 2.0),
                                 floor(CGRectGetMidY(lastCharacterRect) - CGRectGetHeight(caretRect) / 2.0));
  self.caretLabel.frame = caretRect;
  
}

- (CGRect) _lastCharacterRectForAttributedString:(NSAttributedString *)attributedString {
  if ([attributedString length] == 0) {
    attributedString = [self attributedText];
  }
  NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:attributedString];
  NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
  [textStorage addLayoutManager:layoutManager];
  CGSize size = CGSizeMake(CGRectGetWidth(self.bounds), CGFLOAT_MAX);
  NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:size];
  textContainer.lineFragmentPadding = 0;
  [layoutManager addTextContainer:textContainer];
  
  NSRange glyphRange;
  NSRange range = NSMakeRange([attributedString length] - 1, 1);
  // Convert the range for glyphs.
  [layoutManager characterRangeForGlyphRange:range actualGlyphRange:&glyphRange];
  
  return [layoutManager boundingRectForGlyphRange:glyphRange inTextContainer:textContainer];
}

- (UIFont *) _nextCharacterFontWithTextIdx:(NSInteger)textIdx currentCharacterIdx:(NSInteger)currentCharacterIdx {
  if (textIdx < [self.texts count]) {
    NSAttributedString *text = self.texts[textIdx];
    if (currentCharacterIdx + 1 < [text length]) {
      NSInteger nextCharacterIdx = currentCharacterIdx + 1;
      NSRange range = NSMakeRange(nextCharacterIdx, 1);
      __block UIFont *font = nil;
      [text enumerateAttribute:NSFontAttributeName
                       inRange:range
                       options:0
                    usingBlock:^(id _Nullable value, __unused NSRange range, BOOL * _Nonnull stop) {
                      font = value;
                      *stop = YES;
                    }];
      return font;
    } else {
      return [self _nextCharacterFontWithTextIdx:textIdx+1 currentCharacterIdx:-1];
    }
  }
  return nil;
}

@end

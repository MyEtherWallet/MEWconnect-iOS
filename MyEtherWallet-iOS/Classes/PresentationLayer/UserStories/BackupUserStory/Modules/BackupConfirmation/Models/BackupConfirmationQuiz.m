//
//  BackupConfirmationQuiz.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 23/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

#import "BackupConfirmationQuiz.h"

@implementation BackupConfirmationQuiz

- (instancetype) initWithWords:(NSArray <NSString *> *)words correctWords:(NSArray <NSString *> *)correctWords quizSize:(NSInteger)quizSize questionSize:(NSInteger)questionSize {
  self = [super init];
  if (self) {
    if (correctWords) {
      NSMutableIndexSet *indexSet = [[NSMutableIndexSet alloc] init];
      do {
        [indexSet addIndex:arc4random() % [correctWords count]];
      } while ([indexSet count] < quizSize);
      
      _correctWords = [correctWords objectsAtIndexes:indexSet];
      
      NSMutableArray *quizWords = [[NSMutableArray alloc] init];
      for (NSInteger i = 0; i < quizSize; ++i) {
        NSMutableSet *questionWords = [[NSMutableSet alloc] initWithCapacity:questionSize];
        [questionWords addObject:self.correctWords[i]];
        do {
          NSInteger idx = arc4random() % [words count];
          NSString *word = words[idx];
          [questionWords addObject:word];
        } while ([questionWords count] < questionSize - 1);
        do {
          NSInteger idx = arc4random() % [correctWords count];
          NSString *word = correctWords[idx];
          [questionWords addObject:word];
        } while ([questionWords count] < questionSize);
        [quizWords addObjectsFromArray:[questionWords allObjects]];
      }
      _wordsIndexes = [indexSet copy];
      _questionWords = [quizWords copy];
      _quizSize = quizSize;
      _questionSize = questionSize;
    }
  }
  return self;
}

- (BOOL) checkVector:(NSArray <NSString *> *)vector {
  return [self.correctWords isEqualToArray:vector];
}

@end

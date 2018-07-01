//
//  BackupConfirmationQuiz.h
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 23/05/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import Foundation;

@interface BackupConfirmationQuiz : NSObject
@property (nonatomic, strong, readonly) NSArray <NSString *> *questionWords;
@property (nonatomic, strong, readonly) NSIndexSet *wordsIndexes;
@property (nonatomic, strong, readonly) NSArray <NSString *> *correctWords;
@property (nonatomic, readonly) NSInteger questionSize;
@property (nonatomic, readonly) NSInteger quizSize;
- (instancetype) initWithWords:(NSArray <NSString *> *)words
                  correctWords:(NSArray <NSString *> *)correctWords
                      quizSize:(NSInteger)quizSize
                  questionSize:(NSInteger)questionSize;
- (BOOL) checkVector:(NSArray <NSString *> *)vector;
@end

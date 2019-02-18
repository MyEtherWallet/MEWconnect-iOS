//
//  MnemonicsProviderProtocol.h
//
//  Created by Mikhail Nikanorov.
//

#import <Foundation/Foundation.h>

#import "MnemonicsProviderLanguage.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MnemonicsProviderProtocol <NSObject>
- (instancetype) initWithLanguage:(MnemonicsProviderLanguage)language;
- (NSArray <NSString *> *) allWords;
- (NSArray <NSString *> *) wordsWithSearchTerm:(NSString *)term;
- (BOOL) validateWords:(NSArray <NSString *> *)words;
@end

NS_ASSUME_NONNULL_END

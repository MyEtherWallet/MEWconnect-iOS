//
//  TokenPlainObject.h
//
//

#import "_TokenPlainObject.h"

@interface TokenPlainObject : _TokenPlainObject
@property (nonatomic, strong, readonly) NSString *amountString;
@property (nonatomic, strong, readonly) NSDecimalNumber *amount;
@end

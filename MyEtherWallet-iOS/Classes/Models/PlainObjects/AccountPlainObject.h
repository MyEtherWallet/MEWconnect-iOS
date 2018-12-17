//
//  AccountPlainObject.h
//
//

#import "_AccountPlainObject.h"

#import "BlockchainNetworkTypes.h"

@interface AccountPlainObject : _AccountPlainObject
- (NetworkPlainObject *) networkForNetworkType:(BlockchainNetworkType)networkType;
- (BOOL) isEqualToAccount:(AccountPlainObject *)account;
@end

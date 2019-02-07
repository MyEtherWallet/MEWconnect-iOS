//
//  MnemonicsItemViewUpdateProtocol.h
//
//  Created by Mikhail Nikanorov.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MnemonicsItemViewUpdateProtocol <NSObject>
@property (nonatomic, readonly, getter=isCompleted) BOOL completed;
@property (nonatomic, strong, readonly) NSArray <NSString *> *words;
- (void) updateWithWords:(NSArray <NSString *> *)words;
- (void) makeCompleted;
@end

NS_ASSUME_NONNULL_END

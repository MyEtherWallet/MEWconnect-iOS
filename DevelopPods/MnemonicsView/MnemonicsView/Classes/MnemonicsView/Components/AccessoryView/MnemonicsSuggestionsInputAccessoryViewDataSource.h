//
//  MnemonicsSuggestionsInputAccessoryViewDataSource.h
//
//  Created by Mikhail Nikanorov.
//

#import <Foundation/Foundation.h>

#import "MnemonicsItemViewUpdateProtocol.h"

@class UICollectionView;
@class UICollectionViewCell;

NS_ASSUME_NONNULL_BEGIN

@protocol MnemonicsSuggestionsInputAccessoryViewDataSourceDelegate;

@interface MnemonicsSuggestionsInputAccessoryViewDataSource : NSObject <MnemonicsItemViewUpdateProtocol>
@property (nonatomic) BOOL last;
@property (nonatomic, weak) id <MnemonicsSuggestionsInputAccessoryViewDataSourceDelegate> delegate;
- (instancetype) initWithCollectionView:(UICollectionView *)collectionView;
- (Class) cellClass;
- (Class) doneCellClass;
@end

@protocol MnemonicsSuggestionsInputAccessoryViewDataSourceDelegate <NSObject>
- (void) mnemonicsSuggestionsInputAccessoryViewDataSource:(MnemonicsSuggestionsInputAccessoryViewDataSource *)dataSource didSelectItemAtIndex:(NSUInteger)idx;
@end

NS_ASSUME_NONNULL_END

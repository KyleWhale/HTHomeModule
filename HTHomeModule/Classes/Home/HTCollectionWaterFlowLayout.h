//
//  HTCollectionWaterFlowLayout.h
//  Hucolla
//
//  Created by mac on 2022/9/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HTCollectionWaterFlowLayout;
@protocol HTCollectionWaterFlowLayoutDelegate <NSObject>

- (CGFloat)ht_collectionViewLayout:(HTCollectionWaterFlowLayout *)layout heightForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface HTCollectionWaterFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, weak) id<HTCollectionWaterFlowLayoutDelegate> delegate;
@property (nonatomic, assign) NSUInteger var_columns;
@property (nonatomic, assign) CGFloat columnSpacing;
@property (nonatomic, assign) CGFloat itemSpacing;
@property (nonatomic, assign) UIEdgeInsets insets;

@end

NS_ASSUME_NONNULL_END

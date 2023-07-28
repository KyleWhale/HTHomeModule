//
//  HTHomeAdsCell.h
//  Hucolla
//
//  Created by mac on 2022/9/13.
//

#import "BaseCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface HTHomeAdsCell : BaseCollectionViewCell

@property (nonatomic, copy) BLOCK_dataBlock   cancelBlock;
@property (nonatomic, copy) BLOCK_dataBlock   adStartBlock;

@end

NS_ASSUME_NONNULL_END

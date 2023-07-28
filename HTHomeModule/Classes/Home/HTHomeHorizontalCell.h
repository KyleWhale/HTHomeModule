//
//  HTHomeHorizontalCell.h
//  Hucolla
//
//  Created by mac on 2022/9/14.
//

#import "BaseCollectionViewCell.h"
#import "HTHomeDisplayTypeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HTHomeHorizontalCell : BaseCollectionViewCell

@property (nonatomic, copy) BLOCK_cellBlock    horizBlock;

@property (nonatomic, copy) BLOCK_cellBlock    headerBlock;
@property (nonatomic, copy) BLOCK_cellBlock    footerBlock;

@end

NS_ASSUME_NONNULL_END

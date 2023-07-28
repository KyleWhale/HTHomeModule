//
//  HTHistoryViewCell.h
//  Hucolla
//
//  Created by mac on 2022/9/14.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface HTHistoryViewCell : BaseTableViewCell

@property (nonatomic, copy) BLOCK_HTBlock    selectBlock;

- (void)lgjeropj_selectEdit:(BOOL)isEdit;

@end

NS_ASSUME_NONNULL_END

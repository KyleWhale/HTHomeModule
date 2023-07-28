//
//  HTHistoryAdCell.h
//  Moshfocus
//
//  Created by 李雪健 on 2023/6/27.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface HTHistoryAdCell : BaseTableViewCell

@property (nonatomic, copy) BLOCK_dataBlock   cancelBlock;
@property (nonatomic, copy) BLOCK_dataBlock   adStartBlock;

@end

NS_ASSUME_NONNULL_END

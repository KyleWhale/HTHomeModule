//
//  HTTVPlayViewCell.h
//  Hucolla
//
//  Created by mac on 2022/9/22.
//

#import "BaseTableViewCell.h"
#import "HTTVDetailModel.h"
#import "HTTVDetailSeasonModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HTTVPlayViewCell : BaseTableViewCell

@property (nonatomic, strong) HTTVDetailSeasonModel   * schedule;

@property (nonatomic, copy) BLOCK_dataBlock    situationBlock;

@end

NS_ASSUME_NONNULL_END

//
//  HTEpisodesMainView.h
//  Hucolla
//
//  Created by mac on 2022/9/23.
//

#import <UIKit/UIKit.h>
#import "HTTVDetailEpsModel.h"
#import "HTTVDetailSeasonModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HTEpisodesMainView : UIView

@property (nonatomic, strong) HTTVDetailSeasonModel         * currentSchedule;

@property (nonatomic, strong) HTTVDetailEpsModel            * currentIndex;
@property (nonatomic, strong) NSArray                       * contentArray;

@property (nonatomic, copy) BLOCK_dataBlock     scheduleBlock;

@property (nonatomic, copy) BLOCK_dataBlock     exerciseBlock;
@end




NS_ASSUME_NONNULL_END

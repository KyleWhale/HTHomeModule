//
//  HTChangeEpisodesView.h
//  Hucolla
//
//  Created by mac on 2022/9/23.
//

#import <UIKit/UIKit.h>
#import "HTTVDetailEpsModel.h"
#import "HTTVDetailSeasonModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HTChangeEpisodesView : UIView

@property (nonatomic, strong) HTTVDetailSeasonModel         * currentSchedule;

@property (nonatomic, strong) HTTVDetailEpsModel            * currentIndex;
@property (nonatomic, strong) NSArray                       * contentListArray;

@property (nonatomic, copy) BLOCK_dataBlock     scheduleBlock;

@property (nonatomic, copy) BLOCK_dataBlock     exerciseBlock;

- (void)ht_showInView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END

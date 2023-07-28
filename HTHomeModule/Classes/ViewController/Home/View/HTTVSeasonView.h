//
//  HTTVSeasonView.h
//  Hucolla
//
//  Created by mac on 2022/9/22.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HTTVSeasonView : BaseView

@property (nonatomic, assign) CGRect fromRect;
@property (nonatomic, copy) BLOCK_dataBlock seasonBlock;

- (void)ht_showInView;

@end

NS_ASSUME_NONNULL_END

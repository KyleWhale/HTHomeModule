//
//  HTAdvertisementView.h
//  Hucolla
//
//  Created by mac on 2022/9/13.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HTAdvertisementView : BaseView

@property (nonatomic, copy) BLOCK_dataBlock   cancelBlock;
@property (nonatomic, copy) BLOCK_dataBlock   adStartBlock;
@property (nonatomic, assign) BOOL   var_isShowCancel;

- (instancetype)initWithCancel:(BOOL)var_isShowCancel;
- (void)ht_showAd;

@end

NS_ASSUME_NONNULL_END

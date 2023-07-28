//
//  HTAdvertBannerView.h
//  Hucolla
//
//  Created by mac on 2022/9/27.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HTAdvertBannerView : BaseView

@property (nonatomic, copy) BLOCK_dataBlock cancelBlock;
@property (nonatomic, copy) BLOCK_HTVoidBlock var_didLoadBlock;
@property (nonatomic, assign) BOOL var_isLoaded;

- (void)lgjeropj_onClearAction;;

@end

NS_ASSUME_NONNULL_END

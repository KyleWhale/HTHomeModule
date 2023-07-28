//
//  HTHomeTrendingM20Model.h
//  Hucolla
//
//  Created by 李雪健 on 2022/10/24.
//

#import "HTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HTHomeTrendingM20Model : HTBaseModel

// Movie 和 TV 共有
@property (nonatomic, strong) NSString      * ID;

@property (nonatomic, strong) NSString      * title;
@property (nonatomic, strong) NSString      * cover;
@property (nonatomic, strong) NSString      * rate;
@property (nonatomic, strong) NSString      * stars;
@property (nonatomic, strong) NSString      * tags;
@property (nonatomic, strong) NSString      * quality;
// TV 有
@property (nonatomic, strong) NSString      * nw_flag;
@property (nonatomic, strong) NSString      * ss_eps;
@property (nonatomic, strong) NSString      * update;

@end

NS_ASSUME_NONNULL_END

//
//  HTWaterMovieTvModel.h
//  Hucolla
//
//  Created by 李雪健 on 2022/10/24.
//

#import "HTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HTWaterMovieTvModel : HTBaseModel

@property (nonatomic, strong) NSString      * ID;
@property (nonatomic, strong) NSString      * rate;
@property (nonatomic, strong) NSString      * title;
@property (nonatomic, strong) NSString      * cover;
@property (nonatomic, strong) NSString      * ss_eps;
@property (nonatomic, strong) NSString      * nw_flag;
@property (nonatomic, strong) NSString      * quality;

@end

NS_ASSUME_NONNULL_END

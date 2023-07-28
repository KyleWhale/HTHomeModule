//
//  HTMovieDetailModel.h
//  Hucolla
//
//  Created by 李雪健 on 2022/10/24.
//

#import "HTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HTMovieDetailModel : HTBaseModel

@property (nonatomic, strong) NSString      * cflink;
@property (nonatomic, strong) NSString      * country;
@property (nonatomic, strong) NSString      * cover;
@property (nonatomic, strong) NSString      * desc;
@property (nonatomic, strong) NSDictionary  * var_hd;
@property (nonatomic, strong) NSString      * ID;
@property (nonatomic, strong) NSString      * lang;
@property (nonatomic, strong) NSString      * length;
@property (nonatomic, strong) NSString      * lock;
@property (nonatomic, strong) NSString      * quality;
@property (nonatomic, strong) NSString      * rate;
@property (nonatomic, strong) NSDictionary  * var_sd;
@property (nonatomic, strong) NSString      * source;
@property (nonatomic, strong) NSString      * stars;
@property (nonatomic, strong) NSString      * status;
@property (nonatomic, strong) NSString      * tags;
@property (nonatomic, strong) NSString      * title;
@property (nonatomic, strong) NSString      * logout;

@end

NS_ASSUME_NONNULL_END

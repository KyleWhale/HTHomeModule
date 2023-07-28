//
//  HTHomeBannerModel.h
//  Hucolla
//
//  Created by 李雪健 on 2022/10/24.
//

#import "HTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HTHomeBannerModel : HTBaseModel

@property (nonatomic, strong) NSString      * ID;
@property (nonatomic, strong) NSString      * img;
@property (nonatomic, strong) NSString      * nw_img;
@property (nonatomic, strong) NSString      * nw_conf_type;
@property (nonatomic, strong) NSString      * nw_conf_value;
@property (nonatomic, strong) NSString      * nw_conf_name;


@end


NS_ASSUME_NONNULL_END

//
//  HTHomeBannerModel.m
//  Hucolla
//
//  Created by 李雪健 on 2022/10/24.
//

#import "HTHomeBannerModel.h"
#import "HTHomeTrendingModel.h"
#import "HTHomeCompositeModel.h"

@implementation HTHomeBannerModel

+ (Class)modelCustomClassForDictionary:(NSDictionary*)dictionary {
    NSString *var_image = dictionary[@"nw_img"];
    if (var_image) {
        return [self class];
    }
    NSString *var_api = dictionary[AsciiString(@"api")];
    if (var_api) {
        return [HTHomeCompositeModel class];
    }
    return [HTHomeTrendingModel class];
}

@end

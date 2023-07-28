//
//  HTHomeDisplayTypeModel.m
//  Hucolla
//
//  Created by 李雪健 on 2022/10/24.
//

#import "HTHomeDisplayTypeModel.h"

@implementation HTHomeDisplayTypeModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    NSDictionary *params = [self modelCustomPropertyMapper];
    __block NSString *var_data = @"data";
    [params enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:var_data]) {
            var_data = key;
            *stop = YES;
        }
    }];
    return @{var_data : [HTHomeBannerModel class]};
}

@end

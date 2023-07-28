//
//  HTHomeTrendingModel.m
//  Hucolla
//
//  Created by 李雪健 on 2022/10/24.
//

#import "HTHomeTrendingModel.h"

@implementation HTHomeTrendingModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    NSDictionary *params = [self modelCustomPropertyMapper];
    __block NSString *var_m20 = @"m20";
    __block NSString *var_tt20 = @"tt20";
    [params enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:var_m20]) {
            var_m20 = key;
        }
        if ([obj isEqualToString:var_tt20]) {
            var_tt20 = key;
        }
    }];

    return @{var_m20 : [HTHomeTrendingM20Model class], var_tt20 : [HTHomeTrendingM20Model class]};
}

@end

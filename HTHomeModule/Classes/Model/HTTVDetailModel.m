//
//  HTTVDetailModel.m
//  Hucolla
//
//  Created by 李雪健 on 2022/10/24.
//

#import "HTTVDetailModel.h"

@implementation HTTVDetailModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    NSDictionary *params = [self modelCustomPropertyMapper];
    __block NSString *var_casts = @"casts";
    __block NSString *var_ssn_list = @"ssn_list";
    [params enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:var_casts]) {
            var_casts = key;
        }
        if ([obj isEqualToString:var_ssn_list]) {
            var_ssn_list = key;
        }
    }];
    return @{var_casts : [HTTVDetailCastsModel class], var_ssn_list : [HTTVDetailSeasonModel class]};
}

@end

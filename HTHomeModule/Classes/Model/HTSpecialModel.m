//
//  HTSpecialModel.m
//  Hucolla
//
//  Created by 李雪健 on 2022/10/24.
//

#import "HTSpecialModel.h"

@implementation HTSpecialModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    NSDictionary *params = [self modelCustomPropertyMapper];
    __block NSString *var_minfo = @"minfo";
    [params enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:var_minfo]) {
            var_minfo = key;
            *stop = YES;
        }
    }];
    return @{var_minfo : [HTHomeTrendingM20Model class]};
}

@end

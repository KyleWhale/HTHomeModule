//
//  HTHomeModel.m
//  Hucolla
//
//  Created by 李雪健 on 2022/10/24.
//

#import "HTHomeModel.h"

@implementation HTHomeModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    NSDictionary *params = [self modelCustomPropertyMapper];
    __block NSString *var_default_set = @"default_set";
    [params enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:var_default_set]) {
            var_default_set = key;
        }
    }];
    return @{var_default_set : [HTHomeDefaultModel class]};
}

@end

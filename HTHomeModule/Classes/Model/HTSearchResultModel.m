//
//  HTSearchResultModel.m
//  Hucolla
//
//  Created by 李雪健 on 2022/10/24.
//

#import "HTSearchResultModel.h"

@implementation HTSearchResultModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    NSDictionary *params = [self modelCustomPropertyMapper];
    __block NSString *var_movie = @"movie_tv_list";
    [params enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:var_movie]) {
            var_movie = key;
            *stop = YES;
        }
    }];
    return @{var_movie : [HTSearchMovieTvModel class]};
}

@end

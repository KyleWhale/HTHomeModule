//
//  HTHomePointManager.m
//  PostTest
//
//  Created by 李雪健 on 2023/7/28.
//

#import "HTHomePointManager.h"
#import "HTHttpRequest.h"

@implementation HTHomePointManager

+ (void)lgjeropj_maidianRequestWithParams:(NSDictionary *)dict {
    NSMutableDictionary *var_params = [[NSMutableDictionary alloc] init];
    [var_params addEntriesFromDictionary:dict];
    NSString *var_urlString = AsciiString(@"data");
    [[HTHttpRequest sharedManager] ht_get:var_urlString andParameters:var_params andCompletion:^(HTResponseModel *model, NSError * _Nonnull error) {}];
}

@end

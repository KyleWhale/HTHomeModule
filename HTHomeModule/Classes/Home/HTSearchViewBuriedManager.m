//
//  HTSearchViewBuriedManager.m
//  Moshfocus
//
//  Created by 李雪健 on 2023/6/6.
//

#import "HTSearchViewBuriedManager.h"
#import "HTHomePointManager.h"

@implementation HTSearchViewBuriedManager

// 埋点
+ (void)lgjeropj_maidianClickWith:(NSString *)kid andIndex:(NSInteger)index andSource:(NSInteger)source andType:(NSInteger)type andKey:(NSString *)searchString {
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:@"search_cl_new" forKey:@"pointname"];
    [params setValue:@(source) forKey:@"source"];
    [params setValue:@(index) forKey:AsciiString(@"order")];
    [params setValue:searchString forKey:AsciiString(@"word")];
    [params setValue:kid forKey:AsciiString(@"kid")];
    if (type > 0) {
        [params setValue:@(type) forKey:AsciiString(@"type")];
    }
    [HTHomePointManager lgjeropj_maidianRequestWithParams:params];
}

+ (void)lgjeropj_maidianShow:(NSInteger)source {
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:@"search_sh_new" forKey:@"pointname"];
    [params setValue:@(source) forKey:@"source"];
    [HTHomePointManager lgjeropj_maidianRequestWithParams:params];
}

@end

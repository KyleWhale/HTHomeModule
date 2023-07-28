//
//  HTHistoryBuriedManager.m
//  Moshfocus
//
//  Created by 李雪健 on 2023/6/6.
//

#import "HTHistoryBuriedManager.h"
#import "HTHomePointManager.h"

@implementation HTHistoryBuriedManager

//埋点
+ (void)lgjeropj_reportShowMaidian
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"recently_played_sh" forKey:@"pointname"];
    [params setObject:@"1" forKey:@"source"];
    [HTHomePointManager lgjeropj_maidianRequestWithParams:params];
}

+ (void)lgjeropj_clickMTWithKid:(NSString *)kidStr andMID:(NSString *)var_midStr andMname:(NSString *)var_mnameStr andType:(NSString *)typeStr
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"recently_played_cl" forKey:@"pointname"];
    [params setObject:kidStr forKey:AsciiString(@"kid")];
    [params setObject:typeStr forKey:AsciiString(@"type")];
    [params setObject:var_midStr forKey:@"movie_id"];
    [params setObject:var_mnameStr forKey:@"movie_name"];
    [params setObject:@"1" forKey:@"source"];
    [HTHomePointManager lgjeropj_maidianRequestWithParams:params];
}

@end

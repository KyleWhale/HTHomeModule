//
//  HTSpecialViewModel.m
//  Moshfocus
//
//  Created by 李雪健 on 2023/6/6.
//

#import "HTSpecialViewModel.h"
#import "HTHomePointManager.h"

@implementation HTSpecialViewModel

- (void)lgjeropj_reportShowMaidian
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"movielist_sh" forKey:@"pointname"];
    [params setObject:@"1" forKey:@"source"];
    [params setObject:self.var_speId forKey:@"movielist_id"];
    [params setObject:self.type forKey:@"list_type"];
    [HTHomePointManager lgjeropj_maidianRequestWithParams:params];
}

- (void)lgjeropj_clickMTWithKid:(NSString *)kidStr andMID:(NSString *)var_midStr andMname:(NSString *)var_mnameStr
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"movielist_cl" forKey:@"pointname"];
    [params setObject:kidStr forKey:AsciiString(@"kid")];
    [params setObject:var_midStr forKey:@"movie_id"];
    [params setObject:var_mnameStr forKey:@"movie_name"];
    [params setObject:@"1" forKey:@"source"];
    [params setObject:self.var_speId forKey:@"movielist_id"];
    [params setObject:self.type forKey:@"movie_type"];
    [params setObject:self.type forKey:@"list_type"];
    [HTHomePointManager lgjeropj_maidianRequestWithParams:params];
}

@end

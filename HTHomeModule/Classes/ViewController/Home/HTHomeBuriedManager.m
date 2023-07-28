//
//  HTHomeBuriedManager.m
//  Moshfocus
//
//  Created by 李雪健 on 2023/6/6.
//

#import "HTHomeBuriedManager.h"
#import "HTHomePointManager.h"

@implementation HTHomeBuriedManager

+ (void)lgjeropj_homeShowNewWithStatus:(NSString *)status andError:(NSString *)errorStr andTime:(NSDate *)startTime
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:status forKey:@"loadsuccess"];
    [params setObject:(errorStr ?: @"success") forKey:@"errorinfo"];
    NSTimeInterval time = [[NSDate date] timeIntervalSinceDate:startTime];
    [params setObject:@(ceil(time * 1000)) forKey:AsciiString(@"length")];
    [params setObject:@(ceil((NSDate.date.timeIntervalSince1970 - [NSUserDefaults.standardUserDefaults doubleForKey:@"udf_launchTime"])*1000)).stringValue forKey:@"in_time"];
    BOOL notiBool = [[NSUserDefaults standardUserDefaults] boolForKey:@"udf_notiAuth"];
    [params setObject:(notiBool ? @"1" : @"2") forKey:@"notify_status"];
    NSString *optypeStr = [HTCommonConfiguration lgjeropj_shared].BLOCK_switchStateBlock() ? @"2" : @"1";
    [params setObject:optypeStr forKey:@"op_type"];
    [params setObject:AsciiString(@"Featured") forKey:@"mtab_name"];
    [params setObject:@"2" forKey:@"push_pop"];
    [params setObject:@"home_m_sh_new" forKey:@"pointname"];
    [HTHomePointManager lgjeropj_maidianRequestWithParams:params];
}

+ (void)lgjeropj_homeClickNewWithKid:(NSString *)kidStr andCtype:(NSString *)ctypeStr andCId:(NSString *)cidStr andCname:(NSString *)cnameStr andSecname:(NSString *)secnameStr andSecdisplayname:(NSString *)secdisplaynameStr andSecId:(NSString *)secidStr
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:kidStr forKey:AsciiString(@"kid")];
    [params setObject:(cidStr ?:@"") forKey:@"c_id"];
    [params setObject:(cnameStr ?:@"") forKey:@"c_name"];
    [params setObject:(ctypeStr ?:@"") forKey:@"ctype"];
    [params setObject:(secnameStr ?:@"") forKey:@"secname"];
    [params setObject:(secdisplaynameStr ?:@"") forKey:@"secdisplayname"];
    [params setObject:(secidStr ?:@"") forKey:@"secid"];
    [params setObject:@"home_m_cl_new" forKey:@"pointname"];
    [HTHomePointManager lgjeropj_maidianRequestWithParams:params];
}

@end

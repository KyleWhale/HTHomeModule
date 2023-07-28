//
//  HTMoviePlayViewModel.m
//  Moshfocus
//
//  Created by 李雪健 on 2023/6/6.
//

#import "HTMoviePlayViewModel.h"
#import "HTHomePointManager.h"

@implementation HTMoviePlayViewModel

//埋点
- (void)lgjeropj_reportMTPlayShow
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"movie_play_sh" forKey:@"pointname"];
    [params setValue:self.source forKey:@"source"];
    [params setValue:self.var_mId forKey:@"movie_id"];
    if ( self.var_isTType ) {
        [params setValue:self.var_tvModel.title forKey:@"movie_name"];
        [params setValue:@"3" forKey:@"movie_type"];
        [params setValue:self.var_epsModel.ID forKey:@"eps_id"];
        [params setValue:self.var_epsModel.title forKey:@"eps_name"];
        [params setValue:@(self.var_epsArray.count) forKey:@"eps_cnt"];
        [params setValue:@(self.var_tvModel.ssn_list.count) forKey:@"season_cnt"];
        [params setValue:(self.var_tvModel.casts.count > 0)?self.var_tvModel.casts:@"" forKey:AsciiString(@"artist")];
    } else {
        [params setValue:self.var_detailModel.title forKey:@"movie_name"];
        [params setValue:@"1" forKey:@"movie_type"];
        [params setValue:@"0" forKey:@"eps_id"];
        [params setValue:@"0" forKey:@"eps_name"];
        [params setValue:@(0) forKey:@"eps_cnt"];
        [params setValue:@(0) forKey:@"season_cnt"];
        [params setValue:self.var_detailModel.stars?self.var_detailModel.stars:@"" forKey:AsciiString(@"artist")];
    }
    [HTHomePointManager lgjeropj_maidianRequestWithParams:params];
}

- (void)lgjeropj_clickMTWithKid:(NSString *)kidStr
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"movie_play_cl" forKey:@"pointname"];
    [params setValue:kidStr forKey:AsciiString(@"kid")];
    [params setValue:self.source forKey:@"source"];
    [params setValue:self.var_mId forKey:@"movie_id"];
    if ( self.var_isTType ) {
        [params setValue:self.var_tvModel.title forKey:@"movie_name"];
        [params setValue:@"3" forKey:@"movie_type"];
        [params setValue:self.var_epsModel.ID forKey:@"eps_id"];
        [params setValue:self.var_epsModel.title forKey:@"eps_name"];
        [params setValue:@(self.var_epsArray.count) forKey:@"eps_cnt"];
        [params setValue:@(self.var_tvModel.ssn_list.count) forKey:@"season_cnt"];
        [params setValue:self.var_seasonModel.title forKey:AsciiString(@"season")];
        [params setValue:(self.var_tvModel.casts.count > 0)?self.var_tvModel.casts:@"" forKey:AsciiString(@"artist")];
    } else {
        [params setValue:self.var_detailModel.title forKey:@"movie_name"];
        [params setValue:@"1" forKey:@"movie_type"];
        [params setValue:@"0" forKey:@"eps_id"];
        [params setValue:@"0" forKey:@"eps_name"];
        [params setValue:@(0) forKey:@"eps_cnt"];
        [params setValue:@(0) forKey:@"season_cnt"];
        [params setValue:@"0" forKey:AsciiString(@"season")];
        [params setValue:self.var_detailModel.stars?self.var_detailModel.stars:@"" forKey:AsciiString(@"artist")];
    }
    [params setValue:self.var_isShowSubtitle ? @"1" : @"2" forKey:@"subtitle"];
    [HTHomePointManager lgjeropj_maidianRequestWithParams:params];
}

- (void)lgjeropj_castShowAndkid:(NSString *)kidStr
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"cast_sh" forKey:@"pointname"];
    [params setValue:kidStr forKey:AsciiString(@"kid")];
    [params setValue:@"4" forKey:AsciiString(@"type")];
    [params setValue:self.var_mId forKey:@"movie_id"];
    if ( self.var_isTType ) {
        [params setValue:self.var_tvModel.title forKey:@"movie_name"];
    } else {
        [params setValue:self.var_detailModel.title forKey:@"movie_name"];
    }
    [HTHomePointManager lgjeropj_maidianRequestWithParams:params];
}

- (void)lgjeropj_castClickWithKid:(NSString *)kidStr
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"cast_cl" forKey:@"pointname"];
    [params setValue:self.var_mId forKey:@"movie_id"];
    if ( self.var_isTType ) {
        [params setValue:self.var_tvModel.title forKey:@"movie_name"];
        [params setValue:self.var_epsModel.ID forKey:@"eps_id"];
    } else {
        [params setValue:self.var_detailModel.title forKey:@"movie_name"];
        [params setObject:@"0" forKey:@"eps_id"];
    }
    [params setValue:kidStr forKey:AsciiString(@"kid")];
    [params setObject:@"4" forKey:AsciiString(@"type")];
    [params setValue:self.var_playUrl forKey:@"play_url"];
    [HTHomePointManager lgjeropj_maidianRequestWithParams:params];
}

- (void)lgjeropj_vipguideShow
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"vipguide_sh" forKey:@"pointname"];
    [params setObject:@"6" forKey:@"source"];
    [HTHomePointManager lgjeropj_maidianRequestWithParams:params];
}

- (void)lgjeropj_vipguideClickAndkid:(NSString *)kidStr
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"vipguide_cl" forKey:@"pointname"];
    [params setValue:kidStr forKey:AsciiString(@"kid")];
    [params setObject:@"6" forKey:@"source"];
    [HTHomePointManager lgjeropj_maidianRequestWithParams:params];
}

- (void)lgjeropj_playtimeReport
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"movie_play_len" forKey:@"pointname"];
    [params setValue:self.source forKey:@"source"];
    [params setValue:self.var_mId forKey:@"movie_id"];
    if ( self.var_isTType ) {
        [params setValue:self.var_tvModel.title forKey:@"movie_name"];
        [params setValue:@"3" forKey:@"movie_type"];
        [params setValue:self.var_epsModel.ID forKey:@"eps_id"];
        [params setValue:self.var_epsModel.title forKey:@"eps_name"];
    } else {
        [params setValue:self.var_detailModel.title forKey:@"movie_name"];
        [params setValue:@"1" forKey:@"movie_type"];
        [params setValue:@"0" forKey:@"eps_id"];
        [params setValue:@"0" forKey:@"eps_name"];
    }
    [params setObject:@(self.var_isPlaySuccess) forKey:@"if_success"];
    [params setObject:@(self.total) forKey:@"total_len"];
    [params setObject:@"6" forKey:@"lname"];
    [params setObject:@(self.var_pauseNum) forKey:@"lagtimes_server"];
    [params setObject:@(self.var_isFirstPlay) forKey:@"if_first"];
    [params setObject:@(self.var_isBackground) forKey:@"is_back"];
    [params setObject:@(2) forKey:@"is_local"];
    
    long long cacheLen = 0;
    if (self.var_cache2 != nil && self.var_cache1 != nil) {
        cacheLen = [self.var_cache2 timeIntervalSinceDate:self.var_cache1]*1000;
    }
    [params setObject:@(cacheLen) forKey:@"cache_len"];
    [params setObject:@(cacheLen/1000) forKey:@"firsttime"];
    [params setObject:@(cacheLen) forKey:@"firsttime2"];
    
    long long linkLen = 0;
    if (self.var_linkTime2 != nil && self.var_linkTime1 != nil) {
        linkLen = [self.var_linkTime2 timeIntervalSinceDate:self.var_linkTime1]*1000;
    }
    [params setObject:@(linkLen) forKey:@"link_len"];

    if (self.startTime) {
        long long time = [[NSDate date] timeIntervalSinceDate:self.startTime];
        [params setObject:@(time) forKey:@"watch_len"];
    } else {
        [params setObject:@(0) forKey:@"watch_len"];
    }
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"udf_isQuitMTPlayerPage"]) {
        self.startTime = nil;
    }
    [HTHomePointManager lgjeropj_maidianRequestWithParams:params];
}

@end

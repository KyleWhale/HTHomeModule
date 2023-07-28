//
//  HTMoivePlayViewController.m
//  Hucolla
//
//  Created by mac on 2022/9/16.
//

#import "HTMoivePlayViewController.h"
#import <AppLovinSDK/AppLovinSDK.h>
#import "HTPlayer.h"
#import "HTMoivePlayViewCell.h"
#import "HTTVPlayViewCell.h"
#import "HTTVPlayEpsViewCell.h"
#import "HTDBHistoryModel.h"
#import "HTTVSeasonView.h"
#import "HTFileLoader.h"
#import "HTFileManager.h"
#import "HTAdvertBannerView.h"
#import "HTMoviePlayViewModel.h"
#import "HTTVDetailEpsModel.h"
#import "HTHttpRequest.h"
#import "HTSubtitlesModel.h"
#import "SSZipArchive.h"
#import "HTPremiumManager.h"

@interface HTMoivePlayViewController ()<UITableViewDelegate, UITableViewDataSource,HTPlayerDelegate,MAAdViewAdDelegate,MAAdRequestDelegate,MARewardedAdDelegate>

@property (nonatomic, strong) UILabel *var_copyrightLab;
@property (nonatomic, strong) UITableView     * tableView;
@property (nonatomic, strong) HTAdvertBannerView         * var_bannerView;
@property (nonatomic, strong) HTPlayer         * var_player;
@property (nonatomic, strong) HTChangeSubtitleView * var_textView;
@property (nonatomic, strong) HTChangeEpisodesView * var_epsView;
@property (nonatomic, strong) HTTVSeasonView       * var_seasonView;
@property (nonatomic, strong) MARewardedAd          * var_rewardedAd;
@property (nonatomic, strong) HTMoviePlayViewModel *var_playViewModel;

@end

@implementation HTMoivePlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 启动、插屏广告
    __weak typeof(self) weakSelf = self;
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"NTFCTString_AdShowNotify" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        [weakSelf.var_player ht_pause];
    }];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"NTFCTString_AdHiddenNotify" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        [weakSelf.var_player ht_play];
    }];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"NTFCTString_UpdateVIPStatusAndProductsInfo" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        [weakSelf lgjeropj_refreshAdStatus];
    }];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"udf_pause_player" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        weakSelf.var_playViewModel.var_pauseByGuide = YES;
        [weakSelf.var_player ht_pause];
    }];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"udf_play_player" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        weakSelf.var_playViewModel.var_pauseByGuide = NO;
        [weakSelf.var_player ht_play];
    }];

    self.var_playViewModel.var_haveAds = ![HTCommonConfiguration lgjeropj_shared].BLOCK_vipBlock();
    self.var_playViewModel.var_isPlaySuccess = 3;
    self.var_playViewModel.total = 0.0;
    self.var_playViewModel.var_linkTime1 = nil;
    self.var_playViewModel.var_linkTime2 = nil;
    self.var_playViewModel.var_cache1 = nil;
    self.var_playViewModel.var_cache2 = nil;
    self.var_playViewModel.var_isBackground = 2;
    
    [self lgjeropj_addSubViews];
    
    HTDBHistoryModel *model = [[HTDBHistoryModel alloc] ht_getDataWithMID:self.var_mId];
    if (model == nil) {
        self.var_playViewModel.var_isFirstPlay = 1;
        if (self.var_isTType == NO) {
            model = [[HTDBHistoryModel alloc] init];
            model.var_mId = self.var_mId;
            model.var_cover = self.cover;
            model.var_isTV = [NSString stringWithFormat:@"%d", self.var_isTType];
            [model ht_insertOrUpDate];
        }
    } else {
        self.var_playViewModel.var_isFirstPlay = 2;
        if (model.var_isTV.intValue) {
            self.var_playViewModel.var_tvModel = [[HTTVDetailModel alloc] init];
            self.var_playViewModel.var_tvModel.ID = model.var_mId;
            self.var_playViewModel.var_tvModel.cover = model.var_cover;
            self.var_playViewModel.var_tvModel.title = model.var_title;
            self.var_playViewModel.var_tvModel.rate = model.var_rate;
            self.var_playViewModel.var_tvModel.country = model.var_country;
            self.var_playViewModel.var_tvModel.tags = model.var_tags;
            self.var_playViewModel.var_tvModel.desc = model.var_desc;
            self.var_playViewModel.var_epsModel = [[HTTVDetailEpsModel alloc] init];
            self.var_playViewModel.var_epsModel.ID = model.var_vId;
            self.var_playViewModel.var_seasonModel = [[HTTVDetailSeasonModel alloc] init];
            self.var_playViewModel.var_seasonModel.ID = model.var_jId;
        } else {
            self.var_playViewModel.var_detailModel = [[HTMovieDetailModel alloc] init];
            self.var_playViewModel.var_detailModel.ID = model.var_mId;
            self.var_playViewModel.var_detailModel.cover = model.var_cover;
            self.var_playViewModel.var_detailModel.title = model.var_title;
            self.var_playViewModel.var_detailModel.rate = model.var_rate;
            self.var_playViewModel.var_detailModel.country = model.var_country;
            self.var_playViewModel.var_detailModel.tags = model.var_tags;
            self.var_playViewModel.var_detailModel.stars = model.var_stars;
            self.var_playViewModel.var_detailModel.desc = model.var_desc;
        }
        
        [self.var_player lgjeropj_bureaucratTitle:model.var_title];
        [self.var_player lgjeropj_crescendoAmiss:model.var_textPath];
        [self.var_player lgjeropj_bureaucratTitle:self.var_playViewModel.var_detailModel.title];
    }
    [self.var_player lgjeropj_sorbetType:self.var_isTType];
    
    [self lgjeropj_bindViewModel];
    
    if (self.var_playViewModel.var_haveAds) {
        [self.var_rewardedAd loadAd];
        
        self.var_playViewModel.var_isShowReward = YES;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"udf_isQuitMTPlayerPage"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    if (self.var_playViewModel.startTime == nil) {
        self.var_playViewModel.startTime = [NSDate date];
    }
    if (self.var_playViewModel.var_pushPremium != 0) {
        if (self.var_playViewModel.var_pushPremium == 2) {
            [self.var_player ht_play];
        }
        self.var_playViewModel.var_pushPremium = 0;
    }
}

- (void)lgjeropj_refreshAdStatus
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.var_playViewModel.var_haveAds = ![HTCommonConfiguration lgjeropj_shared].BLOCK_vipBlock();
        self.var_player.var_haveAds = self.var_playViewModel.var_haveAds;
        // ad按钮
        [self.var_player ht_hidenAdItem:!self.var_playViewModel.var_haveAds];
        // 竖屏banner
        self.var_bannerView.hidden = !self.var_playViewModel.var_haveAds;
        if (!self.var_playViewModel.var_haveAds) {
            // 暂停原生广告
            [self.var_player lgjeropj_dismissAdverst];
            // 横屏banner
            [self.var_player lgjeropj_removeBannerView];
        }
    });
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"udf_isQuitMTPlayerPage"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)ht_leftItemClicked:(UIButton *)sender {
    
    [self.var_player ht_pause];
    
    [self.var_player lgjeropj_resetHTPlayer];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)lgjeropj_addSubViews {
    
    self.tableView = [HTKitCreate ht_tableViewWithDelegate:self style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (self.var_isTType) {
        [self.tableView registerClass:[HTTVPlayViewCell class] forCellReuseIdentifier:NSStringFromClass([HTTVPlayViewCell class])];
        [self.tableView registerClass:[HTTVPlayEpsViewCell class] forCellReuseIdentifier:NSStringFromClass([HTTVPlayEpsViewCell class])];
    } else {
        [self.tableView registerClass:[HTMoivePlayViewCell class] forCellReuseIdentifier:NSStringFromClass([HTMoivePlayViewCell class])];
    }
    
    [self.view addSubview:self.tableView];
    
    CGFloat var_adH = 50;
    
    CGFloat var_height = kScreenWidth*220/375;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, kHJBottomHeight+15, 0);
    
    self.var_player = [[HTPlayer alloc] init];
    self.var_player.frame = CGRectMake(0, kStatusHeight, kScreenWidth, var_height);
    self.var_player.delegate = self;
    self.var_player.var_haveAds = self.var_playViewModel.var_haveAds;
    [self.view addSubview:self.var_player];
    self.var_playViewModel.var_playerRect = self.var_player.frame;
    
    [self.var_player ht_unfeelCover:self.cover];
    
    if (self.var_playViewModel.var_haveAds) {
        self.var_bannerView = [[HTAdvertBannerView alloc] init];
        __weak typeof(self) weakSelf = self;
        self.var_bannerView.var_didLoadBlock = ^{
            weakSelf.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
            if (weakSelf.var_player.positivismBouncy) {
                weakSelf.var_bannerView.hidden = YES;
            }
        };
        self.var_bannerView.backgroundColor = [UIColor clearColor];
        self.var_bannerView.frame = CGRectMake((kScreenWidth - 320)/2, CGRectGetMaxY(self.var_player.frame), 320, var_adH);
        [self.view addSubview:self.var_bannerView];
    }
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(var_height+kStatusHeight);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.var_isTType) {
        return 1 + 1;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.var_isTType) {
        if (section == 0 && !self.var_playViewModel.var_tvModel) {
            return 0;
        } else if (section == 1) {
            return self.var_playViewModel.var_epsArray.count;
        }
        return 1;
    }else if (!self.var_playViewModel.var_detailModel) {
        return 0;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = 70;
    if (self.var_isTType) {
        if (!self.var_playViewModel.var_tvModel) {
            height = CGFLOAT_MIN;
        } else if (indexPath.section == 0) {
            HTTVPlayViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HTTVPlayViewCell class])];
            if (cell) {
                [cell ht_updateCellWithData:self.var_playViewModel.var_tvModel];
            }
            height = [cell ht_cellHeight];
        }
        
    } else {
        HTMoivePlayViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HTMoivePlayViewCell class])];
        if (cell && self.var_playViewModel.var_detailModel) {
            [cell ht_updateCellWithData:self.var_playViewModel.var_detailModel];
        }
        height = [cell ht_cellHeight];
    }
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.var_isTType) {
        if (indexPath.section == 0) {
            HTTVPlayViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HTTVPlayViewCell class])];
            if (self.var_playViewModel.var_tvModel) {
                [cell ht_updateCellWithData:self.var_playViewModel.var_tvModel];
                cell.schedule = self.var_playViewModel.var_seasonModel;
            }
            @weakify(self);
            cell.situationBlock = ^(id data) {
                @strongify(self);
                UIButton *seasonBtn = (UIButton *)data;
                UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
                CGRect fromRect = [window convertRect:seasonBtn.frame fromView:tableView];
                self.var_seasonView.fromRect = fromRect;
                [self.var_seasonView ht_updateViewWithData:self.var_playViewModel.var_tvModel.ssn_list];
                [self.var_seasonView ht_showInView];
                @weakify(self);
                self.var_seasonView.seasonBlock = ^(HTTVDetailSeasonModel *model) {
                    @strongify(self);
                    if (self.var_playViewModel.var_seasonModel != model) {
                        self.var_playViewModel.var_seasonModel = model;
                        [self requestSeason];
                    }
                    //埋点
                    [self.var_playViewModel lgjeropj_clickMTWithKid:@"12"];
                };
            };
            return cell;
        } else {
            HTTVPlayEpsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HTTVPlayEpsViewCell class])];
            [cell ht_updateCellWithData:self.var_playViewModel.var_epsArray[indexPath.row]];
            return cell;
        }
        
    } else {
        
        HTMoivePlayViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HTMoivePlayViewCell class])];
        [cell ht_updateCellWithData:self.var_playViewModel.var_detailModel];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        [tableView selectRowAtIndexPath:self.var_playViewModel.selectIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    } else {
        self.var_playViewModel.selectIndexPath = indexPath;
        
        [self.var_player ht_pause];
        // 切集之前保存
        [self updateHistoryModel];
        //埋点
        [self.var_playViewModel lgjeropj_playtimeReport];
        [self.var_playViewModel lgjeropj_clickMTWithKid:@"10"];
        self.var_playViewModel.var_epsModel = self.var_playViewModel.var_epsArray[indexPath.row];
        [self requestEps:YES];
    }
}


#pragma mark - HTPlayerDelegate
//投屏
- (void)ht_castPlayer:(HTPlayer *)player {
    
    //埋点
    [self.var_playViewModel lgjeropj_clickMTWithKid:@"13"];
    
    NSDictionary *var_itemDict = [HTCommonConfiguration lgjeropj_shared].BLOCK_airDictBlock();
    if (var_itemDict != nil && var_itemDict.count > 0) {
        NSURL *var_appUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", var_itemDict[@"scheme"], AsciiString(@"://")]];
        if ([[UIApplication sharedApplication] canOpenURL:var_appUrl]) {
            if (self.var_player.positivismBouncy) {
                self.var_player.positivismBouncy = NO;
                [self ht_player:self.var_player andFScreen:NO];
            }
            NSString *string = [NSString stringWithFormat:@"%@%@%@",var_itemDict[@"scheme"], AsciiString(@"://"), var_itemDict[@"bundleid"]];
            NSString *var_urlString = [self lgjeropj_getCastUrlStringWithString:string];
            NSURL *var_appUrl = [NSURL URLWithString:var_urlString];
            // 防止订阅返回弹出广告
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"udf_dynamicLeave"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[UIApplication sharedApplication] openURL:var_appUrl options:@{} completionHandler:nil];
        } else {
            NSString *string1 = [var_itemDict objectForKey:AsciiString(@"c1")] ? [var_itemDict objectForKey:AsciiString(@"c1")] : LocalString(@"Free professional screen casting app, click and cast the screen directly after installation, without additional operation.", nil);
            NSString *string2 = [var_itemDict objectForKey:AsciiString(@"c2")] ? [var_itemDict objectForKey:AsciiString(@"c2")] : LocalString(@"For the first installation, you need to cast screen again.", nil);
            NSString *string3 = [var_itemDict objectForKey:AsciiString(@"c3")] ? [var_itemDict objectForKey:AsciiString(@"c3")] : LocalString(@"Download", nil);
            @weakify(self);
            [self.var_player ht_pause];
            UIAlertController *alertVC = [HTKitCreate ht_alertControllerWithTitle:string1 message:string2 andButtonTitles:@[LocalString(@"Cancel", nil), string3] handle:^(UIAlertAction * _Nonnull action) {
                @strongify(self);
                NSString *kindString = AsciiString(@"12");
                if ([action.title isEqualToString:string3]) {
                    kindString = AsciiString(@"11");
                    NSMutableDictionary *var_dataDictionary = [NSMutableDictionary dictionaryWithDictionary:[self lgjeropj_castParams]];
                    // 开始播放是为了把状态改成正在播放
                    // 然后走进入后台的逻辑 在回来之后就可以自动播放了
                    [self.var_player ht_play];
                    NSURL *var_linkURL = [self lgjeropj_createDynamiclink:var_dataDictionary andDictionary:var_itemDict];
                    [[UIApplication sharedApplication] openURL:var_linkURL options:@{} completionHandler:^(BOOL success) {}];
                } else {
                    [self.var_player ht_play];
                }
                //埋点
                [self.var_playViewModel lgjeropj_castClickWithKid:kindString];
            }];
            UIPopoverPresentationController *popover = alertVC.popoverPresentationController;
            if (popover){
                popover.sourceView = self.view;
                popover.sourceRect = CGRectMake(self.view.frame.size.width/2 -75, self.view.frame.size.height, 150, 150);
                popover.permittedArrowDirections = UIPopoverArrowDirectionDown;
            }
            [self presentViewController:alertVC animated:YES completion:nil];
            //埋点
            [self.var_playViewModel lgjeropj_castShowAndkid:@"2"];
        }
    }
}

- (NSURL *)lgjeropj_createDynamiclink:(NSDictionary *)var_mData andDictionary:(NSDictionary *)data
{
    NSMutableDictionary *params = [HTPremiumManager lgjeropj_getVipParams];
    [params addEntriesFromDictionary:var_mData];
    [params setValue:[NSString stringWithFormat:@"%@%@", AsciiString(@"https://apps.apple.com/app/id"), data[@"appleid"]] forKey:@"var_shopLink"];
    [params setValue:data[@"bundleid"] forKey:@"var_targetBundle"];
    [params setValue:[data objectForKey:AsciiString(@"l1")] forKey:@"var_targetLink"];
    [params setValue:[data objectForKey:AsciiString(@"k2")] forKey:@"var_dynamicK2"];
    [params setValue:[data objectForKey:AsciiString(@"c1")] forKey:@"var_dynamicC1"];
    [params setValue:[data objectForKey:AsciiString(@"c2")] forKey:@"var_dynamicC2"];
    [params setValue:[data objectForKey:AsciiString(@"c4")] forKey:@"var_dynamicC4"];
    [params setValue:[data objectForKey:AsciiString(@"c5")] forKey:@"var_dynamicC5"];
    [params setValue:[data objectForKey:AsciiString(@"logo")] forKey:@"var_dynamicLogo"];
    return [HTCommonConfiguration lgjeropj_shared].BLOCK_deepLinkBlock(params);
}

- (NSString *)lgjeropj_getCastUrlStringWithString:(NSString *)string {
    NSString *urlString = @"";
    NSMutableDictionary *dict = [HTCommonConfiguration lgjeropj_shared].BLOCK_deepLinkParamsBlock();
    [dict addEntriesFromDictionary:[self lgjeropj_castParams]];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *params = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    urlString = [NSString stringWithFormat:@"%@%@%@", string, AsciiString(@"?params="), params];
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return urlString;
}

- (NSDictionary *)lgjeropj_castParams {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@"3" forKey:AsciiString(@"type")];
    [dict setValue:@"2" forKey:AsciiString(@"product")];
    [dict setValue:@"" forKey:AsciiString(@"activity")];
    [dict setValue:self.var_player.var_playUrl forKey:AsciiString(@"url")];
    if (self.var_isTType) {
        [dict setValue:self.var_playViewModel.var_tvModel.title forKey:@"title"];
        [dict setValue:@"0" forKey:AsciiString(@"mid")];
        [dict setValue:self.var_playViewModel.var_tvModel.cover forKey:AsciiString(@"cover")];
        [dict setValue:[NSString stringWithFormat:@"%@-%@-%@", self.var_playViewModel.var_tvModel.title,self.var_playViewModel.var_seasonModel.title,self.var_playViewModel.var_epsModel.title] forKey:AsciiString(@"tvname")];
        [dict setValue:self.var_mId forKey:AsciiString(@"epsid")];
    } else {
        [dict setValue:self.var_playViewModel.var_detailModel.title forKey:@"title"];
        [dict setValue:self.var_playViewModel.var_detailModel.cover forKey:AsciiString(@"cover")];
        [dict setValue:self.var_mId forKey:AsciiString(@"mid")];
        [dict setValue:@"" forKey:AsciiString(@"tvname")];
        [dict setValue:@"0" forKey:AsciiString(@"epsid")];
    }
    return dict;
}

- (void)ht_sharedPlayer:(HTPlayer *)player {
    [self lgjeropj_startShareingAndBlcok:^(bool code) {
    }];
    //埋点
    [self.var_playViewModel lgjeropj_clickMTWithKid:@"8"];
}

- (void)lgjeropj_startShareingAndBlcok:(nonnull void (^)(bool code))block {
    
    NSString *text = @"";
    NSString *link = @"";
    if (self.var_isTType) {
        
        text = self.var_playViewModel.shareText;
        link = self.var_playViewModel.shareLink;

        text = [text stringByReplacingOccurrencesOfString:AsciiString(@"xxx") withString:self.var_playViewModel.var_tvModel.title];
        NSString *nameStr1 = self.var_playViewModel.var_tvModel.title;
        NSString *nameStr2 = [nameStr1 stringByReplacingOccurrencesOfString:@" " withString:@"_"];
        link = [link stringByAppendingFormat:AsciiString(@"para1=%@&para2=3&para4=%@&para3=%@"),self.var_mId,TP_App_Id,nameStr2];
    } else {
        text = self.var_playViewModel.shareText;
        link = self.var_playViewModel.shareLink;
        
        text = [text stringByReplacingOccurrencesOfString:AsciiString(@"xxx") withString:self.var_playViewModel.var_detailModel.title];
        NSString *nameStr1 = self.var_playViewModel.var_detailModel.title;
        NSString *nameStr2 = [nameStr1 stringByReplacingOccurrencesOfString:@" " withString:@"_"];
        link = [link stringByAppendingFormat:AsciiString(@"para1=%@&para2=2&para4=%@&para3=%@"),self.var_mId,TP_App_Id,nameStr2];
    }
    
    //分享的标题
    NSString *textToShare = text;

    NSURL *urlToShare = [NSURL URLWithString:link];

    NSArray *activityItems = @[textToShare, urlToShare];
        
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];

    //activityVC.excludedActivityTypes = @[UIActivityTypePostToFacebook, UIActivityTypePostToTwitter,UIActivityTypePostToWeibo,UIActivityTypeMessage,UIActivityTypeMail,UIActivityTypeCopyToPasteboard,UIActivityTypeAirDrop];
    if (isPad) {
        activityVC.popoverPresentationController.sourceView = self.view;
        activityVC.popoverPresentationController.sourceRect = [self.var_player ht_shareBtnFrame];
        activityVC.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;
    }
    [self presentViewController:activityVC animated:YES completion:nil];
        
    //分享之后的回调
    activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        if (completed) {
            block (YES);
            //分享 成功
        } else  {
            block (NO);
            //分享 取消
        }
    };
}

- (void)ht_cancelPlayer:(HTPlayer *)player {
    if (player.positivismBouncy == NO) {
        [self ht_leftItemClicked:nil];
        
        //埋点
        [self.var_playViewModel lgjeropj_playtimeReport];
        [self.var_playViewModel lgjeropj_clickMTWithKid:@"1"];
    } else {
        player.positivismBouncy = NO;
        
        [self ht_player:player andFScreen:NO];
    }
}
// 字幕
- (void)ht_subtitlesPlayer:(HTPlayer *)player {
    
    self.var_textView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    self.var_textView.textArray = self.var_playViewModel.textArray;
    if (player.positivismBouncy) {
        [self.var_textView ht_showInView:self.var_player andHorizontal:YES];
    } else {
        [self.var_textView ht_showInView:self.view andHorizontal:NO];
    }
    
    @weakify(self);
    self.var_textView.selBlock = ^(id data) {
        @strongify(self);
        HTSubtitlesModel *model = (HTSubtitlesModel *)data;
        
        [self turnLanague:model];
    };
    
    self.var_textView.timeBlock = ^(id data) {
        @strongify(self);
        double offset = [data doubleValue];
        if (offset == 0.5 || offset == -0.5) {
            self.var_player.timeOffset = self.var_player.timeOffset + offset;
        } else {
            self.var_player.timeOffset = offset;
        }
    };
    
    self.var_textView.switchBlock = ^(BOOL isSelect) {
        @strongify(self);
        self.var_playViewModel.var_closeSubtitle = !isSelect;
        [self.var_player lgjeropj_overcriticlMishandle:isSelect];
    };
    
    //埋点
    [self.var_playViewModel lgjeropj_clickMTWithKid:@"11"];
}

- (void)ht_player:(HTPlayer *)player andSeeTime:(double)seeTime {
    
    if (self.var_playViewModel.var_pauseByGuide) {
        [self.var_player ht_pause];
        return;
    }
    [self.var_textView ht_showSrtWithTime:seeTime offset:player.timeOffset];
    
    self.var_playViewModel.total = CMTimeGetSeconds(player.charmerDetract.currentItem.duration);
    if (self.var_playViewModel.var_cache2 == nil) {
        self.var_playViewModel.var_cache2 = [NSDate date];
    }
    if (self.var_playViewModel.var_isPlaySuccess != 1) {
        self.var_playViewModel.var_isPlaySuccess = 1;
    }
    
    if (self.var_playViewModel.var_haveAds) {
        if (self.var_playViewModel.var_isShowReward) {
            if (self.var_rewardedAd.ready && ![HTCommonConfiguration lgjeropj_shared].BLOCK_getStopAdBlock()) {
                // 准备好，显示广告
                [self.var_rewardedAd showAd];
                self.var_playViewModel.var_isShowReward = NO;
            }
        }
        
        // 暂停视频播放
        if (self.var_playViewModel.var_isShowAd) {
            [self.var_player ht_pause];
        }
    }
}
// 去广告
- (void)ht_removeAdsPlayer:(HTPlayer *)player {
    [self ht_pushPremiumWithPlayer:player];
    
    //埋点
    [self.var_playViewModel lgjeropj_clickMTWithKid:@"32"];
}


- (void)ht_pushPremiumWithPlayer:(HTPlayer *)player {
    self.var_playViewModel.var_pushPremium = 1;
    if (player.var_pState == ENUM_HTPlayerStatePlaying) {
        [self.var_player ht_pause];
        self.var_playViewModel.var_pushPremium = 2;
        if (self.var_playViewModel.var_haveAds) {
            [self.var_player lgjeropj_showAdverst];
        }
    }
    
    if (player.positivismBouncy == NO) {
        [HTCommonConfiguration lgjeropj_shared].BLOCK_toPremiumBlock(3);
    } else {
        player.positivismBouncy = NO;
        
        [self ht_player:player andFScreen:NO];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [HTCommonConfiguration lgjeropj_shared].BLOCK_toPremiumBlock(3);
        });
    }
}

- (void)ht_player:(HTPlayer *)player andPlayerState:(ENUM_HTPlayerState)state {
    
    if (state == ENUM_HTPlayerStateFinished || state == ENUM_HTPlayerStateStopped) {
        
        [self updateHistoryModel];
        //埋点
        [self.var_playViewModel lgjeropj_clickMTWithKid:@"2"];
        
        if (state == ENUM_HTPlayerStateFinished && player.var_isTType) {
            // 播放下一集
            if (self.var_playViewModel.selectIndexPath.row < self.var_playViewModel.var_epsArray.count - 1) {
                self.var_playViewModel.selectIndexPath = [NSIndexPath indexPathForRow:self.var_playViewModel.selectIndexPath.row + 1 inSection:1];
                [self.tableView selectRowAtIndexPath:self.var_playViewModel.selectIndexPath animated:NO scrollPosition:(UITableViewScrollPositionNone)];
                [self updateHistoryModel];
                //埋点
                [self.var_playViewModel lgjeropj_clickMTWithKid:@"15"];
                self.var_playViewModel.var_epsModel = self.var_playViewModel.var_epsArray[self.var_playViewModel.selectIndexPath.row];
                self.var_epsView.currentIndex = self.var_playViewModel.var_epsModel;
                [self requestEps:YES];
            } else {
                // 返回首页
                [SVProgressHUD showInfoWithStatus:LocalString(@"No more data", nil)];
                if (player.positivismBouncy == NO) {
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self ht_leftItemClicked:nil];
                    });
                } else {
                    player.positivismBouncy = NO;
                        [self ht_player:player andFScreen:NO];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self ht_leftItemClicked:nil];
                    });
                }
            }
        }
    } else if (state == ENUM_HTPlayerStatePlaying) {
        //埋点
        [self.var_playViewModel lgjeropj_clickMTWithKid:@"3"];
    } else if (state == ENUM_HTPlayerStateFailed) {
        self.var_playViewModel.var_isPlaySuccess = 2;
    }
}

- (void)ht_player:(HTPlayer *)player andFScreen:(BOOL)isFScreen {
    if (isFScreen) {
        //埋点
        [self.var_playViewModel lgjeropj_clickMTWithKid:@"5"];
    }
    if (@available(iOS 16.0, *)) {
        [self rotateIOS16Screen:isFScreen];
    } else {
        [self rotateScreen:isFScreen];
    }
}

- (void)ht_episodesPlayer:(HTPlayer *)player {
    //埋点
    [self.var_playViewModel lgjeropj_clickMTWithKid:@"33"];
    
    self.var_epsView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    
    self.var_epsView.currentSchedule = self.var_playViewModel.var_seasonModel;
    self.var_epsView.contentListArray = self.var_playViewModel.var_epsArray;
    self.var_epsView.currentIndex = self.var_playViewModel.var_epsModel;
    [self.var_epsView ht_showInView:self.var_player];
    
    @weakify(self);
    self.var_epsView.scheduleBlock = ^(id data) {
        @strongify(self);
        UIButton *seasonBtn = (UIButton *)data;
        UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
        CGRect fromRect = [window convertRect:seasonBtn.frame fromView:[seasonBtn superview]];
        self.var_seasonView.fromRect = fromRect;
        [self.var_seasonView ht_updateViewWithData:self.var_playViewModel.var_tvModel.ssn_list];
        [self.var_seasonView ht_showInView];
        @weakify(self);
        self.var_seasonView.seasonBlock = ^(HTTVDetailSeasonModel *model) {
            @strongify(self);
            if (self.var_playViewModel.var_seasonModel != model) {
                self.var_playViewModel.var_seasonModel = model;
                self.var_epsView.currentSchedule = model;
                [self requestSeason];
            }
            //埋点
            [self.var_playViewModel lgjeropj_clickMTWithKid:@"37"];
        };
    };
    
    self.var_epsView.exerciseBlock = ^(id data) {
        @strongify(self);
        // 切集之前保存
        [self updateHistoryModel];
        //埋点
        [self.var_playViewModel lgjeropj_playtimeReport];
        [self.var_playViewModel lgjeropj_clickMTWithKid:@"34"];
        
        self.var_playViewModel.var_epsModel = (HTTVDetailEpsModel *)data;
        NSInteger index = [self.var_playViewModel.var_epsArray indexOfObject:data];
        self.var_playViewModel.selectIndexPath = [NSIndexPath indexPathForRow:index inSection:1];
        [self.tableView selectRowAtIndexPath:self.var_playViewModel.selectIndexPath animated:NO scrollPosition:(UITableViewScrollPositionNone)];
        
        [self requestEps:YES];
    };
}

- (void)ht_didEnterBackgroundPlayer:(HTPlayer *)player {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"udf_isQuitMTPlayerPage"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.var_playViewModel.var_isBackground = 1;
    //埋点
    [self.var_playViewModel lgjeropj_playtimeReport];
}

- (void)ht_willEnterForegroundPlayer:(HTPlayer *)player {
    if (!self.var_playViewModel.var_isShowAd) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"udf_isQuitMTPlayerPage"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        self.var_playViewModel.startTime = [NSDate date];
    }
}

- (void)ht_lockPlayer:(HTPlayer *)player andLock:(BOOL)isLock {
    
    self.var_playViewModel.var_isLock = isLock;
    if (@available(iOS 16.0, *)) {
        [[[[[UIApplication sharedApplication] delegate] window] rootViewController] setNeedsUpdateOfSupportedInterfaceOrientations];
    } else {
        // Fallback on earlier versions
    }
}

- (void)updateHistoryModel {
    if (self.var_isTType) {
        HTDBHistoryModel *model = [[HTDBHistoryModel alloc] ht_getDataWithVID:self.var_playViewModel.var_epsModel.ID];
        if (model) {
            model.var_seeTime = [NSString stringWithFormat:@"%.f",self.var_player.dependnt];
            model.var_totalTime = [NSString stringWithFormat:@"%.f",self.var_player.var_videoLength];
            model.var_lastTime = [[NSDate date] stringWithFormat:AsciiString(@"yyyy-MM-dd HH:mm:ss")];
            [model ht_insertOrUpDate];
        }
    } else {
        HTDBHistoryModel *model = [[HTDBHistoryModel alloc] ht_getDataWithMID:self.var_mId];
        if (model) {
            model.var_seeTime = [NSString stringWithFormat:@"%.f",self.var_player.dependnt];
            model.var_totalTime = [NSString stringWithFormat:@"%.f",self.var_player.var_videoLength];
            model.var_lastTime = [[NSDate date] stringWithFormat:AsciiString(@"yyyy-MM-dd HH:mm:ss")];
            [model ht_insertOrUpDate];
        }
    }
    
}

// ios16之前横竖屏转换
- (void)rotateScreen:(BOOL)horizontal {
    UIDeviceOrientation orientation = horizontal ? UIDeviceOrientationLandscapeLeft : UIDeviceOrientationPortrait;
    if(orientation == UIDeviceOrientationLandscapeLeft) {
        NSNumber *target = [NSNumber numberWithInteger:UIDeviceOrientationLandscapeLeft];
        [[UIDevice currentDevice] setValue:target forKey:@"orientation"];
    } else {
        NSNumber *target = [NSNumber numberWithInteger:UIDeviceOrientationPortrait];
        [[UIDevice currentDevice] setValue:target forKey:@"orientation"];
    }
}

// ios16之后横竖屏转换
- (void)rotateIOS16Screen:(BOOL)horizontal {
    if (@available(iOS 16.0, *)) {
        NSArray *array = [[[UIApplication sharedApplication] connectedScenes] allObjects];
        UIWindowScene *scene = [array firstObject];
        // 屏幕方向
        UIInterfaceOrientationMask mask = horizontal ? UIInterfaceOrientationMaskLandscapeRight : UIInterfaceOrientationMaskPortrait;
        UIWindowSceneGeometryPreferencesIOS *geometry = [[UIWindowSceneGeometryPreferencesIOS alloc] initWithInterfaceOrientations:mask];
        // 开始切换
        [scene requestGeometryUpdateWithPreferences:geometry errorHandler:^(NSError * _Nonnull error) {
        }];
    }
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    NSLog(@"view 发生改变:%@", NSStringFromCGSize(size));
    BOOL isFScreen = size.width > size.height;
    self.var_player.positivismBouncy = isFScreen;
    if (isFScreen) {
        self.var_player.frame = CGRectMake(0, 0, size.width, size.height);
        self.var_bannerView.hidden = YES;
    } else {
        self.var_player.frame = self.var_playViewModel.var_playerRect;
        self.var_bannerView.hidden = !self.var_playViewModel.var_haveAds;
    }
    
    [self setNeedsStatusBarAppearanceUpdate];
    if (@available(iOS 11.0, *)) {
        [self setNeedsUpdateOfHomeIndicatorAutoHidden];
    } else {
        // Fallback on earlier versions
    }
}
- (BOOL)shouldAutorotate {
    
    if (self.var_playViewModel.var_isLock) {
        return NO;
    }
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    if (self.var_playViewModel.var_isLock) {
        return UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
    }
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

#pragma mark - MAAdViewAdDelegate Protocol

- (void)didStartAdRequestForAdUnitIdentifier:(NSString *)adUnitIdentifier {
    NSLog(@"店家 %@",adUnitIdentifier);
}

- (void)didLoadAd:(MAAd *)ad {
    
    NSDictionary *applovinDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"udf_applovin"];
    NSString *var_reward = applovinDict[@"reward"];
    if ([ad.adUnitIdentifier isEqualToString:var_reward]) {
        
    }
}

- (void)didFailToLoadAdForAdUnitIdentifier:(NSString *)adUnitIdentifier withError:(MAError *)error {
    NSLog(@"Load error %@",error.description);
}

- (void)didDisplayAd:(MAAd *)ad {
    NSLog(@"显示 ad");
    self.var_playViewModel.var_isShowAd = YES;
}

- (void)didClickAd:(MAAd *)ad {
    NSLog(@"店家 ad");
}

- (void)didHideAd:(MAAd *)ad {
    
    NSDictionary *applovinDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"udf_applovin"];
    NSString *var_reward = applovinDict[@"reward"];
    if ([ad.adUnitIdentifier isEqualToString:var_reward]) {
        [self ht_resetPlayerFrameAfterRewardAD:self.var_player.positivismBouncy];
          // 暂停视频播放
        __weak typeof(self) weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.var_player ht_play];
        });
        
        self.var_rewardedAd = nil;
        // 8分钟后，再次加载激励视频
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(480 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.var_rewardedAd loadAd];
        });
        
        self.var_playViewModel.var_isShowAd = NO;
        // 9分钟后，再次展示
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(540 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            weakSelf.var_playViewModel.var_isShowReward = YES;
        });
    }
}
- (void)ht_resetPlayerFrameAfterRewardAD:(BOOL)isFScreen {
    if (isFScreen) {
        CGFloat fWidth = ((kScreenWidth < kScreenHeight) ?kScreenHeight :kScreenWidth);
        CGFloat fHeight = ((kScreenWidth < kScreenHeight) ?kScreenWidth :kScreenHeight);
        self.var_player.frame = CGRectMake(0, 0, fWidth, fHeight);
        
        self.var_bannerView.hidden = YES;
    } else {
        self.var_player.frame = self.var_playViewModel.var_playerRect;
        
        self.var_bannerView.hidden = !self.var_playViewModel.var_haveAds;
    }
    [self setNeedsStatusBarAppearanceUpdate];
    if (@available(iOS 11.0, *)) {
        [self setNeedsUpdateOfHomeIndicatorAutoHidden];
    } else {
        // Fallback on earlier versions
    }
}
- (void)didFailToDisplayAd:(MAAd *)ad withError:(MAError *)error {
    NSLog(@"Display error %@",error.description);
}

- (void)didExpandAd:(MAAd *)ad {}

- (void)didCollapseAd:(MAAd *)ad {}

- (void)lgjeropj_bindViewModel {
    
    self.var_playViewModel.var_linkTime1 = [NSDate date];
    self.var_playViewModel.var_linkTime2 = nil;
    
    @weakify(self);
    if (self.var_isTType) {
        NSString *var_userid = @"0";
        ZQAccountModel *result = [HTCommonConfiguration lgjeropj_shared].BLOCK_userBlock();
        if ([result.var_userid integerValue] > 0) {
            var_userid = result.var_userid;
        }
        [[HTHttpRequest sharedManager] ht_post:[NSString stringWithFormat:@"%d", 202] andParameters:@{AsciiString(@"id"):(self.var_mId ?: @""),AsciiString(@"uid"):var_userid} andCompletion:^(HTResponseModel * _Nullable data, NSError * _Nullable error) {
            if (error != nil) {
                if (data.status == 200) {
                    HTTVDetailModel *var_model = [HTTVDetailModel yy_modelWithJSON:data.data];
                    self.var_playViewModel.var_tvModel = var_model;
                    ZQAccountModel *var_account = [HTCommonConfiguration lgjeropj_shared].BLOCK_userBlock();
                    if ([self.var_playViewModel.var_tvModel.logout integerValue] == 1 && var_account.var_userid.integerValue > 0) {
                        [HTCommonConfiguration lgjeropj_shared].BLOCK_toLogoutBlock();
                        [HTCommonConfiguration lgjeropj_shared].BLOCK_subscribeVerifyBlock();
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"NTFCTString_UpdateUserDisplayInformation" object:nil];
                    }

                    if (self.var_playViewModel.var_seasonModel == nil) {
                        self.var_playViewModel.var_seasonModel = [self.var_playViewModel.var_tvModel.ssn_list lastObject];
                    } else {
                        for (HTTVDetailSeasonModel *season in self.var_playViewModel.var_tvModel.ssn_list) {
                            if ([self.var_playViewModel.var_seasonModel.ID isEqualToString:season.ID]) {
                                self.var_playViewModel.var_seasonModel = season;
                            }
                        }
                    }
                    [self ht_requestSeasonInfo:(self.var_playViewModel.var_seasonModel.ID ?: @"")];
                } else {
                    [self ht_showCopyrightLabel];
                }
            }
        }];
    } else {
        // 请求电影详情
        NSString *timestamp = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
        [[HTHttpRequest sharedManager] ht_post:[NSString stringWithFormat:@"%d", 144] andParameters:@{
            AsciiString(@"id"):(self.var_mId ?: @""),
            AsciiString(@"unixtime"):(timestamp ?: @""),
            AsciiString(@"api_ver"):@"1",
        } andCompletion:^(HTResponseModel *response, NSError * _Nullable error) {
            if ( error == nil ) {
                if ( response.status == 200 ) {
                    HTMovieDetailModel *var_model = [HTMovieDetailModel yy_modelWithJSON:response.data];
                    self.var_playViewModel.var_detailModel = var_model;
                    ZQAccountModel *var_account = [HTCommonConfiguration lgjeropj_shared].BLOCK_userBlock();
                    if ([self.var_playViewModel.var_detailModel.logout integerValue] == 1 && var_account.var_userid.integerValue > 0) {
                        [HTCommonConfiguration lgjeropj_shared].BLOCK_toLogoutBlock();
                        [HTCommonConfiguration lgjeropj_shared].BLOCK_subscribeVerifyBlock();
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"NTFCTString_UpdateUserDisplayInformation" object:nil];
                    }
                    NSString *var_size = AsciiString(@"size");
                    NSString *var_link = AsciiString(@"link");
                    NSString *var_playUrl = self.var_playViewModel.var_detailModel.var_hd[var_link];
                    NSString *size = self.var_playViewModel.var_detailModel.var_hd[var_size];
                    if (var_playUrl == nil || [var_playUrl isEqualToString:@""]) {
                        var_playUrl = self.var_playViewModel.var_detailModel.var_sd[var_link];
                        size = self.var_playViewModel.var_detailModel.var_sd[var_size];
                    }
                    HTDBHistoryModel *model = [[HTDBHistoryModel alloc] ht_getDataWithMID:self.var_mId];
                    if (var_playUrl == nil || [var_playUrl isEqualToString:@""]) {
                        [SVProgressHUD showInfoWithStatus:LocalString(@"Error", nil)];
                        return;
                    }
                    model.var_title = self.var_playViewModel.var_detailModel.title;
                    model.var_playLink = var_playUrl;
                    model.var_rate = self.var_playViewModel.var_detailModel.rate;
                    model.var_country = self.var_playViewModel.var_detailModel.country;
                    model.var_tags = self.var_playViewModel.var_detailModel.tags;
                    model.var_stars = self.var_playViewModel.var_detailModel.stars;
                    model.var_desc = self.var_playViewModel.var_detailModel.desc;
                    model.var_size = size;
                    model.var_lastTime = [[NSDate date] stringWithFormat:AsciiString(@"yyyy-MM-dd HH:mm:ss")];
                    [model ht_insertOrUpDate];
                    [self.var_player lgjeropj_prophetessShotmak:var_playUrl];
                    self.var_player.var_videoLength = [model.var_totalTime doubleValue];
                    [self.var_player lgjeropj_bureaucratTitle:self.var_playViewModel.var_detailModel.title];
                    self.var_player.dependnt = [model.var_seeTime doubleValue];
                    [self.var_player ht_play];
                    [self.tableView reloadData];
                    //埋点
                    if (self.var_playViewModel.var_linkTime2 == nil) {
                        self.var_playViewModel.var_linkTime2 = [NSDate date];
                    }
                    self.var_playViewModel.var_cache1 = [NSDate date];
                    self.var_playViewModel.var_cache2 = nil;
                    [self.var_playViewModel lgjeropj_reportMTPlayShow];

                } else if (response.status == 403) {
                    [self ht_showCopyrightLabel];
                } else {
                    [SVProgressHUD showInfoWithStatus:response.msg];
                }
            }
        }];
        [self requestSubtitlesWithId:self.var_mId];
    }
    [[HTHttpRequest sharedManager] ht_post:[NSString stringWithFormat:@"%d", 78] andParameters:nil andCompletion:^(HTResponseModel *model, NSError * _Nullable error) {
        if ( error == nil ) {
            if ( model.status == 200 ) {
                NSDictionary *dict = (NSDictionary *)model.data;
                if (self.var_isTType) {
                    self.var_playViewModel.shareText = dict[@"tttext"];
                    self.var_playViewModel.shareLink = dict[@"ttlink"];
                } else {
                    self.var_playViewModel.shareText = dict[@"mtext"];
                    self.var_playViewModel.shareLink = dict[@"mlink"];
                }
            }
        }
    }];
}

- (void)ht_requestSeasonInfo:(NSString *)var_id {
    
    [[HTHttpRequest sharedManager] ht_post:[NSString stringWithFormat:@"%d", 203] andParameters:@{AsciiString(@"id"):var_id} andCompletion:^(HTResponseModel *model, NSError * _Nullable error) {
        if (error == nil) {
            if ( model.status == 200 ) {
                NSArray *var_array = [NSArray yy_modelArrayWithClass:[HTTVDetailEpsModel class] json:model.data[@"eps_list"]];
                self.var_playViewModel.var_epsArray = var_array;
                self.var_epsView.contentListArray = var_array;
                [self.tableView reloadData];
                BOOL isContains = NO;
                for (HTTVDetailEpsModel *eps in self.var_playViewModel.var_epsArray) {
                    if ([eps.ID isEqualToString:self.var_playViewModel.var_epsModel.ID]) {
                        self.var_playViewModel.var_epsModel = eps;
                        isContains = YES;
                        break;
                    }
                }
                if (!self.var_playViewModel.var_isChange) {
                    if (!isContains) {
                        self.var_playViewModel.var_epsModel = [self.var_playViewModel.var_epsArray firstObject];
                    }
                }
                NSInteger index = [self.var_playViewModel.var_epsArray indexOfObject:self.var_playViewModel.var_epsModel];
                self.var_playViewModel.selectIndexPath = [NSIndexPath indexPathForRow:index inSection:1];
                [self.tableView selectRowAtIndexPath:self.var_playViewModel.selectIndexPath animated:NO scrollPosition:(UITableViewScrollPositionNone)];
                if (!self.var_playViewModel.var_isChange) {
                    [self requestEps:NO];
                }
            } else {
                [SVProgressHUD showInfoWithStatus:model.msg];
            }
        }
    }];
}

- (void)ht_showCopyrightLabel {
    dispatch_async(dispatch_get_main_queue(), ^{
        // 隐藏视频框上按钮
        [self.var_player ht_touchBeganAndEvent];
        [self.tableView reloadData];
        
        self.var_copyrightLab = [[UILabel alloc] init];
        self.var_copyrightLab.numberOfLines = 0;
        self.var_copyrightLab.text = LocalString(@"Due to the request of the copyright owner, the video is not available for playback", nil);
        self.var_copyrightLab.backgroundColor = [UIColor blackColor];
        self.var_copyrightLab.font = [UIFont systemFontOfSize:16];
        self.var_copyrightLab.textColor = [UIColor whiteColor];
        [self.view addSubview:self.var_copyrightLab];
        [self.var_copyrightLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.var_player.mas_left).mas_offset(40);
            make.right.mas_equalTo(self.var_player.mas_right).mas_offset(-40);
            make.top.bottom.mas_equalTo(self.var_player).mas_offset(0);
        }];
    });
}
- (void)requestSeason {
    self.var_playViewModel.var_isChange = YES;
    [self ht_requestSeasonInfo:(self.var_playViewModel.var_seasonModel.ID ?: @"")];
}

- (void)requestEps:(BOOL)var_showReward {
    
    HTDBHistoryModel *model = [[HTDBHistoryModel alloc] ht_getDataWithVID:self.var_playViewModel.var_epsModel.ID];
    self.var_playViewModel.var_isFirstPlay = NO;
    if (model == nil) {
        self.var_playViewModel.var_isFirstPlay = YES;
        model = [[HTDBHistoryModel alloc] init];
        model.var_mId = self.var_mId;
        model.var_cover = self.cover;
        model.var_seeTime = @"0";
        model.var_totalTime = @"0";
        model.var_lastTime = @"0";
        model.var_title = self.var_playViewModel.var_tvModel.title;
        model.var_rate = self.var_playViewModel.var_tvModel.rate;
        model.var_country = self.var_playViewModel.var_tvModel.country;
        model.var_tags = self.var_playViewModel.var_tvModel.tags;
        model.var_desc = self.var_playViewModel.var_tvModel.desc;
        model.var_isTV = [NSString stringWithFormat:@"%d", self.var_isTType];
    }
    model.var_jId = self.var_playViewModel.var_seasonModel.ID;
    model.var_vId = self.var_playViewModel.var_epsModel.ID;
    [model ht_insertOrUpDate];
    // 获取播放链接
    NSString *timestamp = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
    [[HTHttpRequest sharedManager] ht_post:[NSString stringWithFormat:@"%d", 151] andParameters:@{
        AsciiString(@"id"):(self.var_playViewModel.var_epsModel.ID ?: @""),
        AsciiString(@"unixtime"):timestamp,
        AsciiString(@"api_ver"):@"1",
    } andCompletion:^(HTResponseModel *response, NSError * _Nullable error) {
        if (error == nil) {
            if (response.status == 200) {
                HTMovieDetailModel *var_model = [HTMovieDetailModel yy_modelWithJSON:response.data];
                NSString *var_size = AsciiString(@"size");
                NSString *var_link = AsciiString(@"link");
                self.var_playViewModel.var_detailModel = var_model;
                NSString *var_playUrl = self.var_playViewModel.var_detailModel.var_hd[var_link];
                NSString *size = self.var_playViewModel.var_detailModel.var_hd[var_size];
                if (var_playUrl == nil || [var_playUrl isEqualToString:@""]) {
                    var_playUrl = self.var_playViewModel.var_detailModel.var_sd[var_link];
                    size = self.var_playViewModel.var_detailModel.var_sd[var_size];
                }
                if (var_playUrl == nil || [var_playUrl isEqualToString:@""]) {
                    var_playUrl = self.var_playViewModel.var_detailModel.cflink;
                }
                HTDBHistoryModel *model = [[HTDBHistoryModel alloc] ht_getDataWithVID:self.var_playViewModel.var_epsModel.ID];
                if (var_playUrl == nil || [var_playUrl isEqualToString:@""]) {
                    [SVProgressHUD showInfoWithStatus:LocalString(@"Error", nil)];
                    return;
                }
                model.var_playLink = var_playUrl;
                model.var_size = size;
                model.var_lastTime = [[NSDate date] stringWithFormat:AsciiString(@"yyyy-MM-dd HH:mm:ss")];
                [model ht_insertOrUpDate];
                [self.var_player lgjeropj_prophetessShotmak:var_playUrl];
                self.var_player.var_videoLength = [model.var_totalTime doubleValue];
                [self.var_player lgjeropj_bureaucratTitle:self.var_playViewModel.var_tvModel.title];
                self.var_player.dependnt = [model.var_seeTime doubleValue];
                [self.var_player ht_play];
                //埋点
                if (self.var_playViewModel.var_linkTime2 == nil) {
                    self.var_playViewModel.var_linkTime2 = [NSDate date];
                }
                self.var_playViewModel.var_cache1 = [NSDate date];
                self.var_playViewModel.var_cache2 = nil;
                [self.var_playViewModel lgjeropj_reportMTPlayShow];
            } else {
                [SVProgressHUD showInfoWithStatus:response.msg];
            }
        }
    }];
    
    [self requestSubtitlesWithId:self.var_playViewModel.var_epsModel.ID];
    
    if (self.var_playViewModel.var_haveAds && var_showReward) {
        self.var_rewardedAd = nil;
        [self.var_rewardedAd loadAd];
        self.var_playViewModel.var_isShowReward = YES;
    }
}

- (void)requestSubtitlesWithId:(NSString *)idStr {
    
    @weakify(self);
    [[HTHttpRequest sharedManager] ht_post:[NSString stringWithFormat:@"%d", 163] andParameters:@{AsciiString(@"id"):(idStr ?: @""),AsciiString(@"type"):(self.var_isTType ? @"2":@"1")} andCompletion:^(HTResponseModel *model, NSError * _Nullable error) {
        if ( error == nil ) {
            if ( model.status == 200 ) {
                NSArray *var_array = [NSArray yy_modelArrayWithClass:[HTSubtitlesModel class] json:model.data[AsciiString(@"subtitle")]];
                [self.var_player lgjeropj_overcriticlMishandle:!self.var_playViewModel.var_closeSubtitle];
                HTSubtitlesModel *sub = nil;
                if (var_array.count > 0) {
                    for (HTSubtitlesModel *model in var_array) {
                        if ([model.l_short isEqualToString:@"en"]) {
                            sub = model;
                        }
                    }
                    if (sub == nil) {
                        sub = [var_array firstObject];
                    }
                    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
                    // 文件夹
                    self.var_playViewModel.var_textPath = [NSString stringWithFormat:@"%@/%@",path,self.var_mId];
                    [HTFileManager ht_createDirectoryAtPath:self.var_playViewModel.var_textPath];
                    [self turnLanague:sub];
                    self.var_playViewModel.textArray = var_array;
                }
            } else {
                self.var_playViewModel.var_textPath = @"";
                self.var_playViewModel.textArray = [NSArray array];
                [self.var_player lgjeropj_overcriticlMishandle:NO];
            }
        }
    }];
}

- (void)turnLanague:(HTSubtitlesModel *)sub {
    sub.isSelect = YES;
    
    NSString *srtPath = [NSString stringWithFormat:@"%@/%@",self.var_playViewModel.var_textPath,sub.t_name];
    [self.var_player lgjeropj_crescendoAmiss:srtPath];
    HTDBHistoryModel *model = [[HTDBHistoryModel alloc] ht_getDataWithMID:self.var_mId];
    if (model) {
        [model ht_updateSrt:sub.t_name];
    }
    [self loadSubtitle:sub.sub];
}

- (void)loadSubtitle:(NSString *)srtUrl {
    @weakify(self);
    [[HTFileLoader sharedFileloader] ht_loadDataWithURL:[NSURL URLWithString:srtUrl] andCompleted:^(HTFileLoadReceipt * _Nullable receipt, NSError * _Nullable error, BOOL finished) {
        @strongify(self);
        if (receipt.state == ENUM_HTFileloadStateCompleted) {
            NSLog(@"complete path %@",receipt.filePath);
            if ([receipt.filePath hasSuffix:AsciiString(@".zip")]) {
                NSError *error;
                BOOL success = [SSZipArchive unzipFileAtPath:receipt.filePath toDestination:self.var_playViewModel.var_textPath overwrite:YES password:@"" error:&error];
                if (success) {
                    [HTFileManager ht_removeItemAtPath:receipt.filePath];
                }
            }
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
        
    // 释放前面所有页面，只保留当前页面
    for (UINavigationController *navigation in self.tabBarController.viewControllers) {
        if (navigation != self.navigationController) {
            for (UIViewController *vc in navigation.viewControllers) {
                vc.view = nil;
            }
            navigation.view = nil;
        } else {
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if (vc != self) {
                    vc.view = nil;
                }
            }
        }
    }
}

- (BOOL)prefersStatusBarHidden {
    if (isPad && self.var_player.positivismBouncy) {
        return YES;
    }
    return NO;
}

- (BOOL)prefersHomeIndicatorAutoHidden {
    if (self.var_player.positivismBouncy) {
        return YES;
    }
    return NO;
}

- (HTChangeSubtitleView *)var_textView {
    if (_var_textView == nil) {
        _var_textView = [[HTChangeSubtitleView alloc] init];
    }
    return _var_textView;
}

- (HTChangeEpisodesView *)var_epsView {
    if (_var_epsView == nil) {
        _var_epsView = [[HTChangeEpisodesView alloc] init];
    }
    return _var_epsView;
}

- (HTTVSeasonView *)var_seasonView {
    if (_var_seasonView == nil) {
        _var_seasonView = [[HTTVSeasonView alloc] init];
    }
    return _var_seasonView;
}

- (MARewardedAd *)var_rewardedAd {
    if (_var_rewardedAd == nil) {
        NSDictionary *applovinDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"udf_applovin"];
        NSString *var_reward = applovinDict[@"reward"];
        _var_rewardedAd = [MARewardedAd sharedWithAdUnitIdentifier:var_reward sdk:[HTCommonConfiguration lgjeropj_shared].BLOCK_appLovinSDKBlock()];
        _var_rewardedAd.delegate = self;
    }
    return _var_rewardedAd;
}

- (void)didRewardUserForAd:(MAAd *)ad withReward:(MAReward *)reward {}

- (HTMoviePlayViewModel *)var_playViewModel {
    
    if (!_var_playViewModel) {
        _var_playViewModel = [[HTMoviePlayViewModel alloc] init];
    }
    _var_playViewModel.var_isTType = self.var_isTType;
    _var_playViewModel.source = self.source;
    _var_playViewModel.var_mId = self.var_mId;
    _var_playViewModel.var_isShowSubtitle = self.var_player.var_isShowSubtitle;
    _var_playViewModel.var_playUrl = self.var_player.var_playUrl;
    _var_playViewModel.var_pauseNum = self.var_player.intrepidNum;
    return _var_playViewModel;
}

@end

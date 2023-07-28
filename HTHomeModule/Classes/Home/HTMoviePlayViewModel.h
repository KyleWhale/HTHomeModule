//
//  HTMoviePlayViewModel.h
//  Moshfocus
//
//  Created by 李雪健 on 2023/6/6.
//

#import <Foundation/Foundation.h>
#import "HTMovieDetailModel.h"
#import "HTTVDetailEpsModel.h"
#import "HTTVDetailModel.h"
#import "HTTVDetailSeasonModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HTMoviePlayViewModel : NSObject

@property (nonatomic, assign) BOOL var_pauseByGuide;
@property (nonatomic, assign) BOOL var_closeSubtitle;
@property (nonatomic, strong) NSString *var_mId;
@property (nonatomic, strong) NSString *source;
@property (nonatomic, assign) BOOL var_isTType;
@property (nonatomic, strong) HTMovieDetailModel *var_detailModel;
@property (nonatomic, strong) HTTVDetailModel *var_tvModel;
@property (nonatomic, strong) NSArray *var_epsArray;
@property (nonatomic, strong) HTTVDetailSeasonModel *var_seasonModel;
@property (nonatomic, strong) HTTVDetailEpsModel *var_epsModel;
@property (nonatomic, assign) BOOL var_haveAds;
// 是否展示激励视频
@property (nonatomic, assign) BOOL var_isShowReward;
// 是否出现激励视频
@property (nonatomic, assign) BOOL var_isShowAd;
// 是否手动换季
@property (nonatomic, assign) BOOL var_isChange;
@property (nonatomic, assign) CGRect  var_playerRect;
@property (nonatomic, strong) NSArray *textArray;
@property (nonatomic, strong) NSString *var_textPath;
@property (nonatomic, strong) NSIndexPath *selectIndexPath;
@property (nonatomic, strong) NSString *shareText;
@property (nonatomic, strong) NSString *shareLink;
@property (nullable, nonatomic, strong) NSDate *startTime;
@property (nonatomic, assign) NSInteger var_isPlaySuccess;
@property (nonatomic, assign) CGFloat total;//总时长
@property (nullable, nonatomic, strong) NSDate *var_cache1;//开始缓冲时间
@property (nullable, nonatomic, strong) NSDate *var_cache2;//结束缓冲时间
@property (nullable, nonatomic, strong) NSDate *var_linkTime1;//开始获取播放连接时间
@property (nullable, nonatomic, strong) NSDate *var_linkTime2;//结束获取播放连接时间
@property (nonatomic, assign) NSInteger var_isBackground;//是否进入过后台 1 是 2否
@property (nonatomic, assign) NSInteger var_isFirstPlay;
@property (nonatomic, assign) NSInteger var_pushPremium;
@property (nonatomic, assign) BOOL var_isLock;

@property (nonatomic, assign) BOOL var_isShowSubtitle;
@property (nonatomic, copy) NSString *var_playUrl;
@property (nonatomic, assign) NSInteger var_pauseNum;



- (void)lgjeropj_reportMTPlayShow;

- (void)lgjeropj_clickMTWithKid:(NSString *)kidStr;

- (void)lgjeropj_castShowAndkid:(NSString *)kidStr;

- (void)lgjeropj_castClickWithKid:(NSString *)kidStr;

- (void)lgjeropj_vipguideShow;

- (void)lgjeropj_vipguideClickAndkid:(NSString *)kidStr;

- (void)lgjeropj_playtimeReport;

@end

NS_ASSUME_NONNULL_END

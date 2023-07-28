//
//  HTPlayer.h
//  Hucolla
//
//  Created by mac on 2022/9/16.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "HTChangeSubtitleView.h"
#import "HTChangeEpisodesView.h"

NS_ASSUME_NONNULL_BEGIN

@class HTPlayer;
@protocol HTPlayerDelegate <NSObject>

@optional
/// 返回按钮点击
- (void)ht_cancelPlayer:(HTPlayer *)player;
/// 投点击
- (void)ht_castPlayer:(HTPlayer *)player;
/// 分享点击
- (void)ht_sharedPlayer:(HTPlayer *)player;
/// 字幕点击
- (void)ht_subtitlesPlayer:(HTPlayer *)player;
// 去广告点击
- (void)ht_removeAdsPlayer:(HTPlayer *)player;
/// 播放时间
- (void)ht_player:(HTPlayer *)player andSeeTime:(double)seeTime;
/// 锁屏点击
- (void)ht_lockPlayer:(HTPlayer *)player andLock:(BOOL)isLock;
/// 状态改变
- (void)ht_player:(HTPlayer *)player andPlayerState:(ENUM_HTPlayerState)state;
/// 全屏点击
- (void)ht_player:(HTPlayer *)player andFScreen:(BOOL)isFScreen;
/// 切换季、集
- (void)ht_episodesPlayer:(HTPlayer *)player;
/// 进入前台
- (void)ht_willEnterForegroundPlayer:(HTPlayer *)player;
/// 进入后台
- (void)ht_didEnterBackgroundPlayer:(HTPlayer *)player;

@end

@interface HTPlayer : UIView

@property (nonatomic, weak) id <HTPlayerDelegate> delegate;
/// 播放器
@property (nonatomic, strong, nullable) AVPlayer *charmerDetract;
/// Layer
@property (nonatomic, strong) AVPlayerLayer *refllySummarise;
/// 设置Url，可以是本地的路径也可以是http的网络路径
@property (nonatomic, strong, readonly) NSString *var_playUrl;
/// 设置字幕地址
@property (nonatomic, strong, readonly) NSString *var_textPath;
/// 设置播放视频的title
@property (nonatomic, strong, readonly) NSString *var_playTitle;
/// 是否全屏 BOOL值
@property (nonatomic, assign) BOOL positivismBouncy;
/// 视频长度
@property (nonatomic, assign) double var_videoLength;
/// 获取/设置 播放的时间点
@property (nonatomic, assign) double dependnt;
/// 播放器状态
@property (nonatomic, assign, readonly) ENUM_HTPlayerState var_pState;
/// 字幕偏移时间
@property (nonatomic, assign) double timeOffset;
/// 是不是显示字幕
@property (nonatomic, assign, readonly) BOOL var_isShowSubtitle;
/// 是不是电视剧
@property (nonatomic, assign, readonly) BOOL var_isTType;
/// 是不是显示广告
@property (nonatomic, assign) BOOL var_haveAds;
/// 卡顿次数
@property (nonatomic, assign) NSInteger intrepidNum;
/// 进入后台时是否播放状态
@property (nonatomic, assign, readonly) BOOL striationEmergence;
/// 设置封面图
- (void)ht_unfeelCover:(id)var_cover;
/// 播放
- (void)ht_play;
/// 暂停
- (void)ht_pause;
/// 重置播放器
- (void)lgjeropj_resetHTPlayer;
/// 展示原生广告
- (void)lgjeropj_showAdverst;
/// 隐藏原生广告
- (void)lgjeropj_dismissAdverst;

- (CGRect)ht_shareBtnFrame;

- (void)ht_touchBeganAndEvent;

- (void)lgjeropj_sorbetType:(BOOL)var_type;

- (void)lgjeropj_beverageState:(ENUM_HTPlayerState)var_state;

- (void)lgjeropj_crescendoAmiss:(NSString *)var_textPath;

- (void)lgjeropj_bureaucratTitle:(NSString *)var_playTitle;

- (void)lgjeropj_prophetessShotmak:(NSString *)var_playUrl;

- (void)lgjeropj_overcriticlMishandle:(BOOL)var_isShowSubtitle;

//隐藏去广告按钮,yes:隐藏,no显示
- (void)ht_hidenAdItem:(BOOL)var_isHiden;

- (void)lgjeropj_removeBannerView;

@end

NS_ASSUME_NONNULL_END

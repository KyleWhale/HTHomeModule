//
//  HTPlayer.m
//  Hucolla
//
//  Created by mac on 2022/9/16.
//

#import "HTPlayer.h"
#import "HTSubtitleView.h"
#import "HTSubtitleManager.h"
#import "HTPlayBottomBar.h"
#import "HTAdvertisementView.h"
#import "HTAdvertBannerView.h"
#import "HTPlayerViewModel.h"

@interface HTPlayer()

@property (nonatomic, strong) HTPlayerViewModel *viewModel;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UIButton *var_cancelBtn;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) HTPlayBottomBar *bottomView;
@property (nonatomic, strong) UIView *var_middleView;
@property (nonatomic, strong) HTSubtitleView *var_subtitleView;
@property (nonatomic, strong) HTAdvertisementView *var_advertView;
@property (nonatomic, strong) HTAdvertBannerView *var_bannerView;
@property (nonatomic, strong) UIButton *var_dlnaBtn;
@property (nonatomic, strong) UIButton *var_shareBtn;
@property (nonatomic, strong) UIButton *var_subtitlesBtn;
@property (nonatomic, strong) UIButton *var_adBtn;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *var_playMaxBtn;
@property (nonatomic, strong) UIButton *var_timeLastBtn;
@property (nonatomic, strong) UIButton *var_timeNextBtn;
@property (nonatomic, strong) UIButton *var_lockBtn;
@property (nonatomic, strong) AVPlayerItem *currentItem;
@property (nonatomic, strong) UIActivityIndicatorView *loadingView;
@property (nonatomic, strong) NSTimer *var_playTimer;
@property (nonatomic ,strong) id var_playbackTimeObserver;

@end

static void *STATIC_HTPlayerStatusObservationContext = &STATIC_HTPlayerStatusObservationContext;

@implementation HTPlayer

- (instancetype)init {
    self = [super init];
    if ( self ) {
        self.viewModel = [[HTPlayerViewModel alloc] init];
        [self ht_addViewSubViews];
    }
    return self;
}

- (void)ht_addViewSubViews {
    self.backgroundColor = [UIColor blackColor];
    self.clipsToBounds = YES;
    
    self.viewModel.var_isShowTop = YES;
    self.viewModel.var_isShowBottom = YES;
    self.viewModel.var_isAnimation = NO;
    self.timeOffset = 0.0;
    self.intrepidNum = 0;
    
    self.contentView = [[UIView alloc] init];
    [self addSubview:self.contentView];
    
    self.coverImageView = [[UIImageView alloc] init];
    self.coverImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.coverImageView];
    
    self.topView = [[UIView alloc] init];
    [self addSubview:self.topView];
    
    self.var_subtitleView = [[HTSubtitleView alloc] init];
    [self addSubview:self.var_subtitleView];
    
    self.bottomView = [[HTPlayBottomBar alloc] init];
    [self addSubview:self.bottomView];
    
    self.var_middleView = [[UIView alloc] init];
    [self addSubview:self.var_middleView];
    
    self.var_cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.var_cancelBtn setImage:[UIImage imageNamed:@"icon_wdback"] forState:UIControlStateNormal];
    [self.var_cancelBtn addTarget:self action:@selector(lgjeropj_onCancelAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.var_cancelBtn];   
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont systemFontOfSize:14 weight:(UIFontWeightSemibold)];
    [self.topView addSubview:self.titleLabel];
    
    if ([self.viewModel lgjeropj_haveAirplay]) {
        self.var_dlnaBtn = [HTKitCreate ht_buttonWithImage:[LKFPrivateFunction lgjeropj_imageUrlFromNumber:159] andSelectImage:nil];
        [self.var_dlnaBtn addTarget:self action:@selector(lgjeropj_onCastBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self.topView addSubview:self.var_dlnaBtn];
    } else if (self.var_dlnaBtn) {
        self.var_dlnaBtn.hidden = YES;
    }
    
    self.var_shareBtn = [HTKitCreate ht_buttonWithImage:[LKFPrivateFunction lgjeropj_imageUrlFromNumber:274] andSelectImage:nil];
    [self.var_shareBtn addTarget:self action:@selector(lgjeropj_onShareAction) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:self.var_shareBtn];
    
    self.var_subtitlesBtn = [HTKitCreate ht_buttonWithImage:[LKFPrivateFunction lgjeropj_imageUrlFromNumber:174] andSelectImage:nil];
    [self.var_subtitlesBtn addTarget:self action:@selector(lgjeropj_onSubtitlesAction) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:self.var_subtitlesBtn];
    
    self.var_lockBtn = [HTKitCreate ht_buttonWithImage:[LKFPrivateFunction lgjeropj_imageUrlFromNumber:76] andSelectImage:[LKFPrivateFunction lgjeropj_imageUrlFromNumber:75]];
    self.var_lockBtn.hidden = YES;
    [self.var_lockBtn addTarget:self action:@selector(lgjeropj_onLockAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.var_lockBtn];
    
    self.var_adBtn = [HTKitCreate ht_buttonWithImage:[LKFPrivateFunction lgjeropj_imageUrlFromNumber:119] andSelectImage:nil];
    [self.var_adBtn addTarget:self action:@selector(lgjeropj_onDisableAdAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.var_adBtn];
    
    self.var_playMaxBtn = [HTKitCreate ht_buttonWithImage:[LKFPrivateFunction lgjeropj_imageUrlFromNumber:163] andSelectImage:[LKFPrivateFunction lgjeropj_imageUrlFromNumber:162]];
    [self.var_playMaxBtn addTarget:self action:@selector(lgjeropj_onPlayOrPause:) forControlEvents:UIControlEventTouchUpInside];
    [self.var_middleView addSubview:self.var_playMaxBtn];
    
    self.var_timeLastBtn = [HTKitCreate ht_buttonWithImage:[LKFPrivateFunction lgjeropj_imageUrlFromNumber:161] andSelectImage:nil];
    [self.var_timeLastBtn addTarget:self action:@selector(lgjeropj_onTimeLastAction) forControlEvents:UIControlEventTouchUpInside];
    [self.var_middleView addSubview:self.var_timeLastBtn];
    
    self.var_timeNextBtn = [HTKitCreate ht_buttonWithImage:[LKFPrivateFunction lgjeropj_imageUrlFromNumber:164] andSelectImage:nil];
    [self.var_timeNextBtn addTarget:self action:@selector(lgjeropj_onTimeNextAction) forControlEvents:UIControlEventTouchUpInside];
    [self.var_middleView addSubview:self.var_timeNextBtn];
    
    [self.bottomView.playBtn addTarget:self action:@selector(lgjeropj_onPlayOrPause:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.bottomView.fullBtn addTarget:self action:@selector(lgjeropj_onFullScreen:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.bottomView.epsBtn addTarget:self action:@selector(lgjeropj_onEpisodes:) forControlEvents:UIControlEventTouchUpInside];
    
    //滑块设置
    //进度条的拖拽事件
    [self.bottomView.var_slider addTarget:self action:@selector(lgjeropj_onValueChanged:) forControlEvents:UIControlEventValueChanged];
    //进度条的点击事件
    [self.bottomView.var_slider addTarget:self action:@selector(lgjeropj_onTapSlider:) forControlEvents:UIControlEventTouchUpInside];
    
    //小菊花
    self.loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [self.contentView addSubview:self.loadingView];
    
    [self.loadingView startAnimating];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lgjeropj_appDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lgjeropj_appWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionAllowBluetooth error:nil];

    [[AVAudioSession sharedInstance] setActive:YES error:nil];
}

#pragma mark - 

#pragma mark - 公共方法

- (void)ht_unfeelCover:(id)var_cover {
    if ( var_cover ) {
        if ( [var_cover isKindOfClass:[NSString class]] ) {
            [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:(NSString *)var_cover]];
        }
        else if ( [var_cover isKindOfClass:[UIImage class]] ) {
            self.coverImageView.image = (UIImage *)var_cover;
        }
    }
}

- (void)ht_play {
    self.charmerDetract.rate = self.viewModel.var_nowRate;
    self.coverImageView.hidden = YES;
    
    if ( self.viewModel.var_isInitPlayer == NO ) {
        self.viewModel.var_isInitPlayer = YES;
        self.var_subtitleView.curIndex = 0;
        [self ht_creatPlayerAndReadyToPlay];
        [self.charmerDetract play];
        
        self.bottomView.playBtn.selected = YES;
        self.var_playMaxBtn.selected = YES;
        
        [self ht_updateTimer];
    } else {
        
        if ( self.var_pState != ENUM_HTPlayerStatePlaying ) {
            [self lgjeropj_beverageState:ENUM_HTPlayerStatePlaying];
            [self.charmerDetract play];
            self.bottomView.playBtn.selected = YES;
            self.var_playMaxBtn.selected = YES;
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(ht_player:andPlayerState:)]) {
        [self.delegate ht_player:self andPlayerState:self.var_pState];
    }
}


- (void)ht_pause {
    if ( self.var_pState == ENUM_HTPlayerStatePlaying ) {
        [self lgjeropj_beverageState:ENUM_HTPlayerStateStopped];
    }
    [self.charmerDetract pause];
    
    self.bottomView.playBtn.selected = NO;
    self.var_playMaxBtn.selected = NO;
    
    if ([self.delegate respondsToSelector:@selector(ht_player:andPlayerState:)]) {
        [self.delegate ht_player:self andPlayerState:self.var_pState];
    }
}


- (double)dependnt {
    if (self.charmerDetract) {
        return CMTimeGetSeconds([self.charmerDetract currentTime]);
    }else{
        return 0.0;
    }
}

- (void)setDependnt:(double)ht_currentTime {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.viewModel.var_seekTime = ht_currentTime;
        self.bottomView.timeLabel.text = [self.viewModel lgjeropj_convertTime:self.viewModel.var_seekTime];
        self.bottomView.totalLabel.text = [self.viewModel lgjeropj_convertTime:self.var_videoLength];
        
        [self.bottomView.progressView setProgress:0.0 animated:NO];
        if (self.var_videoLength > 0 && self.var_videoLength > self.viewModel.var_seekTime ) {
            self.bottomView.var_slider.maximumValue = self.var_videoLength;
            [self.bottomView.progressView setProgress:self.viewModel.var_seekTime/self.var_videoLength animated:NO];
        }
        self.bottomView.var_slider.value = self.viewModel.var_seekTime;
        
    });
}

- (void)lgjeropj_afterClearBannerView {
    // 自动隐藏
    __weak typeof(self) weakSelf = self;
    NSInteger var_m1 = [[[NSUserDefaults standardUserDefaults] objectForKey:@"udf_banner_ad_m1"] integerValue] ?: 5;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(var_m1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf lgjeropj_removeBannerView];
    });
}

- (void)lgjeropj_removeBannerView {
    
    [self.var_bannerView lgjeropj_onClearAction];
}

- (void)setPositivismBouncy:(BOOL)horizontal {
    _positivismBouncy = horizontal;
    
    if ( horizontal ) {
        
        if ( self.var_haveAds ) {
            
            if ( self.var_pState == ENUM_HTPlayerStateStopped ) {
                [self lgjeropj_showAdverst];
            }
            [self addSubview:self.var_bannerView];
            __weak typeof(self) weakSelf = self;
            self.var_bannerView.cancelBlock = ^(id data) {
                [weakSelf.var_bannerView removeFromSuperview];
                if (weakSelf.var_haveAds) {
                    NSInteger var_secs = [[[NSUserDefaults standardUserDefaults] objectForKey:@"udf_mbanner_secs"] integerValue] ?: 180;
                    // 自动显示
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(var_secs * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        if (weakSelf.positivismBouncy) {
                            [weakSelf addSubview:weakSelf.var_bannerView];
                        }
                        [weakSelf lgjeropj_afterClearBannerView];
                    });
                }
            };
            self.var_bannerView.var_didLoadBlock = ^{
                [weakSelf lgjeropj_afterClearBannerView];
            };
            if (self.var_bannerView.var_isLoaded) {
                [self lgjeropj_afterClearBannerView];
            }
        }
        
    } else {
        if ( self.var_haveAds ) {
            if (self.var_bannerView && [self.var_bannerView superview]) {
                [self.var_bannerView removeFromSuperview];
            }
            [self lgjeropj_dismissAdverst];
        }
    }
}

- (void)lgjeropj_overcriticlMishandle:(BOOL)var_isShowSubtitle {
    _var_isShowSubtitle = var_isShowSubtitle;
    self.var_subtitlesBtn.hidden = !var_isShowSubtitle;
    self.var_subtitleView.hidden = !var_isShowSubtitle;
    [self ht_resetTopButtonsFrame:var_isShowSubtitle];
}
- (void)ht_resetTopButtonsFrame:(BOOL)var_isShowSubtitle {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (var_isShowSubtitle) {
            self.var_subtitlesBtn.frame = CGRectMake(CGRectGetWidth(self.bounds) - 32 - 10, 6, 32, 32);
            self.var_shareBtn.frame = CGRectMake(CGRectGetMinX(self.var_subtitlesBtn.frame) - 32 - 7, 7, 32, 32);
            self.var_dlnaBtn.frame = CGRectMake(CGRectGetMinX(self.var_shareBtn.frame) - 32 - 7, 7, 32, 32);
            self.titleLabel.frame = CGRectMake(50, 10, CGRectGetMinX(self.var_shareBtn.frame) - 90, 24);
        }else {
            self.var_shareBtn.frame = CGRectMake(CGRectGetWidth(self.bounds) - 32 - 10, 6, 32, 32);
            self.var_dlnaBtn.frame = CGRectMake(CGRectGetMinX(self.var_shareBtn.frame) - 32 - 7, 7, 32, 32);
            self.titleLabel.frame = CGRectMake(50, 10, CGRectGetMinX(self.var_shareBtn.frame) - 90, 24);
        }
    });
}

- (void)lgjeropj_resetHTPlayer {
    // 暂停
    [self.charmerDetract pause];
    
    if ( _currentItem ) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:_currentItem];
        [_currentItem removeObserver:self forKeyPath:AsciiString(@"status")];
        [_currentItem removeObserver:self forKeyPath:AsciiString(@"loadedTimeRanges")];
        [_currentItem removeObserver:self forKeyPath:AsciiString(@"playbackBufferEmpty")];
        [_currentItem removeObserver:self forKeyPath:AsciiString(@"playbackLikelyToKeepUp")];
        [_currentItem cancelPendingSeeks];
        [_currentItem.asset cancelLoading];
        _currentItem = nil;
    }
    
    self.viewModel.var_isInitPlayer = NO;
    self.currentItem = nil;
    self.viewModel.var_seekTime = 0;
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    
    [self lgjeropj_closeTimer];
    // 移除原来的layer
    self.refllySummarise.player = nil;
    [self.refllySummarise removeFromSuperlayer];
    // 替换PlayerItem为nil
    [self.charmerDetract replaceCurrentItemWithPlayerItem:nil];
    [self.charmerDetract cancelPendingPrerolls];
    // 把player置为nil
    self.charmerDetract = nil;
}

#pragma mark - 各种操作
- (void)lgjeropj_onCancelAction {
//    if (self.isFullscreen && self.lockBtn.isSelected) {
//        return;
//    }
    if ( self.delegate && [self.delegate respondsToSelector:@selector(ht_cancelPlayer:)] ) {
        [self.delegate ht_cancelPlayer:self];
    }
}

- (void)lgjeropj_onShareAction {
    if ( self.delegate && [self.delegate respondsToSelector:@selector(ht_sharedPlayer:)] ) {
        [self.delegate ht_sharedPlayer:self];
    }
}

- (void)lgjeropj_onSubtitlesAction {
    if ( self.delegate && [self.delegate respondsToSelector:@selector(ht_subtitlesPlayer:)] ) {
        [self.delegate ht_subtitlesPlayer:self];
    }
}

- (void)lgjeropj_onCastBtnAction {
    if ( self.delegate && [self.delegate respondsToSelector:@selector(ht_castPlayer:)] ) {
        [self.delegate ht_castPlayer:self];
    }
}

- (void)lgjeropj_onLockAction {
    self.var_lockBtn.selected = !self.var_lockBtn.isSelected;
    
    if ( self.var_lockBtn.isSelected ) {
        self.viewModel.var_isAnimation = YES;
        self.viewModel.var_isShowTop = NO;
        self.viewModel.var_isShowBottom = NO;
    } else {
        self.viewModel.var_isAnimation = YES;
        self.viewModel.var_isShowTop = YES;
        self.viewModel.var_isShowBottom = YES;
    }
    [self setNeedsLayout];
    
    if ( self.delegate && [self.delegate respondsToSelector:@selector(ht_lockPlayer:andLock:)] ) {
        [self.delegate ht_lockPlayer:self andLock:self.var_lockBtn.isSelected];
    }
}

- (void)lgjeropj_onDisableAdAction {
    self.var_lockBtn.selected = NO;
    if ( self.delegate && [self.delegate respondsToSelector:@selector(ht_removeAdsPlayer:)] ) {
        [self.delegate ht_removeAdsPlayer:self];
    }
}

- (void)ht_hidenAdItem:(BOOL)var_isHiden
{
    if(self.var_adBtn) {
        self.var_adBtn.hidden = var_isHiden;
    }
}

- (void)lgjeropj_onTimeLastAction {
    // 后退10秒
    self.viewModel.var_seekTime = self.dependnt - 10;
    if (!self.var_subtitleView.isHidden) {
        self.var_subtitleView.curIndex = 0;
        self.var_subtitleView.attributeStr = [[NSAttributedString alloc] initWithString:@""];
        [self.var_subtitleView ht_showSrtWithTime:self.viewModel.var_seekTime offset:self.timeOffset];
    }
    self.bottomView.timeLabel.text = [self.viewModel lgjeropj_convertTime:self.viewModel.var_seekTime];
    [self lgjeropj_seekToTimeToPlay:self.viewModel.var_seekTime];
}

- (void)lgjeropj_onTimeNextAction {
    // 前进10秒
    self.viewModel.var_seekTime = self.dependnt + 10;
    if (!self.var_subtitleView.isHidden) {
        self.var_subtitleView.curIndex = 0;
        self.var_subtitleView.attributeStr = [[NSAttributedString alloc] initWithString:@""];
        [self.var_subtitleView ht_showSrtWithTime:self.viewModel.var_seekTime offset:self.timeOffset];
    }
    self.bottomView.timeLabel.text = [self.viewModel lgjeropj_convertTime:self.viewModel.var_seekTime];
    [self lgjeropj_seekToTimeToPlay:self.viewModel.var_seekTime];
}

- (void)lgjeropj_onPlayOrPause:(UIButton *)sender {
    if ( self.var_pState == ENUM_HTPlayerStateStopped || self.var_pState == ENUM_HTPlayerStateFailed ) {
        
        if ( self.var_pState == ENUM_HTPlayerStateStopped ) {
            if ( self.var_haveAds ) {
                [self lgjeropj_dismissAdverst];
            }
        }
        sender.selected = YES;
        [self ht_play];
        
    } else if ( self.var_pState == ENUM_HTPlayerStatePlaying ) {
        sender.selected = NO;
        [self ht_pause];
        
        if ( self.var_haveAds ) {
            [self lgjeropj_showAdverst];
        }
        
    } else if ( self.var_pState == ENUM_HTPlayerStateFinished ) {
        sender.selected = YES;
        self.charmerDetract.rate = self.viewModel.var_nowRate;
        [self lgjeropj_beverageState:ENUM_HTPlayerStatePlaying];
        [self.charmerDetract play];
        
        if ([self.delegate respondsToSelector:@selector(ht_player:andPlayerState:)]) {
            [self.delegate ht_player:self andPlayerState:self.var_pState];
        }
    }
    
}

- (void)lgjeropj_onFullScreen:(UIButton *)sender {
//    if (self.isFullscreen && self.lockBtn.isSelected) {
//        return;
//    }
    self.positivismBouncy = !self.positivismBouncy;
    if ( self.positivismBouncy ) {
        self.titleLabel.hidden = NO;
    } else {
        self.titleLabel.hidden = NO;
    }
    
    if ([self.delegate respondsToSelector:@selector(ht_player:andFScreen:)]) {
        [self.delegate ht_player:self andFScreen:self.positivismBouncy];
    }
}

- (void)lgjeropj_onEpisodes:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(ht_episodesPlayer:)]) {
        [self.delegate ht_episodesPlayer:self];
    }
}

- (void)ht_updateTimer {
    self.viewModel.var_isAnimation = YES;
    self.viewModel.var_isShowTop = NO;
    self.viewModel.var_isShowBottom = NO;
    [self setNeedsLayout];
}

- (void)lgjeropj_onValueChanged:(UISlider *)slider {
    self.viewModel.var_isDragingSlider = YES;
    
    [self lgjeropj_closeTimer];
}

- (void)lgjeropj_onTapSlider:(UISlider *)slider {
    self.viewModel.var_isDragingSlider = NO;
    [self lgjeropj_beverageState:ENUM_HTPlayerStateBuffering];
    self.viewModel.var_seekTime = slider.value;
    if (!self.var_subtitleView.isHidden) {
        self.var_subtitleView.curIndex = 0;
        self.var_subtitleView.attributeStr = [[NSAttributedString alloc] initWithString:@""];
        [self.var_subtitleView ht_showSrtWithTime:self.viewModel.var_seekTime offset:self.timeOffset];
    }
    self.bottomView.timeLabel.text = [self.viewModel lgjeropj_convertTime:self.viewModel.var_seekTime];
    [self lgjeropj_seekToTimeToPlay:self.viewModel.var_seekTime];
}

// 展示原生广告
- (void)lgjeropj_showAdverst {
    if ( self.positivismBouncy == NO ) {
        return;
    }
    [self addSubview:self.var_advertView];
    [self.var_advertView ht_showAd];
    self.var_advertView.bounds = CGRectMake(0, 0, 300, 250);
    
    @weakify(self);
    self.var_advertView.adStartBlock = ^(id data) {
        @strongify(self);
        if ( self.delegate && [self.delegate respondsToSelector:@selector(ht_removeAdsPlayer:)] ) {
            [self.delegate ht_removeAdsPlayer:self];
        }
    };
    
    self.var_advertView.cancelBlock = ^(id data) {
        @strongify(self);
        [self lgjeropj_dismissAdverst];
    };
}

- (void)lgjeropj_dismissAdverst {
    if (self.var_advertView && [self.var_advertView superview]) {
        [self.var_advertView removeFromSuperview];
    }
}

// 启动定时器
- (void)lgjeropj_startTimer {
    
    [self lgjeropj_closeTimer];
    
    self.var_playTimer = [NSTimer timerWithTimeInterval:5.0 target:self selector:@selector(ht_updateTimer) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:self.var_playTimer forMode:NSDefaultRunLoopMode];
}

// 关闭定时器
- (void)lgjeropj_closeTimer {
    [self.var_playTimer invalidate];
    self.var_playTimer = nil;
}


-(void)setCurrentItem:(AVPlayerItem *)playerItem {
    if ( _currentItem == playerItem ) {
        return;
    }
    
    if ( _currentItem ) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:_currentItem];
        [_currentItem removeObserver:self forKeyPath:AsciiString(@"status")];
        [_currentItem removeObserver:self forKeyPath:AsciiString(@"loadedTimeRanges")];
        [_currentItem removeObserver:self forKeyPath:AsciiString(@"playbackBufferEmpty")];
        [_currentItem removeObserver:self forKeyPath:AsciiString(@"playbackLikelyToKeepUp")];
        [_currentItem cancelPendingSeeks];
        [_currentItem.asset cancelLoading];
        _currentItem = nil;
    }
    
    _currentItem = playerItem;
    
    if ( _currentItem ) {
        [_currentItem addObserver:self
                           forKeyPath:AsciiString(@"status")
                              options:NSKeyValueObservingOptionNew
                              context:STATIC_HTPlayerStatusObservationContext];
        
        [_currentItem addObserver:self forKeyPath:AsciiString(@"loadedTimeRanges") options:NSKeyValueObservingOptionNew context:STATIC_HTPlayerStatusObservationContext];
        // 缓冲区空了，需要等待数据
        [_currentItem addObserver:self forKeyPath:AsciiString(@"playbackBufferEmpty") options: NSKeyValueObservingOptionNew context:STATIC_HTPlayerStatusObservationContext];
        // 缓冲区有足够数据可以播放了
        [_currentItem addObserver:self forKeyPath:AsciiString(@"playbackLikelyToKeepUp") options: NSKeyValueObservingOptionNew context:STATIC_HTPlayerStatusObservationContext];
        
        
        [self.charmerDetract replaceCurrentItemWithPlayerItem:_currentItem];
        // 添加视频播放结束通知
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(lgjeropj_moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:_currentItem];
    }
}

- (void)ht_creatPlayerAndReadyToPlay {
    //设置player的参数
    self.currentItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:self.var_playUrl]];
    self.charmerDetract = [AVPlayer playerWithPlayerItem:_currentItem];
    self.charmerDetract.usesExternalPlaybackWhileExternalScreenIsActive = YES;
    self.charmerDetract.automaticallyWaitsToMinimizeStalling = NO;
    self.charmerDetract.volume = 1.0;
    //AVPlayerLayer
    self.refllySummarise = [AVPlayerLayer playerLayerWithPlayer:self.charmerDetract];
    self.refllySummarise.frame = self.contentView.layer.bounds;
    //Player视频的默认填充模式，AVLayerVideoGravityResizeAspect
    self.refllySummarise.videoGravity = AVLayerVideoGravityResizeAspect;
    [self.contentView.layer insertSublayer:_refllySummarise atIndex:0];
    [self lgjeropj_beverageState:ENUM_HTPlayerStateBuffering];
}

- (void)lgjeropj_prophetessShotmak:(NSString *)var_playUrl {
    if ( _var_playUrl == var_playUrl ) {
        return;
    }
    _var_playUrl = var_playUrl;

    if ( self.viewModel.var_isInitPlayer ) {
        [self lgjeropj_beverageState:ENUM_HTPlayerStateBuffering];
        
        self.currentItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:_var_playUrl]];
        
        [self.charmerDetract replaceCurrentItemWithPlayerItem:self.currentItem];
    }else{
        [self lgjeropj_beverageState:ENUM_HTPlayerStateStopped];
        //here
        [self.loadingView stopAnimating];
    }
}

- (void)lgjeropj_crescendoAmiss:(NSString *)var_textPath {
    if ( _var_textPath == var_textPath ) {
        return;
    }
    _var_textPath = var_textPath;
    [[HTSubtitleManager ht_manager] ht_loadSrtFile:var_textPath];
}

- (void)lgjeropj_bureaucratTitle:(NSString *)var_playTitle {
    _var_playTitle = var_playTitle;
    self.titleLabel.text = var_playTitle;
}

// 设置播放的状态
// @param playerState ENUM_HTPlayerState
- (void)lgjeropj_beverageState:(ENUM_HTPlayerState)var_state {
    _var_pState = var_state;
    // 控制菊花显示、隐藏
    if ( var_state == ENUM_HTPlayerStateBuffering ) {
        [self.loadingView startAnimating];
        self.bottomView.playBtn.selected = NO;
        self.var_playMaxBtn.selected = NO;
    } else {
        [self.loadingView stopAnimating];
        self.bottomView.playBtn.selected = YES;
        self.var_playMaxBtn.selected = YES;
    }
}

- (void)lgjeropj_sorbetType:(BOOL)var_type {
    _var_isTType = var_type;
    self.bottomView.var_isTType = var_type;
}

- (BOOL)striationEmergence {
    return self.viewModel.var_isPlayBackground;
}

#pragma mark - 通知
/// 进入后台
- (void)lgjeropj_appDidEnterBackground:(NSNotification *)note
{
    if ( self.var_pState == ENUM_HTPlayerStatePlaying ) {
        self.viewModel.var_isPlayBackground = YES;
    } else {
        self.viewModel.var_isPlayBackground = NO;
    }
    //进入后台就暂停播放视频
    [self ht_pause];
    
    if ( self.delegate && [self.delegate respondsToSelector:@selector(ht_didEnterBackgroundPlayer:)] ) {
        [self.delegate ht_didEnterBackgroundPlayer:self];
    }
}

// 进入前台
- (void)lgjeropj_appWillEnterForeground:(NSNotification *)note
{
    if ( self.viewModel.var_isPlayBackground ) {
        [self ht_play];
    }
    
    if ( self.delegate && [self.delegate respondsToSelector:@selector(ht_willEnterForegroundPlayer:)] ) {
        [self.delegate ht_willEnterForegroundPlayer:self];
    }
}

/// 播放完成
- (void)lgjeropj_moviePlayDidEnd:(NSNotification *)notification {
    
    [self lgjeropj_beverageState:ENUM_HTPlayerStateFinished];
    self.bottomView.playBtn.selected = NO;
    self.var_playMaxBtn.selected = NO;
    
    if ( self.delegate && [self.delegate respondsToSelector:@selector(ht_player:andPlayerState:)]) {
        [self.delegate ht_player:self andPlayerState:self.var_pState];
    }
    
    self.viewModel.var_isAnimation = YES;
    self.viewModel.var_isShowTop = YES;
    self.viewModel.var_isShowBottom = YES;
    [self setNeedsLayout];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    // AVPlayerItem "status" observe
    if ( context == STATIC_HTPlayerStatusObservationContext )
    {
        if ([keyPath isEqualToString:AsciiString(@"status")]) {
            AVPlayerStatus status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
            switch ( status ) {
                case AVPlayerStatusUnknown:
                {
                    // 缓冲
                    [self lgjeropj_beverageState:ENUM_HTPlayerStateBuffering];
                    [self.loadingView startAnimating];
                    
                }
                    break;
                    
                case AVPlayerStatusReadyToPlay:
                {
                    // 播放
                    [self lgjeropj_beverageState:ENUM_HTPlayerStatePlaying];
                    if ( CMTimeGetSeconds(_currentItem.duration) ) {
                        
                        CGFloat totalTime = CMTimeGetSeconds(_currentItem.duration);
                        if ( !isnan(totalTime) ) {
                            self.bottomView.var_slider.maximumValue = totalTime;
                            self.var_videoLength = totalTime;
                        }
                    }
                    
                    [self.charmerDetract play];
                    
                    //监听播放状态
                    [self lgjeropj_initTimer];
                    
                    //5s dismiss bottomView
                    if ( self.var_playTimer == nil ) {
                        [self lgjeropj_startTimer];
                    }
                    
                    [self.loadingView stopAnimating];
                    
                    // 跳到xx秒播放视频
                    if ( self.viewModel.var_seekTime > 0 ) {
                        [self lgjeropj_seekToTimeToPlay:self.viewModel.var_seekTime];
                    }
                    
                }
                    break;
                    
                case AVPlayerStatusFailed:
                {
                    // 视频加载失败
                    [self lgjeropj_beverageState:ENUM_HTPlayerStateFailed];
                    
                    NSError *error = [self.charmerDetract.currentItem error];
                    if ( error ) {
                        
                        [self.loadingView stopAnimating];
                    }
                    NSLog(@"视频加载失败===%@",error.description);
                }
                    break;
            }
            if ( self.delegate && [self.delegate respondsToSelector:@selector(ht_player:andPlayerState:)] ) {
                [self.delegate ht_player:self andPlayerState:self.var_pState];
            }

        }else if ([keyPath isEqualToString:AsciiString(@"loadedTimeRanges")]) {
            
            // 计算缓冲进度
            NSTimeInterval timeInterval = [self lgjeropj_availableDuration];
            CMTime duration             = self.currentItem.duration;
            CGFloat totalDuration       = CMTimeGetSeconds(duration);
            //缓冲颜色
            //缓冲颜色
            self.bottomView.totalLabel.text = [self.viewModel lgjeropj_convertTime:totalDuration];
            self.bottomView.progressView.progressTintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
            [self.bottomView.progressView setProgress:timeInterval / totalDuration animated:NO];
            //NSLog(@"缓冲 %.3f",timeInterval / totalDuration);
        } else if ([keyPath isEqualToString:AsciiString(@"playbackBufferEmpty")]) {
            [self.loadingView startAnimating];
            // 当缓冲是空的时候
            if ( self.currentItem.playbackBufferEmpty ) {
                [self lgjeropj_beverageState:ENUM_HTPlayerStateBuffering];
                
                self.intrepidNum ++;
                
                if ( self.delegate && [self.delegate respondsToSelector:@selector(ht_player:andPlayerState:)] ) {
                    [self.delegate ht_player:self andPlayerState:self.var_pState];
                }
            }
            
        } else if ([keyPath isEqualToString:AsciiString(@"playbackLikelyToKeepUp")]) {
            
            // 当缓冲好的时候
            if ( self.currentItem.playbackLikelyToKeepUp && self.var_pState == ENUM_HTPlayerStateBuffering ){
                
                [self.loadingView stopAnimating];
                
                if ( self.bottomView.playBtn.isSelected ) {
                    
                    [self lgjeropj_startTimer];
                    
                    [self lgjeropj_beverageState:ENUM_HTPlayerStatePlaying];
                    
                    [self.charmerDetract play];
                } else {
                    [self lgjeropj_beverageState:ENUM_HTPlayerStateStopped];
                }
                
                if ( self.delegate && [self.delegate respondsToSelector:@selector(ht_player:andPlayerState:)] ) {
                    [self.delegate ht_player:self andPlayerState:self.var_pState];
                }
            }
        }
    }
}

// 计算缓冲进度
// @return 缓冲进度
- (NSTimeInterval)lgjeropj_availableDuration {
    NSArray *loadedTimeRanges = [_currentItem loadedTimeRanges];
    CMTimeRange timeRange     = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds        = CMTimeGetSeconds(timeRange.start);
    float durationSeconds     = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result     = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}

- (void)lgjeropj_initTimer {
    
    CMTime playerDuration = [self lgjeropj_playerItemDuration];
    if (CMTIME_IS_INVALID(playerDuration))return;
    
    __weak typeof(self) weakSelf = self;
    self.var_playbackTimeObserver = [weakSelf.charmerDetract addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(1.0, NSEC_PER_SEC) queue:dispatch_get_main_queue() usingBlock:^(CMTime time){
        [weakSelf lgjeropj_syncScrubber];
    }];
}

- (void)lgjeropj_syncScrubber {
    
    if ( _currentItem == nil ) {
        return;
    }
    
    if ( self.loadingView.isAnimating && self.var_pState == ENUM_HTPlayerStatePlaying ) {
        [self.loadingView stopAnimating];
    }
    
    float var_minValue = [self.bottomView.var_slider minimumValue];
    float var_maxValue = [self.bottomView.var_slider maximumValue];
    float var_nowTime = CMTimeGetSeconds(_currentItem.currentTime);
    if (!self.var_subtitleView.isHidden) {
        [self.var_subtitleView ht_showSrtWithTime:var_nowTime offset:self.timeOffset];
    }
    
    if ( self.delegate && [self.delegate respondsToSelector:@selector(ht_player:andSeeTime:)] ) {
        [self.delegate ht_player:self andSeeTime:var_nowTime];
    }
    
    self.bottomView.timeLabel.text = [self.viewModel lgjeropj_convertTime:var_nowTime];
    self.bottomView.totalLabel.text = [self.viewModel lgjeropj_convertTime:self.var_videoLength];
    if ( self.viewModel.var_isDragingSlider == YES ) {//拖拽slider中，不更新slider的值
        
    } else {
        if ( self.var_pState == ENUM_HTPlayerStatePlaying ) {
            [self lgjeropj_dismissAdverst];
            [self.bottomView.var_slider setValue:(var_maxValue - var_minValue) * var_nowTime / self.var_videoLength + var_minValue];
        }
    }
}

// 跳到time处播放
- (void)lgjeropj_seekToTimeToPlay:(double)time {
    if ( self.charmerDetract && self.charmerDetract.currentItem.status == AVPlayerItemStatusReadyToPlay ) {
        if ( time >= self.var_videoLength ) {
            time = 0.0;
        }
        if ( time < 0 ) {
            time=0.0;
        }
        
        @weakify(self);
        //currentItem.asset.duration.timescale计算的时候严重堵塞主线程，慎用
        CMTime MT = CMTimeMakeWithSeconds(time, _currentItem.currentTime.timescale);
        [self.charmerDetract seekToTime:MT toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
            @strongify(self);
            if ( finished ) {
                self.viewModel.var_seekTime = 0;
                [self.charmerDetract.currentItem cancelPendingSeeks];
                if ( self.bottomView.playBtn.isSelected ) {
                    if ( self.var_haveAds ) {
                        [self lgjeropj_dismissAdverst];
                    }
                }
            }
        }];
    }
}

- (CMTime)lgjeropj_playerItemDuration{
    AVPlayerItem *playerItem = _currentItem;
    if (playerItem.status == AVPlayerItemStatusReadyToPlay){
        return([playerItem duration]);
    }
    return(kCMTimeInvalid);
}

- (HTAdvertisementView *)var_advertView {
    
    if ( _var_advertView == nil ) {
        _var_advertView = [[HTAdvertisementView alloc] initWithCancel:YES];
    }
    return _var_advertView;
}

- (HTAdvertBannerView *)var_bannerView {
    
    if ( _var_bannerView == nil ) {
        _var_bannerView = [[HTAdvertBannerView alloc] init];
        _var_bannerView.backgroundColor = [UIColor clearColor];
    }
    return _var_bannerView;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self ht_touchBeganAndEvent];
}
- (void)ht_touchBeganAndEvent {
    if ( self.positivismBouncy && self.var_lockBtn.isSelected ) {
        
        CGFloat adOffsetX = self.positivismBouncy ? (44-10):0;
        CGRect lockFrame = CGRectMake(16+adOffsetX, CGRectGetHeight(self.bounds)/2 - 12, 24, 24);
        if ( CGRectEqualToRect(self.var_lockBtn.frame, lockFrame) == NO ) {
            [self lgjeropj_startTimer];
            [UIView animateWithDuration:0.2 animations:^{
                self.var_lockBtn.frame = CGRectMake(16+adOffsetX, CGRectGetHeight(self.bounds)/2 - 12, 24, 24);
            }];
        }
        
        return;
    }
    self.viewModel.var_isAnimation = YES;
    self.viewModel.var_isShowTop = !self.viewModel.var_isShowTop;
    self.viewModel.var_isShowBottom = !self.viewModel.var_isShowBottom;
    [self setNeedsLayout];
    
    if ( self.viewModel.var_isShowTop ) {
        [self lgjeropj_startTimer];
    }
}
- (CGRect)ht_shareBtnFrame {
    return self.var_shareBtn.frame;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.contentView.frame = self.bounds;
    self.coverImageView.frame = self.bounds;
    
    self.refllySummarise.frame = self.contentView.layer.bounds;
    
    self.var_lockBtn.hidden = !self.positivismBouncy;
    self.var_timeLastBtn.hidden = !self.positivismBouncy;
    self.var_timeNextBtn.hidden = !self.positivismBouncy;
    
    if ( self.var_haveAds ) {
        self.var_advertView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        if ( self.positivismBouncy ) {
            self.var_bannerView.frame = CGRectMake(CGRectGetMidX(self.bounds)-160, 0, 320, 50);
        }
    }
    self.var_adBtn.hidden = !self.var_haveAds;

    CGFloat adH = (CGRectGetHeight(self.bounds) - 24)*82/(82+114);
    if ( self.positivismBouncy ) {
        adH = (CGRectGetHeight(self.bounds) - 24*2 - 12)/2 + 24 + 12;
    }
    
    CGFloat bottomH = self.positivismBouncy ? 88:44;
    CGFloat adOffsetX = self.positivismBouncy ? (44-10):0;
    
    if ( self.viewModel.var_isAnimation ) {
        
        [UIView animateWithDuration:0.2 animations:^{
            if ( self.viewModel.var_isShowTop ) {
                self.var_cancelBtn.frame = CGRectMake(10, 7, 30, 30);
                self.topView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), 44);
            } else {
                self.topView.frame = CGRectMake(0, -44, CGRectGetWidth(self.bounds), 44);
                if ( self.positivismBouncy ) {
                    self.var_cancelBtn.frame = CGRectMake(10, -44, 30, 30);
                } else {
                    self.var_cancelBtn.frame = CGRectMake(10, 7, 30, 30);
                }
            }
            if ( self.viewModel.var_isShowBottom ) {
                self.bottomView.frame = CGRectMake(0, CGRectGetHeight(self.bounds) - bottomH, CGRectGetWidth(self.bounds), bottomH);
                self.var_adBtn.frame = CGRectMake(16+adOffsetX, adH, 24, 24);
                self.var_lockBtn.frame = CGRectMake(16+adOffsetX, adH - 24 - 12, 24, 24);
                
                self.var_middleView.frame = CGRectMake(CGRectGetMidX(self.bounds) - 80, CGRectGetMidY(self.bounds) - 22, 160, 44);
            } else {
                self.bottomView.frame = CGRectMake(0, CGRectGetHeight(self.bounds), CGRectGetWidth(self.bounds), bottomH);
                self.var_adBtn.frame = CGRectMake(-25, adH, 24, 24);
                
                if ( self.var_lockBtn.isSelected ) {
                    self.var_lockBtn.frame = CGRectMake(-25, CGRectGetHeight(self.bounds)/2 - 12, 24, 24);
                } else {
                    self.var_lockBtn.frame = CGRectMake(-25, adH - 24 - 12, 24, 24);
                }
                
                self.var_middleView.frame = CGRectMake(CGRectGetMidX(self.bounds) - 80, CGRectGetMaxY(self.bounds), 160, 44);
            }
            self.bottomView.isFScreen = self.positivismBouncy;
        }];
        
    } else {
        
        if ( self.viewModel.var_isShowTop ) {
            self.var_cancelBtn.frame = CGRectMake(10, 7, 30, 30);
            self.topView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), 44);
        } else {
            self.topView.frame = CGRectMake(0, -44, CGRectGetWidth(self.bounds), 44);
            if ( self.positivismBouncy ) {
                self.var_cancelBtn.frame = CGRectMake(10, -44, 30, 30);
            } else {
                self.var_cancelBtn.frame = CGRectMake(10, 7, 30, 30);
            }
        }
        
        if ( self.viewModel.var_isShowBottom ) {
            self.bottomView.frame = CGRectMake(0, CGRectGetHeight(self.bounds) - bottomH, CGRectGetWidth(self.bounds), bottomH);
            self.var_adBtn.frame = CGRectMake(16+adOffsetX, adH, 24, 24);
            self.var_lockBtn.frame = CGRectMake(16+adOffsetX, adH - 24 - 12, 24, 24);
            
            self.var_middleView.frame = CGRectMake(CGRectGetMidX(self.bounds) - 80, CGRectGetMidY(self.bounds) - 22, 160, 44);
        } else {
            self.bottomView.frame = CGRectMake(0, CGRectGetHeight(self.bounds), CGRectGetWidth(self.bounds), bottomH);
            self.var_adBtn.frame = CGRectMake(-25, adH, 24, 24);
            self.var_lockBtn.frame = CGRectMake(-25, adH - 24 - 12, 24, 24);
            if ( self.var_lockBtn.isSelected ) {
                self.var_lockBtn.frame = CGRectMake(-25, CGRectGetHeight(self.bounds)/2 - 12, 24, 24);
            } else {
                self.var_lockBtn.frame = CGRectMake(-25, adH - 24 - 12, 24, 24);
            }
            self.var_middleView.frame = CGRectMake(CGRectGetMidX(self.bounds) - 80, CGRectGetMaxY(self.bounds), 160, 44);
        }
        self.bottomView.isFScreen = self.positivismBouncy;
    }
    
    self.var_subtitleView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetHeight(self.bounds) - CGRectGetHeight(self.var_subtitleView.bounds) - 10);
    
    [self ht_resetTopButtonsFrame:!self.var_subtitlesBtn.isHidden];
    
    self.var_playMaxBtn.frame = CGRectMake(CGRectGetMidX(self.var_middleView.bounds) - 19,CGRectGetMidY(self.var_middleView.bounds) - 19, 38, 38);
    self.var_timeLastBtn.frame = CGRectMake(8, CGRectGetMidY(self.var_middleView.bounds) - 19, 38, 38);
    self.var_timeNextBtn.frame = CGRectMake(CGRectGetMaxX(self.var_middleView.bounds) - 8 - 38, CGRectGetMidY(self.var_middleView.bounds) - 19, 38, 38);
    
    self.loadingView.frame = self.contentView.bounds;
}

@end

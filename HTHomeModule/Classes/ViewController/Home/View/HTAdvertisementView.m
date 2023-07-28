//
//  HTAdvertisementView.m
//  Hucolla
//
//  Created by mac on 2022/9/13.
//

#import "HTAdvertisementView.h"
#import <AppLovinSDK/AppLovinSDK.h>
#import "HTAdvertisementManager.h"

@interface HTAdvertisementView()<MAAdViewAdDelegate>

@property (nonatomic, strong) MAAdView         * var_topAdView;
@property (nonatomic, strong) UIImageView      * var_bottomImageView;
@property (nonatomic, strong) UIButton         * var_cancelBtn;
@property (nonatomic, strong) UIButton         * var_clearBtn;
@property (nonatomic, strong) UIButton         * var_vipBtn;

@end

@implementation HTAdvertisementView

- (instancetype)initWithCancel:(BOOL)var_isShowCancel {
    self = [super init];
    if ( self ) {
        self.var_isShowCancel = var_isShowCancel;
        [self ht_addViewSubViews];
    }
    return self;
}

- (void)ht_addViewSubViews {
    self.backgroundColor = [UIColor colorWithHexString:@"#8F8F8F"];
    self.clipsToBounds = YES;
    
    self.var_bottomImageView = [HTAdvertisementManager lgjeropj_bottomView];
    [self addSubview:self.var_bottomImageView];
    [self.var_bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    self.var_cancelBtn = [HTAdvertisementManager lgjeropj_cancelButton:self action:@selector(lgjeropj_onCancelAds)];
    [self.var_bottomImageView addSubview:self.var_cancelBtn];
    
    self.var_vipBtn = [HTAdvertisementManager lgjeropj_vipButton:self action:@selector(lgjeropj_onShouldVip)];
    [self.var_bottomImageView addSubview:self.var_vipBtn];
    
    CGFloat var_scale = 250/150.0;
    [self.var_vipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.var_bottomImageView).inset(15);
        make.height.equalTo(@(34 * var_scale));
        make.top.equalTo(self.var_bottomImageView).offset(29 * var_scale);
    }];
    
    [self.var_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.var_bottomImageView).inset(15);
        make.height.equalTo(@(34 * var_scale));
        make.bottom.equalTo(self.var_bottomImageView).offset(-29 * var_scale);
    }];
    
    self.var_topAdView = [HTAdvertisementManager lgjeropj_adView:self];
    [self addSubview:self.var_topAdView];
    [self.var_topAdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    self.var_clearBtn = [HTAdvertisementManager lgjeropj_clearButton:self action:@selector(lgjeropj_onClearAction)];
    [self addSubview:self.var_clearBtn];
    [self.var_clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@30);
        make.bottom.right.equalTo(self).offset(-3);
    }];
    
    [self.var_topAdView loadAd];
}

- (void)lgjeropj_onClearAction {
    self.var_clearBtn.hidden = YES;
    [self.var_topAdView removeFromSuperview];
}

- (void)lgjeropj_onCancelAds {
    if ( self.cancelBlock ) {
        self.cancelBlock(nil);
    }
}

- (void)lgjeropj_onShouldVip {
    if ( self.adStartBlock ) {
        self.adStartBlock(nil);
    }
}

- (void)ht_showAd {
    if (self.var_isShowCancel) {
        self.hidden = YES;
        [self.var_topAdView loadAd];
    }
    self.var_clearBtn.hidden = NO;
    [self addSubview:self.var_topAdView];
    [self bringSubviewToFront:self.var_clearBtn];
    [self.var_topAdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

#pragma mark - MAAdViewAdDelegate Protocol
- (void)didLoadAd:(MAAd *)ad {
    //[self.topAdView startAutoRefresh];
    if (self.var_isShowCancel) {
        self.var_isShowCancel = NO;
        self.hidden = NO;
    }
}

- (void)didFailToLoadAdForAdUnitIdentifier:(NSString *)adUnitIdentifier withError:(MAError *)error {}

- (void)didClickAd:(MAAd *)ad {}

- (void)didFailToDisplayAd:(MAAd *)ad withError:(MAError *)error {}

- (void)didDisplayAd:(nonnull MAAd *)ad {}

- (void)didHideAd:(nonnull MAAd *)ad {}

- (void)didExpandAd:(MAAd *)ad {}

- (void)didCollapseAd:(MAAd *)ad {}

@end

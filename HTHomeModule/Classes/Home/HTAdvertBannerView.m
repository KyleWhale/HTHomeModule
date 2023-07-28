//
//  HTAdvertBannerView.m
//  Hucolla
//
//  Created by mac on 2022/9/27.
//

#import "HTAdvertBannerView.h"
#import <AppLovinSDK/AppLovinSDK.h>
#import "HTAdvertBannerManager.h"

@interface HTAdvertBannerView()<MAAdViewAdDelegate>

@property (nonatomic, strong) MAAdView         * var_bannerView;
@property (nonatomic, strong) UIButton         * var_clearBtn;

@end

@implementation HTAdvertBannerView

- (void)ht_addViewSubViews {
    
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = YES;
    
    self.var_bannerView = [HTAdvertBannerManager lgjeropj_bannerView:self];
    [self addSubview:self.var_bannerView];
    [self.var_bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.var_bannerView loadAd];
}

- (void)lgjeropj_onClearAction {
    if ( self.cancelBlock ) {
        self.cancelBlock(nil);
    }
}


#pragma mark - MAAdViewAdDelegate Protocol
- (void)didLoadAd:(MAAd *)ad {
    self.var_isLoaded = YES;
    if (self.var_didLoadBlock) {
        self.var_didLoadBlock();
    }
}

- (void)didFailToLoadAdForAdUnitIdentifier:(NSString *)adUnitIdentifier withError:(MAError *)error {
    self.var_isLoaded = NO;
}

- (void)didClickAd:(MAAd *)ad {}

- (void)didFailToDisplayAd:(MAAd *)ad withError:(MAError *)error {}

- (void)didDisplayAd:(nonnull MAAd *)ad {}

- (void)didHideAd:(nonnull MAAd *)ad {}

- (void)didExpandAd:(MAAd *)ad {}

- (void)didCollapseAd:(MAAd *)ad {}

@end

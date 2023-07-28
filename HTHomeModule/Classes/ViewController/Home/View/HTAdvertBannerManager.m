//
//  HTAdvertBannerManager.m
//  Moshfocus
//
//  Created by 李雪健 on 2023/6/7.
//

#import "HTAdvertBannerManager.h"

@implementation HTAdvertBannerManager

+ (MAAdView *)lgjeropj_bannerView:(id)target {
    
    NSDictionary *applovinDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"udf_applovin"];
    if ([HTCommonConfiguration lgjeropj_shared].BLOCK_appLovinSDKBlock() && applovinDict.count > 0) {
        NSString *var_banner = applovinDict[@"banner"];
        MAAdView *view = [[MAAdView alloc] initWithAdUnitIdentifier:var_banner sdk:[HTCommonConfiguration lgjeropj_shared].BLOCK_appLovinSDKBlock()];
        view.delegate = target;
        view.bounds = CGRectMake(0, 0, 320, 50);
        NSString *massage = AsciiString(@"allow_pause_auto_refresh_immediately");
        [view setExtraParameterForKey: massage value: @"true"];
        [view stopAutoRefresh];
        view.backgroundColor = [UIColor clearColor];
        return view;
    }
    return nil;
}

+ (UIButton *)lgjeropj_clearButton:(id)target action:(SEL)action {
    
    UIButton *view = [HTKitCreate ht_buttonWithImage:[UIImage imageNamed:@"icon_wdfork_white"] andSelectImage:nil];
    view.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    view.cornerRadius = 12;
    view.hidden = YES;
    [view addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return view;
}

@end

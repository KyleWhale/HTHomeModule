//
//  HTAdvertisementManager.m
//  Moshfocus
//
//  Created by 李雪健 on 2023/6/7.
//

#import "HTAdvertisementManager.h"

@implementation HTAdvertisementManager

+ (UIImageView *)lgjeropj_bottomView {
    
    UIImageView *view = [[UIImageView alloc] init];
    view.userInteractionEnabled = YES;
    view.backgroundColor = [UIColor colorWithHexString:@"#8F8F8F"];
    return view;
}

+ (UIButton *)lgjeropj_cancelButton:(id)target action:(SEL)action {
    
    UIButton *view = [HTKitCreate ht_buttonWithImage:nil andTitle:LocalString(@"Cancel", nil) andFont:HTPingFangRegularFont(12) andTextColor:[UIColor colorWithHexString:@"#222222"] andState:UIControlStateNormal];
    view.cornerRadius = 4;
    view.backgroundColor = [UIColor colorWithHexString:@"#CCCCCC"];
    [view addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return view;
}

+ (UIButton *)lgjeropj_vipButton:(id)target action:(SEL)action {
    
    UIButton *view = [HTKitCreate ht_buttonWithImage:nil andTitle:LocalString(@"Get Premium to remove all ads", nil) andFont:HTPingFangRegularFont(12) andTextColor:[UIColor colorWithHexString:@"#222222"] andState:UIControlStateNormal];
    view.cornerRadius = 4;
    view.backgroundColor = [UIColor colorWithHexString:@"#CCCCCC"];
    [view addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return view;
}

+ (MAAdView *)lgjeropj_adView:(id)target {
    
    NSDictionary *applovinDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"udf_applovin"];
    if (applovinDict.count > 0 && [HTCommonConfiguration lgjeropj_shared].BLOCK_appLovinSDKBlock()) {
        NSString *var_mrec = applovinDict[@"mrec"];
        MAAdView *view = [[MAAdView alloc] initWithAdUnitIdentifier:var_mrec sdk:[HTCommonConfiguration lgjeropj_shared].BLOCK_appLovinSDKBlock()];
        view.delegate = target;
        view.bounds = CGRectMake(0, 0, 300, 250);
        // Set this extra parameter to work around SDK bug that ignores calls to stopAutoRefresh()
        [view setExtraParameterForKey: AsciiString(@"allow_pause_auto_refresh_immediately") value: @"true"];
        [view stopAutoRefresh];
        view.backgroundColor = [UIColor colorWithHexString:@"#8F8F8F"];
        return view;
    }
    return nil;
}

+ (UIButton *)lgjeropj_clearButton:(id)target action:(SEL)action {
    
    UIButton *view = [HTKitCreate ht_buttonWithImage:[UIImage imageNamed:@"icon_wdfork_white"] andSelectImage:nil];
    view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    view.cornerRadius = 15;
    [view addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return view;
}

@end

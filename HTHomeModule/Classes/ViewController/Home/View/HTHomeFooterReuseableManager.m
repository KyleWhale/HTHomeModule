//
//  HTHomeFooterReuseableManager.m
//  Moshfocus
//
//  Created by 李雪健 on 2023/6/7.
//

#import "HTHomeFooterReuseableManager.h"

@implementation HTHomeFooterReuseableManager

+ (UIButton *)lgjeropj_moreButton {
    
    UIButton *view = [HTKitCreate ht_buttonWithImage:[UIImage imageNamed:@"icon_wdmore_down"] andTitle:@"More" andFont:[UIFont systemFontOfSize:12 weight:(UIFontWeightRegular)] andTextColor:[UIColor whiteColor] andState:UIControlStateNormal];
    view.cornerRadius = 6;
    [view setPosition:3 interval:3];
    view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2];
    return view;
}

+ (UIButton *)lgjeropj_loadButton {
    
    UIButton *view = [HTKitCreate ht_buttonWithImage:[UIImage imageNamed:@"icon_wdVector"] andTitle:LocalString(@"Loading", nil) andFont:[UIFont systemFontOfSize:12 weight:(UIFontWeightRegular)] andTextColor:[UIColor whiteColor] andState:UIControlStateNormal];
    view.hidden = YES;
    view.cornerRadius = 6;
    [view setPosition:3 interval:3];
    view.backgroundColor = [UIColor colorWithHexString:@"#4F4F5A"];
    return view;
}

+ (UIButton *)lgjeropj_allButton {
    
    UIButton *view = [HTKitCreate ht_buttonWithImage:[UIImage imageNamed:@"icon_wdsee_all"] andTitle:LocalString(@"See all", nil) andFont:[UIFont systemFontOfSize:12 weight:(UIFontWeightRegular)] andTextColor:[UIColor whiteColor] andState:UIControlStateNormal];
    view.cornerRadius = 6;
    [view setPosition:3 interval:3];
    view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2];
    return view;
}

@end

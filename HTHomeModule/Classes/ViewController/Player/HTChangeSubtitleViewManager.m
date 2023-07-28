//
//  HTChangeSubtitleViewManager.m
//  Moshfocus
//
//  Created by 李雪健 on 2023/6/8.
//

#import "HTChangeSubtitleViewManager.h"

@implementation HTChangeSubtitleViewManager

+ (UIView *)lgjeropj_contentView {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 360, kScreenHeight)];
    view.clipsToBounds = YES;
    return view;
}

+ (UIImageView *)lgjeropj_backgroundView {
    
    UIImageView *view = [[UIImageView alloc] init];
    [view sd_setImageWithURL:[LKFPrivateFunction lgjeropj_imageUrlFromNumber:110]];
    view.hidden = YES;
    return view;
}

+ (HTSubtitleMainView *)lgjeropj_mainView {
    
    HTSubtitleMainView *view = [[HTSubtitleMainView alloc] init];
    return view;
}

+ (HTSubtitleSettingView *)lgjeropj_settingView {
    
    HTSubtitleSettingView *view = [[HTSubtitleSettingView alloc] init];
    view.title = LocalString(@"Adjust subtitle time", nil);
    return view;
}

+ (HTSubtitleLanguageView *)lgjeropj_languageView {
    
    HTSubtitleLanguageView *view = [[HTSubtitleLanguageView alloc] init];
    view.title = LocalString(@"Switch language", nil);
    return view;
}

@end

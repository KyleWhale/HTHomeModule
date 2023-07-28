//
//  HTChangeSubtitleViewManager.h
//  Moshfocus
//
//  Created by 李雪健 on 2023/6/8.
//

#import <Foundation/Foundation.h>
#import "HTSubtitleMainView.h"
#import "HTSubtitleSettingView.h"
#import "HTSubtitleLanguageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HTChangeSubtitleViewManager : NSObject

+ (UIView *)lgjeropj_contentView;

+ (UIImageView *)lgjeropj_backgroundView;

+ (HTSubtitleMainView *)lgjeropj_mainView;

+ (HTSubtitleSettingView *)lgjeropj_settingView;

+ (HTSubtitleLanguageView *)lgjeropj_languageView;

@end

NS_ASSUME_NONNULL_END

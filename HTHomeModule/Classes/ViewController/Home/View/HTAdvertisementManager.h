//
//  HTAdvertisementManager.h
//  Moshfocus
//
//  Created by 李雪健 on 2023/6/7.
//

#import <Foundation/Foundation.h>
#import <AppLovinSDK/AppLovinSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface HTAdvertisementManager : NSObject

+ (UIImageView *)lgjeropj_bottomView;

+ (UIButton *)lgjeropj_cancelButton:(id)target action:(SEL)action;

+ (UIButton *)lgjeropj_vipButton:(id)target action:(SEL)action;

+ (MAAdView * _Nullable)lgjeropj_adView:(id __nullable)target;

+ (UIButton *)lgjeropj_clearButton:(id)target action:(SEL)action;

@end

NS_ASSUME_NONNULL_END

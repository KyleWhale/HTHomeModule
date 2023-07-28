//
//  HTTVPlayViewCellManager.h
//  Moshfocus
//
//  Created by 李雪健 on 2023/6/7.
//

#import <Foundation/Foundation.h>
#import "HTStarLevelView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HTTVPlayViewCellManager : NSObject

+ (UILabel *)lgjeropj_titleLabel;

+ (HTStarLevelView *)lgjeropj_starView;

+ (UILabel *)lgjeropj_levelLabel;

+ (UILabel *)lgjeropj_countryLabel;

+ (UILabel *)lgjeropj_tagsLabel;

+ (UILabel *)lgjeropj_starsLabel;

+ (UILabel *)lgjeropj_infoLabel;

+ (UIButton *)lgjeropj_seasonButton:(id)target action:(SEL)action;

@end

NS_ASSUME_NONNULL_END

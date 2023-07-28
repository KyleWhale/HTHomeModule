//
//  HTTVPlayViewCellManager.m
//  Moshfocus
//
//  Created by 李雪健 on 2023/6/7.
//

#import "HTTVPlayViewCellManager.h"

@implementation HTTVPlayViewCellManager

+ (UILabel *)lgjeropj_titleLabel {
    
    return [HTKitCreate ht_labelWithText:@"" andFont:[UIFont systemFontOfSize:18 weight:(UIFontWeightSemibold)] andTextColor:[UIColor whiteColor] andAligment:NSTextAlignmentLeft andNumberOfLines:0];
}

+ (HTStarLevelView *)lgjeropj_starView {
    
    HTStarLevelView *view = [HTStarLevelView ht_starLevelView];
    [view lgjeropj_spacing:4.0/18];
    return view;
}

+ (UILabel *)lgjeropj_levelLabel {
    
    return [HTKitCreate ht_labelWithText:@"0.0" andFont:HTPingFangRegularFont(14) andTextColor:[UIColor colorWithHexString:@"#FFCC48"] andAligment:NSTextAlignmentLeft andNumberOfLines:1];
}

+ (UILabel *)lgjeropj_countryLabel {
    
    return [HTKitCreate ht_labelWithText:@"country" andFont:HTPingFangRegularFont(14) andTextColor:[UIColor whiteColor] andAligment:NSTextAlignmentLeft andNumberOfLines:1];
}

+ (UILabel *)lgjeropj_tagsLabel {
    
    return [HTKitCreate ht_labelWithText:@"tags" andFont:HTPingFangRegularFont(14) andTextColor:[UIColor colorWithHexString:@"#999999"] andAligment:NSTextAlignmentLeft andNumberOfLines:0];
}

+ (UILabel *)lgjeropj_starsLabel {
    
    return [HTKitCreate ht_labelWithText:AsciiString(@"stars") andFont:HTPingFangRegularFont(14) andTextColor:[UIColor colorWithHexString:@"#999999"] andAligment:NSTextAlignmentLeft andNumberOfLines:0];
}

+ (UILabel *)lgjeropj_infoLabel {
    
    return [HTKitCreate ht_labelWithText:LocalString(@"Episodes", nil) andFont:[UIFont systemFontOfSize:16 weight:(UIFontWeightMedium)] andTextColor:[UIColor whiteColor] andAligment:NSTextAlignmentLeft andNumberOfLines:1];
}

+ (UIButton *)lgjeropj_seasonButton:(id)target action:(SEL)action {
    
    UIButton *view = [HTKitCreate ht_buttonWithImage:nil andTitle:@"" andFont:HTPingFangRegularFont(14) andTextColor:[UIColor whiteColor] andState:UIControlStateNormal];
    view.cornerRadius = 3;
    [view addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    view.backgroundColor = [UIColor colorWithHexString:@"#434360"];
    [view sd_setImageWithURL:[LKFPrivateFunction lgjeropj_imageUrlFromNumber:178] forState:UIControlStateNormal completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        [view setPosition:3 interval:2];
    }];
    return view;
}

@end

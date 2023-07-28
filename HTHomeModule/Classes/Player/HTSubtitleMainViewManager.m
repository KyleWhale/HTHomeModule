//
//  HTSubtitleMainViewManager.m
//  Moshfocus
//
//  Created by 李雪健 on 2023/6/8.
//

#import "HTSubtitleMainViewManager.h"

@implementation HTSubtitleMainViewManager

+ (UILabel *)lgjeropj_subtitleLab {
    
    UILabel *view = [[UILabel alloc] init];
    view.textColor = [UIColor whiteColor];
    view.font = HTPingFangFont(18);
    view.text = LocalString(@"Subtitles", nil);
    return view;
}

+ (UIView *)lgjeropj_line {
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
    return view;
}

+ (UISwitch *)lgjeropj_subtitleSwitch {
    
    UISwitch *view = [[UISwitch alloc] init];
    view.on = YES;
    view.onTintColor = [UIColor colorWithHexString:@"#37D850"];
    view.thumbTintColor = [UIColor colorWithHexString:@"#ffffff"];
    CGAffineTransform transform = CGAffineTransformMakeScale(20.0/31, 20.0/31);
    view.transform = CGAffineTransformTranslate(transform, -9, -5.5);
    return view;
}

+ (UIButton *)lgjeropj_settingBtn {
    
    UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
    [view sd_setImageWithURL:[LKFPrivateFunction lgjeropj_imageUrlFromNumber:211] forState:UIControlStateNormal];
    view.titleLabel.font = [UIFont systemFontOfSize:14 weight:(UIFontWeightSemibold)];
    [view setTitle:LocalString(@"Adjust subtitle time", nil) forState:UIControlStateNormal];
    [view setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [view setPosition:1 interval:12];
    view.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    return view;
}

+ (UIButton *)lgjeropj_languageBtn {
    
    UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
    [view sd_setImageWithURL:[LKFPrivateFunction lgjeropj_imageUrlFromNumber:173] forState:UIControlStateNormal];
    [view setTitle:LocalString(@"Switch language", nil) forState:UIControlStateNormal];
    view.titleLabel.font = [UIFont systemFontOfSize:14 weight:(UIFontWeightSemibold)];
    [view setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [view setPosition:1 interval:12];
    view.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    return view;
}

@end

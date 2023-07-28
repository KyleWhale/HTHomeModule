//
//  HTHistoryCellManager.m
//  Moshfocus
//
//  Created by 李雪健 on 2023/6/7.
//

#import "HTHistoryCellManager.h"

@implementation HTHistoryCellManager

+ (UIView *)lgjeropj_conView {
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithHexString:@"#313143"];
    view.cornerRadius = 6;
    return view;
}

+ (UIImageView *)lgjeropj_imageView {
    
    UIImageView *view = [[UIImageView alloc] init];
    view.backgroundColor = [UIColor colorWithHexString:@"#3B3B3B"];
    return view;
}

+ (UIImageView *)lgjeropj_playImageView {
    
    UIImageView *view = [[UIImageView alloc] init];
    [view sd_setImageWithURL:[LKFPrivateFunction lgjeropj_imageUrlFromNumber:268]];
    return view;
}

+ (UILabel *)lgjeropj_titleLabel {
    
    return [HTKitCreate ht_labelWithText:nil andFont:[UIFont systemFontOfSize:14 weight:(UIFontWeightRegular)] andTextColor:[UIColor whiteColor] andAligment:NSTextAlignmentLeft andNumberOfLines:1];
}

+ (UILabel *)lgjeropj_watchLabel {
    
    return [HTKitCreate ht_labelWithText:LocalString(@"Watched", nil) andFont:[UIFont systemFontOfSize:12 weight:(UIFontWeightRegular)] andTextColor:[UIColor colorWithHexString:@"#FFFFFF"] andAligment:NSTextAlignmentLeft andNumberOfLines:1];
}

+ (UILabel *)lgjeropj_watchedLabel {
    
    return [HTKitCreate ht_labelWithText:@"" andFont:[UIFont systemFontOfSize:12 weight:(UIFontWeightRegular)] andTextColor:[UIColor colorWithHexString:@"#3CDEF4"] andAligment:NSTextAlignmentLeft andNumberOfLines:1];
}

+ (UIButton *)lgjeropj_selectButton:(id)target action:(SEL)action {
    
    UIButton *view = [HTKitCreate ht_buttonWithImage:[LKFPrivateFunction lgjeropj_imageUrlFromNumber:82] andSelectImage:[LKFPrivateFunction lgjeropj_imageUrlFromNumber:81]];
    view.hidden = YES;
    [view addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return view;
}

@end

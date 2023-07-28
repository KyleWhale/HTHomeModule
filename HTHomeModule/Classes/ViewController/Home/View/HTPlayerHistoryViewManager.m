//
//  HTPlayerHistoryViewManager.m
//  Moshfocus
//
//  Created by 李雪健 on 2023/6/7.
//

#import "HTPlayerHistoryViewManager.h"

@implementation HTPlayerHistoryViewManager

+ (UIImageView *)lgjeropj_backgroundView {
    
    UIImageView *view = [[UIImageView alloc] init];
    [view sd_setImageWithURL:[LKFPrivateFunction lgjeropj_imageUrlFromNumber:63]];
    return view;
}

+ (UILabel *)lgjeropj_nameLabel {
    
    return [HTKitCreate ht_labelWithText:@"" andFont:HTPingFangFont(14) andTextColor:[UIColor whiteColor] andAligment:NSTextAlignmentLeft andNumberOfLines:1];
}

+ (UIButton *)lgjeropj_playButton:(id)target action:(SEL)action {
    
    UIButton *view = [HTKitCreate ht_buttonWithImage:[LKFPrivateFunction lgjeropj_imageUrlFromNumber:40] andSelectImage:nil];
    [view addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return view;
}

+ (UIButton *)lgjeropj_deleteButton:(id)target action:(SEL)action {
    
    UIButton *view = [HTKitCreate ht_buttonWithImage:[UIImage imageNamed:@"icon_wdfork_white"] andSelectImage:nil];
    [view addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return view;
}

@end

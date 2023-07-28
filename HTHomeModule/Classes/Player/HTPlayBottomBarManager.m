//
//  HTPlayBottomBarManager.m
//  Moshfocus
//
//  Created by 李雪健 on 2023/6/8.
//

#import "HTPlayBottomBarManager.h"

@implementation HTPlayBottomBarManager

+ (UIProgressView *)lgjeropj_progress {

    UIProgressView *view = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    view.progressTintColor = [UIColor clearColor];
    view.trackTintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
    [view setProgress:0.0 animated:NO];
    return view;
}

+ (UISlider *)lgjeropj_slider {
    
    UISlider *view = [[UISlider alloc] init];
    view.minimumValue = 0.0;
    view.maximumValue = 1.0;
    view.minimumTrackTintColor = [UIColor colorWithHexString:@"#3CDEF4"];
    view.thumbTintColor = [UIColor colorWithHexString:@"#3CDEF4"];
    view.maximumTrackTintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    [view setThumbImage:[UIImage imageNamed:@"icon_wdslider"] forState:UIControlStateNormal];
    return view;
}

+ (UILabel *)lgjeropj_timeLabel {
    
    UILabel *view = [[UILabel alloc] init];
    view.text = AsciiString(@"0:00:00");
    view.adjustsFontSizeToFitWidth = YES;
    view.textAlignment = NSTextAlignmentRight;
    view.font = HTPingFangRegularFont(12);
    view.textColor = [UIColor whiteColor];
    return view;
}

+ (UILabel *)lgjeropj_totalLabel {
    
    UILabel *view = [[UILabel alloc] init];
    view.text = AsciiString(@"0:00:00");
    view.adjustsFontSizeToFitWidth = YES;
    view.textAlignment = NSTextAlignmentLeft;
    view.font = HTPingFangRegularFont(12);
    view.textColor = [UIColor whiteColor];
    return view;
}

@end

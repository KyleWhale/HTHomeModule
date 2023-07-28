//
//  HTMoviePlayViewManager.m
//  Moshfocus
//
//  Created by 李雪健 on 2023/6/7.
//

#import "HTMoviePlayViewManager.h"

@implementation HTMoviePlayViewManager

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
    
    return [HTKitCreate ht_labelWithText:AsciiString(@"Info") andFont:HTPingFangFont(16) andTextColor:[UIColor whiteColor] andAligment:NSTextAlignmentLeft andNumberOfLines:1];
}

+ (UILabel *)lgjeropj_descLabel {
    
    return [HTKitCreate ht_labelWithText:AsciiString(@"desc") andFont:HTPingFangRegularFont(14) andTextColor:[UIColor colorWithHexString:@"#999999"] andAligment:NSTextAlignmentLeft andNumberOfLines:0];
}


@end

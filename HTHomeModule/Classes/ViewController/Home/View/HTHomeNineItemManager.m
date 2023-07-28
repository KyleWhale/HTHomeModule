//
//  HTHomeNineItemManager.m
//  Moshfocus
//
//  Created by 李雪健 on 2023/6/7.
//

#import "HTHomeNineItemManager.h"

@implementation HTHomeNineItemManager

+ (UIImageView *)lgjeropj_imageView {
    
    UIImageView *view = [[UIImageView alloc] init];
    view.backgroundColor = [UIColor colorWithHexString:@"#3C3C3C"];
    view.cornerRadius = 6;
    return view;
}

+ (CAGradientLayer *)lgjeropj_layer {
    
    CGFloat itemWid = (kScreenWidth - 10*4)/3;
    CAGradientLayer *view = [CAGradientLayer layer];
    view.frame = CGRectMake(0, 0, itemWid, 24*kScale);
    view.startPoint = CGPointMake(0.5, 0);
    view.endPoint = CGPointMake(0.5, 1);
    view.colors = @[(__bridge id)[UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.0f].CGColor, (__bridge id)[UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1.0f].CGColor];
    view.locations = @[@(0.07f), @(1.00f)];
    return view;
}

+ (UIImageView *)lgjeropj_camImageView {
    
    UIImageView *view = [[UIImageView alloc] init];
    [view sd_setImageWithURL:[LKFPrivateFunction lgjeropj_imageUrlFromNumber:243]];
    return view;
}

+ (UILabel *)lgjeropj_seasonLabel {
    
    UILabel *view = [[UILabel alloc] init];
    view.textAlignment = NSTextAlignmentRight;
    return view;
}

+ (UILabel *)lgjeropj_titleLabel {
    
    return [HTKitCreate ht_labelWithText:@"" andFont:[UIFont systemFontOfSize:10 weight:UIFontWeightRegular] andTextColor:[UIColor colorWithHexString:@"#CCCCCC"] andAligment:NSTextAlignmentLeft andNumberOfLines:2];
}

+ (NSMutableAttributedString *)ht_rateAttribute:(NSString *)rate
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:rate attributes:@{NSFontAttributeName:HTPingFangFont(20),NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#FF6D1C"]}];
    [attributedString setAttributes:@{NSFontAttributeName:HTPingFangFont(12),NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#FF6D1C"]} range:NSMakeRange(2, 1)];
    return attributedString;
}

+ (NSMutableAttributedString *)ht_seasonAttribute:(NSString *)season
{
    if ( season == nil ) {
        return nil;
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:season attributes:@{NSFontAttributeName:[UIFont fontWithName:AsciiString(@"PingFangHK-Semibold") size:8],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    if ( [season hasPrefix:AsciiString(@"NEW")] ) {
        [attributedString setAttributes:@{NSFontAttributeName:[UIFont fontWithName:AsciiString(@"PingFangHK-Semibold") size:8],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#FF6D1C"]} range:NSMakeRange(0, 3)];
    }
    return attributedString;
}

@end

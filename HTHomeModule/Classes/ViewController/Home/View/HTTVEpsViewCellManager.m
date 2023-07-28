//
//  HTTVEpsViewCellManager.m
//  Moshfocus
//
//  Created by 李雪健 on 2023/6/7.
//

#import "HTTVEpsViewCellManager.h"

@implementation HTTVEpsViewCellManager

+ (UIView *)lgjeropj_conView {
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithHexString:@"#2C2C3F"];
    return view;
}

+ (UILabel *)lgjeropj_indexLabel {
    
    return [HTKitCreate ht_labelWithText:@"" andFont:[UIFont systemFontOfSize:16 weight:(UIFontWeightBold)] andTextColor:[UIColor whiteColor] andAligment:NSTextAlignmentLeft andNumberOfLines:1];
}

+ (UILabel *)lgjeropj_titleLabel {
    
    return [HTKitCreate ht_labelWithText:@"" andFont:[UIFont systemFontOfSize:14 weight:(UIFontWeightRegular)] andTextColor:[UIColor whiteColor] andAligment:NSTextAlignmentLeft andNumberOfLines:1];
}

@end

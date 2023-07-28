//
//  HTAssociationCellManager.m
//  Moshfocus
//
//  Created by 李雪健 on 2023/6/7.
//

#import "HTAssociationCellManager.h"

@implementation HTAssociationCellManager

+ (UIImageView *)lgjeropj_imageView {
    
    UIImageView *view = [[UIImageView alloc] init];
    [view sd_setImageWithURL:[LKFPrivateFunction lgjeropj_imageUrlFromNumber:131]];
    return view;
}

+ (UILabel *)lgjeropj_searchLabel {
    
    return [HTKitCreate ht_labelWithText:@"" andFont:HTPingFangRegularFont(14) andTextColor:[UIColor whiteColor] andAligment:NSTextAlignmentLeft andNumberOfLines:1];
}

@end

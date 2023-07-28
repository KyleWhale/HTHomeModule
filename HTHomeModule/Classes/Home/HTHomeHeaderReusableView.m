//
//  HTHomeHeaderReusableView.m
//  Hucolla
//
//  Created by mac on 2022/9/13.
//

#import "HTHomeHeaderReusableView.h"

@implementation HTHomeHeaderReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if ( self ) {
        [self ht_addViewSubViews];
    }
    return self;
}

- (void)ht_addViewSubViews {
    
    //self.backgroundColor = [UIColor redColor];
    
    self.titleLabel = [HTKitCreate ht_labelWithText:@"" andFont:[UIFont systemFontOfSize:18 weight:UIFontWeightBold] andTextColor:[UIColor whiteColor] andAligment:NSTextAlignmentLeft andNumberOfLines:1];
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.bottom.equalTo(self);
        make.height.equalTo(@22);
        make.width.greaterThanOrEqualTo(@100);
    }];
    
    self.rightBtn = [HTKitCreate ht_buttonWithImage:[LKFPrivateFunction lgjeropj_imageUrlFromNumber:217] andSelectImage:nil];
    self.rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self addSubview:self.rightBtn];
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-16);
        make.bottom.equalTo(self);
        make.height.equalTo(@22);
        make.width.equalTo(@45);
    }];
}

@end

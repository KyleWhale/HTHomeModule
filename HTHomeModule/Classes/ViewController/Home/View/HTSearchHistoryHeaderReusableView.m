//
//  HTSearchHistoryHeaderReusableView.m
//  Hucolla
//
//  Created by mac on 2022/9/14.
//

#import "HTSearchHistoryHeaderReusableView.h"

@implementation HTSearchHistoryHeaderReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if ( self ) {
        [self ht_addViewSubViews];
    }
    return self;
}

- (void)ht_addViewSubViews {
    
    self.titleLabel = [HTKitCreate ht_labelWithText:LocalString(@"History", nil) andFont:[UIFont systemFontOfSize:16 weight:(UIFontWeightSemibold)] andTextColor:[UIColor whiteColor] andAligment:NSTextAlignmentLeft andNumberOfLines:1];
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.left.equalTo(self).offset(16);
        make.height.equalTo(@22);
        make.width.greaterThanOrEqualTo(@20);
    }];
    
    self.rightBtn = [HTKitCreate ht_buttonWithImage:nil andTitle:LocalString(@"Clear", nil) andFont:[UIFont systemFontOfSize:14 weight:(UIFontWeightSemibold)] andTextColor:[UIColor colorWithHexString:@"#FF2929"] andState:UIControlStateNormal];
    [self addSubview:self.rightBtn];
    
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-16);
        make.bottom.equalTo(self);
        make.height.equalTo(@22);
        make.width.equalTo(@36);
    }];
}

@end

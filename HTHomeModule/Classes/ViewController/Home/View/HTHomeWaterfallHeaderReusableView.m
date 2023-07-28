//
//  HTHomeWaterfallHeaderReusableView.m
//  Hucolla
//
//  Created by mac on 2022/9/14.
//

#import "HTHomeWaterfallHeaderReusableView.h"

@interface HTHomeWaterfallHeaderReusableView ()

@property (nonatomic, strong) UIView *var_leftLine;
@property (nonatomic, strong) UIView *var_rightLine;

@end

@implementation HTHomeWaterfallHeaderReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if ( self ) {
        [self ht_addViewSubViews];
    }
    return self;
}

- (void)ht_addViewSubViews {
    
    self.titleLabel = [HTKitCreate ht_labelWithText:LocalString(@"More Big Hits", nil) andFont:[UIFont systemFontOfSize:14 weight:UIFontWeightRegular] andTextColor:[UIColor whiteColor] andAligment:NSTextAlignmentCenter andNumberOfLines:1];
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(0);
        make.height.equalTo(@22);
        make.width.greaterThanOrEqualTo(@30);
    }];
    
    UIView *leftLine = [[UIView alloc] init];
    leftLine.backgroundColor = [UIColor whiteColor];
    [self addSubview:leftLine];
    _var_leftLine = leftLine;
    
    UIView *rightLine = [[UIView alloc] init];
    rightLine.backgroundColor = [UIColor whiteColor];
    [self addSubview:rightLine];
    _var_rightLine = rightLine;
    
    [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(73);
        make.right.equalTo(self.titleLabel.mas_left).offset(-11);
        make.centerY.equalTo(self.titleLabel);
        make.height.equalTo(@0.5);
    }];
    
    [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-73);
        make.left.equalTo(self.titleLabel.mas_right).offset(11);
        make.centerY.equalTo(self.titleLabel);
        make.height.equalTo(@0.5);
    }];
}

- (void)ht_hideLine:(BOOL)isHidden {
    _var_leftLine.hidden = isHidden;
    _var_rightLine.hidden = isHidden;
    self.titleLabel.hidden = isHidden;
}

@end

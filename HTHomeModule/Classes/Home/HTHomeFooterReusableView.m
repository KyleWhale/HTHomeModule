//
//  HTHomeFooterReusableView.m
//  Hucolla
//
//  Created by mac on 2022/9/13.
//

#import "HTHomeFooterReusableView.h"
#import "HTHomeFooterReuseableManager.h"

@interface HTHomeFooterReusableView ()

@property (nonatomic, strong) UIButton           * loadBtn;
@property (nonatomic, assign) BOOL                 isStart;

@end

@implementation HTHomeFooterReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if ( self ) {
        [self ht_addViewSubViews];
    }
    return self;
}

- (void)ht_addViewSubViews {
    
    //self.backgroundColor = [UIColor brownColor];
    
    self.allBtn = [HTHomeFooterReuseableManager lgjeropj_allButton];
    [self addSubview:self.allBtn];
    
    [self.allBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-16);
        make.top.mas_equalTo(6);
        make.height.equalTo(@32);
    }];

    self.moreBtn = [HTHomeFooterReuseableManager lgjeropj_moreButton];
    [self addSubview:self.moreBtn];
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(6);
        make.right.equalTo(self.allBtn.mas_left).offset(-19);
        make.width.equalTo(self.allBtn.mas_width);
        make.height.mas_equalTo(32);
    }];

    self.loadBtn = [HTHomeFooterReuseableManager lgjeropj_loadButton];
    [self addSubview:self.loadBtn];
    [self.loadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.moreBtn);
    }];
}

- (void)ht_startLoadding
{
    self.loadBtn.hidden = NO;
    self.isStart = YES;
    [self imageTransform:UIViewAnimationOptionCurveEaseIn];
}

- (void)ht_endLoadding
{
    self.loadBtn.hidden = YES;
    self.isStart = NO;
}

- (void)imageTransform:(UIViewAnimationOptions)options
{
    //2s 旋转 360度
    [UIView animateWithDuration:0.5f delay:0.0f options:options animations:^{
        self.loadBtn.imageView.transform =CGAffineTransformRotate(self.loadBtn.imageView.transform,M_PI / 2);//M_PI / 2 = 90度
    } completion:^(BOOL finished) {
        if ( self.isStart ) {
            [self imageTransform:UIViewAnimationOptionCurveLinear];
        } else {
            if ( options != UIViewAnimationOptionCurveEaseOut ) {
                [self imageTransform:UIViewAnimationOptionCurveEaseOut];
            }
        }
    }];
}

@end

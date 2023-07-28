//
//  HTPlayBottomBar.m
//  Hucolla
//
//  Created by 彭金伟 on 2022/9/24.
//

#import "HTPlayBottomBar.h"
#import "HTPlayBottomBarManager.h"

@implementation HTPlayBottomBar

- (instancetype)init {
    self = [super init];
    if ( self ) {
        [self ht_addViewSubViews];
    }
    return self;
}

- (void)ht_addViewSubViews {
    
    self.playBtn = [HTKitCreate ht_buttonWithImage:[LKFPrivateFunction lgjeropj_imageUrlFromNumber:163] andSelectImage:[LKFPrivateFunction lgjeropj_imageUrlFromNumber:162]];
    [self addSubview:self.playBtn];
    
    self.fullBtn = [HTKitCreate ht_buttonWithImage:[LKFPrivateFunction lgjeropj_imageUrlFromNumber:267] andSelectImage:nil];
    [self addSubview:self.fullBtn];
    
    self.progressView = [HTPlayBottomBarManager lgjeropj_progress];
    [self addSubview:self.progressView];
    
    self.var_slider = [HTPlayBottomBarManager lgjeropj_slider];
    [self addSubview:self.var_slider];
    
    self.timeLabel = [HTPlayBottomBarManager lgjeropj_timeLabel];
    [self addSubview:self.timeLabel];
    
    self.totalLabel = [HTPlayBottomBarManager lgjeropj_totalLabel];
    [self addSubview:self.totalLabel];
    
    self.epsBtn = [HTKitCreate ht_buttonWithImage:nil andTitle:LocalString(@"Episodes", nil) andFont:[UIFont systemFontOfSize:16 weight:(UIFontWeightSemibold)] andTextColor:[UIColor whiteColor] andState:UIControlStateNormal];
    [self addSubview:self.epsBtn];
    
}

- (void)setIsFScreen:(BOOL)isFScreen {
    _isFScreen = isFScreen;
    self.fullBtn.hidden = isFScreen;
    if ( isFScreen == NO ) {
        self.epsBtn.hidden = YES;
    } else {
        if( self.var_isTType ) {
            self.epsBtn.hidden = NO;
        } else {
            self.epsBtn.hidden = YES;
        }
    }
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if ( self.isFScreen ) {
        
        self.playBtn.frame = CGRectMake(40, 44, 24, 24);
        self.timeLabel.frame = CGRectMake(40+4, 15, 48, 14);
        self.fullBtn.frame = CGRectMake(CGRectGetWidth(self.bounds) - 20 - 24, 10, 24, 24);
        self.totalLabel.frame = CGRectMake(CGRectGetWidth(self.bounds) - 20 - 48, 15, 48, 14);
        self.var_slider.frame = CGRectMake(CGRectGetMaxX(self.timeLabel.frame)+4, 12, CGRectGetMinX(self.totalLabel.frame) - 4 - CGRectGetMaxX(self.timeLabel.frame) - 4, 20);
        self.progressView.frame = CGRectMake(CGRectGetMinX(self.var_slider.frame) + 4, CGRectGetMidY(self.var_slider.frame)-2, CGRectGetWidth(self.var_slider.frame) - 8, 2);
        self.epsBtn.frame = CGRectMake(CGRectGetMaxX(self.var_slider.frame) - 70, 40, 70, 24);
        
    } else {
        
        self.playBtn.frame = CGRectMake(15, 10, 24, 24);
        self.timeLabel.frame = CGRectMake(CGRectGetMaxX(self.playBtn.frame)+4, 15, 48, 14);
        self.fullBtn.frame = CGRectMake(CGRectGetWidth(self.bounds) - 15 - 24, 10, 24, 24);
        self.totalLabel.frame = CGRectMake(CGRectGetMinX(self.fullBtn.frame) - 4 - 48, 15, 48, 14);
        self.var_slider.frame = CGRectMake(CGRectGetMaxX(self.timeLabel.frame)+4, 12, CGRectGetWidth(self.bounds) - (CGRectGetMaxX(self.timeLabel.frame)+4)*2, 20);
        self.progressView.frame = CGRectMake(CGRectGetMinX(self.var_slider.frame) + 4, CGRectGetMidY(self.var_slider.frame)-2, CGRectGetWidth(self.var_slider.frame) - 8, 2);
        self.epsBtn.frame = CGRectMake(CGRectGetMaxX(self.totalLabel.frame) - 70, 40, 70, 24);
    }
    
}

@end

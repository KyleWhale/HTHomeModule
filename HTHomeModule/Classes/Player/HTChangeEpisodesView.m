//
//  HTChangeEpisodesView.m
//  Hucolla
//
//  Created by mac on 2022/9/23.
//

#import "HTChangeEpisodesView.h"
#import "HTEpisodesMainView.h"
@interface HTChangeEpisodesView()

@property (nonatomic, strong) UIView        * var_contentView;
@property (nonatomic, strong) UIImageView   * var_backgroundImageView;
@property (nonatomic, strong) HTEpisodesMainView  * var_mainView;

@end


@implementation HTChangeEpisodesView

- (instancetype)init {
    self = [super init];
    if ( self ) {
        [self ht_addViewSubViews];
    }
    return self;
}

- (void)ht_addViewSubViews {
    
    [self addSubview:self.var_contentView];
    [self.var_contentView addSubview:self.var_backgroundImageView];
    [self.var_contentView addSubview:self.var_mainView];
}

- (void)setContentListArray:(NSArray *)contentListArray {
    _contentListArray = contentListArray;
    self.var_mainView.contentArray = contentListArray;
}

- (void)setCurrentSchedule:(HTTVDetailSeasonModel *)currentSchedule {
    _currentSchedule = currentSchedule;
    self.var_mainView.currentSchedule = currentSchedule;
}

- (void)setCurrentIndex:(HTTVDetailEpsModel *)currentIndex {
    _currentIndex = currentIndex;
    self.var_mainView.currentIndex = currentIndex;
}

- (void)setScheduleBlock:(BLOCK_dataBlock)scheduleBlock {
    _scheduleBlock = scheduleBlock;
    self.var_mainView.scheduleBlock = scheduleBlock;
}

- (void)setExerciseBlock:(BLOCK_dataBlock)exerciseBlock {
    _exerciseBlock = exerciseBlock;
    self.var_mainView.exerciseBlock = exerciseBlock;
}

- (void)ht_showInView:(UIView *)view {
    
    [view addSubview:self];
    
    self.var_backgroundImageView.hidden = NO;
    self.var_contentView.frame = CGRectMake(kScreenWidth, 0, 360, kScreenHeight);
    [UIView animateWithDuration:0.2 animations:^{
        self.var_contentView.frame = CGRectMake(kScreenWidth - 360, 0, 360, kScreenHeight);
    }];
    
    self.var_backgroundImageView.frame = self.var_contentView.bounds;
    self.var_mainView.frame = self.var_contentView.bounds;
}

- (void)dissSubtitleView {
    
    [UIView animateWithDuration:0.2 animations:^{
        self.var_contentView.frame = CGRectMake(kScreenWidth, 0, 360, kScreenHeight);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if ( touch ) {
        CGPoint point = [touch locationInView:self];
        if ( CGRectContainsPoint(self.var_contentView.frame, point) == NO ) {
            
            [self dissSubtitleView];
        }
    }
}


- (UIView *)var_contentView {
    if ( _var_contentView == nil ) {
        _var_contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 360, kScreenHeight)];
        _var_contentView.clipsToBounds = YES;
    }
    return _var_contentView;
}

- (UIImageView *)var_backgroundImageView {
    if ( _var_backgroundImageView == nil ) {
        _var_backgroundImageView = [[UIImageView alloc] init];
        [_var_backgroundImageView sd_setImageWithURL:[LKFPrivateFunction lgjeropj_imageUrlFromNumber:110]];
    }
    return _var_backgroundImageView;
}

- (HTEpisodesMainView *)var_mainView {
    if ( _var_mainView == nil ) {
        _var_mainView = [[HTEpisodesMainView alloc] init];
    }
    return _var_mainView;
}

@end

//
//  HTChangeSubtitleView.m
//  Hucolla
//
//  Created by mac on 2022/9/21.
//

#import "HTChangeSubtitleView.h"
#import "HTChangeSubtitleViewManager.h"

@interface HTChangeSubtitleView()

@property (nonatomic, strong) UIView        * var_contentView;
@property (nonatomic, strong) UIImageView   * var_backgroundImageView;
@property (nonatomic, strong) HTSubtitleMainView           * var_mainView;
@property (nonatomic, strong) HTSubtitleSettingView        * var_settingView;
@property (nonatomic, strong) HTSubtitleLanguageView       * var_lanView;
@property (nonatomic, assign) BOOL             var_isHorizontal;
// 是否使用了延时执行
@property (nonatomic, assign) BOOL useAfterTask;
// 延时执行任务
@property (nonatomic, copy) dispatch_block_t loadWaitingTask;

@end

@implementation HTChangeSubtitleView

- (instancetype)init {
    self = [super init];
    if ( self ) {
        [self ht_addViewSubViews];
    }
    return self;
}

- (void)ht_addViewSubViews {
    
    self.var_contentView = [HTChangeSubtitleViewManager lgjeropj_contentView];
    [self addSubview:self.var_contentView];
    self.var_backgroundImageView = [HTChangeSubtitleViewManager lgjeropj_backgroundView];
    [self.var_contentView addSubview:self.var_backgroundImageView];
    self.var_mainView = [HTChangeSubtitleViewManager lgjeropj_mainView];
    [self.var_contentView addSubview:self.var_mainView];
    
    @weakify(self);
    self.var_mainView.switchBlock = ^(BOOL isSelect) {
        @strongify(self);
        if ( self.switchBlock ) {
            self.switchBlock(isSelect);
        }
    };
    
    self.var_mainView.settingBlock = ^{
        @strongify(self);
        [self.var_contentView addSubview:self.var_settingView];
        [self ht_pushView:self.var_settingView animation:YES];
    };
    
    self.var_mainView.languageBlock = ^{
        @strongify(self);
        [self.var_contentView addSubview:self.var_lanView];
        [self.var_lanView setTextArray:self.textArray];
        [self ht_pushView:self.var_lanView animation:YES];
    };
    
    self.var_settingView = [HTChangeSubtitleViewManager lgjeropj_settingView];
    self.var_settingView.cancelBlock = ^{
        @strongify(self);
        [self ht_popView:self.var_settingView animation:YES];
    };
    self.var_settingView.timeBlock = ^(id data) {
        @strongify(self);
        self.timeBlock(data);
    };
    
    self.var_lanView = [HTChangeSubtitleViewManager lgjeropj_languageView];
    self.var_lanView.cancelBlock = ^{
        @strongify(self);
        [self ht_popView:self.var_lanView animation:YES];
    };
    self.var_lanView.selBlock = ^(id data) {
        @strongify(self);
        self.selBlock(data);
        [self ht_popView:self.var_lanView animation:NO];
        [self ht_dissSubtitleView];
    };
}

- (void)setSelBlock:(BLOCK_dataBlock)selBlock {
    _selBlock = selBlock;
    
}

- (void)setTimeBlock:(BLOCK_dataBlock)timeBlock {
    _timeBlock = timeBlock;
}

- (void)ht_pushView:(UIView *)view animation:(BOOL)animation {
    
    if ( animation ) {
        if ( self.var_isHorizontal ) {
            view.frame = CGRectMake(360, 0, 360, kScreenHeight);
            [UIView animateWithDuration:0.2 animations:^{
                view.frame = CGRectMake(0, 0, 360, kScreenHeight);
                self.var_mainView.frame = CGRectMake(-80, 0, 360, kScreenHeight);
            } completion:^(BOOL finished) {
                self.var_mainView.hidden = YES;
            }];
        } else {
            view.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, 360);
            [UIView animateWithDuration:0.2 animations:^{
                view.frame = CGRectMake(0, 0, kScreenWidth, 360);
                self.var_mainView.frame = CGRectMake(-80, 0, kScreenWidth, 360);
            } completion:^(BOOL finished) {
                self.var_mainView.hidden = YES;
            }];
        }
    } else {
        if ( self.var_isHorizontal ) {
            view.frame = CGRectMake(0, 0, 360, kScreenHeight);
            self.var_mainView.frame = CGRectMake(-80, 0, 360, kScreenHeight);
            self.var_mainView.hidden = YES;
        } else {
            view.frame = CGRectMake(0, 0, kScreenWidth, 360);
            self.var_mainView.frame = CGRectMake(-80, 0, kScreenWidth, 360);
            self.var_mainView.hidden = YES;
        }
    }
}

- (void)ht_popView:(UIView *)view animation:(BOOL)animation {
    if ( animation )
    {
        if ( self.var_isHorizontal ) {
            self.var_mainView.hidden = NO;
            [UIView animateWithDuration:0.2 animations:^{
                view.frame = CGRectMake(360, 0, 360, kScreenHeight);
                self.var_mainView.frame = CGRectMake(0, 0, 360, kScreenHeight);
            } completion:^(BOOL finished) {
                
            }];
        } else {
            self.var_mainView.hidden = NO;
            [UIView animateWithDuration:0.2 animations:^{
                view.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, 360);
                self.var_mainView.frame = CGRectMake(0, 0, kScreenWidth, 360);
            } completion:^(BOOL finished) {
                
            }];
        }
    } else {
        if ( self.var_isHorizontal ) {
            view.frame = CGRectMake(360, 0, 360, kScreenHeight);
            self.var_mainView.frame = CGRectMake(0, 0, 360, kScreenHeight);
            self.var_mainView.hidden = NO;
        } else {
            view.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, 360);
            self.var_mainView.frame = CGRectMake(0, 0, kScreenWidth, 360);
            self.var_mainView.hidden = NO;
        }
    }
}


- (void)ht_showInView:(UIView *)view andHorizontal:(BOOL)horizontal {
    
    [view addSubview:self];
    
    self.var_isHorizontal = horizontal;
    
    if ( horizontal ) {
        self.var_backgroundImageView.hidden = NO;
        self.var_contentView.frame = CGRectMake(kScreenWidth, 0, 360, kScreenHeight);
        [UIView animateWithDuration:0.2 animations:^{
            self.var_contentView.frame = CGRectMake(kScreenWidth - 360, 0, 360, kScreenHeight);
        }];
    } else {
        self.var_contentView.backgroundColor = [UIColor blackColor];
        self.var_contentView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 360);
        [UIView animateWithDuration:0.2 animations:^{
            self.var_contentView.frame = CGRectMake(0, kScreenHeight - 360, kScreenWidth, 360);
        }];
    }
    
    self.var_backgroundImageView.frame = self.var_contentView.bounds;
    self.var_mainView.frame = self.var_contentView.bounds;
}

// offset 时间偏移
- (void)ht_showSrtWithTime:(double)time offset:(double)offset {
    [self.var_settingView ht_showSrtWithTime:time offset:offset];
}

- (void)ht_dissSubtitleView {
    
    if ( self.var_isHorizontal ) {
        self.var_backgroundImageView.hidden = YES;
        [UIView animateWithDuration:0.2 animations:^{
            self.var_contentView.frame = CGRectMake(kScreenWidth, 0, 360, kScreenHeight);
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    } else {
        self.var_contentView.backgroundColor = [UIColor clearColor];
        
        [UIView animateWithDuration:0.2 animations:^{
            self.var_contentView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 360);
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if ( touch ) {
        CGPoint point = [touch locationInView:self];
        if ( CGRectContainsPoint(self.var_contentView.frame, point) == NO ) {
            
            [self ht_dissSubtitleView];
        }
    }
}

@end

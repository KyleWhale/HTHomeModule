//
//  HTSubtitleView.m
//  Hucolla
//
//  Created by mac on 2022/9/20.
//

#import "HTSubtitleView.h"
#import "HTSubtitleObject.h"
#import "HTSubtitleManager.h"

@interface HTSubtitleView()

@property (nonatomic, strong) UILabel      * var_titleLabel;

// 是否使用了延时执行
@property (nonatomic, assign) BOOL useAfterTask;
// 延时执行任务
@property (nonatomic, copy) dispatch_block_t loadWaitingTask;

@end

@implementation HTSubtitleView

- (instancetype)init {
    self = [super init];
    if ( self ) {
        [self ht_addViewSubViews];
    }
    return self;
}

- (void)ht_addViewSubViews {
    
    self.backgroundColor = [UIColor clearColor];
    self.var_titleLabel = [[UILabel alloc] init];
    self.var_titleLabel.numberOfLines = 0;
    [self addSubview:self.var_titleLabel];
}

- (void)setAttributeStr:(NSAttributedString *)attributeStr {
    _attributeStr = attributeStr;
    
    self.var_titleLabel.attributedText = attributeStr;
    
    CGRect rect = [attributeStr boundingRectWithSize:CGSizeMake(kScreenWidth - 60, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    
    self.var_titleLabel.frame = CGRectMake(3, 3, rect.size.width + 2, rect.size.height + 2);
    self.bounds = CGRectMake(0, 0, CGRectGetWidth(self.var_titleLabel.frame)+6, CGRectGetHeight(self.var_titleLabel.frame)+6);
    
    //NSLog(@"frame: %@",NSStringFromCGRect(self.frame));
}

- (void)showSubtitle:(BOOL)isShow duration:(double)duration {
    
    if ( isShow ) {
        // 如果有延迟执行任务，取消
        if ( self.useAfterTask ) {
            dispatch_block_cancel(self.loadWaitingTask);
        }
        
        [UIView animateWithDuration:0.1 animations:^{
            self.alpha = 1.0;
        }];
        
        @weakify(self);
        self.loadWaitingTask = dispatch_block_create(DISPATCH_BLOCK_BARRIER, ^{
            @strongify(self);
            
            [UIView animateWithDuration:0.1 animations:^{
                self.alpha = 0.0;
            } completion:^(BOOL finished) {
                self.useAfterTask = NO;
            }];
        });
        
        self.useAfterTask = YES;
        
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC));
        
        dispatch_after(delayTime, dispatch_get_main_queue(), self.loadWaitingTask);
    } else {
        [UIView animateWithDuration:0.1 animations:^{
            self.alpha = 0.0;
        } completion:^(BOOL finished) {
            self.useAfterTask = NO;
        }];
    }
}
- (void)ht_showSrtWithTime:(double)time offset:(double)offset {
    
    NSMutableArray *dataArray = [HTSubtitleManager ht_manager].dataArray;
    if ( dataArray.count > 0 ) {
        double showTime = time + offset;
        HTSubtitleObject *showObj = nil;
        for ( int i = self.curIndex; i < dataArray.count; i++ ) {
            HTSubtitleObject *obj = dataArray[i];
            ENUM_HTSubtitleState state = [obj ht_subtitleStateWithTime:showTime];
            if ( state == ENUM_HTSubtitleStateLessStart ) {
                break;
            } else if ( state == ENUM_HTSubtitleStateDuration ) {
                showObj = obj;
                self.curIndex = i;
                break;
            }
        }
        if ( showObj ) {
            if (![self.attributeStr.string isEqualToString:showObj.content]) {
                self.attributeStr = [showObj ht_attributeStrForContentWithFont:[UIFont systemFontOfSize:14 weight:(UIFontWeightSemibold)] textColor:[UIColor whiteColor] lineSpace:3];
                [self showSubtitle:YES duration:[showObj ht_duration]];
            }
        } else if (self.alpha == 1.0) {
            [self showSubtitle:NO duration:[showObj ht_duration]];
        }
    }
}

@end

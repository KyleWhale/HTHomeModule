//
//  HTSubtitleSettingView.m
//  Hucolla
//
//  Created by mac on 2022/9/21.
//

#import "HTSubtitleSettingView.h"
#import "HTSubtitleManager.h"
#import "HTSubtitleObject.h"
#import "HTSubtitleSettingViewManager.h"

@interface HTSubtitleSettingView()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView     * var_tableView;
@property (nonatomic, strong) UIButton        * var_cancelBtn;
@property (nonatomic, strong) UIView          * var_line;

@property (nonatomic, strong) UIButton        * originBtn;
@property (nonatomic, strong) UIButton        * plusBtn;
@property (nonatomic, strong) UIButton        * minusBtn;
@property (nonatomic, strong) UIButton        * upperBtn;
@property (nonatomic, strong) UIButton        * nextBtn;

@property (nonatomic, assign) NSInteger         index;
@property (nonatomic, assign) double            timeOffset;
@property (nonatomic, assign) double            curStartTime;

@end

@implementation HTSubtitleSettingView

- (instancetype)init {
    self = [super init];
    if ( self ) {
        [self ht_addViewSubViews];
    }
    return self;
}

- (void)ht_addViewSubViews {
    
    self.var_cancelBtn = [HTSubtitleSettingViewManager lgjeropj_cancelBtn];
    [self addSubview:self.var_cancelBtn];
    
    self.var_line = [HTSubtitleSettingViewManager lgjeropj_line];
    [self addSubview:self.var_line];
    
    self.var_tableView = [HTSubtitleSettingViewManager lgjeropj_tableView:self];
    [self addSubview:self.var_tableView];
    
    self.originBtn = [HTSubtitleSettingViewManager lgjeropj_originBtn];
    [self addSubview:self.originBtn];
    
    self.upperBtn= [HTSubtitleSettingViewManager lgjeropj_upperBtn];
    [self addSubview:self.upperBtn];
    
    self.minusBtn = [HTSubtitleSettingViewManager lgjeropj_minusBtn];
    [self addSubview:self.minusBtn];
    
    self.plusBtn = [HTSubtitleSettingViewManager lgjeropj_plusBtn];
    [self addSubview:self.plusBtn];
    
    self.nextBtn = [HTSubtitleSettingViewManager lgjeropj_nextBtn];
    [self addSubview:self.nextBtn];
    
    [self.var_cancelBtn addTarget:self action:@selector(ht_onCancelAction) forControlEvents:UIControlEventTouchUpInside];
    [self.originBtn addTarget:self action:@selector(ht_onOriginAction) forControlEvents:UIControlEventTouchUpInside];
    [self.upperBtn addTarget:self action:@selector(ht_onUpperAction) forControlEvents:UIControlEventTouchUpInside];
    [self.minusBtn addTarget:self action:@selector(ht_onMinusAction) forControlEvents:UIControlEventTouchUpInside];
    [self.plusBtn addTarget:self action:@selector(ht_onPlusAction) forControlEvents:UIControlEventTouchUpInside];
    [self.nextBtn addTarget:self action:@selector(ht_onNextAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    
    [self.var_cancelBtn setTitle:title forState:UIControlStateNormal];
    [self.var_cancelBtn setPosition:1 interval:8];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [HTSubtitleManager ht_manager].dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HTSubtitleObject *obj = [HTSubtitleManager ht_manager].dataArray[indexPath.row];
    HTSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HTSettingCell class])];
    if ( indexPath.row <= self.index ) {
        [cell ht_updateCellWithData:[obj ht_attributeStrForContentWithFont:[UIFont systemFontOfSize:14 weight:(UIFontWeightRegular)] textColor:[UIColor colorWithHexString:@"#3CDEF4"] lineSpace:0]];
    } else {
        [cell ht_updateCellWithData:[obj ht_attributeStrForContentWithFont:[UIFont systemFontOfSize:14 weight:(UIFontWeightRegular)] textColor:[UIColor colorWithHexString:@"#5D5D70"] lineSpace:0]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)ht_onCancelAction {
    if ( self.cancelBlock ) {
        self.cancelBlock();
    }
}

- (void)ht_onOriginAction {
    if ( self.timeBlock ) {
        self.timeBlock(@0);
    }
    [SVProgressHUD showInfoWithStatus:LocalString(@"Finish", nil)];
}

- (void)ht_onUpperAction {
    
    if ( self.index > 0 ) {
        HTSubtitleObject *obj = [HTSubtitleManager ht_manager].dataArray[self.index - 1];
        self.timeOffset = obj.startTime - self.curStartTime;
        if ( self.timeBlock ) {
            self.timeBlock(@(self.timeOffset));
        }
        NSString *str = [NSString stringWithFormat:AsciiString(@"-%.1fs"),-self.timeOffset];
        [SVProgressHUD showInfoWithStatus:str];
    }
}

- (void)ht_onMinusAction {
    if ( self.timeBlock ) {
        self.timeBlock(@-0.5);
    }
    self.timeOffset = self.timeOffset - 0.5;
    NSString *str = [NSString stringWithFormat:AsciiString(@"-0.5s\n%.1fs"),self.timeOffset];
    [SVProgressHUD showInfoWithStatus:str];
}

- (void)ht_onPlusAction {
    if ( self.timeBlock ) {
        self.timeBlock(@0.5);
    }
    self.timeOffset = self.timeOffset + 0.5;
    NSString *str = [NSString stringWithFormat:AsciiString(@"+0.5s\n%.1fs"),self.timeOffset];
    [SVProgressHUD showInfoWithStatus:str];
}

- (void)ht_onNextAction {
    if ( self.index < [HTSubtitleManager ht_manager].dataArray.count - 1 ) {
        HTSubtitleObject *obj = [HTSubtitleManager ht_manager].dataArray[self.index + 1];
        self.timeOffset = obj.startTime - self.curStartTime;
        if ( self.timeBlock ) {
            self.timeBlock(@(self.timeOffset));
        }
        NSString *str = [NSString stringWithFormat:AsciiString(@"+%.1fs"),self.timeOffset];
        [SVProgressHUD showInfoWithStatus:str];
    }
}

// offset 时间偏移
- (void)ht_showSrtWithTime:(double)time offset:(double)offset {
    self.timeOffset = offset;
    
    NSMutableArray *dataArray = [HTSubtitleManager ht_manager].dataArray;
    if ( dataArray.count > 0 ) {
        
        double showTime = time + offset;
        HTSubtitleObject *var_showObj = nil;
        
        for ( int i=0; i < dataArray.count; i++ ) {
            HTSubtitleObject *obj = dataArray[i];
            ENUM_HTSubtitleState state = [obj ht_subtitleStateWithTime:showTime];
            if ( state == ENUM_HTSubtitleStateLessStart ) {
                break;
            } else if ( state == ENUM_HTSubtitleStateDuration ) {
                var_showObj = obj;
                self.index = i;
                break;
            }
        }
        
        if ( var_showObj ) {
            
            self.curStartTime = var_showObj.startTime;
            [self.var_tableView reloadData];
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.index inSection:0];
            
            [self.var_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:(UITableViewScrollPositionMiddle) animated:YES];
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.var_cancelBtn.frame = CGRectMake(50, 49, 200, 30);
    self.var_line.frame = CGRectMake(50, CGRectGetMaxY(self.var_cancelBtn.frame), CGRectGetWidth(self.bounds) - 50, 1);
    
    self.var_tableView.frame = CGRectMake(50, CGRectGetMaxY(self.var_line.frame)+9, CGRectGetWidth(self.bounds) - 50 - 64, CGRectGetHeight(self.bounds) - 28 - CGRectGetMaxY(self.var_line.frame));
    
    self.upperBtn.frame = CGRectMake(CGRectGetWidth(self.bounds) - 30 - 34, CGRectGetMaxY(self.var_line.frame)+22, 30, 30);
    self.minusBtn.frame = CGRectMake(CGRectGetWidth(self.bounds) - 30 - 34, CGRectGetMaxY(self.upperBtn.frame)+24, 30, 30);
    self.originBtn.frame = CGRectMake(CGRectGetWidth(self.bounds) - 30 - 34, CGRectGetMaxY(self.minusBtn.frame)+24, 30, 30);
    self.plusBtn.frame = CGRectMake(CGRectGetWidth(self.bounds) - 30 - 34, CGRectGetMaxY(self.originBtn.frame)+24, 30, 30);
    self.nextBtn.frame = CGRectMake(CGRectGetWidth(self.bounds) - 30 - 34, CGRectGetMaxY(self.plusBtn.frame)+24, 30, 30);
    
}

@end

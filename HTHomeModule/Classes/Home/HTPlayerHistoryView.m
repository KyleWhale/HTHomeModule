//
//  HTPlayerHistoryView.m
//  Hucolla
//
//  Created by mac on 2022/9/15.
//

#import "HTPlayerHistoryView.h"
#import "HTDBHistoryModel.h"
#import "HTPlayerHistoryViewManager.h"

@interface HTPlayerHistoryView ()

@property (nonatomic, strong) UIImageView   * bookImageView;
@property (nonatomic, strong) UILabel       * var_nameLab;
@property (nonatomic, strong) UIButton        * var_playBtn;
@property (nonatomic, strong) UIButton        * var_delBtn;
@property (nonatomic, strong) NSTimer         * historyTimer;

@end

@implementation HTPlayerHistoryView

- (void)ht_addViewSubViews {
    
    self.cornerRadius = 8;
    self.backgroundColor = [UIColor colorWithHexString:@"#424271"];
    
    UIImageView *var_bgImgV = [HTPlayerHistoryViewManager lgjeropj_backgroundView];
    [self addSubview:var_bgImgV];
    [var_bgImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    CGSize size = CGSizeMake(isPad ? 48*kScale:48, isPad ? 60*kScale:60);
    self.bookImageView = [[UIImageView alloc] init];
    [self addSubview:self.bookImageView];
    [self.bookImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(size.width));
        make.height.equalTo(@(size.height));
        make.left.equalTo(self);
        make.centerY.equalTo(self);
    }];
    
    self.var_nameLab = [HTPlayerHistoryViewManager lgjeropj_nameLabel];
    [self addSubview:self.var_nameLab];
    
    self.var_playBtn = [HTPlayerHistoryViewManager lgjeropj_playButton:self action:@selector(lgjeropj_onPlayAction)];
    [self addSubview:self.var_playBtn];
    
    self.var_delBtn = [HTPlayerHistoryViewManager lgjeropj_deleteButton:self action:@selector(lgjeropj_onCancelAction)];
    [self addSubview:self.var_delBtn];
    
    [self.var_delBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-12);
        make.centerY.equalTo(self);
        make.width.height.equalTo(@20);
    }];
    
    [self.var_playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.var_delBtn.mas_left).offset(-16);
        make.centerY.equalTo(self);
        make.width.height.equalTo(@20);
    }];
    
    [self.var_nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bookImageView.mas_right).offset(6);
        make.centerY.equalTo(self);
        make.right.equalTo(self.var_playBtn.mas_left).offset(-12);
        make.height.equalTo(@16);
    }];
}

- (void)ht_updateViewWithData:(id)data {
    if ( data ) {
        HTDBHistoryModel *model = (HTDBHistoryModel *)data;
        [self.bookImageView sd_setImageWithURL:[NSURL URLWithString:model.var_cover] placeholderImage:[UIImage imageNamed:@"icon_momtype_default"]];
        
        NSDateFormatter *var_formatter = [[NSDateFormatter alloc] init];
        var_formatter.timeZone = [NSTimeZone timeZoneWithName:AsciiString(@"GMT")];
        NSInteger var_seeTime = [model.var_seeTime integerValue];
        NSDate *var_date = [NSDate dateWithTimeIntervalSince1970:var_seeTime];
        if (var_seeTime / 3600.0 >= 1) {
            var_formatter.dateFormat = AsciiString(@"HH:mm:ss");
        } else {
            var_formatter.dateFormat = AsciiString(@"mm:ss");
        }
        NSString *var_timeStr = [var_formatter stringFromDate:var_date];
        NSString *var_message = LocalString(@"Continue Watching From", nil);
        self.var_nameLab.text = [NSString stringWithFormat:@"%@ %@",var_message, var_timeStr];
    }
}

- (void)ht_startTimer {
    if ( self.historyTimer == nil ) {
        self.historyTimer = [NSTimer scheduledTimerWithTimeInterval:6 target:self selector:@selector(ht_updateTimer) userInfo:nil repeats:NO];
    }
}

- (void)ht_endTimer {
    [self.historyTimer invalidate];
    self.historyTimer = nil;
}

- (void)ht_updateTimer {
    [self ht_endTimer];
    if ( self.cancelBlock ) {
        self.cancelBlock(NO);
    }
}

- (void)lgjeropj_onPlayAction {
    if ( self.playBlock ) {
        self.playBlock();
    }
}

- (void)lgjeropj_onCancelAction {
    if ( self.cancelBlock ) {
        self.cancelBlock(YES);
    }
}

@end

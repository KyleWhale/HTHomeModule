//
//  HTSubtitleMainView.m
//  Hucolla
//
//  Created by mac on 2022/9/21.
//

#import "HTSubtitleMainView.h"
#import "HTSubtitleMainViewManager.h"

@interface HTSubtitleMainView()

@property (nonatomic, strong) UILabel       * subtitleLab;
@property (nonatomic, strong) UIView       * var_line;
@property (nonatomic, strong) UISwitch       * var_subtitleSwitch;
@property (nonatomic, strong) UIButton       * settingBtn;
@property (nonatomic, strong) UIButton       * languageBtn;

@end

@implementation HTSubtitleMainView

- (instancetype)init {
    self = [super init];
    if ( self ) {
        [self ht_addViewSubViews];
    }
    return self;
}

- (void)ht_addViewSubViews {
    
    self.subtitleLab = [HTSubtitleMainViewManager lgjeropj_subtitleLab];
    [self addSubview:self.subtitleLab];
    
    self.var_line = [HTSubtitleMainViewManager lgjeropj_line];
    [self addSubview:self.var_line];
    
    self.var_subtitleSwitch = [HTSubtitleMainViewManager lgjeropj_subtitleSwitch];
    [self addSubview:self.var_subtitleSwitch];
    
    self.settingBtn = [HTSubtitleMainViewManager lgjeropj_settingBtn];
    [self addSubview:self.settingBtn];
    
    self.languageBtn = [HTSubtitleMainViewManager lgjeropj_languageBtn];
    [self addSubview:self.languageBtn];
    
    [self.var_subtitleSwitch addTarget:self action:@selector(lgjeropj_onSwitchAction:) forControlEvents:UIControlEventValueChanged];
    [self.settingBtn addTarget:self action:@selector(lgjeropj_onSettingAction) forControlEvents:UIControlEventTouchUpInside];
    [self.languageBtn addTarget:self action:@selector(lgjeropj_onLanguageAction) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)lgjeropj_onSwitchAction:(UISwitch *)sender {
    if ( self.switchBlock ) {
        self.switchBlock(sender.isOn);
    }
}

- (void)lgjeropj_onSettingAction {
    if ( self.settingBlock ) {
        self.settingBlock();
    }
}

- (void)lgjeropj_onLanguageAction {
    if ( self.languageBlock ) {
        self.languageBlock();
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.subtitleLab.frame = CGRectMake(50, 54, 80, 21);
    self.var_line.frame = CGRectMake(50, CGRectGetMaxY(self.subtitleLab.frame)+4, CGRectGetWidth(self.bounds)-50, 1);
    self.var_subtitleSwitch.frame = CGRectMake(CGRectGetWidth(self.bounds)-38-42, CGRectGetMidY(self.subtitleLab.frame)-10, 42, 20);
    self.settingBtn.frame = CGRectMake(50, CGRectGetMaxY(self.var_line.frame) + 30, 280, 30);
    self.languageBtn.frame = CGRectMake(50, CGRectGetMaxY(self.settingBtn.frame) + 24, 280, 30);
}

@end

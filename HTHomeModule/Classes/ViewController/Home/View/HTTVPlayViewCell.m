//
//  HTTVPlayViewCell.m
//  Hucolla
//
//  Created by mac on 2022/9/22.
//

#import "HTTVPlayViewCell.h"
#import "HTTVPlayViewCellManager.h"

@interface HTTVPlayViewCell()

@property (nonatomic, strong) UILabel       * titleLabel;
@property (nonatomic, strong) HTStarLevelView       * starView;
@property (nonatomic, strong) UILabel       * levelLabel;
@property (nonatomic, strong) UILabel       * countryLabel;
@property (nonatomic, strong) UILabel       * tagsLabel;
@property (nonatomic, strong) UILabel       * descLabel;
@property (nonatomic, strong) UIButton       * seasonBtn;
@property (nonatomic, strong) UIView        * line;

@end

@implementation HTTVPlayViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)ht_addCellSubViews {
    
    self.backgroundColor = [UIColor clearColor];
    
    self.titleLabel = [HTTVPlayViewCellManager lgjeropj_titleLabel];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView).inset(14);
        make.top.equalTo(self.contentView).offset(20);
        make.height.greaterThanOrEqualTo(@21);
    }];
    
    self.starView = [HTTVPlayViewCellManager lgjeropj_starView];
    [self.contentView addSubview:self.starView];
    [self.starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(14);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.width.equalTo(@(18*5+4*4));
        make.height.equalTo(@18);
    }];
    
    self.levelLabel = [HTTVPlayViewCellManager lgjeropj_levelLabel];
    [self.contentView addSubview:self.levelLabel];
    [self.levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.starView.mas_right).offset(4);
        make.centerY.equalTo(self.starView);
        make.height.equalTo(@18);
        make.width.greaterThanOrEqualTo(@18);
    }];
    
    self.countryLabel = [HTTVPlayViewCellManager lgjeropj_countryLabel];
    [self.contentView addSubview:self.countryLabel];
    [self.countryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView).inset(14);
        make.top.equalTo(self.starView.mas_bottom).offset(16);
        make.height.greaterThanOrEqualTo(@16);
    }];
    
    self.tagsLabel = [HTTVPlayViewCellManager lgjeropj_tagsLabel];
    [self.contentView addSubview:self.tagsLabel];
    [self.tagsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView).inset(14);
        make.top.equalTo(self.countryLabel.mas_bottom).offset(6);
        make.height.greaterThanOrEqualTo(@16);
    }];
    
    self.descLabel = [HTTVPlayViewCellManager lgjeropj_starsLabel];
    [self.contentView addSubview:self.descLabel];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView).inset(14);
        make.top.equalTo(self.tagsLabel.mas_bottom).offset(6);
        make.height.greaterThanOrEqualTo(@16);
    }];
    
    UILabel *infoLab = [HTTVPlayViewCellManager lgjeropj_infoLabel];
    [self.contentView addSubview:infoLab];
    [infoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView).inset(15);
        make.top.equalTo(self.descLabel.mas_bottom).offset(28);
        make.height.equalTo(@19);
    }];
    
    self.seasonBtn = [HTTVPlayViewCellManager lgjeropj_seasonButton:self action:@selector(lgjeropj_onSeasonAction)];
    [self.contentView addSubview:self.seasonBtn];
    [self.seasonBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.centerY.equalTo(infoLab);
        make.width.equalTo(@100);
        make.height.equalTo(@28);
    }];
    
    self.line = [[UIView alloc] init];
    self.line.backgroundColor = [UIColor colorWithHexString:@"#3F3F5C"];
    [self.contentView addSubview:self.line];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(infoLab.mas_bottom).offset(13);
        make.height.equalTo(@1);
    }];
}

- (void)ht_updateCellWithData:(id)data {
    if ( data ) {
        
        HTTVDetailModel *model = (HTTVDetailModel *)data;
        
        self.titleLabel.attributedText = [self lgjeropj_getAttributeWithString:model.title lineSpace:3 font:[UIFont systemFontOfSize:18 weight:(UIFontWeightSemibold)] textColor:[UIColor whiteColor]];
        [self.starView lgjeropj_starCount:[model.rate floatValue]];
        self.levelLabel.text = [NSString stringWithFormat:@"%.1f",[model.rate floatValue]];
        
        self.countryLabel.attributedText = [self lgjeropj_getAttributeWithString:model.country lineSpace:2 font:HTPingFangRegularFont(14) textColor:[UIColor whiteColor]];
        self.tagsLabel.attributedText = [self lgjeropj_getAttributeWithString:model.tags lineSpace:2 font:HTPingFangRegularFont(14) textColor:[UIColor colorWithHexString:@"#999999"]];
        self.descLabel.attributedText = [self lgjeropj_getAttributeWithString:model.desc lineSpace:2 font:HTPingFangRegularFont(14) textColor:[UIColor colorWithHexString:@"#999999"]];
        
    }
    [self layoutIfNeeded];
}

- (void)setSchedule:(HTTVDetailSeasonModel *)schedule {
    _schedule = schedule;
    
    [self.seasonBtn setTitle:schedule.title forState:UIControlStateNormal];
    [self.seasonBtn setPosition:3 interval:2];
}

- (void)lgjeropj_onSeasonAction {
    if ( self.situationBlock ) {
        self.situationBlock(self.seasonBtn);
    }
}

- (CGFloat)ht_cellHeight {
    return CGRectGetMaxY(self.line.frame);
}

- (NSMutableAttributedString *)lgjeropj_getAttributeWithString:(NSString *)str lineSpace:(CGFloat)lineSpace font:(UIFont *)font textColor:(UIColor *)textColor {
    HTAttributedManager *manager = [[HTAttributedManager alloc] initWithText:str andFont:font andForegroundColor:textColor];
    [manager ht_addLineSpace:lineSpace andFirstLineHeadIndent:0 andAlignment:NSTextAlignmentLeft];
    
    return manager.contentMutableAttributed;
}

@end

//
//  HTMoivePlayViewCell.m
//  Hucolla
//
//  Created by mac on 2022/9/17.
//

#import "HTMoivePlayViewCell.h"
#import "HTMoviePlayViewManager.h"

@interface HTMoivePlayViewCell()

@property (nonatomic, strong) UILabel       * titleLabel;
@property (nonatomic, strong) HTStarLevelView       * starView;
@property (nonatomic, strong) UILabel       * levelLabel;
@property (nonatomic, strong) UILabel       * countryLabel;
@property (nonatomic, strong) UILabel       * tagsLabel;
@property (nonatomic, strong) UILabel       * starsLabel;
@property (nonatomic, strong) UILabel       * descLabel;

@end

@implementation HTMoivePlayViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)ht_addCellSubViews {
    
    self.backgroundColor = [UIColor clearColor];
    
    self.clipsToBounds = YES;
    
    self.titleLabel = [HTMoviePlayViewManager lgjeropj_titleLabel];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView).inset(14);
        make.top.equalTo(self.contentView).offset(20);
        make.height.greaterThanOrEqualTo(@21);
    }];
    
    self.starView = [HTMoviePlayViewManager lgjeropj_starView];
    [self.contentView addSubview:self.starView];
    [self.starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(14);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.width.equalTo(@(18*5+4*4));
        make.height.equalTo(@18);
    }];
    
    self.levelLabel = [HTMoviePlayViewManager lgjeropj_levelLabel];
    [self.contentView addSubview:self.levelLabel];
    [self.levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.starView.mas_right).offset(4);
        make.centerY.equalTo(self.starView);
        make.height.equalTo(@18);
        make.width.greaterThanOrEqualTo(@18);
    }];
    
    self.countryLabel = [HTMoviePlayViewManager lgjeropj_countryLabel];
    [self.contentView addSubview:self.countryLabel];
    [self.countryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView).inset(14);
        make.top.equalTo(self.starView.mas_bottom).offset(16);
        make.height.greaterThanOrEqualTo(@16);
    }];
    
    self.tagsLabel = [HTMoviePlayViewManager lgjeropj_tagsLabel];
    [self.contentView addSubview:self.tagsLabel];
    [self.tagsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView).inset(14);
        make.top.equalTo(self.countryLabel.mas_bottom).offset(6);
        make.height.greaterThanOrEqualTo(@16);
    }];
    
    self.starsLabel = [HTMoviePlayViewManager lgjeropj_starsLabel];
    [self.contentView addSubview:self.starsLabel];
    [self.starsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView).inset(14);
        make.top.equalTo(self.tagsLabel.mas_bottom).offset(6);
        make.height.greaterThanOrEqualTo(@16);
    }];
    
    UILabel *infoLab = [HTMoviePlayViewManager lgjeropj_infoLabel];
    [self.contentView addSubview:infoLab];
    [infoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView).inset(15);
        make.top.equalTo(self.starsLabel.mas_bottom).offset(24);
        make.height.equalTo(@18);
    }];
    
    self.descLabel = [HTMoviePlayViewManager lgjeropj_descLabel];
    [self.contentView addSubview:self.descLabel];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView).inset(15);
        make.top.equalTo(infoLab.mas_bottom).offset(6);
        make.height.greaterThanOrEqualTo(@16);
    }];
}

- (void)ht_updateCellWithData:(id)data {
    if ( data ) {
        
        if ( [data isKindOfClass:[HTMovieDetailModel class]] ) {
            
            HTMovieDetailModel *model = (HTMovieDetailModel *)data;
            
            self.titleLabel.attributedText = [self lgjeropj_getAttributeWithString:model.title lineSpace:3 font:[UIFont systemFontOfSize:18 weight:(UIFontWeightSemibold)] textColor:[UIColor whiteColor]];
            [self.starView lgjeropj_starCount:[model.rate floatValue]];
            self.levelLabel.text = [NSString stringWithFormat:@"%.1f",[model.rate floatValue]];
            
            self.countryLabel.attributedText = [self lgjeropj_getAttributeWithString:model.country lineSpace:2 font:HTPingFangRegularFont(14) textColor:[UIColor whiteColor]];
            self.tagsLabel.attributedText = [self lgjeropj_getAttributeWithString:model.tags lineSpace:2 font:HTPingFangRegularFont(14) textColor:[UIColor colorWithHexString:@"#999999"]];
            self.starsLabel.attributedText = [self lgjeropj_getAttributeWithString:model.stars lineSpace:2 font:HTPingFangRegularFont(14) textColor:[UIColor colorWithHexString:@"#999999"]];
            
            self.descLabel.attributedText = [self lgjeropj_getAttributeWithString:model.desc lineSpace:7 font:HTPingFangRegularFont(14) textColor:[UIColor colorWithHexString:@"#999999"]];
        }
        
    }
    [self layoutIfNeeded];
}



- (CGFloat)ht_cellHeight {
    return CGRectGetMaxY(self.descLabel.frame) + 10;
}

- (NSMutableAttributedString *)lgjeropj_getAttributeWithString:(NSString *)str lineSpace:(CGFloat)lineSpace font:(UIFont *)font textColor:(UIColor *)textColor {
    HTAttributedManager *manager = [[HTAttributedManager alloc] initWithText:str andFont:font andForegroundColor:textColor];
    [manager ht_addLineSpace:lineSpace andFirstLineHeadIndent:0 andAlignment:NSTextAlignmentLeft];
    
    return manager.contentMutableAttributed;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

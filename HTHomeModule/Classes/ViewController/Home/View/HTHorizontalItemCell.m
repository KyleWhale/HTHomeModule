//
//  HTHorizontalItemCell.m
//  Hucolla
//
//  Created by mac on 2022/9/14.
//

#import "HTHorizontalItemCell.h"
#import "HTHorizontalItemManager.h"

@interface HTHorizontalItemCell()

@property (nonatomic, strong) UIImageView      * imageView;
@property (nonatomic, strong) UILabel          * titleLabel;
@property (nonatomic, strong) UILabel         * rateLabel;
@property (nonatomic, strong) UILabel         * seasonLabel;
@property (nonatomic, strong) UIImageView     * camImageView;

@end

@implementation HTHorizontalItemCell

- (void)ht_addCellSubViews {
    
    self.imageView = [HTHorizontalItemManager lgjeropj_imageView];
    self.imageView.backgroundColor = [UIColor colorWithHexString:@"#3C3C3C"];
    [self.contentView addSubview:self.imageView];
    
    self.rateLabel = [[UILabel alloc] init];
    [self.contentView addSubview:self.rateLabel];
    
    self.camImageView = [HTHorizontalItemManager lgjeropj_camImageView];
    [self.contentView addSubview:self.camImageView];
    
    self.seasonLabel = [HTHorizontalItemManager lgjeropj_seasonLabel];
    [self.imageView addSubview:self.seasonLabel];
    
    self.titleLabel = [HTHorizontalItemManager lgjeropj_titleLabel];
    [self.contentView addSubview:self.titleLabel];
    
    CGFloat itemWid = (kScreenWidth - 10*4)/3;
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(0);
        make.height.equalTo(@(itemWid*10/7));
    }];
    
    [self.rateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView).offset(6);
        make.left.equalTo(self.imageView).offset(6);
        make.height.equalTo(@24);
        make.width.equalTo(@28);
    }];
    
    [self.camImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView).offset(6);
        make.right.equalTo(self.imageView).offset(-14);
        make.width.equalTo(@34);
        make.height.equalTo(@16);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView.mas_bottom).offset(4);
        make.left.right.equalTo(self.contentView);
        make.height.greaterThanOrEqualTo(@(15));
    }];
    
    [self.seasonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.imageView).offset(-5);
        make.left.right.equalTo(self.imageView).inset(6);
        make.height.equalTo(@24);
    }];
}

- (void)ht_updateCellWithData:(id)data {
    if ( data ) {
        HTHomeTrendingM20Model *model = (HTHomeTrendingM20Model *)data;
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:[UIImage imageNamed:@"icon_momtype_default"]];
        self.titleLabel.text = model.title;
        NSString * var_rate = [NSString stringWithFormat:@"%.1f",[model.rate floatValue]];
        self.rateLabel.attributedText = [HTHorizontalItemManager ht_rateAttribute:var_rate];
        self.rateLabel.hidden = [model.rate floatValue] == 0;
        NSString *message = AsciiString(@"CAM");
        if ( model.quality && [model.quality isEqualToString:message] ) {
            self.camImageView.hidden = NO;
        } else {
            self.camImageView.hidden = YES;
        }
        
        if ( model.ss_eps == nil ) {
            self.seasonLabel.hidden = YES;
        } else {
            self.seasonLabel.hidden = NO;
            NSString * var_season = model.ss_eps;
            if ( ![model.nw_flag isEqualToString:@""] || [model.update integerValue] > 0 ) {
                var_season = [NSString stringWithFormat:@"%@ %@ %@", AsciiString(@"NEW"), AsciiString(@"|"), model.ss_eps];
            }
            self.seasonLabel.attributedText = [HTHorizontalItemManager ht_seasonAttribute:var_season];
        }
    }
}

@end

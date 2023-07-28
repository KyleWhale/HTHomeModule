//
//  HTHomeWaterfallCell.m
//  Hucolla
//
//  Created by mac on 2022/9/14.
//

#import "HTHomeWaterfallCell.h"
#import "HTHomeWaterfallManager.h"

@interface HTHomeWaterfallCell()

@property (nonatomic, strong) UIImageView      * imageView;
@property (nonatomic, strong) UILabel          * titleLabel;
@property (nonatomic, strong) UIView          * gradientView;
@property (nonatomic, strong) UILabel         * rateLabel;
@property (nonatomic, strong) UILabel         * seasonLabel;
@property (nonatomic, strong) UIImageView     * camImageView;
@property (nonatomic, strong) CAGradientLayer * gradientLayer;

@end

@implementation HTHomeWaterfallCell

- (void)ht_addCellSubViews {
    
    self.backgroundColor = [UIColor colorWithHexString:@"#4F4F5A"];
    
    self.cornerRadius = 6;
    
    self.imageView = [HTHomeWaterfallManager lgjeropj_imageView];
    [self.contentView addSubview:self.imageView];
    
    CGFloat itemWid = (kScreenWidth - 10*3)/2;
    self.gradientView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, itemWid, 24*kScale)];
    [self.imageView addSubview:self.gradientView];
    
    self.gradientLayer = [HTHomeWaterfallManager lgjeropj_layer];
    [self.gradientView.layer addSublayer:self.gradientLayer];
    
    self.rateLabel = [[UILabel alloc] init];
    [self.contentView addSubview:self.rateLabel];
    
    self.camImageView = [HTHomeWaterfallManager lgjeropj_camImageView];
    [self.contentView addSubview:self.camImageView];
    
    self.seasonLabel = [HTHomeWaterfallManager lgjeropj_seasonLabel];
    [self.imageView addSubview:self.seasonLabel];
    
    self.titleLabel = [HTHomeWaterfallManager lgjeropj_titleLabel];
    [self.contentView addSubview:self.titleLabel];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.contentView);
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
        make.left.right.equalTo(self.contentView).inset(10);
        make.height.greaterThanOrEqualTo(@15);
    }];
    
    [self.gradientView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.imageView.mas_bottom);
        make.left.right.equalTo(self.imageView);
        make.height.equalTo(@(24*kScale));
    }];
    
    [self.seasonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.gradientView);
        make.left.right.equalTo(self.imageView).inset(6);
        make.height.equalTo(@24);
    }];
}

- (void)ht_updateCellWithData:(id)data {
    if ( data ) {
        if ( [data isKindOfClass:[HTWaterMovieTvModel class]] ) {
            HTWaterMovieTvModel *model = (HTWaterMovieTvModel *)data;
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:[UIImage imageNamed:@"icon_momtype_default"]];
            self.titleLabel.text = model.title;
            
            NSString * var_rate = [NSString stringWithFormat:@"%.1f",[model.rate floatValue]];
            self.rateLabel.attributedText = [HTHomeWaterfallManager ht_rateAttribute:var_rate];
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
                if ( ![model.nw_flag isEqualToString:@""] ) {
                    var_season = [NSString stringWithFormat:@"%@ %@ %@", AsciiString(@"NEW"), AsciiString(@"|"), model.ss_eps];
                }
                self.seasonLabel.attributedText = [HTHomeWaterfallManager ht_seasonAttribute:var_season];
            }
            
        }
    }
}

@end

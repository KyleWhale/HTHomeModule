//
//  HTLanguageCell.m
//  Hucolla
//
//  Created by dn on 2022/10/25.
//

#import "HTLanguageCell.h"

@interface HTLanguageCell()

@property (nonatomic, strong) UIImageView     * var_imgView;
@property (nonatomic, strong) UILabel         * var_titleLab;

@end


@implementation HTLanguageCell

- (void)ht_addCellSubViews {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    
    self.var_imgView = [[UIImageView alloc] init];
    [self.var_imgView sd_setImageWithURL:[LKFPrivateFunction lgjeropj_imageUrlFromNumber:212]];
    self.var_imgView.hidden = YES;
    [self.contentView addSubview:self.var_imgView];
    
    self.var_titleLab = [[UILabel alloc] init];
    self.var_titleLab.textColor = [UIColor whiteColor];
    self.var_titleLab.font = [UIFont systemFontOfSize:14 weight:(UIFontWeightSemibold)];
    [self.contentView addSubview:self.var_titleLab];
}

- (void)ht_updateCellWithData:(id)data {
    if (data) {
        HTSubtitlesModel *model = (HTSubtitlesModel *)data;
        _var_titleLab.text = model.lang;
        _var_imgView.hidden = !model.isSelect;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.var_imgView.frame = CGRectMake(25, CGRectGetMidY(self.bounds)-7, 14, 14);
    self.var_titleLab.frame = CGRectMake(49, CGRectGetMidY(self.bounds)-9, CGRectGetWidth(self.bounds) - 49 - 10, 18);
}

@end

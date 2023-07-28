//
//  HTSettingCell.m
//  Hucolla
//
//  Created by dn on 2022/10/25.
//

#import "HTSettingCell.h"

@interface HTSettingCell()

@property (nonatomic, strong) UILabel         * var_titleLab;

@end

@implementation HTSettingCell

- (void)ht_addCellSubViews {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    
    self.var_titleLab = [[UILabel alloc] init];
    _var_titleLab.numberOfLines = 2;
    [self.contentView addSubview:_var_titleLab];
}

- (void)ht_updateCellWithData:(id)data {
    _var_titleLab.attributedText = (NSAttributedString *)data;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.var_titleLab.frame = CGRectMake(26, CGRectGetMidY(self.bounds)-19, CGRectGetWidth(self.bounds) - 26 - 10, 38);
}

@end

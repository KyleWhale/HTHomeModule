//
//  HTSearchHistoryHotCell.m
//  Hucolla
//
//  Created by mac on 2022/9/14.
//

#import "HTSearchHistoryHotCell.h"

@interface HTSearchHistoryHotCell()

@property (nonatomic, strong) UILabel * numberLab;
@property (nonatomic, strong) UILabel * titleLabel;

@end

@implementation HTSearchHistoryHotCell

- (void)ht_addCellSubViews {
    
    self.numberLab = [HTKitCreate ht_labelWithText:@"1" andFont:[UIFont systemFontOfSize:16] andTextColor:[UIColor colorWithHexString:@"#999999"] andAligment:NSTextAlignmentLeft andNumberOfLines:1];
    [self.contentView addSubview:self.numberLab];
    
    self.titleLabel = [HTKitCreate ht_labelWithText:@"" andFont:[UIFont systemFontOfSize:14 weight:(UIFontWeightRegular)] andTextColor:[UIColor colorWithHexString:@"#999999"] andAligment:NSTextAlignmentLeft andNumberOfLines:0];
    [self.contentView addSubview:self.titleLabel];
    
    [self.numberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(9);
        make.bottom.equalTo(self.contentView);
        make.height.equalTo(@22);
        make.width.equalTo(@20);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.numberLab.mas_right).offset(1);
        make.centerY.equalTo(self.numberLab);
        make.width.mas_lessThanOrEqualTo(kScreenWidth/2.0-30);
    }];
}

- (void)setIndex:(NSInteger)index {
    _index = index;
    if ( index%2 == 0 ) {
        self.numberLab.text = [NSString stringWithFormat:@"%zd", index/2 + 5];
    } else {
        self.numberLab.text = [NSString stringWithFormat:@"%zd", (index+1)/2];
    }
    
    if ( index == 1 ) {
        self.numberLab.textColor = [UIColor colorWithHexString:@"#EB2B2B"];
    } else if ( index == 3 ) {
        self.numberLab.textColor = [UIColor colorWithHexString:@"#EB872B"];
    } else {
        self.numberLab.textColor = [UIColor colorWithHexString:@"#999999"];
    }
}

- (void)ht_updateCellWithData:(id)data {
    if ( data ) {
        self.titleLabel.text = (NSString *)data;
    }
}

@end

//
//  HTSearchAssociationCell.m
//  Hucolla
//
//  Created by mac on 2022/9/15.
//

#import "HTSearchAssociationCell.h"
#import "HTAssociationCellManager.h"

@interface HTSearchAssociationCell()

@property (nonatomic, strong) UILabel       * searchLabel;

@end

@implementation HTSearchAssociationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)ht_addCellSubViews {
    
    self.backgroundColor = [UIColor clearColor];
    
    UIImageView *imgV = [HTAssociationCellManager lgjeropj_imageView];
    [self.contentView addSubview:imgV];
    [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@16);
        make.left.equalTo(self.contentView).offset(16);
        make.bottom.equalTo(self.contentView).offset(-11);
    }];
    
    self.searchLabel = [HTAssociationCellManager lgjeropj_searchLabel];
    [self.contentView addSubview:self.searchLabel];
    [self.searchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgV.mas_right).offset(10);
        make.centerY.equalTo(imgV);
        make.right.equalTo(self.contentView).offset(-16);
        make.height.equalTo(@20);
    }];
}

- (void)ht_updateCellWithData:(id)data {
    if ( data ) {
        self.searchLabel.text = (NSString *)data;
    } 
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

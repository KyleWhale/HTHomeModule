//
//  HTTVPlayEpsViewCell.m
//  Hucolla
//
//  Created by mac on 2022/9/22.
//

#import "HTTVPlayEpsViewCell.h"
#import "HTTVDetailEpsModel.h"
#import "HTTVEpsViewCellManager.h"

@interface HTTVPlayEpsViewCell()

@property (nonatomic, strong) UIView        * conView;
@property (nonatomic, strong) UILabel       * titleLabel;
@property (nonatomic, strong) UILabel       * indexLabel;

@end

@implementation HTTVPlayEpsViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)ht_addCellSubViews {
    
    self.backgroundColor = [UIColor clearColor];
    
    self.conView = [HTTVEpsViewCellManager lgjeropj_conView];
    [self.contentView addSubview:self.conView];
    [self.conView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(10);
        make.height.equalTo(@60);
    }];
    
    self.indexLabel = [HTTVEpsViewCellManager lgjeropj_indexLabel];
    [self.conView addSubview:self.indexLabel];
    [self.indexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.conView).offset(16);
        make.top.equalTo(self.conView).offset(10);
        make.width.greaterThanOrEqualTo(@100);
        make.height.equalTo(@19);
    }];
    
    self.titleLabel = [HTTVEpsViewCellManager lgjeropj_titleLabel];
    [self.conView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.conView).inset(16);
        make.top.equalTo(self.indexLabel.mas_bottom).offset(4);
        make.height.equalTo(@16);
    }];
}

- (void)ht_updateCellWithData:(id)data {
    if ( data ) {
        HTTVDetailEpsModel *model = (HTTVDetailEpsModel *)data;
        NSString *message = LocalString(@"EPS", nil);
        self.indexLabel.text = [NSString stringWithFormat:@"%@ %@", message, model.eps_num];
        self.titleLabel.text = model.title;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    self.indexLabel.textColor = selected ? [UIColor colorWithHexString:@"#3CDEF4"]:[UIColor whiteColor];
    self.titleLabel.textColor = selected ? [UIColor colorWithHexString:@"#3CDEF4"]:[UIColor whiteColor];
    // Configure the view for the selected state
}

@end

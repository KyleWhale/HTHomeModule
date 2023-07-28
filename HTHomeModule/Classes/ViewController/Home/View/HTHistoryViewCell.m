//
//  HTHistoryViewCell.m
//  Hucolla
//
//  Created by mac on 2022/9/14.
//

#import "HTHistoryViewCell.h"
#import "HTDBHistoryModel.h"
#import "HTHistoryCellManager.h"

@interface HTHistoryViewCell()

@property (nonatomic, strong) UIView            * conView;
@property (nonatomic, strong) UIImageView       * bookImageView;
@property (nonatomic, strong) UILabel           * titleLabel;
@property (nonatomic, strong) UILabel           * watchedLabel;
@property (nonatomic, strong) UIImageView       * playImageView;
@property (nonatomic, strong) UIButton          * selectBtn;
@property (nonatomic, assign) BOOL                isEdit;
@property (nonatomic, strong) HTDBHistoryModel  * dataModel;

@end

@implementation HTHistoryViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)ht_addCellSubViews {
    
    self.backgroundColor = [UIColor clearColor];
    
    self.conView = [HTHistoryCellManager lgjeropj_conView];
    [self.contentView addSubview:self.conView];
    [self.conView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView).inset(16);
        make.top.equalTo(self.contentView).offset(16);
        make.bottom.equalTo(self.contentView);
    }];
    
    self.bookImageView = [HTHistoryCellManager lgjeropj_imageView];
    [self.conView addSubview:self.bookImageView];
    [self.bookImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.conView);
        make.width.equalTo(@90);
    }];
    
    self.playImageView = [HTHistoryCellManager lgjeropj_playImageView];
    [self.conView addSubview:self.playImageView];
    [self.playImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@30);
        make.center.equalTo(self.bookImageView);
    }];
    
    self.titleLabel = [HTHistoryCellManager lgjeropj_titleLabel];
    [self.conView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bookImageView.mas_right).offset(10);
        make.top.equalTo(self.conView).offset(10);
        make.right.equalTo(self.conView).offset(-10);
        make.height.equalTo(@16);
    }];
    
    UILabel *watLab = [HTHistoryCellManager lgjeropj_watchLabel];
    [self.conView addSubview:watLab];
    [watLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bookImageView.mas_right).offset(10);
        make.bottom.equalTo(self.conView).offset(-10);
    }];
    
    self.watchedLabel = [HTHistoryCellManager lgjeropj_watchedLabel];
    [self.conView addSubview:self.watchedLabel];
    [self.watchedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(watLab.mas_right).offset(5);
        make.bottom.equalTo(self.conView).offset(-10);
        make.height.equalTo(@14);
    }];
    
    self.selectBtn = [HTHistoryCellManager lgjeropj_selectButton:self action:@selector(lgjeropj_onSelectAction:)];
    [self.conView addSubview:self.selectBtn];
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@30);
        make.centerY.equalTo(self.conView);
        make.right.equalTo(self.conView).offset(-15);
    }];
}

- (void)ht_updateCellWithData:(id)data {
    if ( data ) {
        HTDBHistoryModel *model = (HTDBHistoryModel *)data;
        self.dataModel = model;
        
        [self.bookImageView sd_setImageWithURL:[NSURL URLWithString:model.var_cover] placeholderImage:[UIImage imageNamed:@"icon_momtype_default"]];
        self.titleLabel.text = model.var_title;
        
        if( ![model.var_seeTime isEqualToString:@""] && ![model.var_totalTime isEqualToString:@""] ) {
            if ( [model.var_totalTime floatValue] > 0.0 ) {
                CGFloat var_w = [model.var_seeTime floatValue]/[model.var_totalTime floatValue];
                if ( var_w > 1.0 ) {
                    var_w = 1.0;
                }
                self.watchedLabel.text = [NSString stringWithFormat:@"%.f%%", var_w*100];
            } else {
                self.watchedLabel.text = @"0%";
            }
        } else {
            self.watchedLabel.text = @"0%";
        }
        
        if ( self.isEdit ) {
            self.selectBtn.selected = model.var_isSelect;
        }
    }
}

- (void)lgjeropj_onSelectAction:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    
    self.dataModel.var_isSelect = sender.isSelected;
    
    if ( self.selectBlock ) {
        self.selectBlock(sender.isSelected);
    }
}

- (void)lgjeropj_selectEdit:(BOOL)isEdit {
    self.isEdit = isEdit;
    self.selectBtn.hidden = !isEdit;
    if (!isEdit) {
        self.selectBtn.selected = NO;
        self.dataModel.var_isSelect = NO;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

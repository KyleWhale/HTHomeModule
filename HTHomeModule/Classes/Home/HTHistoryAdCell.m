//
//  HTHistoryAdCell.m
//  Hucolla
//
//  Created by mac on 2022/9/13.
//

#import "HTHistoryAdCell.h"
#import "HTAdvertisementView.h"

@interface HTHistoryAdCell()

@property (nonatomic, strong) HTAdvertisementView *adsView;

@end

@implementation HTHistoryAdCell

- (void)ht_addCellSubViews {
    
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    self.adsView = [[HTAdvertisementView alloc] init];
    [self.contentView addSubview:self.adsView];
    [self.adsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
        make.width.equalTo(@300);
        make.height.equalTo(@250);
    }];
}

- (void)setCancelBlock:(BLOCK_dataBlock)cancelBlock {
    _cancelBlock = cancelBlock;
    self.adsView.cancelBlock = cancelBlock;
}

- (void)setAdStartBlock:(BLOCK_dataBlock)adStartBlock {
    _adStartBlock = adStartBlock;
    self.adsView.adStartBlock = adStartBlock;
}

@end

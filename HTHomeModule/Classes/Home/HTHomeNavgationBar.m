//
//  HTHomeNavgationBar.m
//  Hucolla
//
//  Created by mac on 2022/9/13.
//

#import "HTHomeNavgationBar.h"


@implementation HTHomeNavgationBar

- (void)ht_addViewSubViews {
    self.backgroundColor = kNavBGColor;
    
    self.var_shareBtn = [HTKitCreate ht_buttonWithImage:[LKFPrivateFunction lgjeropj_imageUrlFromNumber:274] andSelectImage:nil];
    [self addSubview:self.var_shareBtn];
    
    self.var_historyBtn = [HTKitCreate ht_buttonWithImage:[LKFPrivateFunction lgjeropj_imageUrlFromNumber:101] andSelectImage:nil];
    [self addSubview:self.var_historyBtn];
    
    self.var_searchView = [[HTSearchView alloc] init];
    [self addSubview:self.var_searchView];
    
    [self.var_shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.bottom.equalTo(self).offset(-10);
        make.width.equalTo(@30);
        make.height.equalTo(@36);
    }];
    
    [self.var_historyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        make.bottom.equalTo(self).offset(-10);
        make.width.equalTo(@36);
        make.height.equalTo(@36);
    }];
    
    [self.var_searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.var_shareBtn.mas_right).offset(15);
        make.right.equalTo(self.var_historyBtn.mas_left).offset(-15);
        make.height.equalTo(@36);
        make.bottom.equalTo(self).offset(-10);
    }];
}

@end

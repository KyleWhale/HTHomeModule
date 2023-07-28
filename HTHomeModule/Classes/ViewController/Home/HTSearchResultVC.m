//
//  HTSearchResultVC.m
//  Hucolla
//
//  Created by mac on 2022/9/14.
//

#import "HTSearchResultVC.h"
#import <AppLovinSDK/AppLovinSDK.h>
#import "HTMoivePlayViewController.h"
#import "HTAdvertBannerView.h"
#import "HTSearchResultViewManager.h"
#import "HTHomePointManager.h"
#import "HTHttpRequest.h"

@interface HTSearchResultVC ()<UICollectionViewDelegate, UICollectionViewDataSource,MAAdViewAdDelegate,MAAdRequestDelegate>

@property (nonatomic, strong) UICollectionView              * collectionView;
@property (nonatomic, strong) HTAdvertBannerView            * var_bannerView;
@property (nonatomic, assign) BOOL                            var_haveAds;

@end


@implementation HTSearchResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.var_haveAds = ![HTCommonConfiguration lgjeropj_shared].BLOCK_vipBlock();
    [self lgjeropj_addSubViews];
}

- (void)lgjeropj_addSubViews {
    
    self.collectionView = [HTSearchResultViewManager lgjeropj_collectionView:self];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view);
    }];
        
    if (self.var_haveAds) {
        self.var_bannerView = [[HTAdvertBannerView alloc] init];
        self.var_bannerView.backgroundColor = kMainColor;
        [self.view addSubview:self.var_bannerView];
        [self.var_bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(50);
            make.width.mas_equalTo(320);
            make.centerX.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).offset(-50);
        }];
    }
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    //  1、结果数大于9 有广告分3个区 无广告1个区；2、结果数小于等于于9 有广告分2个区 无广告1个区；
    NSInteger count = 0;
    if ( self.var_haveAds ) {
        if ( self.resultModel ) {
            if ( self.resultModel.movie_tv_list.count > 9 ) {
                count = 3;
            } else {
                count = 2;
            }
        }
    } else {
        count = 1;
    }
    return count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    NSInteger count = 0;
    if ( self.var_haveAds ) {
        if ( self.resultModel ) {
            if ( self.resultModel.movie_tv_list.count > 9 ) {
                if ( section == 0 ) {
                    count = 9;
                } else if ( section == 1 ) {
                    count = 1;
                } else {
                    count = self.resultModel.movie_tv_list.count - 9;
                }
            } else {
                if ( section == 0 ) {
                    count = self.resultModel.movie_tv_list.count;
                } else {
                    count = 1;
                }
            }
        }
    } else {
        count = self.resultModel.movie_tv_list.count;
    }
    
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    NSInteger index = 0;
    if ( self.var_haveAds ) {
        
        index = indexPath.row;
        
        if ( indexPath.section == 1 ) {
            HTHomeAdsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HTHomeAdsCell class]) forIndexPath:indexPath];
            cell.cancelBlock = ^(id data) {
                self.var_haveAds = NO;
                [collectionView reloadData];
            };
            
            cell.adStartBlock = ^(id data) {
                [HTCommonConfiguration lgjeropj_shared].BLOCK_toPremiumBlock(18);
            };
            
            return cell;
        }
        else if ( indexPath.section == 2 ) {
            index = indexPath.row + 9;
        }
    } else {
        index = indexPath.row;
    }
    
    HTSearchMovieTvModel *model = self.resultModel.movie_tv_list[index];
    
    HTHomeNineItemsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HTHomeNineItemsCell class]) forIndexPath:indexPath];
    [cell ht_updateCellWithData:model];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = 0;
    if ( self.var_haveAds ) {
        
        index = indexPath.row;
        
        if ( indexPath.section == 1 ) {
            return;
        }
    } else {
        index = indexPath.row;
    }
    
    BOOL var_isTType = NO;
    HTSearchMovieTvModel *model = self.resultModel.movie_tv_list[index];
    if ( [model.data_type integerValue] == 3 ) {
        var_isTType = YES;
    }
    HTMoivePlayViewController *vc = [[HTMoivePlayViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.source = @"4";
    vc.var_mId = model.ID;
    vc.cover = model.cover;
    vc.var_isTType = var_isTType;
    [self.navigationController pushViewController:vc animated:YES];
    // 埋点
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:@"search_result_cl_movies" forKey:@"pointname"];
    [params setValue:@(index+1) forKey:AsciiString(@"order")];
    [params setValue:self.resultModel.var_word forKey:AsciiString(@"word")];
    [params setValue:@"5" forKey:AsciiString(@"kid")];
    if (self.resultModel.var_type > 0) {
        [params setValue:@(self.resultModel.var_type) forKey:AsciiString(@"type")];
    }
    [params setValue:model.ID forKey:@"movie_id"];
    NSString *dataType = model.data_type;
    if (dataType.intValue == 2 || dataType.intValue == 3) {
        dataType = @"2";
    }else if(dataType.intValue == 4) {
        dataType = @"3";
    }
    [params setValue:dataType forKey:@"movie_type"];
    [params setValue:model.title forKey:@"movie_name"];
    [HTHomePointManager lgjeropj_maidianRequestWithParams:params];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ( self.var_haveAds ) {
        
        if ( indexPath.section == 1 ) {
            return CGSizeMake(kScreenWidth, 280);
        }
    }
    
    CGFloat itemWid = (kScreenWidth - 10*4)/3;
//    if ( isPad ) {// 预留方法 iPad可以显示更多内容
//        itemWid = (kScreenWidth - 10*5)/4;
//    }
    return CGSizeMake(itemWid, itemWid*10/7 +32);
}

- (void)setResultModel:(HTSearchResultModel *)resultModel {
    _resultModel = resultModel;
    
    [self.collectionView reloadData];
}

#pragma mark - MAAdViewAdDelegate Protocol

- (void)didStartAdRequestForAdUnitIdentifier:(NSString *)adUnitIdentifier {
    NSLog(@"店家 %@",adUnitIdentifier);
}

- (void)didLoadAd:(MAAd *)ad {}

- (void)didFailToLoadAdForAdUnitIdentifier:(NSString *)adUnitIdentifier withError:(MAError *)error {
    NSLog(@"Load error %@",error.description);
}

- (void)didClickAd:(MAAd *)ad {
    NSLog(@"店家 ad");
}

- (void)didFailToDisplayAd:(MAAd *)ad withError:(MAError *)error {
    NSLog(@"Display error %@",error.description);
}

- (void)didDisplayAd:(nonnull MAAd *)ad {}

- (void)didHideAd:(nonnull MAAd *)ad {}


- (void)didExpandAd:(MAAd *)ad {}

- (void)didCollapseAd:(MAAd *)ad {}

@end

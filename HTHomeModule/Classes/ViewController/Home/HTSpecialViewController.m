//
//  HTSpecialViewController.m
//  Hucolla
//
//  Created by mac on 2022/9/14.
//

#import "HTSpecialViewController.h"
#import "HTHomeNineItemsCell.h"
#import "HTSearchViewController.h"
#import "HTMoivePlayViewController.h"
#import "HTSpecialViewModel.h"
#import "HTHomeAdsCell.h"
#import "HTAdvertBannerView.h"
#import "HTHttpRequest.h"
#import "HTSpecialModel.h"
#import "HTHomeTrendingM20Model.h"

@interface HTSpecialViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView              * collectionView;
@property (nonatomic, strong) NSMutableArray                * dataArray;
@property (nonatomic, assign) NSInteger                       page;
@property (nonatomic, assign) BOOL                            isMore;
@property (nonatomic, strong) HTSpecialViewModel            * viewModel;
@property (nonatomic, assign) BOOL                            var_haveAds;
@property (nonatomic, strong) HTAdvertBannerView            * var_bannerView;

@end

@implementation HTSpecialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak typeof(self) weakSelf = self;;
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"NTFCTString_UpdateVIPStatusAndProductsInfo" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.var_haveAds = ![HTCommonConfiguration lgjeropj_shared].BLOCK_vipBlock();
            [weakSelf.collectionView reloadData];
            weakSelf.var_bannerView.hidden = !weakSelf.var_haveAds;
            [weakSelf.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(weakSelf.view).offset(weakSelf.var_haveAds ? -50 : 0);
            }];
        });
    }];
    self.var_haveAds = ![HTCommonConfiguration lgjeropj_shared].BLOCK_vipBlock();
    [self ht_addDefaultLeftItem];
    [self ht_addRightBtnWithImage:[LKFPrivateFunction lgjeropj_imageUrlFromNumber:165]];
    [self lgjeropj_addSubViews];
    [self lgjeropj_bindViewModel];
    [self lgjeropj_headerRefresh];
    [self.viewModel lgjeropj_reportShowMaidian];
}

- (void)ht_rightItemClicked:(UIButton *)sender {
    
    HTSearchViewController *vc = [[HTSearchViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.var_source = 5;
    [self.navigationController pushViewController:vc animated:YES];
    //埋点
    [self.viewModel lgjeropj_clickMTWithKid:@"2" andMID:@"0" andMname:@"0"];
}

- (void)lgjeropj_addSubViews {
    
    self.collectionView = [HTKitCreate ht_collectionViewWithDelegate:self andIsVertical:YES andLineSpacing:10 andColumnSpacing:5 andItemSize:CGSizeZero andIsEstimated:NO andSectionInset:UIEdgeInsetsMake(0, 10, 0, 10)];
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(lgjeropj_headerRefresh)];
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(lgjeropj_footerRefresh)];
    [self.collectionView registerClass:[HTHomeNineItemsCell class] forCellWithReuseIdentifier:NSStringFromClass([HTHomeNineItemsCell class])];
    [self.collectionView registerClass:[HTHomeAdsCell class] forCellWithReuseIdentifier:NSStringFromClass([HTHomeAdsCell class])];
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

- (void)lgjeropj_headerRefresh {
    
    self.var_haveAds = ![HTCommonConfiguration lgjeropj_shared].BLOCK_vipBlock();
    
    if ( self.var_speId == nil ) {
        [self.collectionView.mj_header endRefreshing];
        return;
    }
    self.page = 1;
    NSDictionary *dic = @{AsciiString(@"id"):self.var_speId,AsciiString(@"page"):@(self.page),AsciiString(@"page_size"):@"20"};
    [self ht_specialRequest:dic];
}

- (void)lgjeropj_footerRefresh {
    if ( self.var_speId == nil ) {
        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    if ( self.isMore ) {
        self.page = self.page + 1;
        NSDictionary *dic = @{AsciiString(@"id"):self.var_speId,AsciiString(@"page"):@(self.page),AsciiString(@"page_size"):@"20"};
        [self ht_specialRequest:dic];
    } else {
        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
    }
}

- (void)ht_specialRequest:(NSDictionary *)params {
    
    [[HTHttpRequest sharedManager] ht_post:[NSString stringWithFormat:@"%d", 253] andParameters:params andCompletion:^(HTResponseModel *model, NSError * _Nullable error) {
        
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        if ( error == nil ) {
            if ( model.status == 200 ) {
                HTSpecialModel *var_model = [HTSpecialModel yy_modelWithJSON:model.data];
                if ( self.page == 1 ) {
                    self.dataArray = [NSMutableArray arrayWithArray:var_model.minfo];
                } else {
                    [self.dataArray addObjectsFromArray:var_model.minfo];
                }
                if ( self.dataArray.count < var_model.total ) {
                    self.isMore = YES;
                } else {
                    self.isMore = NO;
                    [self.collectionView.mj_footer endRefreshingWithNoMoreData];
                }
                [self.collectionView reloadData];
            } else {
                [SVProgressHUD showInfoWithStatus:model.msg];
            }
        }
    }];
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    NSInteger count = 0;
    if (self.var_haveAds) {
        if ( self.dataArray.count > 9 ) {
            count = 3;
        } else {
            count = 2;
        }
    } else {
        count = 1;
    }
    return count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    NSInteger count = 0;
    if ( self.var_haveAds ) {
        if (self.dataArray.count > 9) {
            if ( section == 0 ) {
                count = 9;
            } else if (section == 1) {
                count = 1;
            } else {
                count = self.dataArray.count - 9;
            }
        } else {
            if (section == 0) {
                count = self.dataArray.count;
            } else {
                count = 1;
            }
        }
    } else {
        count = self.dataArray.count;
    }
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    NSInteger index = 0;
    if (self.var_haveAds) {
        
        index = indexPath.row;
        if (indexPath.section == 1) {
            HTHomeAdsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HTHomeAdsCell class]) forIndexPath:indexPath];
            __weak typeof(self) weakSelf = self;
            cell.cancelBlock = ^(id data) {
                weakSelf.var_haveAds = NO;
                [weakSelf.collectionView reloadData];
            };
            cell.adStartBlock = ^(id data) {
                [HTCommonConfiguration lgjeropj_shared].BLOCK_toPremiumBlock(18);
            };
            return cell;
        } else if ( indexPath.section == 2 ) {
            index = indexPath.row + 9;
        }
    } else {
        index = indexPath.row;
    }

    HTHomeTrendingM20Model *model = self.dataArray[index];
    HTHomeNineItemsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HTHomeNineItemsCell class]) forIndexPath:indexPath];
    [cell ht_updateCellWithData:model];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger index = 0;
    if (self.var_haveAds) {
        index = indexPath.row;
        if (indexPath.section == 1) {
            return;
        }
    } else {
        index = indexPath.row;
    }

    HTHomeTrendingM20Model *model = self.dataArray[index];
    BOOL var_isTType = NO;
    if ( model.ss_eps && model.ss_eps.length > 0 ) {
        var_isTType = YES;
    }
    
    HTMoivePlayViewController *vc = [[HTMoivePlayViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.source = @"10";
    vc.var_mId = model.ID;
    vc.cover = model.cover;
    vc.var_isTType = var_isTType;
    [self.navigationController pushViewController:vc animated:YES];
    //埋点
    [self.viewModel lgjeropj_clickMTWithKid:@"1" andMID:model.ID andMname:model.title];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    if (section == 0) {
        return UIEdgeInsetsMake(10, 0, 0, 0);
    }
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.var_haveAds) {
        if (indexPath.section == 1) {
            return CGSizeMake(kScreenWidth, 280);
        }
    }
    // 九宫格
    CGFloat itemWid = (kScreenWidth - 10*4)/3;
//    if ( isPad ) {// 预留方法 iPad可以显示更多内容
//        itemWid = (kScreenWidth - 10*5)/4;
//    }
    return CGSizeMake(itemWid, itemWid*10/7 +32);
}

- (void)lgjeropj_bindViewModel {
    
    self.viewModel = [[HTSpecialViewModel alloc] init];
    self.viewModel.type = self.type;
    self.viewModel.var_speId = self.var_speId;
}

@end

//
//  HTHomeViewController.m
//  Hucolla
//
//  Created by mac on 2022/4/14.
//

#import "HTHomeViewController.h"
#import "HTSpecialViewController.h"
#import "HTHistoryViewController.h"
#import "HTSearchViewController.h"
#import "HTMoivePlayViewController.h"
#import "HTHomeNavgationBar.h"
#import "HTPlayerHistoryView.h"
#import "HTDBHistoryModel.h"
#import "AppDelegate.h"
#import "HTHomeViewModel.h"
#import "HTHomeViewManager.h"
#import "HTHomeBuriedManager.h"
#import <StoreKit/StoreKit.h>
#import "HTHomeTrendingModel.h"
#import "HTHomeCompositeModel.h"
#import "HTHttpRequest.h"
#import "HTHomeModel.h"

@interface HTHomeViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, HTSearchViewDelegate,HTCollectionWaterFlowLayoutDelegate>

@property (nonatomic, strong) HTHomeNavgationBar            * navgationBar;
@property (nonatomic, strong) UICollectionView              * collectionView;
@property (nonatomic, strong) HTPlayerHistoryView           * historyView;
@property (nonatomic, strong) HTHomeViewModel               * homeViewModel;

@end

@implementation HTHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self lgjeropj_addSubViews];
    [self lgjeropj_bindViewModel];
    [self lgjeropj_headerRefresh];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lgjeropj_onPaySuccessNoti:) name:@"NTFCTString_IPASuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lgjeropj_showkaishisuoyou) name:@"NTFCTString_showVipGuide" object:nil];
    __weak typeof(self) weakSelf = self;
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"NTFCTString_AdHiddenNotify" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        [weakSelf lgjeropj_storeReview];
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lgjeropj_shareApp) name:@"NTFCTString_shareApp" object:nil];
    @weakify(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"NTFCTString_AdShowNotify" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self);
        [self.historyView ht_endTimer];
    }];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"NTFCTString_AdHiddenNotify" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self);
        [self.historyView ht_startTimer];
    }];
}

- (void)lgjeropj_shareApp
{
    [self lgjeropj_onShareAction];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.homeViewModel.var_haveAds = ![HTCommonConfiguration lgjeropj_shared].BLOCK_vipBlock();
    [self.collectionView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([HTCommonConfiguration lgjeropj_shared].BLOCK_switchStateBlock() && ![[NSUserDefaults standardUserDefaults] boolForKey:@"udf_NotificationGuide"]) {
        [self lgjeropj_showkaishisuoyou];
    }
    NSInteger isGuide = [[NSUserDefaults standardUserDefaults] integerForKey:@"udf_Show_Guide"];
    if (isGuide == 1 && [HTCommonConfiguration lgjeropj_shared].BLOCK_vipBlock()) {
        [self lgjeropj_storeReview];
    }
}

- (void)lgjeropj_addSubViews {
    
    self.navgationBar = [[HTHomeNavgationBar alloc] init];
    self.navgationBar.var_searchView.delegate = self;
    [self.navgationBar.var_shareBtn addTarget:self action:@selector(lgjeropj_onShareAction) forControlEvents:UIControlEventTouchUpInside];
    [self.navgationBar.var_historyBtn addTarget:self action:@selector(lgjeropj_onHistoryAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.navgationBar];
    [self.navgationBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(kHJBottomHeight>0?((kStatusHeight>0?kStatusHeight:44) + 56):76);
    }];
        
    self.collectionView = [HTHomeViewManager lgjeropj_collectionView:self];
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(lgjeropj_headerRefresh)];
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(lgjeropj_footerRefresh)];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.navgationBar.mas_bottom);
    }];
    
    NSArray *var_array = [[HTDBHistoryModel alloc] ht_getAllData];
    if ( var_array.count > 0 ) {
        HTDBHistoryModel *model = var_array.firstObject;
        if ( model ) {
            CGFloat hei = isPad ? 60*kScale:60;
            self.historyView = [[HTPlayerHistoryView alloc] init];
            [self.view addSubview:self.historyView];
            [self.historyView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@(kScreenWidth - 30));
                make.height.equalTo(@(hei));
                make.centerX.equalTo(self.view);
                make.bottom.equalTo(self.view).offset(-15);
            }];
            [self.historyView ht_updateViewWithData:model];
            [self.historyView ht_startTimer];
            @weakify(self);
            self.historyView.playBlock = ^{
                @strongify(self);
                //埋点
                [HTHomeBuriedManager lgjeropj_homeClickNewWithKid:@"9" andCtype:@"1" andCId:model.var_mId andCname:model.var_title andSecname:@"0" andSecdisplayname:@"0" andSecId:@"0"];
                [self.historyView removeFromSuperview];
                self.historyView = nil;
                
                HTMoivePlayViewController *vc = [[HTMoivePlayViewController alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                vc.source = @"5";
                vc.var_mId = model.var_mId;
                vc.cover = model.var_cover;
                vc.var_isTType = model.var_isTV.intValue;
                [self.navigationController pushViewController:vc animated:YES];
            };
            self.historyView.cancelBlock = ^(BOOL click) {
                @strongify(self);
                if ( click ) {
                    //埋点
                    [HTHomeBuriedManager lgjeropj_homeClickNewWithKid:@"10" andCtype:@"0" andCId:@"0" andCname:@"0" andSecname:@"0" andSecdisplayname:@"0" andSecId:@"0"];
                }
                [self.historyView removeFromSuperview];
                self.historyView = nil;
            };
        }
    }
}

- (BOOL)ht_searchViewShouldBeginEditing:(HTSearchView *)searchView {
    //埋点
    [HTHomeBuriedManager lgjeropj_homeClickNewWithKid:@"1" andCtype:@"0" andCId:@"0" andCname:@"0" andSecname:@"0" andSecdisplayname:@"0" andSecId:@"0"];
    
    HTSearchViewController *vc = [[HTSearchViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.var_source = 5;
    [self.navigationController pushViewController:vc animated:YES];
    return NO;
}

- (void)lgjeropj_onShareAction {
    //埋点
    [HTHomeBuriedManager lgjeropj_homeClickNewWithKid:@"2" andCtype:@"0" andCId:@"0" andCname:@"0" andSecname:@"0" andSecdisplayname:@"0" andSecId:@"0"];
    //分享的标题
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *displayName = [infoDictionary objectForKey:AsciiString(@"CFBundleDisplayName")];
    NSString *textToShare = self.homeViewModel.shareText ? :displayName;
    //分享的图片
    UIImage *imageToShare = [UIImage imageNamed:@"icon_momtype_default"];
    //分享的url
    NSURL *urlToShare = [NSURL URLWithString:self.homeViewModel.shareLink];

    NSArray *activityItems = @[textToShare, urlToShare];

    if (imageToShare) {
        activityItems = @[textToShare,imageToShare, urlToShare];
    }
        
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    if (isPad) {
        activityVC.popoverPresentationController.sourceView = self.view;
        activityVC.popoverPresentationController.sourceRect = self.navgationBar.var_shareBtn.frame;
        activityVC.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;
    }
    [self presentViewController:activityVC animated:YES completion:nil];
        
    //分享之后的回调
    activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {};
}

- (void)lgjeropj_onHistoryAction {
    //埋点
    [HTHomeBuriedManager lgjeropj_homeClickNewWithKid:@"3" andCtype:@"0" andCId:@"0" andCname:@"0" andSecname:@"0" andSecdisplayname:@"0" andSecId:@"0"];
    
    HTHistoryViewController *vc = [[HTHistoryViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)lgjeropj_headerRefresh
{
    self.homeViewModel.startTime = [NSDate date];
    NSString *massage = AsciiString(@"p1");
    [self ht_homeRequest:@{AsciiString(@"page"):@"1",AsciiString(@"page_size"):@"20",massage:@"0"}];
    
    self.homeViewModel.var_water_page = 1;
    NSDictionary *param = @{AsciiString(@"page"):@(self.homeViewModel.var_water_page),
                            AsciiString(@"page_size"):@"20",
                            AsciiString(@"type"):@"100",
                            AsciiString(@"stageflag"):@"3"};
    [self ht_homeWaterRequest:param];
}

- (void)lgjeropj_footerRefresh
{
    if ( self.homeViewModel.var_isMore ) {
        self.homeViewModel.var_water_page = self.homeViewModel.var_water_page + 1;
        NSDictionary *param = @{AsciiString(@"page"):@(self.homeViewModel.var_water_page),
                                AsciiString(@"page_size"):@"20",
                                AsciiString(@"type"):@"100",
                                AsciiString(@"stageflag"):@"3"};
        [self ht_homeWaterRequest:param];
    } else {
        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
    }
}

- (void)lgjeropj_showkaishisuoyou {
    
    [HTCommonConfiguration lgjeropj_shared].BLOCK_showGuidePageBlock();
}

- (void)lgjeropj_onPaySuccessNoti:(NSNotification *)noti {
    self.homeViewModel.var_haveAds = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}

- (void)lgjeropj_storeReview {
    
    NSMutableArray *dataArr = [[NSMutableArray alloc] init];
    NSArray *array = [[HTDBHistoryModel alloc] ht_getAllData];
    for (int i = 0; i < array.count; i++) {
        HTDBHistoryModel *model = array[i];
        BOOL isHaveModel = NO;
        if (dataArr.count > 0) {
            for (int j = 0 ; j < dataArr.count; j++) {
                HTDBHistoryModel *var_model = dataArr[j];
                if ([model.var_mId isEqualToString:var_model.var_mId]) {
                    isHaveModel = YES;
                    break;
                }
            }
        }
        if (!isHaveModel) {
            [dataArr addObject:model];
        }
    }
    NSInteger number = 0;
    if (dataArr.count > 0) {
        for (HTDBHistoryModel *model in dataArr) {
            CGFloat progress = [model.var_seeTime floatValue] / 60.0;
            if (progress > 10.0) {
                number = number + 1;
                break;
            }
        }
    }
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"udf_hasShownRateView"] && number >= 1) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"udf_hasShownRateView"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        if ([SKStoreReviewController respondsToSelector:@selector(requestReview)]) {
            [[[[UIApplication sharedApplication] delegate] window] endEditing:YES];
            [SKStoreReviewController requestReview];
        } else {
            NSString *firLaunStr1 = AsciiString(@"itms-apps://itunes.apple.com/app/id%@?action=write-review");
            NSString *nsStringToOpen = [NSString stringWithFormat: firLaunStr1, AppleID];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:nsStringToOpen] options:@{} completionHandler:^(BOOL success) {}];
        }
    }
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if ( self.homeViewModel.var_haveAds ) {
        return self.homeViewModel.dataArray.count + 1 + 1;
    }
    return self.homeViewModel.dataArray.count + 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    // display_type  1 竖滑；2 横滑；3 Banner
    // 广告 横滑 和 Banner 都返回1
    
    // 有广告, 广告 section = 2
    NSInteger sec = section;
    
    if ( self.homeViewModel.var_haveAds ) {
        
        if ( section > 2 ) {
            sec = section - 1;
        }
        
        if ( section == 2 ) {
            return 1;
        }
    }
    
    if ( sec < self.homeViewModel.dataArray.count )
    {
        HTHomeDisplayTypeModel *type = self.homeViewModel.dataArray[sec];
        if ( type.display_type == 1 ) {
            HTHomeTrendingModel *model = type.data.firstObject;
            if ( model == nil ) {
                return 0;
            }
            if ( [model isKindOfClass:[HTHomeTrendingModel class]] ) {
                if ( model.m20 ) {
                    return model.m20.count;
                } else {
                    return model.tt20.count;
                }
            }
            else if ( [model isKindOfClass:[HTHomeCompositeModel class]] ) {
                return type.data.count;
            }
        } else if ( type.display_type == 2 ) {
            if ( type.data.count == 0 ) {
                return 0;
            }
        }
    }
    else
    {
        return self.homeViewModel.var_waterArray.count;
    }
    
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    NSInteger sec = indexPath.section;
    if ( self.homeViewModel.var_haveAds ) {
        
        if ( indexPath.section > 2 ) {
            sec = indexPath.section - 1;
        }
        
        if ( indexPath.section == 2 ) {
            HTHomeAdsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HTHomeAdsCell class]) forIndexPath:indexPath];
            cell.cancelBlock = ^(id data) {
                self.homeViewModel.var_haveAds = NO;
                [collectionView reloadData];
            };
            
            cell.adStartBlock = ^(id data) {
                self.tabBarController.selectedIndex = 1;
            };
            
            return cell;
        }
    }
    
    if ( sec < self.homeViewModel.dataArray.count ) {
        
        HTHomeDisplayTypeModel *type = self.homeViewModel.dataArray[sec];
        if ( type.display_type == 3 ) {
            HTBannerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HTBannerCollectionViewCell class]) forIndexPath:indexPath];
            
            [cell ht_updateCellWithData:type];
            
            cell.var_bannerBlock = ^(id data, BOOL var_isTType) {
                HTHomeBannerModel *banner = (HTHomeBannerModel *)data;
                //埋点
                NSString *ctype = var_isTType ?@"2" :@"1";
                [HTHomeBuriedManager lgjeropj_homeClickNewWithKid:@"4" andCtype:ctype andCId:banner.ID andCname:banner.nw_conf_name andSecname:@"0" andSecdisplayname:@"0" andSecId:@"0"];
                
                HTMoivePlayViewController *vc = [[HTMoivePlayViewController alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                vc.source = @"9";
                vc.var_mId = banner.nw_conf_value;
                vc.cover = banner.nw_img;
                vc.var_isTType = var_isTType;
                [self.navigationController pushViewController:vc animated:YES];
            };
            return cell;
        } else if ( type.display_type == 2 ) {
            HTHomeHorizontalCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HTHomeHorizontalCell class]) forIndexPath:indexPath];
            [cell ht_updateCellWithData:type];
            
            cell.horizBlock = ^(id data, BOOL var_isTType) {
                HTHomeTrendingM20Model *model = (HTHomeTrendingM20Model *)data;
                //埋点
                NSString *ctype = var_isTType ?@"2" :@"1";
                [HTHomeBuriedManager lgjeropj_homeClickNewWithKid:@"6" andCtype:ctype andCId:model.ID andCname:model.title andSecname:@"0" andSecdisplayname:@"0" andSecId:@"0"];
                
                HTMoivePlayViewController *vc = [[HTMoivePlayViewController alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                vc.source = @"9";
                vc.var_mId = model.ID;
                vc.cover = model.cover;
                vc.var_isTType = var_isTType;
                [self.navigationController pushViewController:vc animated:YES];
            };
            return cell;
        } else if ( type.display_type == 1 ) {
            
            HTHomeTrendingModel *model = type.data.firstObject;
            HTHomeTrendingM20Model *itemModel = nil;
            if ( [model isKindOfClass:[HTHomeTrendingModel class]] ) {
                if ( model.m20 ) {
                    itemModel = model.m20[indexPath.row];
                } else {
                    itemModel = model.tt20[indexPath.row];
                }
            } else if ( [model isKindOfClass:[HTHomeCompositeModel class]] ) {
                itemModel = type.data[indexPath.row];
            }
            
            HTHomeNineItemsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HTHomeNineItemsCell class]) forIndexPath:indexPath];
            [cell ht_updateCellWithData:itemModel];
            return cell;
        }
    }
    
    
    HTHomeWaterfallCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HTHomeWaterfallCell class]) forIndexPath:indexPath];
    [cell ht_updateCellWithData:self.homeViewModel.var_waterArray[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger sec = indexPath.section;
    if ( self.homeViewModel.var_haveAds ) {
        
        if ( indexPath.section > 2 ) {
            sec = indexPath.section - 1;
        }
        
        if ( indexPath.section == 2 ) {
            return;
        }
    }
    
    BOOL var_isTType = NO;
    NSString *var_mId = nil;
    NSString *mTitle = nil;
    NSString *cover = nil;
    
    if ( sec < self.homeViewModel.dataArray.count ) {
        HTHomeDisplayTypeModel *type = self.homeViewModel.dataArray[sec];
        
        HTHomeTrendingModel *model = type.data.firstObject;
        if ( [model isKindOfClass:[HTHomeTrendingModel class]] ) {
            if ( model.m20 ) {
                HTHomeTrendingM20Model *itemModel = model.m20[indexPath.row];
                var_isTType = NO;
                var_mId = itemModel.ID;
                mTitle = itemModel.title;
                cover = itemModel.cover;
            } else {
                HTHomeTrendingM20Model *itemModel = model.tt20[indexPath.row];
                var_isTType = YES;
                var_mId = itemModel.ID;
                mTitle = itemModel.title;
                cover = itemModel.cover;
            }
        }
        else if ( [model isKindOfClass:[HTHomeCompositeModel class]] ) {
            HTHomeCompositeModel *comp = type.data[indexPath.row];
            HTSpecialViewController *vc = [[HTSpecialViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.title = comp.title;
            vc.var_speId = comp.ID;
            if ([type.info_type_2 localizedCaseInsensitiveContainsString:AsciiString(@"mtype")]) {
                vc.type = @"1";
            } else {
                vc.type = @"2";
            }
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else
    {
        HTWaterMovieTvModel *itemModel = self.homeViewModel.var_waterArray[indexPath.row];
        var_isTType = NO;
        var_mId = itemModel.ID;
        mTitle = itemModel.title;
        cover = itemModel.cover;
    }
    
    if ( var_mId == nil ) {
        return;
    }
    //埋点
    NSString *ctype = var_isTType ?@"2" :@"1";
    [HTHomeBuriedManager lgjeropj_homeClickNewWithKid:@"6" andCtype:ctype andCId:var_mId andCname:mTitle andSecname:@"0" andSecdisplayname:@"0" andSecId:@"0"];
    
    HTMoivePlayViewController *vc = [[HTMoivePlayViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.source = @"9";
    vc.var_mId = var_mId;
    vc.cover = cover;
    vc.var_isTType = var_isTType;
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(nonnull NSString *)kind atIndexPath:(nonnull NSIndexPath *)indexPath {
    
    NSInteger sec = indexPath.section;
    
    if ( self.homeViewModel.var_haveAds ) {
        
        if ( indexPath.section > 2 ) {
            sec = indexPath.section - 1;
        }
        
        if ( indexPath.section == 2 ) {
            return nil;
        }
    }
    
    if ( sec < self.homeViewModel.dataArray.count ) {
        HTHomeDisplayTypeModel *type = self.homeViewModel.dataArray[sec];
        if ( [kind isEqualToString:UICollectionElementKindSectionHeader] ) {
            HTHomeHeaderReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([HTHomeHeaderReusableView class]) forIndexPath:indexPath];
            header.titleLabel.text = type.name;
            header.type = type;
            [header.rightBtn addTarget:self action:@selector(lgjeropj_onSpecialAction:) forControlEvents:UIControlEventTouchUpInside];
            return header;
        } else {
            HTHomeFooterReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass([HTHomeFooterReusableView class]) forIndexPath:indexPath];
            footer.type = type;
            [footer.moreBtn addTarget:self action:@selector(lgjeropj_onMoreAction:) forControlEvents:UIControlEventTouchUpInside];
            [footer.allBtn addTarget:self action:@selector(lgjeropj_onSeeAllAction:) forControlEvents:UIControlEventTouchUpInside];
            return footer;
        }
    } else {
        if ( [kind isEqualToString:UICollectionElementKindSectionHeader] ) {
            HTHomeWaterfallHeaderReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([HTHomeWaterfallHeaderReusableView class]) forIndexPath:indexPath];
            if (self.homeViewModel.var_waterArray.count>0) {
                [header ht_hideLine:NO];
            } else {
                [header ht_hideLine:YES];
            }
            
            return header;
        }
    }
    
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger sec = indexPath.section;
    
    if ( self.homeViewModel.var_haveAds ) {
        
        if ( indexPath.section > 2 ) {
            sec = indexPath.section - 1;
        }
        
        if ( indexPath.section == 2 ) {
            return CGSizeMake(kScreenWidth, 280);
        }
    }
    
    if ( sec < self.homeViewModel.dataArray.count ) {
        HTHomeDisplayTypeModel *type = self.homeViewModel.dataArray[sec];
        if ( type.display_type == 1 ) {
            // 九宫格
            CGFloat itemWid = (kScreenWidth - 10*4)/3;
//            if ( isPad ) {// 预留方法 iPad可以显示更多内容
//                itemWid = (kScreenWidth - 10*5)/4;
//            }
            return CGSizeMake(itemWid, itemWid*10/7 +32);
        }
        else if ( type.display_type == 2 ) {
            // 横向
            CGFloat itemWid = (kScreenWidth - 10*4)/3;
            return CGSizeMake(kScreenWidth, itemWid*10/7 +32);
        }
        else if ( type.display_type == 3 ) {
            // Banner
            CGFloat itemWid = kScreenWidth*0.4;
            return CGSizeMake(kScreenWidth, itemWid*10/7);
        }
    }
    
    CGFloat itemWid = (kScreenWidth - 10*3)/2;
    HTHomeTrendingM20Model *model = self.homeViewModel.var_waterArray[indexPath.row];
    CGSize size = [model.title boundingRectWithSize:CGSizeMake(itemWid - 20, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:HTPingFangRegularFont(12)} context:nil].size;
    
    CGFloat height = itemWid*10/7 + size.height + 10;
    
    return CGSizeMake(itemWid, height);
}

- (CGFloat)ht_collectionViewLayout:(HTCollectionWaterFlowLayout *)layout heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger sec = indexPath.section;
    
    if ( self.homeViewModel.var_haveAds ) {
        
        if ( indexPath.section > 2 ) {
            sec = indexPath.section - 1;
        }
        
        if ( indexPath.section == 2 ) {
            return 0;
        }
    }
    
    if ( sec == self.homeViewModel.dataArray.count ) {
        CGFloat itemWid = (kScreenWidth - 10*3)/2;
        HTHomeTrendingM20Model *model = self.homeViewModel.var_waterArray[indexPath.row];
        CGSize size = [model.title boundingRectWithSize:CGSizeMake(itemWid - 20, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:HTPingFangRegularFont(12)} context:nil].size;
        
        CGFloat height = itemWid*10/7 + size.height + 15;
        
        return height;
    }
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    NSInteger sec = section;
    
    if ( self.homeViewModel.var_haveAds ) {
        
        if ( section > 2 ) {
            sec = section - 1;
        }
        
        if ( section == 2 ) {
            return CGSizeZero;
        }
    }
    
    if ( sec < self.homeViewModel.dataArray.count ) {
        HTHomeDisplayTypeModel *type = self.homeViewModel.dataArray[sec];
        if ( type.display_type == 3 ) {
            return CGSizeZero;
        } else if ( type.display_type == 2 ) {
            if ( type.data.count == 0 ) {
                return CGSizeZero;
            }
        }
    }
    
    return CGSizeMake(kScreenWidth, 36);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    NSInteger sec = section;
    
    if ( self.homeViewModel.var_haveAds ) {
        
        if ( section > 2 ) {
            sec = section - 1;
        }
        
        if ( section == 2 ) {
            return CGSizeZero;
        }
    }
    
    if ( sec < self.homeViewModel.dataArray.count ) {
        HTHomeDisplayTypeModel *type = self.homeViewModel.dataArray[sec];
        if ( type.display_type == 1 ) {
            return CGSizeMake(kScreenWidth, 44);
        }
    }
    
    return CGSizeZero;
}

- (void)lgjeropj_onSpecialAction:(UIButton *)sender {
    
    NSString  * var_speId = nil;
    NSString  * title = nil;
    HTHomeHeaderReusableView *header = (HTHomeHeaderReusableView *)[sender superview];
    HTHomeDisplayTypeModel *type = header.type;
    HTHomeTrendingModel *model = type.data.firstObject;
    if ( model == nil ) {
        return;
    }
    //埋点
    [HTHomeBuriedManager lgjeropj_homeClickNewWithKid:@"7" andCtype:@"0" andCId:@"0" andCname:@"0" andSecname:type.secname andSecdisplayname:type.name andSecId:type.open_mode_value];
    if ( [model isKindOfClass:[HTHomeTrendingModel class]] ) {
        var_speId = model.ID;
        title = type.name;
    }
    else if ( [model isKindOfClass:[HTHomeCompositeModel class]] ) {
        HTHomeCompositeModel *comp = (HTHomeCompositeModel *)model;
        var_speId = comp.ID;
        title = comp.title;
    }
    
    HTSpecialViewController *vc = [[HTSpecialViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.title = title;
    vc.var_speId = var_speId;
    if ([type.info_type_2 localizedCaseInsensitiveContainsString:AsciiString(@"mtype")]) {
        vc.type = @"1";
    } else {
        vc.type = @"2";
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)lgjeropj_onMoreAction:(UIButton *)sender {
    
    HTHomeFooterReusableView *footer = (HTHomeFooterReusableView *)[sender superview];
    
    [footer ht_startLoadding];
    
    NSString  * speId = nil;
    NSMutableArray *mutaArray = [NSMutableArray array];
    HTHomeDisplayTypeModel *type = footer.type;
    HTHomeTrendingModel *model = type.data.firstObject;
    if ( model == nil ) {
        [footer ht_endLoadding];
        return;
    }
    //埋点
    [HTHomeBuriedManager lgjeropj_homeClickNewWithKid:@"8" andCtype:@"0" andCId:@"0" andCname:@"0" andSecname:type.secname andSecdisplayname:type.name andSecId:type.open_mode_value];
    
    if ( [model isKindOfClass:[HTHomeTrendingModel class]] ) {
        speId = model.ID;
        if ( model.m20 ) {
            [mutaArray addObjectsFromArray:model.m20];
        } else {
            [mutaArray addObjectsFromArray:model.tt20];
        }
        if ( mutaArray.count <= 9 ) {
            model.page = 0;
            model.var_isMore = type.moreflag;
        }
    }
    else if ( [model isKindOfClass:[HTHomeCompositeModel class]] ) {
        [footer ht_endLoadding];
        return;
    }
        
    if ( model.var_isMore ) {
        NSDictionary *params = @{AsciiString(@"id"):speId,AsciiString(@"page"):@(model.page + 1),AsciiString(@"page_size"):@"9"};
        [[HTHttpRequest sharedManager] ht_post:[NSString stringWithFormat:@"%d", 358] andParameters:params andCompletion:^(HTResponseModel *response, NSError * _Nullable error) {
            [footer ht_endLoadding];
            if (error == nil) {
                if (response.status == 200) {
                    NSDictionary *dict = response.data;
                    model.total = [dict[AsciiString(@"total")] integerValue];
                    model.page = [dict[AsciiString(@"page")] integerValue];
                    NSArray *array = nil;
                    if ( model.m20 ) {
                        array = [NSArray yy_modelArrayWithClass:[HTHomeTrendingM20Model class] json:dict[@"minfo"]];
                        [mutaArray addObjectsFromArray:array];
                        model.m20 = mutaArray;
                    } else {
                        array = [NSArray yy_modelArrayWithClass:[HTHomeTrendingM20Model class] json:dict[@"ttinfo"]];
                        [mutaArray addObjectsFromArray:array];
                        model.tt20 = mutaArray;
                    }
                    if ( mutaArray.count - 9 < model.total ) {
                        model.var_isMore = YES;
                    } else {
                        model.var_isMore = NO;
                    }
                    [self.collectionView reloadData];
                } else {
                    [SVProgressHUD showInfoWithStatus:response.msg];
                }
            }
        }];
    }
}

- (void)lgjeropj_onSeeAllAction:(UIButton *)sender {
    NSString  * speId = nil;
    NSString  * title = nil;
    
    HTHomeHeaderReusableView *header = (HTHomeHeaderReusableView *)[sender superview];
    HTHomeDisplayTypeModel *type = header.type;
    HTHomeTrendingModel *model = type.data.firstObject;
    if ( model == nil ) {
        return;
    }
    //埋点
    [HTHomeBuriedManager lgjeropj_homeClickNewWithKid:@"7" andCtype:@"0" andCId:@"0" andCname:@"0" andSecname:type.secname andSecdisplayname:type.name andSecId:type.open_mode_value];
    if ( [model isKindOfClass:[HTHomeTrendingModel class]] ) {
        speId = model.ID;
        title = model.name;
    }
    else if ( [model isKindOfClass:[HTHomeCompositeModel class]] ) {
        return;
    }
    
    HTSpecialViewController *vc = [[HTSpecialViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.title = title;
    vc.var_speId = speId;
    if ([type.info_type_2 localizedCaseInsensitiveContainsString:AsciiString(@"mtype")]) {
        vc.type = @"1";
    } else {
        vc.type = @"2";
    }
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - network
- (void)ht_homeRequest:(NSDictionary *)params {
    
    [[HTHttpRequest sharedManager] ht_post:[NSString stringWithFormat:@"%d", 250] andParameters:params andCompletion:^(HTResponseModel *response, NSError * _Nullable error) {
        if (error == nil) {
            if (response.status == 200) {
                [HTHomeBuriedManager lgjeropj_homeShowNewWithStatus:@"1" andError:@"0" andTime:self.homeViewModel.startTime];
                HTHomeModel *model = [HTHomeModel yy_modelWithJSON:response.data];
                NSMutableArray *multArray = [NSMutableArray array];
                for ( HTHomeDisplayTypeModel *type in model.default_set.data ) {
                    if ( ![type.name isEqualToString:AsciiString(@"com_1")] ) {
                        [multArray addObject:type];
                    }
                }
                self.homeViewModel.dataArray = multArray;
                [self.collectionView reloadData];
            } else {
                [SVProgressHUD showInfoWithStatus:response.msg];
                [HTHomeBuriedManager lgjeropj_homeShowNewWithStatus:@"4" andError:response.msg andTime:self.homeViewModel.startTime];
            }
        }
    }];
}

- (void)ht_homeWaterRequest:(NSDictionary *)params {
    
    [[HTHttpRequest sharedManager] ht_post:[NSString stringWithFormat:@"%d", 156] andParameters:params andCompletion:^(HTResponseModel *response, NSError * _Nullable error) {
        
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        if (error == nil) {
            if (response.status == 200) {
                NSArray *var_array = [NSArray yy_modelArrayWithClass:[HTWaterMovieTvModel class] json:response.data[@"minfo"]];
                if ( self.homeViewModel.var_water_page == 1 ) {
                    self.homeViewModel.var_waterArray = [NSMutableArray arrayWithArray:var_array];
                } else {
                    [self.homeViewModel.var_waterArray addObjectsFromArray:var_array];
                }
                if (var_array.count == 0) {
                    self.homeViewModel.var_isMore = NO;
                    [self.collectionView.mj_footer endRefreshingWithNoMoreData];
                } else {
                    self.homeViewModel.var_isMore = YES;
                }
            }
        }
        [self.collectionView reloadData];
    }];
}

- (void)lgjeropj_bindViewModel {

    [SVProgressHUD showWithStatus:LocalString(@"Loading", nil)];
    self.homeViewModel.startTime = [NSDate date];
    NSString *massage = AsciiString(@"p1");
    [self ht_homeRequest:@{AsciiString(@"page"):@"1",AsciiString(@"page_size"):@"20",massage:@"0"}];
    
    [[HTHttpRequest sharedManager] ht_post:[NSString stringWithFormat:@"%d", 78] andParameters:nil andCompletion:^(HTResponseModel *response, NSError * _Nullable error) {
        if (error == nil) {
            if (response.status == 200) {
                NSDictionary *dict = (NSDictionary *)response.data;
                self.homeViewModel.shareText = dict[@"appm_text"];
                self.homeViewModel.shareLink = dict[@"appm_link"];
                [[NSUserDefaults standardUserDefaults] setObject:self.homeViewModel.shareText forKey:@"udf_shareText"];
                [[NSUserDefaults standardUserDefaults] setObject:self.homeViewModel.shareLink forKey:@"udf_shareLink"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }
    }];
}

- (HTHomeViewModel *)homeViewModel {
    
    if (!_homeViewModel) {
        _homeViewModel = [[HTHomeViewModel alloc] init];
    }
    return _homeViewModel;
}

@end

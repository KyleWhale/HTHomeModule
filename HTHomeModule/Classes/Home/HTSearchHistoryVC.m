//
//  HTSearchHistoryVC.m
//  Hucolla
//
//  Created by mac on 2022/9/14.
//

#import "HTSearchHistoryVC.h"
#import "HTAdvertBannerView.h"
#import "HTHttpRequest.h"
#import "HTSearchHistoryManager.h"

@interface HTSearchHistoryVC ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *wordsArray;
@property (nonatomic, assign) BOOL var_isStretch;
@property (nonatomic, strong) HTAdvertBannerView *var_bannerView;
@property (nonatomic, assign) BOOL var_haveAds;

@end


@implementation HTSearchHistoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak typeof(self) weakSelf = self;;
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"NTFCTString_UpdateVIPStatusAndProductsInfo" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.var_haveAds = ![HTCommonConfiguration lgjeropj_shared].BLOCK_vipBlock();
            weakSelf.var_bannerView.hidden = !weakSelf.var_haveAds;
        });
    }];
    self.var_haveAds = ![HTCommonConfiguration lgjeropj_shared].BLOCK_vipBlock();
    [self lgjeropj_addSubViews];
    [self lgjeropj_bindViewModel];
}

- (void)lgjeropj_addSubViews {

    self.collectionView = [HTSearchHistoryManager lgjeropj_collectionView:self];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.var_bannerView = [[HTAdvertBannerView alloc] init];
    self.var_bannerView.hidden = !self.var_haveAds;
    self.var_bannerView.backgroundColor = kMainColor;
    [self.view addSubview:self.var_bannerView];
    [self.var_bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(320);
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    NSArray *keywords = [HTSearchHistoryManager lgjeropj_history];
    if ( keywords.count == 0 ) {
        return 1;
    }
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSArray *keywords = [HTSearchHistoryManager lgjeropj_history];
    if ( keywords.count > 0 ) {
        if ( section == 0 ) {
            return 1;
        }
    }
    return self.wordsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    NSArray *keywords = [HTSearchHistoryManager lgjeropj_history];
    if ( keywords.count > 0 ) {
        if ( indexPath.section == 0 ) {
            HTSearchHistoryKeywordCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HTSearchHistoryKeywordCell class]) forIndexPath:indexPath];
            
            cell.keywordArray = keywords;
            cell.wordsBlock = self.wordsBlock;
            [cell lgjeropj_potentateAwestruck:self.var_isStretch];
            @weakify(self);
            cell.stretchBlock = ^(BOOL isSelect) {
                @strongify(self);
                self.var_isStretch = isSelect;
                [collectionView reloadData];
                if (self.stretchBlock) {
                    self.stretchBlock(isSelect);
                }
            };
            
            return cell;
        }
    }
    
    HTSearchHistoryHotCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HTSearchHistoryHotCell class]) forIndexPath:indexPath];
    cell.index = indexPath.row + 1;
    [cell ht_updateCellWithData:self.wordsArray[indexPath.row]];
    return cell;
}

- (UIView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(nonnull NSString *)kind atIndexPath:(nonnull NSIndexPath *)indexPath {
    if ( [kind isEqualToString:UICollectionElementKindSectionHeader] ) {
        
        NSArray *keywords = [HTSearchHistoryManager lgjeropj_history];
        
        HTSearchHistoryHeaderReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([HTSearchHistoryHeaderReusableView class]) forIndexPath:indexPath];
        
        if ( keywords.count > 0 ) {
            if ( indexPath.section == 0 ) {
                header.rightBtn.hidden = NO;
                header.titleLabel.text = LocalString(@"History", nil);
                [header.rightBtn addTarget:self action:@selector(lgjeropj_onClearAction:) forControlEvents:UIControlEventTouchUpInside];
            } else {
                header.titleLabel.text = AsciiString(@"Top Search");
                header.rightBtn.hidden = YES;
            }
            
        } else {
            header.titleLabel.text = AsciiString(@"Top Search");
            header.rightBtn.hidden = YES;
        }
        
        return header;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *keywords = [HTSearchHistoryManager lgjeropj_history];
    
    if ( keywords.count > 0 ) {
        if ( indexPath.section == 0 ) {
            HTSearchHistoryKeywordCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HTSearchHistoryKeywordCell class]) forIndexPath:indexPath];
            NSArray *keywords = [HTSearchHistoryManager lgjeropj_history];
            cell.keywordArray = keywords;
            [cell lgjeropj_potentateAwestruck:self.var_isStretch];
            // 默认显示两行
            CGFloat rowH = 10*3 + 28*2;
            if ( cell ) {
                rowH = [cell ht_cellHeight];
            }
            
            return CGSizeMake(kScreenWidth, rowH);
        }
    }
    
    return CGSizeMake(kScreenWidth*0.49, 38);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeMake(kScreenWidth, 42);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *keywords = [HTSearchHistoryManager lgjeropj_history];
    if ( keywords.count > 0 ) {
        if ( indexPath.section == 0 ) {
            return;
        }
    }
    NSString *keyword = self.wordsArray[indexPath.row];
    NSInteger index = indexPath.row+1;
    if (index%2 == 0) {
        index = index/2 + 5;
    } else {
        index = (index+1)/2;
    }
    if (self.wordsBlock) {
        self.wordsBlock(keyword, 2, index);
    }
}

- (void)lgjeropj_onClearAction:(UIButton *)sender
{
    [HTSearchHistoryManager lgjeropj_clear];
    [self.collectionView reloadData];
}

- (void)ht_reloadData
{
    [self.collectionView reloadData];
}

- (void)lgjeropj_bindViewModel {
    
    @weakify(self);
    NSString *massage = AsciiString(@"p1");
    [[HTHttpRequest sharedManager] ht_post:[NSString stringWithFormat:@"%d", 230] andParameters:@{massage:@"2"} andCompletion:^(HTResponseModel *model, NSError * _Nullable error) {
        if ( error == nil ) {
            if ( model.status == 200 ) {
                NSDictionary *dictionary = model.data[@"bighits"];
                self.wordsArray = dictionary[@"data"];
                [self.collectionView reloadData];
            } else {
                [SVProgressHUD showInfoWithStatus:model.msg];
            }
        }
    }];
}

@end

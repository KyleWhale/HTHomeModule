//
//  HTHomeHorizontalCell.m
//  Hucolla
//
//  Created by mac on 2022/9/14.
//

#import "HTHomeHorizontalCell.h"
#import "HTHomeHorizontalManager.h"
#import "HTHomeTrendingModel.h"
#import "HTHomeCompositeModel.h"
#import "HTHttpRequest.h"

@interface HTHomeHorizontalCell()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView      * collectionView;
@property (nonatomic, strong) UIView                * headerView;
@property (nonatomic, strong) UIView                * footerView;
@property (nonatomic, strong) NSArray               * dataArray;
@property (nonatomic, assign) BOOL                    var_isTType;
@property (nonatomic, assign) BOOL                    isStart;
@property (nonatomic, assign) NSInteger               count;

@property (nonatomic, strong) UIActivityIndicatorView   * var_loadingView;
@property (nonatomic, strong) UIImageView               * pullImageView;

@property (nonatomic, strong) HTHomeDisplayTypeModel    * type;

@end

@implementation HTHomeHorizontalCell

- (void)ht_addCellSubViews {
    
    CGFloat itemWid = (kScreenWidth - 10*4)/3;
    self.collectionView = [HTHomeHorizontalManager lgjeropj_collectionView:self];
    [self.contentView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    //[self.collectionView addSubview:self.headerView];
    [self.collectionView addSubview:self.footerView];
    
    self.headerView.frame = CGRectMake(-44, 0, 44, itemWid*10/7 +32);
    self.footerView.frame = CGRectMake(self.collectionView.contentSize.width, 0, 44, itemWid*10/7 +32);
    self.var_loadingView.frame = CGRectMake(12, 60*kScale, 24, 24);
    self.pullImageView.frame = CGRectMake(6, 60*kScale, 24, 24);
    
    [self.collectionView addObserver:self forKeyPath:AsciiString(@"contentSize") options:NSKeyValueObservingOptionNew context:nil];
    [self.collectionView addObserver:self forKeyPath:AsciiString(@"contentOffset") options:NSKeyValueObservingOptionNew context:nil];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    HTHomeTrendingM20Model *model = self.dataArray[indexPath.row];
    HTHorizontalItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HTHorizontalItemCell class]) forIndexPath:indexPath];
    [cell ht_updateCellWithData:model];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    HTHomeTrendingM20Model *model = self.dataArray[indexPath.row];
    
    if ( self.horizBlock ) {
        self.horizBlock(model, self.var_isTType);
    }
}

- (void)ht_updateCellWithData:(id)data {
    if ( data ) {
        HTHomeDisplayTypeModel *type = (HTHomeDisplayTypeModel *)data;
        self.type = type;
        HTHomeTrendingModel *model = type.data.firstObject;
        if ( model.m20.count > 0 ) {
            self.dataArray = model.m20;
            self.var_isTType = NO;
        }
        if ( model.tt20.count > 0 ) {
            self.dataArray = model.tt20;
            self.var_isTType = YES;
        }
        self.count = self.dataArray.count;
        
        [self.collectionView reloadData];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ( [keyPath isEqualToString:AsciiString(@"contentSize")] ) {
        CGSize size = [change[NSKeyValueChangeNewKey] CGSizeValue];
        
        self.footerView.frame = CGRectMake(size.width, 0, 44, 184*kScale);
    }
    else if ( [keyPath isEqualToString:AsciiString(@"contentOffset")] ) {
        CGPoint offset = [change[NSKeyValueChangeNewKey] CGPointValue];
        
        if ( self.collectionView.contentSize.width > self.collectionView.size.width ) {
            
            if ( offset.x > self.collectionView.contentSize.width + 44 - self.collectionView.size.width ) {
                self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 44);
                if ( self.isStart == NO ) {
                    [self startPulling];
                }
            }
        }
    }
}

- (void)headerRefresh {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self endRefresh];
    });
}

- (void)endRefresh {
    [UIView animateWithDuration:0.2 animations:^{
        self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    } completion:^(BOOL finished) {
        [self.var_loadingView stopAnimating];
    }];
}

- (void)startPulling {
    
    self.isStart = YES;
    
    [self lgjeropj_imageTransform:UIViewAnimationOptionCurveEaseIn];
    
    [self lgjeropj_onPullMoreData];
}

- (void)lgjeropj_endPulling {
    
    [UIView animateWithDuration:0.5 animations:^{
        self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    } completion:^(BOOL finished) {
        self.isStart = NO;
    }];
}

- (void)lgjeropj_imageTransform:(UIViewAnimationOptions)options {
    
    //2s 旋转 360度
    [UIView animateWithDuration:0.5f delay:0.0f options:options animations:^{

        self.pullImageView.transform =CGAffineTransformRotate(self.pullImageView.transform,M_PI / 2);//M_PI / 2 = 90度

        if ( self.isStart == NO ) {
            self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        }
    } completion:^(BOOL finished) {
        
        if ( self.isStart ) {
            [self lgjeropj_imageTransform:UIViewAnimationOptionCurveLinear];
        } else {
            if ( options != UIViewAnimationOptionCurveEaseOut ) {
                [self lgjeropj_imageTransform:UIViewAnimationOptionCurveEaseOut];
            }
        }
    }];
}

- (void)lgjeropj_onPullMoreData {
    
    //
    [self lgjeropj_endPulling];
    return;
    
    NSString  * var_speId = nil;
    NSMutableArray *mutaArray = [NSMutableArray array];
    
    HTHomeTrendingModel *model = self.type.data.firstObject;
    if ( [model isKindOfClass:[HTHomeTrendingModel class]] ) {
        var_speId = model.ID;
        if ( model.m20 ) {
            [mutaArray addObjectsFromArray:model.m20];
        } else {
            [mutaArray addObjectsFromArray:model.tt20];
        }
        
        if ( mutaArray.count < model.total ) {
            model.var_isMore = YES;
        } else {
            model.var_isMore = NO;
        }
    }
    else if ( [model isKindOfClass:[HTHomeCompositeModel class]] ) {
        [self lgjeropj_endPulling];
        return;
    }
        
    if ( model.var_isMore ) {
        NSDictionary *params = @{AsciiString(@"id"):var_speId,AsciiString(@"page"):@(model.page + 1),AsciiString(@"page_size"):@"20"};
        [[HTHttpRequest sharedManager] ht_post:[NSString stringWithFormat:@"%d", 358] andParameters:params andCompletion:^(HTResponseModel *response, NSError * _Nullable error) {
            [self lgjeropj_endPulling];
            if (error == nil) {
                if (response.status == 200) {
                    NSDictionary *dict = (NSDictionary *)response.data;
                    model.total = [dict[AsciiString(@"total")] integerValue];
                    model.page = [dict[AsciiString(@"page")] integerValue];
                    NSArray *array = nil;
                    if ( model.m20 ) {
                        array = [NSArray yy_modelArrayWithClass:[HTHomeTrendingM20Model class] json:dict[@"minfo"]];
                        [mutaArray addObjectsFromArray:array];
                        model.m20 = mutaArray;
                        self.dataArray = model.m20;
                    } else {
                        array = [NSArray yy_modelArrayWithClass:[HTHomeTrendingM20Model class] json:dict[@"ttinfo"]];
                        [mutaArray addObjectsFromArray:array];
                        model.tt20 = mutaArray;
                        self.dataArray = model.tt20;
                    }
                    
                    if ( mutaArray.count - self.count < model.total ) {
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
    } else {
        [self lgjeropj_endPulling];
    }
}

- (UIView *)headerView {
    if ( _headerView == nil ) {
        _headerView = [[UIView alloc] init];
    }
    return _headerView;
}

- (UIView *)footerView {
    if ( _footerView == nil ) {
        _footerView = [[UIView alloc] init];
    }
    return _footerView;
}

- (UIImageView *)pullImageView
{
    if ( !_pullImageView ) {
        _pullImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_wdVector"]];
        [self.footerView addSubview:_pullImageView];
    }
    return _pullImageView;
}

- (UIActivityIndicatorView *)var_loadingView
{
    if (!_var_loadingView) {
        _var_loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _var_loadingView.hidesWhenStopped = YES;
        [self.headerView addSubview:_var_loadingView];
    }
    return _var_loadingView;
}

@end

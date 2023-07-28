//
//  HTBannerCollectionViewCell.m
//  Hucolla
//
//  Created by mac on 2022/9/13.
//

#import "HTBannerCollectionViewCell.h"
#import <WMZBanner/WMZBannerView.h>
#import "HTHomeBannerModel.h"
#import "HTHomeDisplayTypeModel.h"
#import "HTBannerCollectionCellManager.h"

@interface HTBannerCollectionViewCell()

@property (nonatomic, strong) WMZBannerView *var_cardView;
@property (nonatomic, strong) WMZBannerParam *param;

@end

@implementation HTBannerCollectionViewCell

- (void)ht_addCellSubViews {
    CGFloat var_itemWid = kScreenWidth * 0.4;
    CGFloat var_itemHeight = var_itemWid * 10 / 7;
    CGFloat var_coverWidth = var_itemWid * 0.7 * 1.3;
    CGFloat var_coverHeight = var_itemHeight * 0.7 * 1.3;
    WMZBannerParam *param = BannerParam()
   .wFrameSet(CGRectMake(10, 0, kScreenWidth - 20, var_itemHeight))
   .wDataSet([self ht_getData])
   .wSelectIndexSet(0)
   .wHideBannerControlSet(NO)
   .wScaleSet(YES)
   .wScaleFactorSet(0.7)
   .wItemSizeSet(CGSizeMake(var_coverWidth, var_coverHeight))
   .wContentOffsetXSet(0.5)
   .wZindexSet(YES)
   .wRepeatSet(YES)
   .wAutoScrollSet(YES)
   .wAutoScrollSecondSet(3.0)
   .wLineSpacingSet(-var_itemWid*0.5)
   .wSectionInsetSet(UIEdgeInsetsMake(0, kScreenWidth * 0.25, 0, kScreenWidth * 0.25))
   .wMyCellClassNameSet(NSStringFromClass(UICollectionViewCell.class))
   .wEventCenterClickSet(^(id anyID,NSInteger index,BOOL isCenter,UICollectionViewCell* cell){
       HTHomeBannerModel *banner = anyID;
       if ( self.var_bannerBlock ) {
           BOOL var_isTType = (banner.nw_conf_type.intValue == 7) ?YES :NO;
           self.var_bannerBlock(banner, var_isTType);
       }
   })
   .wMyCellSet(^UICollectionViewCell *(NSIndexPath *indexPath, UICollectionView *collectionView, id model, UIImageView *bgImageView, NSArray *dataArry) {
       return [HTBannerCollectionCellManager ht_collectionView:collectionView cellForItemAtIndexPath:indexPath model:model];
   })
   .wBannerControlImageSizeSet(CGSizeMake(5, 5))
   .wBannerControlSelectImageSizeSet(CGSizeMake(20, 5))
   .wBannerControlImageSet(@"icon_wdslideCirclePoint")
   .wBannerControlSelectImageSet(@"icon_wdslidePoint")
   .wBannerControlSelectMarginSet(4).wCustomControlSet(^(UIControl *pageControl) {
       CGRect var_rect = pageControl.frame;
       var_rect.origin.y = var_coverHeight;
       pageControl.frame = var_rect;
   });
   WMZBannerView *var_bannerView = [[WMZBannerView alloc] initConfigureWithModel:param];
   [self addSubview:var_bannerView];
    self.var_cardView = var_bannerView;
    self.param = param;
}

- (void)ht_updateCellWithData:(id)data {
    if ( [data isKindOfClass:[HTHomeDisplayTypeModel class]] ) {
        HTHomeDisplayTypeModel *var_bannerType = (HTHomeDisplayTypeModel *)data;
        self.param.wDataSet(var_bannerType.data);
        [self.var_cardView updateUI];
    }
}

- (NSArray *)ht_getData{
    return self.param.wData;
}
@end

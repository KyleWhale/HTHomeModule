//
//  HTHomeViewManager.m
//  Moshfocus
//
//  Created by 李雪健 on 2023/6/6.
//

#import "HTHomeViewManager.h"

@implementation HTHomeViewManager

+ (UICollectionView *)lgjeropj_collectionView:(id)target {
    
    HTCollectionWaterFlowLayout *layout = [[HTCollectionWaterFlowLayout alloc] init];
    layout.delegate = target;
    layout.itemSpacing = 15;
    layout.var_columns = 2;
    layout.columnSpacing = 15;
    layout.insets = UIEdgeInsetsMake(0, 10, 0, 10);
    
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 5;
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 0, 10);
    
    UICollectionView *view = [HTKitCreate ht_collectionViewWithDelegate:target andLayout:layout];
    [view registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [view registerClass:[HTBannerCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([HTBannerCollectionViewCell class])];
    [view registerClass:[HTHomeHeaderReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([HTHomeHeaderReusableView class])];
    [view registerClass:[HTHomeFooterReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass([HTHomeFooterReusableView class])];
    [view registerClass:[HTHomeNineItemsCell class] forCellWithReuseIdentifier:NSStringFromClass([HTHomeNineItemsCell class])];
    [view registerClass:[HTHomeAdsCell class] forCellWithReuseIdentifier:NSStringFromClass([HTHomeAdsCell class])];
    [view registerClass:[HTHomeHorizontalCell class] forCellWithReuseIdentifier:NSStringFromClass([HTHomeHorizontalCell class])];
    [view registerClass:[HTHomeWaterfallHeaderReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([HTHomeWaterfallHeaderReusableView class])];
    [view registerClass:[HTHomeWaterfallCell class] forCellWithReuseIdentifier:NSStringFromClass([HTHomeWaterfallCell class])];

    return view;
}

@end

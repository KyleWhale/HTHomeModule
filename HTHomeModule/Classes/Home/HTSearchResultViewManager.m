//
//  HTSearchResultViewManager.m
//  Moshfocus
//
//  Created by 李雪健 on 2023/6/6.
//

#import "HTSearchResultViewManager.h"

@implementation HTSearchResultViewManager

+ (UICollectionView *)lgjeropj_collectionView:(id)target {

    UICollectionView *view = [HTKitCreate ht_collectionViewWithDelegate:target andIsVertical:YES andLineSpacing:10 andColumnSpacing:5 andItemSize:CGSizeZero andIsEstimated:NO andSectionInset:UIEdgeInsetsMake(0, 10, 0, 10)];
    view.contentInset = UIEdgeInsetsMake(5, 0, kHJBottomHeight, 0);
    [view registerClass:[HTHomeNineItemsCell class] forCellWithReuseIdentifier:NSStringFromClass([HTHomeNineItemsCell class])];
    [view registerClass:[HTHomeAdsCell class] forCellWithReuseIdentifier:NSStringFromClass([HTHomeAdsCell class])];
    return view;
}

@end

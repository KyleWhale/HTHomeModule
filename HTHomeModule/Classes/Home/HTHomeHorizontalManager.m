//
//  HTHomeHorizontalManager.m
//  Moshfocus
//
//  Created by 李雪健 on 2023/6/7.
//

#import "HTHomeHorizontalManager.h"

@implementation HTHomeHorizontalManager

+ (UICollectionView *)lgjeropj_collectionView:(id)target {
    
    CGFloat itemWid = (kScreenWidth - 10*4)/3;
    UICollectionView *view = [HTKitCreate ht_collectionViewWithDelegate:target andIsVertical:NO andLineSpacing:6 andColumnSpacing:0 andItemSize:CGSizeMake(itemWid, itemWid*10/7 +32) andIsEstimated:NO andSectionInset:UIEdgeInsetsMake(0, 10, 0, 10)];
    [view registerClass:[HTHorizontalItemCell class] forCellWithReuseIdentifier:NSStringFromClass([HTHorizontalItemCell class])];
    return view;
}

@end

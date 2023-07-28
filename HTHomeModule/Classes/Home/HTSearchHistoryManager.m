//
//  HTSearchHistoryManager.m
//  Moshfocus
//
//  Created by 李雪健 on 2023/6/6.
//

#import "HTSearchHistoryManager.h"

@implementation HTSearchHistoryManager

+ (UICollectionView *)lgjeropj_collectionView:(id)target {
    
    UICollectionView *view = [HTKitCreate ht_collectionViewWithDelegate:target andIsVertical:YES andLineSpacing:0 andColumnSpacing:0 andItemSize:CGSizeZero andIsEstimated:NO andSectionInset:UIEdgeInsetsZero];
    [view registerClass:[HTSearchHistoryKeywordCell class] forCellWithReuseIdentifier:NSStringFromClass([HTSearchHistoryKeywordCell class])];
    [view registerClass:[HTSearchHistoryHotCell class] forCellWithReuseIdentifier:NSStringFromClass([HTSearchHistoryHotCell class])];
    [view registerClass:[HTSearchHistoryHeaderReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([HTSearchHistoryHeaderReusableView class])];
    return view;
}

+ (NSArray *)lgjeropj_history {
    
    return [[NSUserDefaults standardUserDefaults] arrayForKey:@"udf_SearchHistory"];
}

+ (void)lgjeropj_saveHistory:(NSArray *)data {
    
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"udf_SearchHistory"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)lgjeropj_clear {
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"udf_SearchHistory"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end

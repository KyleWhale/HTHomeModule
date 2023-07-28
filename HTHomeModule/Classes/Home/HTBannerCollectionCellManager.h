//
//  HTBannerCollectionCellManager.h
//  Moshfocus
//
//  Created by 李雪健 on 2023/6/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HTBannerCollectionCellManager : NSObject

+ (UICollectionViewCell *)ht_collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath model:(id)model;

@end

NS_ASSUME_NONNULL_END

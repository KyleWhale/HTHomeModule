//
//  HTBannerCollectionCellManager.m
//  Moshfocus
//
//  Created by 李雪健 on 2023/6/7.
//

#import "HTBannerCollectionCellManager.h"
#import "HTHomeBannerModel.h"

@implementation HTBannerCollectionCellManager

+ (UICollectionViewCell *)ht_collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath model:(id)model {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(UICollectionViewCell.class) forIndexPath:indexPath];
    UIImageView *imgView = [cell.contentView viewWithTag:100000];
    if(!imgView) {
        CGRect cellRect = cell.contentView.bounds;
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cellRect.size.width, cellRect.size.height)];
        imgView.tag = 100000;
        imgView.layer.masksToBounds = YES;
        imgView.layer.cornerRadius = 8;
        [cell.contentView addSubview:imgView];
    }
    HTHomeBannerModel *banner = model;
    [imgView sd_setImageWithURL:[NSURL URLWithString:banner.nw_img] placeholderImage:[UIImage imageNamed:@"icon_momtype_default"]];
    return cell;
}

@end

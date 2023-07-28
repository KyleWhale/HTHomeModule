//
//  HTEpisodesMainViewManager.m
//  Moshfocus
//
//  Created by 李雪健 on 2023/6/8.
//

#import "HTEpisodesMainViewManager.h"

@implementation HTEpisodesMainViewManager

+ (UILabel *)lgjeropj_episodesLabel {
    
    UILabel *view = [[UILabel alloc] init];
    view.textColor = [UIColor whiteColor];
    view.font = HTPingFangFont(18);
    view.text = LocalString(@"Episodes", nil);
    return view;
}

+ (UIView *)lgjeropj_line {
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
    return view;
}

+ (UIButton *)lgjeropj_seasonBtn {

    UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
    view.titleLabel.font = HTPingFangRegularFont(14);
    [view setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    view.cornerRadius = 3;
    view.backgroundColor = [UIColor colorWithHexString:@"#434360"];
    [view sd_setImageWithURL:[LKFPrivateFunction lgjeropj_imageUrlFromNumber:178] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [view setPosition:3 interval:2];
    }];
    return view;
}

+ (UICollectionView *)lgjeropj_colletionView:(id)target {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 14;
    layout.minimumInteritemSpacing = 14;
    layout.itemSize = CGSizeMake(46, 46);
    layout.sectionInset = UIEdgeInsetsMake(24, 0, 24, 24);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    UICollectionView *view = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    view.showsHorizontalScrollIndicator = NO;
    view.showsVerticalScrollIndicator = NO;
    view.delegate = target;
    view.dataSource = target;
    view.backgroundColor = [UIColor clearColor];
    if (@available(iOS 11.0, *)) {
        view.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    if (@available(iOS 13.0, *)) {
        view.automaticallyAdjustsScrollIndicatorInsets = NO;
    }
    return view;
}

@end

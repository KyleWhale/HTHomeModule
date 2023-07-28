//
//  HTHomeWaterfallHeaderReusableView.h
//  Hucolla
//
//  Created by mac on 2022/9/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HTHomeWaterfallHeaderReusableView : UICollectionReusableView

@property (nonatomic, strong) UILabel          * titleLabel;

- (void)ht_hideLine:(BOOL)isHidden;

@end

NS_ASSUME_NONNULL_END

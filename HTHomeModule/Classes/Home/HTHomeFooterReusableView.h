//
//  HTHomeFooterReusableView.h
//  Hucolla
//
//  Created by mac on 2022/9/13.
//

#import <UIKit/UIKit.h>
#import "HTHomeDisplayTypeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HTHomeFooterReusableView : UICollectionReusableView

@property (nonatomic, strong) HTHomeDisplayTypeModel *type;
@property (nonatomic, strong) UIButton          * moreBtn;
@property (nonatomic, strong) UIButton          * allBtn;

- (void)ht_startLoadding;

- (void)ht_endLoadding;

@end

NS_ASSUME_NONNULL_END

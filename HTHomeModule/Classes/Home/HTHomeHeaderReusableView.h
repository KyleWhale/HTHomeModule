//
//  HTHomeHeaderReusableView.h
//  Hucolla
//
//  Created by mac on 2022/9/13.
//

#import <UIKit/UIKit.h>
#import "HTHomeDisplayTypeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HTHomeHeaderReusableView : UICollectionReusableView

@property (nonatomic, strong) UILabel          * titleLabel;
@property (nonatomic, strong) UIButton          * rightBtn;
@property (nonatomic, strong) HTHomeDisplayTypeModel *type;

@end

NS_ASSUME_NONNULL_END

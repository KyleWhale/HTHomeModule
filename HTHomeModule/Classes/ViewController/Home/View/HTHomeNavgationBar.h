//
//  HTHomeNavgationBar.h
//  Hucolla
//
//  Created by mac on 2022/9/13.
//

#import "BaseView.h"
#import "HTSearchView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HTHomeNavgationBar : BaseView

@property (nonatomic, strong) UIButton         * var_shareBtn;
@property (nonatomic, strong) UIButton         * var_historyBtn;
@property (nonatomic, strong) HTSearchView     * var_searchView;

@end

NS_ASSUME_NONNULL_END

//
//  HTHomeTrendingModel.h
//  Hucolla
//
//  Created by 李雪健 on 2022/10/24.
//

#import "HTBaseModel.h"
#import "HTHomeTrendingM20Model.h"

NS_ASSUME_NONNULL_BEGIN

@interface HTHomeTrendingModel : HTBaseModel

@property (nonatomic, strong) NSString      * ID;
@property (nonatomic, strong) NSString      * name;
@property (nonatomic, strong) NSString      * cover;
@property (nonatomic, strong) NSString      * desc;
@property (nonatomic, strong) NSString      * tag;
@property (nonatomic, strong) NSString      * fav;
@property (nonatomic, strong) NSString      * share;
@property (nonatomic, strong) NSString      * status;
@property (nonatomic, strong) NSString      * country;
@property (nonatomic, strong) NSString      * lang;
@property (nonatomic, assign) NSInteger       total;
@property (nonatomic, strong) NSArray       * m20;
@property (nonatomic, strong) NSArray       * tt20;

@property (nonatomic, assign) NSInteger       page;
@property (nonatomic, assign) BOOL            var_isMore;

@end

NS_ASSUME_NONNULL_END

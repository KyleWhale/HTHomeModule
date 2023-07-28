//
//  HTSpecialModel.h
//  Hucolla
//
//  Created by 李雪健 on 2022/10/24.
//

#import "HTBaseModel.h"
#import "HTHomeTrendingM20Model.h"

NS_ASSUME_NONNULL_BEGIN

@interface HTSpecialModel : HTBaseModel

@property (nonatomic, strong) NSString      * desc;
@property (nonatomic, strong) NSArray       * minfo;
@property (nonatomic, assign) NSInteger       total;

@end

NS_ASSUME_NONNULL_END

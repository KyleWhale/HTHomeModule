//
//  HTSearchResultModel.h
//  Hucolla
//
//  Created by 李雪健 on 2022/10/24.
//

#import "HTBaseModel.h"
#import "HTSearchMovieTvModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HTSearchResultModel : HTBaseModel

@property (nonatomic, strong) NSArray       * movie_tv_list;
@property (nonatomic, copy) NSString        * var_word;
@property (nonatomic, assign) NSInteger       var_type;

@end

NS_ASSUME_NONNULL_END

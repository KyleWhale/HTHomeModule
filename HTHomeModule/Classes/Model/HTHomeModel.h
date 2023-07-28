//
//  HTHomeModel.h
//  Hucolla
//
//  Created by 李雪健 on 2022/10/24.
//

#import "HTBaseModel.h"
#import "HTHomeDefaultModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HTHomeModel : HTBaseModel

@property (nonatomic, strong) NSString      * flag;
@property (nonatomic, strong) NSString      * ID;
@property (nonatomic, strong) HTHomeDefaultModel       * default_set;

@end

NS_ASSUME_NONNULL_END

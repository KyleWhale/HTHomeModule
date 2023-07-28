//
//  HTHomeCompositeModel.h
//  Hucolla
//
//  Created by 李雪健 on 2022/10/24.
//

#import "HTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HTHomeCompositeModel : HTBaseModel

@property (nonatomic, strong) NSString      * ID;
@property (nonatomic, strong) NSString      * title;
@property (nonatomic, strong) NSString      * cover;
@property (nonatomic, strong) NSArray       * params;

@end

NS_ASSUME_NONNULL_END

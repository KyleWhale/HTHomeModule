//
//  HTHomeDefaultModel.h
//  Hucolla
//
//  Created by 李雪健 on 2022/10/24.
//

#import "HTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HTHomeDefaultModel : HTBaseModel

@property (nonatomic, assign) NSInteger      total;
@property (nonatomic, strong) NSString     * source;
@property (nonatomic, strong) NSArray      * data;
@property (nonatomic, strong) NSString     * msg;
@property (nonatomic, assign) NSInteger      status;

@end

NS_ASSUME_NONNULL_END

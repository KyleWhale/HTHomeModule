//
//  HTGuideViewManager.h
//  Moshfocus
//
//  Created by 李雪健 on 2023/6/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HTGuideViewManager : NSObject

+ (NSURL *)lgjeropj_createDynamiclink:(NSDictionary *)data;

+ (void)lgjeropj_daoLiangShow:(NSInteger)status andSource:(NSString *)source andTag:(NSString *)var_name;

+ (void)lgjeropj_daoLiangClick:(NSString *)kid andStatus:(NSInteger)status andSource:(NSString *)source andTag:(NSString *)var_name;

@end

NS_ASSUME_NONNULL_END

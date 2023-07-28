//
//  HTSpecialViewModel.h
//  Moshfocus
//
//  Created by 李雪健 on 2023/6/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HTSpecialViewModel : NSObject

@property (nonatomic, strong) NSString *var_speId;
@property (nonatomic, strong) NSString *type;

- (void)lgjeropj_reportShowMaidian;

- (void)lgjeropj_clickMTWithKid:(NSString *)kidStr andMID:(NSString *)var_midStr andMname:(NSString *)var_mnameStr;

@end

NS_ASSUME_NONNULL_END

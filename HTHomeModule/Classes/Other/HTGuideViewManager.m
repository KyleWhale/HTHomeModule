//
//  HTGuideViewManager.m
//  Moshfocus
//
//  Created by 李雪健 on 2023/6/6.
//

#import "HTGuideViewManager.h"
#import "HTHomePointManager.h"
#import "HTPremiumManager.h"

@implementation HTGuideViewManager

+ (NSURL *)lgjeropj_createDynamiclink:(NSDictionary *)data {
    NSMutableDictionary *params = [HTPremiumManager lgjeropj_getVipParams];
    [params setValue:@"2" forKey:AsciiString(@"type")];
    [params setValue:[data objectForKey:AsciiString(@"l2")] forKey:@"var_shopLink"];
    [params setValue:[data objectForKey:AsciiString(@"a1")] forKey:@"var_targetBundle"];
    [params setValue:[data objectForKey:AsciiString(@"l1")] forKey:@"var_targetLink"];
    [params setValue:[data objectForKey:AsciiString(@"k2")] forKey:@"var_dynamicK2"];
    [params setValue:[data objectForKey:AsciiString(@"c4")] forKey:@"var_dynamicC4"];
    [params setValue:[data objectForKey:AsciiString(@"c5")] forKey:@"var_dynamicC5"];
    [params setValue:[data objectForKey:AsciiString(@"logo")] forKey:@"var_dynamicLogo"];
    return [HTCommonConfiguration lgjeropj_shared].BLOCK_deepLinkBlock(params);
}

+ (void)lgjeropj_daoLiangShow:(NSInteger)status andSource:(NSString *)source andTag:(NSString *)var_name {
    NSMutableDictionary *var_dic = [[NSMutableDictionary alloc] init];
    [var_dic setValue:@"app_guide_sh" forKey:@"pointname"];
    [var_dic setValue:@(status) forKey:AsciiString(@"type")];
    NSInteger var_productType = 0;
    NSString *var_productName = @"";
    ZQAccountModel *var_accountResult = [HTCommonConfiguration lgjeropj_shared].BLOCK_userBlock();
    if ([HTCommonConfiguration lgjeropj_shared].BLOCK_vipBlock()) {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"udf_isLocalIapVip"]) {
            var_productType = 1;
            var_productName = [[NSUserDefaults standardUserDefaults] stringForKey:@"udf_productIdentifier"];
        } else {
            var_productType = 2;
            if ([var_accountResult.var_familyPlanState isEqualToString:@"1"]) {
                var_productName = var_accountResult.var_pid ?:@"";
            } else if ([var_accountResult.var_bindPlanState isEqualToString:@"1"]) {
                var_productName = var_accountResult.var_bindPid ?:@"";
            } else {
                var_productName = [[NSUserDefaults standardUserDefaults] stringForKey:@"udf_devicePid"];
            }
        }
    }
    [var_dic setValue:source forKey:AsciiString(@"source")];
    [var_dic setValue:var_name forKey:@"g_name"];
    [var_dic setValue:var_productName forKey:@"vip_name"];
    [var_dic setValue:@(var_productType) forKey:@"vip_type"];
    [HTHomePointManager lgjeropj_maidianRequestWithParams:var_dic];
}

+ (void)lgjeropj_daoLiangClick:(NSString *)kid andStatus:(NSInteger)status andSource:(NSString *)source andTag:(NSString *)var_name {
    NSMutableDictionary *var_dic = [[NSMutableDictionary alloc] init];
    [var_dic setValue:@"app_guide_cl" forKey:@"pointname"];
    [var_dic setValue:kid forKey:AsciiString(@"kid")];
    [var_dic setValue:@(status) forKey:AsciiString(@"type")];
    NSInteger var_productType = 0;
    NSString *var_productName = @"";
    ZQAccountModel *var_accountResult = [HTCommonConfiguration lgjeropj_shared].BLOCK_userBlock();
    if ([HTCommonConfiguration lgjeropj_shared].BLOCK_vipBlock()) {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"udf_isLocalIapVip"]) {
            var_productType = 1;
            var_productName = [[NSUserDefaults standardUserDefaults] stringForKey:@"udf_productIdentifier"];
        } else {
            var_productType = 2;
            if ([var_accountResult.var_familyPlanState isEqualToString:@"1"]) {
                var_productName = var_accountResult.var_pid ?:@"";
            } else if ([var_accountResult.var_bindPlanState isEqualToString:@"1"]) {
                var_productName = var_accountResult.var_bindPid ?:@"";
            } else {
                var_productName = [[NSUserDefaults standardUserDefaults] stringForKey:@"udf_devicePid"];
            }
        }
    }
    [var_dic setValue:source forKey:AsciiString(@"source")];
    [var_dic setValue:var_name forKey:@"g_name"];
    [var_dic setValue:@(var_productType) forKey:@"vip_type"];
    [var_dic setValue:var_productName forKey:@"vip_name"];
    [HTHomePointManager lgjeropj_maidianRequestWithParams:var_dic];
}

@end

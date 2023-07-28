//
//  HTDBHistoryModel.m
//  Hucolla
//
//  Created by mac on 2022/9/19.
//

#import "HTDBHistoryModel.h"

@implementation HTDBHistoryModel

/// 插入数据
- (void)ht_insertOrUpDate {
    NSUserDefaults *var_userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *var_array = [var_userDefaults objectForKey:@"udf_historyPlay"];
    NSData *var_jsonData = [[self yy_modelToJSONString] dataUsingEncoding:NSUTF8StringEncoding];
    NSError *var_error;
    NSDictionary *var_newDict = [NSJSONSerialization JSONObjectWithData:var_jsonData options:NSJSONReadingMutableContainers error:&var_error];
    NSMutableArray *var_mutableArray = [NSMutableArray arrayWithArray:var_array];
    BOOL var_exist = NO;
    for (int i = 0; i < var_mutableArray.count; i ++) {
        NSDictionary *var_dict = var_mutableArray[i];
        if ([var_dict[@"var_mId"] isEqualToString:self.var_mId]) {
            NSMutableDictionary *var_newDictionary = [NSMutableDictionary dictionaryWithDictionary:var_dict];
            [var_newDictionary addEntriesFromDictionary:var_newDict];
            [var_mutableArray removeObject:var_dict];
            [var_mutableArray addObject:var_newDictionary];
            var_exist = YES;
            break;
        }
    }
    if (!var_exist) {
        [var_mutableArray addObject:var_newDict];
    }
    [var_userDefaults setObject:var_mutableArray forKey:@"udf_historyPlay"];
    [var_userDefaults synchronize];
}

- (void)ht_updateSrt:(NSString *)var_srt {
    if (var_srt != nil) {
        self.var_srt = var_srt;
        NSUserDefaults *var_userDefaults = [NSUserDefaults standardUserDefaults];
        NSArray *var_array = [var_userDefaults objectForKey:@"udf_historyPlay"];
        NSMutableArray *var_mutableArray = [NSMutableArray arrayWithArray:var_array];
        for (int i = 0; i < var_mutableArray.count; i ++) {
            NSDictionary *var_dict = var_mutableArray[i];
            if ([var_dict[@"var_mId"] isEqualToString:self.var_mId]) {
                NSMutableDictionary *var_newDictionary = [NSMutableDictionary dictionaryWithDictionary:var_dict];
                [var_newDictionary setObject:(self.var_srt ? : @"") forKey:@"var_srt"];
                [var_mutableArray removeObject:var_dict];
                [var_mutableArray addObject:var_newDictionary];
                break;
            }
        }
        [var_userDefaults setObject:var_mutableArray forKey:@"udf_historyPlay"];
        [var_userDefaults synchronize];
    }
}

/// 获取所有数据
- (NSArray *)ht_getAllData {
    NSUserDefaults *var_userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *var_array = [var_userDefaults objectForKey:@"udf_historyPlay"];
    
    if(var_array.count > 0) {
        NSArray *var_modelArr = [NSArray yy_modelArrayWithClass:[HTDBHistoryModel class] json:var_array];
        NSArray *var_temArray = [var_modelArr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            HTDBHistoryModel *var_mod_1 = (HTDBHistoryModel *)obj1;
            HTDBHistoryModel *var_mod_2 = (HTDBHistoryModel *)obj2;
            NSDate *var_date_1 = [var_mod_1.var_lastTime dateWithFormat:AsciiString(@"yyyy-MM-dd HH:mm:ss")];
            NSDate *var_date_2 = [var_mod_2.var_lastTime dateWithFormat:AsciiString(@"yyyy-MM-dd HH:mm:ss")];
            return [var_date_2 compare:var_date_1];
        }];
        return var_temArray;
    }
    return nil;
}

/// 删除某一条数据
- (void)ht_deleteDataWithMID:(NSString *)var_mId {
    NSUserDefaults *var_userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *var_array = [var_userDefaults objectForKey:@"udf_historyPlay"];
    NSMutableArray *var_mutableArray = [NSMutableArray arrayWithArray:var_array];
    for (int i = 0; i < var_mutableArray.count; i ++) {
        NSDictionary *var_dict = var_mutableArray[i];
        if ([var_mId isEqualToString:var_dict[@"var_mId"]]) {
            [var_mutableArray removeObject:var_dict];
            break;
        }
    }
    [var_userDefaults setObject:var_mutableArray forKey:@"udf_historyPlay"];
    [var_userDefaults synchronize];
}


- (HTDBHistoryModel *)ht_getDataWithMID:(NSString *)var_mId {
    NSArray *var_array = [self ht_getAllData];
    if (var_array.count > 0) {
        for (HTDBHistoryModel *var_model in var_array) {
            if ([var_model.var_mId isEqualToString:var_mId]) {
                return var_model;
            }
        }
    }
    return nil;
}

- (HTDBHistoryModel *)ht_getDataWithVID:(NSString *)var_vId {
    NSArray *var_array = [self ht_getAllData];
    if (var_array.count > 0) {
        for (HTDBHistoryModel *var_model in var_array) {
            if ([var_model.var_vId isEqualToString:var_vId]) {
                return var_model;
            }
        }
    }
    return nil;
}

- (NSString *)var_textPath {
    if(self.var_srt != nil && ![self.var_srt isEqualToString:@""]) {
        NSString *var_path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *var_string = [NSString stringWithFormat:@"%@/%@/%@", var_path, self.var_mId, self.var_srt];
        return var_string;
    }
    return nil;
}

@end

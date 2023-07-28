//
//  HTSearchHistoryManager.h
//  Moshfocus
//
//  Created by 李雪健 on 2023/6/6.
//

#import <Foundation/Foundation.h>
#import "HTSearchHistoryHotCell.h"
#import "HTSearchHistoryKeywordCell.h"
#import "HTSearchHistoryHeaderReusableView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HTSearchHistoryManager : NSObject

+ (UICollectionView *)lgjeropj_collectionView:(id)target;

+ (NSArray *)lgjeropj_history;

+ (void)lgjeropj_saveHistory:(NSArray *)data;

+ (void)lgjeropj_clear;

@end

NS_ASSUME_NONNULL_END

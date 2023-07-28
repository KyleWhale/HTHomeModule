//
//  HTAssociationViewManager.h
//  Moshfocus
//
//  Created by 李雪健 on 2023/6/6.
//

#import <Foundation/Foundation.h>
#import "HTSearchAssociationCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface HTAssociationViewManager : NSObject

+ (UILabel *)lgjeropj_searchLabel;

+ (UITableView *)lgjeropj_tableView:(id)target;

+ (void)lgjeropj_getAssociationWordsWithRequest:(NSString *)keyword completion:(BLOCK_dataBlock)completion;

@end

NS_ASSUME_NONNULL_END

//
//  HTHistoryViewManager.h
//  Moshfocus
//
//  Created by 李雪健 on 2023/6/6.
//

#import <Foundation/Foundation.h>
#import "HTHistoryViewCell.h"
#import "HTHistoryAdCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface HTHistoryViewManager : NSObject

+ (UITableView *)lgjeropj_tableView:(id)target;

+ (UIView *)lgjeropj_bottomView;

+ (UIButton *)lgjeropj_selectButton:(id)target action:(SEL)action;

+ (UIButton *)lgjeropj_deleteButton:(id)target action:(SEL)action;

@end

NS_ASSUME_NONNULL_END

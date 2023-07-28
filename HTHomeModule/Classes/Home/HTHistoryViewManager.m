//
//  HTHistoryViewManager.m
//  Moshfocus
//
//  Created by 李雪健 on 2023/6/6.
//

#import "HTHistoryViewManager.h"

@implementation HTHistoryViewManager

+ (UITableView *)lgjeropj_tableView:(id)target {

    UITableView *view = [HTKitCreate ht_tableViewWithDelegate:target style:UITableViewStylePlain];
    view.separatorStyle = UITableViewCellSeparatorStyleNone;
    view.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    [view registerClass:[HTHistoryViewCell class] forCellReuseIdentifier:NSStringFromClass([HTHistoryViewCell class])];
    [view registerClass:[HTHistoryAdCell class] forCellReuseIdentifier:NSStringFromClass([HTHistoryAdCell class])];
    return view;
}

+ (UIView *)lgjeropj_bottomView {
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithHexString:@"#313143"];
    return view;
}

+ (UIButton *)lgjeropj_selectButton:(id)target action:(SEL)action {
    
    UIButton *view = [HTKitCreate ht_buttonWithImage:nil andTitle:LocalString(@"Select All", nil) andFont:HTPingFangRegularFont(16) andTextColor:[UIColor whiteColor] andState:UIControlStateNormal];
    [view setTitle:LocalString(@"Deselect All", nil) forState:UIControlStateSelected];
    [view addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return view;
}

+ (UIButton *)lgjeropj_deleteButton:(id)target action:(SEL)action {
    
    UIButton *view = [HTKitCreate ht_buttonWithImage:nil andTitle:LocalString(@"Delete", nil) andFont:HTPingFangRegularFont(16) andTextColor:[UIColor colorWithHexString:@"#FF2929"] andState:UIControlStateNormal];
    [view setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateDisabled];
    view.enabled = NO;
    [view addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return view;
}

@end

//
//  HTGuideView.h
//  newNotes
//
//  Created by 李雪健 on 2022/11/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HTGuideView : UIView

- (instancetype)initWithData:(NSDictionary *)data andType:(NSInteger)type andSource:(NSString *)source;

- (void)lgjeropj_addAlertSubviews;
- (void)lgjeropj_showAlertView;
- (void)lgjeropj_hideAlertView;

@end

NS_ASSUME_NONNULL_END

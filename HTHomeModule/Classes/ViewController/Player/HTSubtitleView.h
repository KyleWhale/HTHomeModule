//
//  HTSubtitleView.h
//  Hucolla
//
//  Created by mac on 2022/9/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HTSubtitleView : UIView
@property (nonatomic, assign) int curIndex;
@property (nonatomic, strong) NSAttributedString    * attributeStr;

// offset 时间偏移
- (void)ht_showSrtWithTime:(double)time offset:(double)offset;

@end

NS_ASSUME_NONNULL_END

//
//  HTSubtitleSettingView.h
//  Hucolla
//
//  Created by mac on 2022/9/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HTSubtitleSettingView : UIView

@property (nonatomic, strong) NSString       * title;

@property (nonatomic, copy) BLOCK_HTVoidBlock     cancelBlock;
@property (nonatomic, copy) BLOCK_dataBlock       timeBlock;

// offset 时间偏移
- (void)ht_showSrtWithTime:(double)time offset:(double)offset;

@end
NS_ASSUME_NONNULL_END

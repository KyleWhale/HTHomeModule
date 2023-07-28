//
//  HTChangeSubtitleView.h
//  Hucolla
//
//  Created by mac on 2022/9/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HTChangeSubtitleView : UIView

@property (nonatomic, strong) NSArray          * textArray;

@property (nonatomic, copy) BLOCK_dataBlock     selBlock;

@property (nonatomic, copy) BLOCK_dataBlock     timeBlock;

@property (nonatomic, copy) BLOCK_HTBlock     switchBlock;

- (void)ht_showInView:(UIView *)view andHorizontal:(BOOL)horizontal;

// offset 时间偏移
- (void)ht_showSrtWithTime:(double)time offset:(double)offset;

@end

NS_ASSUME_NONNULL_END

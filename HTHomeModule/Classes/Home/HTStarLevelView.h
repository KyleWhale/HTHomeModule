//
//  HTStarLevelView.h
//  Examination
//
//  Created by mac on 2020/12/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^BLOCK_StartLevelBlock)(NSUInteger count);

@interface HTStarLevelView : UIView

+ (instancetype)ht_starLevelView;

@property (nonatomic, assign, readonly) CGFloat var_spacing;

@property (nonatomic, assign, readonly) CGFloat var_starCount;

- (void)lgjeropj_spacing:(CGFloat)var_spacing;

- (void)lgjeropj_starCount:(CGFloat)var_starCount;

@end


NS_ASSUME_NONNULL_END

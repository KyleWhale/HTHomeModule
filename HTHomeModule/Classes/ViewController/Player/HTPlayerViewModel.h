//
//  HTPlayerViewModel.h
//  Moshfocus
//
//  Created by 李雪健 on 2023/6/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HTPlayerViewModel : NSObject

@property (nonatomic,assign ) BOOL var_isShowTop;
@property (nonatomic,assign ) BOOL var_isShowBottom;
@property (nonatomic,assign ) BOOL var_isAnimation;
// 是否初始化了播放器
@property (nonatomic, assign) BOOL var_isInitPlayer;
// 跳到time处播放
@property (nonatomic, assign) double var_seekTime;
// 是否拖拽Slider
@property (nonatomic, assign) BOOL var_isDragingSlider;
// 记录播放速度
@property (nonatomic, assign) float var_nowRate;
// 进入后台时是否播放状态
@property (nonatomic,assign ) BOOL var_isPlayBackground;

@property (nonatomic, strong) NSDateFormatter *var_dateFormatter;

- (NSString *)lgjeropj_convertTime:(float)second;

- (BOOL)lgjeropj_haveAirplay;

@end

NS_ASSUME_NONNULL_END

//
//  HTPlayBottomBar.h
//  Hucolla
//
//  Created by 彭金伟 on 2022/9/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HTPlayBottomBar : UIView

@property (nonatomic, strong) UIButton          * playBtn;
@property (nonatomic, strong) UIButton          * fullBtn;
@property (nonatomic, strong) UISlider          * var_slider;
@property (nonatomic, strong) UIProgressView    * progressView;
@property (nonatomic, strong) UILabel           * timeLabel;
@property (nonatomic, strong) UILabel           * totalLabel;
@property (nonatomic, strong) UIButton          * epsBtn; // 季 集切换

@property (nonatomic, assign) BOOL                var_isTType;
@property (nonatomic, assign) BOOL                isFScreen;

@end

NS_ASSUME_NONNULL_END

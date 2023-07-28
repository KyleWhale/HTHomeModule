//
//  HTSubtitleObject.h
//  Hucolla
//
//  Created by mac on 2022/9/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HTSubtitleObject : NSObject

@property (nonatomic, assign) NSInteger        index;
@property (nonatomic, assign) double           startTime;
@property (nonatomic, assign) double           endTime;
@property (nonatomic, strong) NSString       * content;

- (instancetype)initWithString:(NSString *)string;

- (ENUM_HTSubtitleState)ht_subtitleStateWithTime:(double)time;

- (NSMutableAttributedString *)ht_attributeStrForContentWithFont:(UIFont *)font textColor:(UIColor *)textColor lineSpace:(CGFloat)lineSpace;

- (double)ht_duration;

@end

NS_ASSUME_NONNULL_END

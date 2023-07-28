//
//  HTSubtitleObject.m
//  Hucolla
//
//  Created by mac on 2022/9/21.
//

#import "HTSubtitleObject.h"

@implementation HTSubtitleObject

- (instancetype)initWithString:(NSString *)string {
    self = [super init];
    if ( self ) {
        NSArray *array = [string componentsSeparatedByString:@"\n"];
        if ( array.count > 0 ) {
            
            NSMutableString *content = [NSMutableString string];
            for ( int i=0; i < array.count; i++ ) {
                NSString *str = array[i];
                if ( i == 0 ) {
                    // 字幕序号
                    self.index = [str integerValue];
                } else if ( i == 1 ) {
                    // 字幕时间
                    NSRange range = [str rangeOfString:@" --> "];
                    if ( range.location != NSNotFound ) {
                        NSString *beginstr = [str substringToIndex:range.location];
                        NSString *endstr = [str substringFromIndex:NSMaxRange(range)];
                        
                        
                        self.startTime = [self lgjeropj_getSecondWithDateStr:beginstr]/1000.0;
                        self.endTime = [self lgjeropj_getSecondWithDateStr:endstr]/1000.0;
                    }
                } else {
                    [content appendFormat:@"%@\n",str];
                }
            }
            
            self.content = [content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
        }
    }
    return self;
}

- (NSInteger)lgjeropj_getSecondWithDateStr:(NSString *)dateStr {
    // 返回毫秒  格式 @"00:00:00,000"
    NSString *HH = [dateStr substringToIndex:2];
    NSString *mm = [dateStr substringWithRange:NSMakeRange(3, 2)];
    NSString *ss = [dateStr substringWithRange:NSMakeRange(6, 2)];
    NSString *SSS = [dateStr substringFromIndex:dateStr.length - 3];
    
    double second = [HH integerValue]*3600*1000 + [mm integerValue]*60*1000 + [ss integerValue]*1000 + [SSS integerValue];
    return second;
}

- (ENUM_HTSubtitleState)ht_subtitleStateWithTime:(double)time {
    
    if ( time < self.startTime ) {
        return ENUM_HTSubtitleStateLessStart;
    } else if ( time > self.endTime ) {
        return ENUM_HTSubtitleStateThanEnd;
    }
    return ENUM_HTSubtitleStateDuration;
}

- (double)ht_duration {
    return self.endTime - self.startTime;
}

- (NSMutableAttributedString *)ht_attributeStrForContentWithFont:(UIFont *)font textColor:(UIColor *)textColor lineSpace:(CGFloat)lineSpace {
    
    if ( self.content == nil ) {
        return nil;
    }
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = lineSpace;
    
    NSMutableAttributedString *var_attributeString = [[NSMutableAttributedString alloc] initWithString:self.content attributes:@{NSFontAttributeName: font,NSForegroundColorAttributeName:textColor,NSParagraphStyleAttributeName:style}];
    
    return var_attributeString;
}



@end

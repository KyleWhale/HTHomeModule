//
//  HTPlayerViewModel.m
//  Moshfocus
//
//  Created by 李雪健 on 2023/6/8.
//

#import "HTPlayerViewModel.h"

@implementation HTPlayerViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.var_dateFormatter = [[NSDateFormatter alloc] init];
        self.var_dateFormatter.timeZone = [NSTimeZone timeZoneWithName:AsciiString(@"GMT")];
    }
    return self;
}

- (NSString *)lgjeropj_convertTime:(float)second {
    
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:second];
    if (second/3600 >= 1) {
        [self.var_dateFormatter setDateFormat:AsciiString(@"HH:mm:ss")];
    } else {
        [self.var_dateFormatter setDateFormat:AsciiString(@"mm:ss")];
    }
    return [self.var_dateFormatter stringFromDate:d];
}

- (BOOL)lgjeropj_haveAirplay {

    return [[HTCommonConfiguration lgjeropj_shared].BLOCK_airDictBlock() count] > 0;
}

@end

//
//  HTSubtitleManager.m
//  Hucolla
//
//  Created by mac on 2022/9/21.
//

#import "HTSubtitleManager.h"
#import "HTSubtitleObject.h"

@interface HTSubtitleManager()

@property (nonatomic, strong) NSString          * srtPath;

@end

@implementation HTSubtitleManager

+ (HTSubtitleManager *)ht_manager {
    
    static HTSubtitleManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[HTSubtitleManager alloc] init];
    });
    return manager;
}

- (void)ht_loadSrtFile:(NSString *)srtPath {
    NSString *message = AsciiString(@"srt");
    if ( ![srtPath hasSuffix:message] ) {
        return;
    }
    self.srtPath = srtPath;
    
    if ( [[NSFileManager defaultManager] fileExistsAtPath:srtPath] == NO ) {
        [self performSelector:@selector(onReloadSrt) withObject:nil afterDelay:5];
        return;
    }
    
    NSData *data = [NSData dataWithContentsOfFile:srtPath];
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if ( string == nil ) {
        // GBK
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        string = [[NSString alloc] initWithData:data encoding:enc];
    }
    
    if ( string == nil ) {
        return;
    }
    
    string = [string stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    // 换行分割
    NSArray *array = [string componentsSeparatedByString:@"\n\n"];
    
    self.dataArray = [NSMutableArray array];
    
    for ( int i = 0; i < array.count; i++ ) {
        NSString *subString1 = array[i];
        NSString *subString2 = [subString1 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        HTSubtitleObject *obj = [[HTSubtitleObject alloc] initWithString:subString2];
        if ( obj.index > 0 && ![obj.content isEqualToString:@""]) {
            [self.dataArray addObject:obj];
        }
    }
}

- (void)onReloadSrt {
    [self ht_loadSrtFile:self.srtPath];
}

@end

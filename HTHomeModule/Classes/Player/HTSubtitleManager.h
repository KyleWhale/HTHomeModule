//
//  HTSubtitleManager.h
//  Hucolla
//
//  Created by mac on 2022/9/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HTSubtitleManager : NSObject

@property (nonatomic, strong) NSMutableArray      * dataArray;

+ (HTSubtitleManager *)ht_manager;

- (void)ht_loadSrtFile:(NSString *)srtPath;

@end

NS_ASSUME_NONNULL_END

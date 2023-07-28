//
//  HTHomeViewModel.h
//  Moshfocus
//
//  Created by 李雪健 on 2023/6/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HTHomeViewModel : NSObject

@property (nonatomic, assign) BOOL var_haveAds;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic, strong) NSMutableArray *var_waterArray;
@property (nonatomic, assign) BOOL var_isMore;
@property (nonatomic, assign) NSInteger var_water_page;
@property (nonatomic, strong) NSString *shareText;
@property (nonatomic, strong) NSString *shareLink;
@property (nonatomic, assign) NSInteger var_adPosition;

@end

NS_ASSUME_NONNULL_END

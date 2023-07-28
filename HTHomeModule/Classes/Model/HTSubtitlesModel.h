//
//  HTSubtitlesModel.h
//  Hucolla
//
//  Created by 李雪健 on 2022/10/24.
//

#import "HTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HTSubtitlesModel : HTBaseModel

@property (nonatomic, strong) NSString      * l_short;
@property (nonatomic, strong) NSString      * t_name;
@property (nonatomic, strong) NSString      * lang;
@property (nonatomic, strong) NSString      * sub;
@property (nonatomic, strong) NSString      * delay;
@property (nonatomic, strong) NSString      * forward;

@property (nonatomic, assign) BOOL            isSelect;

@end

NS_ASSUME_NONNULL_END

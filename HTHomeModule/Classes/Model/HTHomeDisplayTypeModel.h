//
//  HTHomeDisplayTypeModel.h
//  Hucolla
//
//  Created by 李雪健 on 2022/10/24.
//

#import "HTBaseModel.h"
#import "HTHomeBannerModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HTHomeDisplayTypeModel : HTBaseModel

@property (nonatomic, strong) NSString      * name;
@property (nonatomic, strong) NSArray       * data;

@property (nonatomic, assign) NSInteger       display_type;
@property (nonatomic, strong) NSString      * secname;
@property (nonatomic, strong) NSString      * data_type;

@property (nonatomic, strong) NSString      * info_type_2;
@property (nonatomic, assign) BOOL            moreflag;
@property (nonatomic, strong) NSString      * open_mode;
@property (nonatomic, strong) NSString      * open_mode_value;
@property (nonatomic, assign) NSInteger       total;
@property (nonatomic, strong) NSString      * cover;

@end

NS_ASSUME_NONNULL_END

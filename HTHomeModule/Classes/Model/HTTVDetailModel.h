//
//  HTTVDetailModel.h
//  Hucolla
//
//  Created by 李雪健 on 2022/10/24.
//

#import "HTBaseModel.h"
#import "HTTVDetailCastsModel.h"
#import "HTTVDetailSeasonModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HTTVDetailModel : HTBaseModel

@property (nonatomic, strong) NSArray       * casts;
@property (nonatomic, strong) NSString      * country;
@property (nonatomic, strong) NSString      * cover;
@property (nonatomic, strong) NSString      * desc;
@property (nonatomic, strong) NSString      * ID;
@property (nonatomic, strong) NSString      * rate;
@property (nonatomic, strong) NSString      * source;
@property (nonatomic, strong) NSArray       * ssn_list;
@property (nonatomic, strong) NSString      * tags;
@property (nonatomic, strong) NSString      * title;
@property (nonatomic, strong) NSString      * logout;

@end

NS_ASSUME_NONNULL_END
